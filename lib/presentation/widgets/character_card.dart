import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_character_list/data/models/character_model.dart';
import 'package:flutter_character_list/presentation/bloc/character/character_bloc.dart';
import 'package:flutter_character_list/presentation/bloc/favorite/favorite_bloc.dart';

class CharacterCard extends StatelessWidget {
  final CharacterModel character;
  final bool isFavoriteScreen;

  const CharacterCard({
    super.key,
    required this.character,
    this.isFavoriteScreen = false,
  });

  void _toggleFavorite(BuildContext context) {
    if (isFavoriteScreen) {
      context.read<FavoriteBloc>().add(RemoveFavorite(character));
    } else {
      context.read<CharacterBloc>().add(ToggleFavorite(character));

      Future.delayed(const Duration(milliseconds: 100), () {
        context.read<FavoriteBloc>().add(const LoadFavorites());
      });
    }
  }

  Icon getToggleFavoriteButton() {
    if (isFavoriteScreen) {
      return Icon(Icons.delete_outline);
    }

    IconData iconData;
    Color? color;
    if (character.isFavorite) {
      iconData = Icons.star;
      color = Colors.amber;
    } else {
      iconData = Icons.star_border;
    }
    return Icon(iconData, color: color);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Row(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(8.0)),
            child: CachedNetworkImage(
              imageUrl: character.image,
              width: 100,
              height: 100,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                width: 100,
                height: 100,
                color: Colors.grey[300],
                child: const Icon(Icons.person, size: 40),
              ),
              errorWidget: (context, url, error) => Container(
                width: 100,
                height: 100,
                color: Colors.grey[300],
                child: const Icon(Icons.error, size: 40),
              ),
            ),
          ),
          const SizedBox(width: 8.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  character.name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text('Status: ${character.status}'),
                Text('Species: ${character.species}'),
                Text('Location: ${character.location}'),
              ],
            ),
          ),
          IconButton(
            icon: getToggleFavoriteButton(),
            onPressed: () => _toggleFavorite(context),
          ),
        ],
      ),
    );
  }
}
