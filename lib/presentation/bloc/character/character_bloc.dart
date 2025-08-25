import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_character_list/data/models/character_model.dart';
import 'package:flutter_character_list/domain/repositories/character_repository.dart';

part 'character_event.dart';
part 'character_state.dart';

class CharacterBloc extends Bloc<CharacterEvent, CharacterState> {
  final CharacterRepository characterRepository;

  CharacterBloc({required this.characterRepository})
    : super(const CharacterState()) {
    on<LoadCharacters>(_onLoadCharacters);
    on<LoadMoreCharacters>(_onLoadMoreCharacters);
    on<ToggleFavorite>(_onToggleFavorite);
  }

  Future<void> _onLoadCharacters(
    LoadCharacters event,
    Emitter<CharacterState> emit,
  ) async {
    try {
      emit(
        state.copyWith(
          status: CharacterStatus.loading,
          characters: event.isRefresh ? [] : state.characters,
          currentPage: event.isRefresh ? 1 : state.currentPage,
        ),
      );

      final characters = await characterRepository.getCharacters(1);

      emit(
        state.copyWith(
          status: CharacterStatus.success,
          characters: characters,
          currentPage: 1,
          hasReachedMax: characters.length < 20,
        ),
      );
    } catch (e) {
      print('Error loading characters: $e');
      emit(
        state.copyWith(
          status: CharacterStatus.failure,
          errorMessage: 'Failed to load characters',
        ),
      );
    }
  }

  Future<void> _onLoadMoreCharacters(
    LoadMoreCharacters event,
    Emitter<CharacterState> emit,
  ) async {
    if (state.hasReachedMax || state.status == CharacterStatus.loading) {
      return;
    }

    try {
      emit(state.copyWith(status: CharacterStatus.loading));

      final nextPage = state.currentPage + 1;
      final newCharacters = await characterRepository.getCharacters(nextPage);

      emit(
        state.copyWith(
          status: CharacterStatus.success,
          characters: [...state.characters, ...newCharacters],
          currentPage: nextPage,
          hasReachedMax: newCharacters.length < 20,
        ),
      );
    } catch (e) {
      print('Error loading more characters: $e');
      emit(
        state.copyWith(
          status: CharacterStatus.failure,
          errorMessage: 'Failed to load more characters',
        ),
      );
    }
  }

  Future<void> _onToggleFavorite(
    ToggleFavorite event,
    Emitter<CharacterState> emit,
  ) async {
    try {
      await characterRepository.toggleFavorite(event.character);

      final updatedCharacters = state.characters.map((character) {
        if (character.id == event.character.id) {
          return character.copyWith(isFavorite: !character.isFavorite);
        }
        return character;
      }).toList();

      emit(state.copyWith(characters: updatedCharacters));
    } catch (e) {
      print('Error toggling favorite: $e');
      emit(state.copyWith(errorMessage: 'Failed to toggle favorite'));
    }
  }
}
