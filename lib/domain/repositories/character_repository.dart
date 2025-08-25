import 'package:flutter_character_list/data/models/character_model.dart';

abstract class CharacterRepository {
  Future<List<CharacterModel>> getCharacters(int page);
  Future<List<CharacterModel>> getFavoriteCharacters();
  Future<void> toggleFavorite(CharacterModel character);
}