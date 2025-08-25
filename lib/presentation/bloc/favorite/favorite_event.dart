part of 'favorite_bloc.dart';

enum SortBy { name, status, species }

abstract class FavoriteEvent extends Equatable {
  const FavoriteEvent();

  @override
  List<Object> get props => [];
}

class LoadFavorites extends FavoriteEvent {
  const LoadFavorites();
}

class RefreshFavorites extends FavoriteEvent {
  const RefreshFavorites();
}

class RemoveFavorite extends FavoriteEvent {
  final CharacterModel character;

  const RemoveFavorite(this.character);

  @override
  List<Object> get props => [character];
}

class SortFavorites extends FavoriteEvent {
  final SortBy sortBy;

  const SortFavorites(this.sortBy);

  @override
  List<Object> get props => [sortBy];
}