import 'package:flutter/material.dart';
import 'package:movienest/pages/search.dart';
import 'package:movienest/pages/splashScreen.dart';
import 'package:movienest/pages/start.dart';
import 'package:movienest/pages/main_navigation.dart'; // ici le menu en bas

void main() {
  runApp(const MyApp());
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
        '/': (context) => const SplashScreen(),     // Étape 1
        '/start': (context) => const StartPage(),   // Étape 2
        '/search': (context) => SearchPage() // Étape 3 avec menu
      },
    );
  }
}
