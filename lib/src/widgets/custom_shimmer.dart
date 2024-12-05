import 'package:flutter/material.dart';

class CustomShimmer extends StatefulWidget {
  final double borderRadius;

  const CustomShimmer({super.key, this.borderRadius = 4});

  @override
  State<CustomShimmer> createState() => _CustomShimmerState();
}

class _CustomShimmerState extends State<CustomShimmer> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            gradient: LinearGradient(
              colors: [
                Colors.grey.withOpacity(.3),
                Colors.transparent,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        );
        // return Container(
        //   decoration: BoxDecoration(
        //     borderRadius: BorderRadius.circular(widget.borderRadius),
        //     color: Colors.grey.shade300,
        //     gradient: LinearGradient(
        //       colors: [
        //         Colors.grey.shade300,
        //         Colors.grey.shade100,
        //         Colors.grey.shade300,
        //       ],
        //       stops: const [0.3, 0.5, 0.7],
        //       begin: Alignment(-1 + _controller.value * 2, 0),
        //       end: Alignment(1 + _controller.value * 2, 0),
        //     ),
        //   ),
        // );
      },
    );
  }
}

class AppShimmers {
  // Build Movie/Series Card Shimmer
  buildMovieSeriesShimmerList() {
    return SizedBox(
      height: 280,
      child: ListView.separated(
        separatorBuilder: (context, index) => const SizedBox(width: 10),
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.only(left: 10, right: 10),
        itemCount: 5, // For shimmer effect, show a limited number
        itemBuilder: (context, index) {
          return const Padding(
            padding: EdgeInsets.only(right: 10),
            child: SizedBox(
              width: 132,
              height: 180,
              child: CustomShimmer(),
            ),
          );
        },
      ),
    );
  }

  // Shimmer for trending list
  trendingMovieSeriesShimmer() {
    return SizedBox(
      height: 280,  // Adjust height based on your design
      width: double.infinity,
      child: PageView.builder(
        itemCount: 3,  // Number of shimmer placeholders
        controller: PageController(
          initialPage: 1,
          viewportFraction: 0.6
        ),  // Make side items smaller
        itemBuilder: (context, index) {
          // For shimmer effect, we just use containers to simulate images
          double scale = index == 1 ? 1.0 : 0.7;  // Active image in the center is larger
          return AnimatedScale(
            scale: scale,
            duration: const Duration(milliseconds: 350),
            child: Container(
              width: 100,
              height: 180,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: const CustomShimmer(),
            ),
          );
        },
      ),
    );
  }
}