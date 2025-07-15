abstract class ChampionEvent {
  const ChampionEvent();

  @override
  List<Object> get props => [];
}

class LoadChampions extends ChampionEvent {}

class SearchChampions extends ChampionEvent {
  final String query;
  const SearchChampions(this.query);

  @override
  List<Object> get props => [query];
}

class ClearSearch extends ChampionEvent {}
