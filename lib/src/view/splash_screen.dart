import 'package:flutter/material.dart';
import 'package:showbox/src/view/bottom_nav.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _opacityController;  // Controller for opacity animation
  late AnimationController _scaleController;  // Controller for scale (zoom-in) animation

  late Animation<double> _opacity;  // Animation for opacity
  late Animation<double> _scale;  // Animation for scaling

  @override
  void initState() {
    super.initState();
    
    // Animation 1: Opacity animation
    _opacityController = AnimationController(
      duration: const Duration(seconds: 2),  // Opacity animation duration
      vsync: this,
    );

    _scaleController = AnimationController(
      duration: const Duration(seconds: 2),  // Scale animation duration
      vsync: this,
    );


    _opacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _opacityController, curve: Curves.easeIn),
    );
    _opacityController.forward();  // Start opacity animation

    // Navigate to the next screen after the total animation duration (4 seconds)
    Future.delayed(const Duration(seconds: 4), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const BottomNav()),
      );
    });

    // Start the zoom animation after opacity reaches 1 (delay by 2 seconds)
    Future.delayed(const Duration(seconds: 3), () {
      _startZoomAnimation();  // Start zoom animation
    });
  }

  // Start scale (zoom) animation after opacity animation finishes
  void _startZoomAnimation() {
    // Initialize _scaleController only when it's time to start the zoom animation
    // Define the scale animation from 1 to 2 (zoom in effect)
    _scale = Tween<double>(begin: 1.0, end: 80.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut),
    );

    // Start zoom-in animation
    _scaleController.forward();
  }

  @override
  void dispose() {
    _opacityController.dispose();  // Dispose opacity controller
    if (_scaleController.isAnimating) {
      _scaleController.dispose();  // Dispose scale controller if it's animating
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FadeTransition(
          opacity: _opacity,  // Apply opacity animation
          child: AnimatedBuilder(
            animation: _scaleController,  // Bind scale animation to AnimatedBuilder
            builder: (context, child) {
              // Apply scaling animation after opacity is fully visible
              return Transform.scale(
                scale: _scaleController.isAnimating ? _scale.value : 1.0,  // Apply zoom effect based on the scale animation
                child: child,
              );
            },
            child: const Text(
              'ShowBox',
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:showbox/src/view/bottom_nav.dart';

// class SplashScreen extends StatefulWidget {
//   const SplashScreen({super.key});

//   @override
//   _SplashScreenState createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
//   late AnimationController _scaleController;  // Controller for scale (zoom-in) animation
//   late Animation<double> _scale;  // Animation for scaling

//   @override
//   void initState() {
//     super.initState();

//     _scaleController = AnimationController(
//       duration: const Duration(seconds: 1),  // Scale animation duration
//       vsync: this,
//     );
//     // Start the zoom animation after opacity reaches 1 (delay by 2 seconds)
//       _startZoomAnimation(); 

//     // Navigate to the next screen after the total animation duration (4 seconds)
//     Future.delayed(const Duration(seconds: 4), () {
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => const BottomNav()),
//       );
//     });
//   }

//   // Start scale (zoom) animation after opacity animation finishes
//   void _startZoomAnimation() {
//     // Initialize _scaleController only when it's time to start the zoom animation
//     // Define the scale animation from 1 to 2 (zoom in effect)
//     _scale = Tween<double>(begin: 200.0, end: 1.0).animate(
//       CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut),
//     );

//     // Start zoom-in animation
//     _scaleController.forward();
//   }

//   @override
//   void dispose() {
//     if (_scaleController.isAnimating) {
//       _scaleController.dispose();  // Dispose scale controller if it's animating
//     }
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: AnimatedBuilder(
//           animation: _scaleController,  // Bind scale animation to AnimatedBuilder
//           builder: (context, child) {
//             // Apply scaling animation after opacity is fully visible
//             return Transform.scale(
//               scale: _scaleController.isAnimating ? _scale.value : 1.0,  // Apply zoom effect based on the scale animation
//               child: child,
//             );
//           },
//           child: const Text(
//             'ShowBox',
//             style: TextStyle(
//               fontSize: 40,
//               fontWeight: FontWeight.bold
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }