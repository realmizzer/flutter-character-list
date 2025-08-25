part of 'favorite_bloc.dart';

enum FavoriteStatus { initial, loading, success, failure }

class FavoriteState extends Equatable {
  final FavoriteStatus status;
  final List<CharacterModel> characters;
  final List<CharacterModel> sortedCharacters;
  final SortBy? currentSort;
  final String? errorMessage;

  const FavoriteState({
    this.status = FavoriteStatus.initial,
    this.characters = const [],
    this.sortedCharacters = const [],
    this.currentSort,
    this.errorMessage,
  });

  FavoriteState copyWith({
    FavoriteStatus? status,
    List<CharacterModel>? characters,
    List<CharacterModel>? sortedCharacters,
    SortBy? currentSort,
    String? errorMessage,
  }) {
    return FavoriteState(
      status: status ?? this.status,
      characters: characters ?? this.characters,
      sortedCharacters: sortedCharacters ?? this.sortedCharacters,
      currentSort: currentSort ?? this.currentSort,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    characters,
    sortedCharacters,
    currentSort,
    errorMessage,
  ];
}
