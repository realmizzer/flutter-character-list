import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_character_list/data/models/character_model.dart';
import 'package:flutter_character_list/domain/repositories/character_repository.dart';

part 'favorite_event.dart';
part 'favorite_state.dart';

class FavoriteBloc extends Bloc<FavoriteEvent, FavoriteState> {
  final CharacterRepository characterRepository;

  FavoriteBloc({required this.characterRepository})
      : super(const FavoriteState()) {
    on<LoadFavorites>(_onLoadFavorites);
    on<RemoveFavorite>(_onRemoveFavorite);
    on<SortFavorites>(_onSortFavorites);
    on<RefreshFavorites>(_onRefreshFavorites);
  }

  Future<void> _onLoadFavorites(
    LoadFavorites event,
    Emitter<FavoriteState> emit,
  ) async {
    try {
      emit(state.copyWith(status: FavoriteStatus.loading));

      final favorites = await characterRepository.getFavoriteCharacters();

      emit(state.copyWith(
        status: FavoriteStatus.success,
        characters: favorites,
        sortedCharacters: _sortCharacters(favorites, state.currentSort),
      ));
    } catch (e) {
      emit(state.copyWith(
        status: FavoriteStatus.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _onRemoveFavorite(
    RemoveFavorite event,
    Emitter<FavoriteState> emit,
  ) async {
    try {
      await characterRepository.toggleFavorite(event.character);

      final updatedCharacters = state.characters
          .where((character) => character.id != event.character.id)
          .toList();

      emit(state.copyWith(
        characters: updatedCharacters,
        sortedCharacters: _sortCharacters(updatedCharacters, state.currentSort),
      ));
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }

  Future<void> _onRefreshFavorites(
    RefreshFavorites event,
    Emitter<FavoriteState> emit,
  ) async {
    try {
      final favorites = await characterRepository.getFavoriteCharacters();
      
      emit(state.copyWith(
        characters: favorites,
        sortedCharacters: _sortCharacters(favorites, state.currentSort),
      ));
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }

  void _onSortFavorites(
    SortFavorites event,
    Emitter<FavoriteState> emit,
  ) {
    final sortedCharacters = _sortCharacters(state.characters, event.sortBy);
    
    emit(state.copyWith(
      sortedCharacters: sortedCharacters,
      currentSort: event.sortBy,
    ));
  }

  List<CharacterModel> _sortCharacters(List<CharacterModel> characters, SortBy? sortBy) {
    if (sortBy == null) return characters;

    final sorted = List<CharacterModel>.from(characters);
    
    switch (sortBy) {
      case SortBy.name:
        sorted.sort((a, b) => a.name.compareTo(b.name));
        break;
      case SortBy.status:
        sorted.sort((a, b) => a.status.compareTo(b.status));
        break;
      case SortBy.species:
        sorted.sort((a, b) => a.species.compareTo(b.species));
        break;
    }

    return sorted;
  }
}