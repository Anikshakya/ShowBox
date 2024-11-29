import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:showbox/src/view/bottom_nav.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  late Animation<double> _scaleAnimation;
  late AnimationController _zoomController;

  @override
  void initState() {
    super.initState();

    // Initialize main controller for the total duration (4 seconds).
    _controller = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    );

    // Opacity animation (fade in the logo) for the first 2 seconds.
    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    // Zoom animation for the last 2 seconds after opacity reaches 1.
    _scaleAnimation = Tween<double>(begin: 1.0, end: 3.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    // Start the opacity animation first.
    _controller.forward();

    // After 2 seconds (when opacity reaches 1), start zooming.
    Future.delayed(const Duration(seconds: 2), () {
      // Start the zoom animation.
      _controller.animateTo(1.0, duration: const Duration(seconds: 2), curve: Curves.easeOut);
    });

    // Navigate to the next screen after 4 seconds.
    Future.delayed(const Duration(seconds: 4), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const BottomNav()),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Black background for premium feel
      body: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Opacity(
              opacity: _opacityAnimation.value, // Apply the opacity fade in
              child: Transform.scale(
                scale: _scaleAnimation.value, // Apply the zoom effect after opacity
                child: child,
              ),
            );
          },
          child: Text(
            'ShowBox',
            style: GoogleFonts.poppins(
              fontSize: 32,
              fontWeight: FontWeight.w600,
              color: Colors.white, // Premium white color
            ),
          ),
        ),
      ),
    );
  }
}