import 'package:flutter/material.dart';
import 'package:movienest/pages/home.dart';
import 'package:movienest/pages/search.dart';
import 'package:movienest/pages/splashScreen.dart';
import 'package:movienest/pages/start.dart';
import 'package:movienest/pages/main_navigation.dart';

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
        '/': (context) => const SplashScreen(),
        '/start': (context) => const StartPage(),
        '/home' : (context) => const Home(),
        '/search': (context) => SearchPage()
      },
    );
  }
}
