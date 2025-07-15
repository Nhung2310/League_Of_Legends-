import 'package:bloc/bloc.dart';
import 'package:state_management/models/champion_detail_model.dart';
import 'package:state_management/bloc/detail/champion_detail_api_service.dart';





abstract class ChampionDetailEvent  {
  const ChampionDetailEvent();

  @override
  List<Object> get props => [];
}

class LoadChampionDetail extends ChampionDetailEvent {
  final String championId;
  final String version;
  final String locale; 

  const LoadChampionDetail({
    required this.championId,
    required this.version,
    required this.locale,
  });

  @override
  List<Object> get props => [championId, version, locale];
}

class ToggleLoreExpansion extends ChampionDetailEvent {
  const ToggleLoreExpansion();

  @override
  List<Object> get props => [];
}


abstract class ChampionDetailState  {
  const ChampionDetailState();

  @override
  List<Object> get props => [];
}

class ChampionDetailInitial extends ChampionDetailState {}

class ChampionDetailLoading extends ChampionDetailState {}

class ChampionDetailLoaded extends ChampionDetailState {
  final ChampionDetailModel championDetail;
  final bool isLoreExpanded;

  const ChampionDetailLoaded({
    required this.championDetail,
    this.isLoreExpanded = false, 
  });

 
  ChampionDetailLoaded copyWith({
    ChampionDetailModel? championDetail,
    bool? isLoreExpanded,
  }) {
    return ChampionDetailLoaded(
      championDetail: championDetail ?? this.championDetail,
      isLoreExpanded: isLoreExpanded ?? this.isLoreExpanded,
    );
  }

  @override
  List<Object> get props => [championDetail, isLoreExpanded];
}

class ChampionDetailError extends ChampionDetailState {
  final String message;
  const ChampionDetailError(this.message);

  @override
  List<Object> get props => [message];
}


class ChampionDetailBloc extends Bloc<ChampionDetailEvent, ChampionDetailState> {
  
  final ChampionDetailApiService _apiService; 

  ChampionDetailBloc({required ChampionDetailApiService apiService}) 
      : _apiService = apiService,
        super(ChampionDetailInitial()) {
    on<LoadChampionDetail>(_onLoadChampionDetail);
    on<ToggleLoreExpansion>(_onToggleLoreExpansion);
  }

 
  Future<void> _onLoadChampionDetail(
      LoadChampionDetail event, Emitter<ChampionDetailState> emit) async {
    emit(ChampionDetailLoading());
    try {
      final championDetail = await _apiService.fetchChampionDetail(
        event.championId,
        event.version,
        event.locale,
      );
      emit(ChampionDetailLoaded(championDetail: championDetail)); 
    } catch (e) {
      emit(ChampionDetailError(e.toString())); 
    }
  }

  void _onToggleLoreExpansion(
      ToggleLoreExpansion event, Emitter<ChampionDetailState> emit) {
    if (state is ChampionDetailLoaded) {
      final currentState = state as ChampionDetailLoaded;
     
      emit(currentState.copyWith(isLoreExpanded: !currentState.isLoreExpanded));
    }
  }
}