import 'package:dio/dio.dart';
import 'package:flutter_character_list/data/models/character_model.dart';

abstract class CharacterRemoteDataSource {
  Future<List<CharacterModel>> getCharacters(int page);
}

class CharacterRemoteDataSourceImpl implements CharacterRemoteDataSource {
  final Dio dio;

  CharacterRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<CharacterModel>> getCharacters(int page) async {
    try {
      final response = await dio.get(
        'https://rickandmortyapi.com/api/character',
        queryParameters: {'page': page},
      );

      if (response.statusCode == 200) {
        final data = response.data['results'] as List;
        return data.map((json) => CharacterModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load characters');
      }
    } catch (e) {
      throw Exception('Failed to load characters: $e');
    }
  }
}
