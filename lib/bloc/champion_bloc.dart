import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:state_management/bloc/champion_event.dart';
import 'package:state_management/bloc/champion_state.dart';
import 'package:state_management/models/champion_model.dart';
import 'package:state_management/bloc/champion_api_service.dart';

class ChampionBloc extends Bloc<ChampionEvent, ChampionState> {
  final ChampionApiService _apiService;

  ChampionBloc({required ChampionApiService apiService})
    : _apiService = apiService,
      super(ChampionInitial()) {
    on<LoadChampions>(_onLoadChampions);
    on<SearchChampions>(_onSearchChampions);
    on<ClearSearch>(_onClearSearch);

    add(LoadChampions());
  }

  Future<void> _onLoadChampions(
    LoadChampions event,
    Emitter<ChampionState> emit,
  ) async {
    emit(ChampionLoading());
    try {
      final version = await _apiService.fetchCurrentDDragonVersion();
      final champions = await _apiService.fetchChampions(version);

      final minLoadingTime = Future.delayed(const Duration(seconds: 2));
      await Future.wait([minLoadingTime]);

      emit(
        ChampionLoaded(
          allChampions: champions,
          searchResults: champions,
          currentDDragonVersion: version,
          currentQuery: '',
        ),
      );
    } catch (e) {
      emit(ChampionError(e.toString()));
    }
  }

  void _onSearchChampions(SearchChampions event, Emitter<ChampionState> emit) {
    if (state is ChampionLoaded) {
      final currentState = state as ChampionLoaded;
      final query = event.query.toLowerCase();

      List<Champion> filteredChampions;
      if (query.isEmpty) {
        filteredChampions = List.from(currentState.allChampions);
      } else {
        filteredChampions = currentState.allChampions
            .where((champion) => champion.name.toLowerCase().contains(query))
            .toList();
      }
      emit(
        currentState.copyWith(
          searchResults: filteredChampions,
          currentQuery: event.query,
        ),
      );
    }
  }

  void _onClearSearch(ClearSearch event, Emitter<ChampionState> emit) {
    if (state is ChampionLoaded) {
      final currentState = state as ChampionLoaded;
      emit(
        currentState.copyWith(
          searchResults: List.from(currentState.allChampions),
          currentQuery: '',
        ),
      );
    }
  }
}
