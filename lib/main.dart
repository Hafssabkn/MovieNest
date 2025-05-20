import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:movienest/pages/favorite.dart';
import 'package:movienest/pages/home.dart';
import 'package:movienest/pages/search.dart';
import 'package:movienest/pages/splashScreen.dart';
import 'package:movienest/pages/start.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final dbPath = await getDatabasesPath();
  await deleteDatabase(join(dbPath, 'favorites.db')); // Supprimer l'ancienne base
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movie Nest',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFF330F3D)),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/start': (context) => const StartPage(),
        //'/home' : (context) => const Home(),
        '/home' : (context) => const MainNavigation(),
        '/search': (context) => SearchPage(),
      },
    );
  }
}

class MainNavigation extends StatefulWidget{
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    Home(),
    SearchPage(),
    FavoritePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff5d2376),
      body: _pages[_selectedIndex],
      bottomNavigationBar: Container(
        color: Color(0xFF330f3d),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
          child: GNav(
            backgroundColor: Color(0xFF330f3d),
            color: Colors.white,
            activeColor: Colors.white,
            tabBackgroundColor: Color(0xff5d2376).withOpacity(0.4),
            gap: 8,
            padding: EdgeInsets.all(16.0),
            selectedIndex: _selectedIndex,
            onTabChange: _onItemTapped,
            tabs: const [
              GButton(
                icon: Icons.home,
                text: "Accueil",
              ),
              GButton(
                icon: Icons.search,
                text: "Recherche",
              ),
              GButton(
                icon: Icons.list,
                text: "Librairie",
              ),
            ],
          ),
        ),
      ),
    );
  }
}

