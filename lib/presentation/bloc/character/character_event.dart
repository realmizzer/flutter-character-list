part of 'character_bloc.dart';

abstract class CharacterEvent extends Equatable {
  const CharacterEvent();

  @override
  List<Object> get props => [];
}

class LoadCharacters extends CharacterEvent {
  final bool isRefresh;

  const LoadCharacters({this.isRefresh = false});

  @override
  List<Object> get props => [isRefresh];
}

class ToggleFavorite extends CharacterEvent {
  final CharacterModel character;

  const ToggleFavorite(this.character);

  @override
  List<Object> get props => [character];
}

class LoadMoreCharacters extends CharacterEvent {}
