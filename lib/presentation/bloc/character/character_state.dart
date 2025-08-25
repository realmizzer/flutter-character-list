part of 'character_bloc.dart';

enum CharacterStatus { initial, loading, success, failure }

class CharacterState extends Equatable {
  final CharacterStatus status;
  final List<CharacterModel> characters;
  final bool hasReachedMax;
  final int currentPage;
  final String? errorMessage;

  const CharacterState({
    this.status = CharacterStatus.initial,
    this.characters = const [],
    this.hasReachedMax = false,
    this.currentPage = 1,
    this.errorMessage,
  });

  CharacterState copyWith({
    CharacterStatus? status,
    List<CharacterModel>? characters,
    bool? hasReachedMax,
    int? currentPage,
    String? errorMessage,
  }) {
    return CharacterState(
      status: status ?? this.status,
      characters: characters ?? this.characters,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      currentPage: currentPage ?? this.currentPage,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        characters,
        hasReachedMax,
        currentPage,
        errorMessage,
      ];
}