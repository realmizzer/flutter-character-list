import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_character_list/presentation/bloc/favorite/favorite_bloc.dart';

class SortDialog extends StatelessWidget {
  const SortDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final currentSort = context.select<FavoriteBloc, SortBy?>(
      (bloc) => bloc.state.currentSort,
    );

    return AlertDialog(
      title: const Text('Sort by'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          RadioListTile<SortBy>(
            value: SortBy.name,
            groupValue: currentSort,
            title: const Text('Name'),
            onChanged: (value) {
              if (value != null) {
                context.read<FavoriteBloc>().add(SortFavorites(value));
                Navigator.pop(context);
              }
            },
          ),
          RadioListTile<SortBy>(
            value: SortBy.status,
            groupValue: currentSort,
            title: const Text('Status'),
            onChanged: (value) {
              if (value != null) {
                context.read<FavoriteBloc>().add(SortFavorites(value));
                Navigator.pop(context);
              }
            },
          ),
          RadioListTile<SortBy>(
            value: SortBy.species,
            groupValue: currentSort,
            title: const Text('Species'),
            onChanged: (value) {
              if (value != null) {
                context.read<FavoriteBloc>().add(SortFavorites(value));
                Navigator.pop(context);
              }
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
      ],
    );
  }
}
