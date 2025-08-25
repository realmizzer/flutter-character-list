import 'package:flutter_character_list/data/models/character_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

abstract class CharacterLocalDataSource {
  Future<List<CharacterModel>> getFavoriteCharacters();
  Future<void> saveFavoriteCharacters(List<CharacterModel> characters);
  Future<List<int>> getFavoriteIds();
  Future<void> saveFavoriteIds(List<int> ids);
}

class CharacterLocalDataSourceImpl implements CharacterLocalDataSource {
  final SharedPreferences sharedPreferences;

  CharacterLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<List<CharacterModel>> getFavoriteCharacters() async {
    final jsonString = sharedPreferences.getString('favorite_characters');
    if (jsonString != null) {
      try {
        final List<dynamic> jsonList = json.decode(jsonString);
        return jsonList.map((json) => CharacterModel.fromJson(json)).toList();
      } catch (e) {
        print('Error parsing favorite characters: $e');
        return [];
      }
    }
    return [];
  }

  @override
  Future<void> saveFavoriteCharacters(List<CharacterModel> characters) async {
    try {
      final jsonList = characters.map((character) => character.toJson()).toList();
      await sharedPreferences.setString('favorite_characters', json.encode(jsonList));
    } catch (e) {
      print('Error saving favorite characters: $e');
    }
  }

  @override
  Future<List<int>> getFavoriteIds() async {
    final jsonString = sharedPreferences.getString('favorite_ids');
    if (jsonString != null) {
      try {
        final List<dynamic> jsonList = json.decode(jsonString);
        return jsonList.map((id) => id is int ? id : int.parse(id.toString())).toList();
      } catch (e) {
        print('Error parsing favorite ids: $e');
        return [];
      }
    }
    return [];
  }

  @override
  Future<void> saveFavoriteIds(List<int> ids) async {
    try {
      await sharedPreferences.setString('favorite_ids', json.encode(ids));
    } catch (e) {
      print('Error saving favorite ids: $e');
    }
  }
}