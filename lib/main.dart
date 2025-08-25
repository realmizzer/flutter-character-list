import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_character_list/data/datasources/character_local_data_source.dart';
import 'package:flutter_character_list/data/datasources/character_remote_data_source.dart';
import 'package:flutter_character_list/data/repositories/character_repository_impl.dart';
import 'package:flutter_character_list/domain/repositories/character_repository.dart';
import 'package:flutter_character_list/presentation/bloc/character/character_bloc.dart';
import 'package:flutter_character_list/presentation/bloc/favorite/favorite_bloc.dart';
import 'package:flutter_character_list/presentation/pages/favorites_screen.dart';
import 'package:flutter_character_list/presentation/pages/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final SharedPreferences sharedPreferences =
      await SharedPreferences.getInstance();
  final Dio dio = Dio();

  final CharacterRemoteDataSource remoteDataSource =
      CharacterRemoteDataSourceImpl(dio: dio);
  final CharacterLocalDataSource localDataSource = CharacterLocalDataSourceImpl(
    sharedPreferences: sharedPreferences,
  );

  final CharacterRepository characterRepository = CharacterRepositoryImpl(
    remoteDataSource: remoteDataSource,
    localDataSource: localDataSource,
  );

  runApp(MyApp(characterRepository: characterRepository));
}

class MyApp extends StatelessWidget {
  final CharacterRepository characterRepository;

  const MyApp({super.key, required this.characterRepository});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              CharacterBloc(characterRepository: characterRepository)
                ..add(const LoadCharacters()),
        ),
        BlocProvider(
          create: (context) =>
              FavoriteBloc(characterRepository: characterRepository)
                ..add(const LoadFavorites()),
        ),
      ],
      child: MaterialApp(
        title: 'Rick and Morty',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        darkTheme: ThemeData.dark().copyWith(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.deepPurple,
            brightness: Brightness.dark,
          ),
        ),
        themeMode: ThemeMode.system,
        home: const MainNavigation(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  final List<Widget> _screens = [const HomeScreen(), const FavoritesScreen()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Characters',
            activeIcon: Icon(Icons.home),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star_border_outlined),
            label: 'Favorites',
            activeIcon: Icon(Icons.star),
          ),
        ],
      ),
    );
  }
}
