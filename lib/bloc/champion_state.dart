import 'package:state_management/models/champion_model.dart'; 


abstract class ChampionState {
  const ChampionState();

  @override
  List<Object> get props => [];
}

class ChampionInitial extends ChampionState {}

class ChampionLoading extends ChampionState {}

class ChampionLoaded extends ChampionState {
  final List<Champion> allChampions;
  final List<Champion> searchResults;
  final String currentDDragonVersion;
  final String? errorMessage; 
  final  String currentQuery;

  const ChampionLoaded({
    this.allChampions = const [],
    this.searchResults = const [],
    this.currentDDragonVersion = '14.13.1', 
    this.errorMessage,
    this.currentQuery='',
    
  });

  @override
  List<Object> get props => [
        allChampions,
        searchResults,
        currentDDragonVersion,
        errorMessage ?? '', 
        currentQuery
      ];

  
  ChampionLoaded copyWith({
    List<Champion>? allChampions,
    List<Champion>? searchResults,
    String? currentDDragonVersion,
    String? errorMessage,
    String? currentQuery
  }) {
    return ChampionLoaded(
      allChampions: allChampions ?? this.allChampions,
      searchResults: searchResults ?? this.searchResults,
      currentDDragonVersion: currentDDragonVersion ?? this.currentDDragonVersion,
      errorMessage: errorMessage ?? this.errorMessage,
       currentQuery: currentQuery ?? this.currentQuery,
    );
  }
}

class ChampionError extends ChampionState {
  final String message;
  const ChampionError(this.message);

  @override
  List<Object> get props => [message];
}