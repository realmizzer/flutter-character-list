import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_character_list/presentation/bloc/favorite/favorite_bloc.dart';
import 'package:flutter_character_list/presentation/widgets/character_card.dart';
import 'package:flutter_character_list/presentation/widgets/sort_dialog.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.sort),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => const SortDialog(),
              );
            },
          ),
        ],
      ),
      body: BlocConsumer<FavoriteBloc, FavoriteState>(
        listener: (context, state) {
          if (state.errorMessage != null) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
          }
        },
        builder: (context, state) {
          if (state.status == FavoriteStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.sortedCharacters.isEmpty) {
            return const Center(child: Text('No favorite characters yet!'));
          }

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.builder(
              itemCount: state.sortedCharacters.length,
              itemBuilder: (context, index) {
                return CharacterCard(
                  character: state.sortedCharacters[index],
                  isFavoriteScreen: true,
                );
              },
            ),
          );
        },
      ),
    );
  }
}
