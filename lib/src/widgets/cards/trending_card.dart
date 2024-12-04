import 'package:flutter/material.dart';

class TrendingCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String rating;
  final String duration;
  final String description;
  final String pricing;
  final VoidCallback onWatchPressed;

  const TrendingCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.rating,
    required this.duration,
    required this.description,
    required this.pricing,
    required this.onWatchPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Movie Poster Image with Gradient Overlay
        Image.network(
          imageUrl,
          width: double.infinity,
          height: 480,
          fit: BoxFit.cover,
        ),
        // Gradient Overlay (Linear Gradient)
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Theme.of(context).brightness == Brightness.dark ? Colors.black : Colors.white, // Darker gradient start
                ],
              ),
            ),
          ),
        ),
        // Movie Info Text and Button
        Center(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 40.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Movie Title
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                // Movie Rating and Duration
                Text(
                  "$rating • $duration",
                  style: TextStyle(
                   color: Theme.of(context).primaryColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 12),
                // Movie Description
                Text(
                  description,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                   color: Theme.of(context).primaryColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w300,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 20),
                // Watch Button
                ElevatedButton(
                  onPressed: onWatchPressed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 30),
                  ),
                  child: const Text(
                    "Watch",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                // Movie Pricing Information
                Text(
                  pricing,
                  style: TextStyle(
                   color: Theme.of(context).primaryColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
