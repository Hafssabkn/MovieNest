import 'package:flutter/material.dart';
import 'package:movienest/pages/start.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const StartPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF330F3D),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Image(
              image: AssetImage('images/movieNest.png'),
              width: 400,
              height: 400,
            ),
            LoadingAnimationWidget.twistingDots(
              leftDotColor: Colors.white,
              rightDotColor: Colors.white,
              size: 80,
            ),
          ],
        ),
      ),
    );
  }
}
