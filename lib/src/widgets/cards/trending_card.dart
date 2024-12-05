import 'package:flutter/material.dart';
import 'package:showbox/src/widgets/custom_image_widget.dart';

class TrendingCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String rating;
  final String year;
  final String description;
  final String pricing;
  final VoidCallback onWatchPressed;

  const TrendingCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.rating,
    required this.year,
    required this.description,
    required this.pricing,
    required this.onWatchPressed,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textShadow = Shadow(
      offset: const Offset(2.0, 2.0),
      blurRadius: 4.0,
      color: isDark ? Colors.black.withOpacity(0.2) : Colors.white.withOpacity(0.4),
    );

    return Stack(
      children: [
        // Movie Poster Image with Gradient Overlay
        CustomImageNetworkWidget(
          imagePath: imageUrl,
          width: double.infinity,
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
                  isDark ? Colors.black.withOpacity(0.1) : Colors.white.withOpacity(0.1), // Subtle gradient at the top
                  Colors.transparent, // Middle transition
                  isDark ? Colors.black : Colors.white, // Bottom gradient
                ],
                stops: const [0.0, 0.4, 1.0], // Adjust stops for smoother blending
              ),
            ),
          ),
        ),
        // Movie Info Text and Button
        Center(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Movie Title
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    shadows: [textShadow],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                // Movie Rating and Duration
                Text(
                  "Rating $rating • $year",
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 14,
                    fontWeight: Theme.of(context).brightness == Brightness.dark ? FontWeight.w400: FontWeight.w600,
                    shadows: [textShadow],
                  ),
                ),
                const SizedBox(height: 12),
                // Movie Description
                SizedBox(
                  width: 280,
                  child: Text(
                    description,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 14,
                      fontWeight: Theme.of(context).brightness == Brightness.dark ? FontWeight.w300: FontWeight.w500,
                      height: 1.5,
                      shadows: [textShadow],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(height: 10),
                // Watch Button
                ElevatedButton(
                  onPressed: onWatchPressed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0XFFCBA84A).withOpacity(.9),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 58),
                  ),
                  child: Text(
                    "WATCH",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w300,
                      letterSpacing: 1,
                      height: 1.6,
                      shadows: [textShadow],
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
                    shadows: [textShadow],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
