import 'package:flutter/material.dart';
import 'package:flutter_character_list/presentation/screens/characters_screen.dart';
import 'package:flutter_character_list/presentation/screens/favorites_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final List<Widget> _screens = [CharactersScreen(), FavoritesScreen()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: _screens.elementAt(_currentIndex),
      bottomNavigationBar: NavigationBar(
        destinations: [
          NavigationDestination(icon: Icon(Icons.person), label: 'Characters'),
          NavigationDestination(icon: Icon(Icons.star), label: 'Favorites'),
        ],
        onDestinationSelected: (value) {
          setState(() {
            _currentIndex = value;
          });
          print(_currentIndex);
        },
        selectedIndex: _currentIndex,
      ),
    );
  }
}
