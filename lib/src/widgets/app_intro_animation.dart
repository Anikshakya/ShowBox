import 'package:flutter/material.dart';

class AppIntroAnimation extends StatefulWidget {
  final Widget child;

  const AppIntroAnimation({super.key, required this.child});

  @override
  State<AppIntroAnimation> createState() => _AppIntroAnimationState();
}

class _AppIntroAnimationState extends State<AppIntroAnimation> with TickerProviderStateMixin {
  late AnimationController _opacityController;  // Controller for opacity animation
  late AnimationController _scaleController;  // Controller for scale (bounce) animation
  
  late Animation<double> _opacity;  // Animation for opacity
  late Animation<double> _scale;  // Animation for scale (bounce effect)

  @override
  void initState() {
    super.initState();

    // Animation for opacity (fade in)
    _opacityController = AnimationController(
      duration: const Duration(seconds: 1),  // Animation duration
      vsync: this,
    );
    _opacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _opacityController, curve: Curves.easeIn),
    );

    // Animation for scale (bounce effect)
    _scaleController = AnimationController(
      duration: const Duration(seconds: 2),  // Increased bounce duration
      vsync: this,
    );
    _scale = Tween<double>(begin: 0.0, end: 1.2).animate(  // Less scale to keep it smooth
      CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut),  // Elastic bounce curve
    );

    // Start fade-in animation
    _opacityController.forward();

    // After fade-in completes, start the bounce (scale) animation
    Future.delayed(const Duration(milliseconds: 200), () {
      _scaleController.forward();  // Start bounce animation
    });

    // After 2 seconds of opacity fade, start fade-out animation (reverse)
    Future.delayed(const Duration(milliseconds: 3000), () {
      _opacityController.reverse();  // Start fade-out animation (reverse)
    });
  }

  @override
  void dispose() {
    _opacityController.dispose();  // Dispose opacity controller
    _scaleController.dispose();  // Dispose scale controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacity,  // Apply opacity animation (fade in and out)
      child: AnimatedBuilder(
        animation: _scaleController,  // Bind scale animation to AnimatedBuilder
        builder: (context, child) {
          return Transform.scale(
            scale: _scale.value,  // Apply bounce effect (scale)
            child: child,
          );
        },
        child: widget.child,  // Wrap the passed widget (Text or any other widget)
      ),
    );
  }
}
