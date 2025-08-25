import 'package:flutter_character_list/data/datasources/character_local_data_source.dart';
import 'package:flutter_character_list/data/datasources/character_remote_data_source.dart';
import 'package:flutter_character_list/data/models/character_model.dart';
import 'package:flutter_character_list/domain/entities/character_entity.dart';
import 'package:flutter_character_list/domain/repositories/character_repository.dart';

class CharacterRepositoryImpl implements CharacterRepository {
  final CharacterRemoteDataSource remoteDataSource;
  final CharacterLocalDataSource localDataSource;

  CharacterRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<List<CharacterModel>> getCharacters(int page) async {
    try {
      final characters = await remoteDataSource.getCharacters(page);
      final favoriteIds = await localDataSource.getFavoriteIds();

      return characters.map((character) {
        return character.copyWith(
          isFavorite: favoriteIds.contains(character.id),
        );
      }).toList();
    } catch (e) {
      print('Error getting characters: $e');
      rethrow;
    }
  }

  @override
  Future<List<CharacterModel>> getFavoriteCharacters() async {
    try {
      return await localDataSource.getFavoriteCharacters();
    } catch (e) {
      print('Error getting favorite characters: $e');
      rethrow;
    }
  }

  @override
  Future<void> toggleFavorite(CharacterModel character) async {
    try {
      final favoriteIds = await localDataSource.getFavoriteIds();
      final favoriteCharacters = await localDataSource.getFavoriteCharacters();

      if (favoriteIds.contains(character.id)) {
        // Удаляем из избранного
        favoriteIds.remove(character.id);
        favoriteCharacters.removeWhere((c) => c.id == character.id);
      } else {
        // Добавляем в избранное
        favoriteIds.add(character.id);
        favoriteCharacters.add(character.copyWith(isFavorite: true));
      }

      await localDataSource.saveFavoriteIds(favoriteIds);
      await localDataSource.saveFavoriteCharacters(favoriteCharacters);
    } catch (e) {
      print('Error toggling favorite: $e');
      rethrow;
    }
  }
}
