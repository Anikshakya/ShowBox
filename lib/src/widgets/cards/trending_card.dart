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

    return Stack(
      children: [
        // Movie Poster Image with Gradient Overlay
        CustomImageNetworkWidget(
          imagePath: imageUrl,
          width: double.infinity,
          fit: BoxFit.cover,
        ),
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withOpacity(0.5),
                ],
              ),
            ),
          ),
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
                  isDark ? Colors.black : Colors.white,
                ],
              ),
            ),
          ),
        ),
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.center,
                end: Alignment.topCenter,
                colors: [
                  Colors.transparent,
                  Colors.white.withOpacity(0.5),
                ],
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
                  title   ,
                  style: TextStyle(
                    fontSize: 26,
                    color: Colors.white.withOpacity(0.7),
                    fontWeight: FontWeight.w300,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                // Movie Rating and Duration
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "Rating • ",
                        style: TextStyle(
                          color: Theme.of(context).primaryColor.withOpacity(0.6),
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      TextSpan(
                        text: rating,
                        style: const TextStyle(
                          color: Color(0xffecc877), // Change to your desired color
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      TextSpan(
                        text: "  •  $year",
                        style: TextStyle(
                          color: Theme.of(context).primaryColor.withOpacity(0.6),
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),
                // Movie Description
                SizedBox(
                  width: 320,
                  child: Text(
                    description,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Theme.of(context).primaryColor.withOpacity(0.93),
                      fontSize: 14,
                      fontWeight: Theme.of(context).brightness == Brightness.dark ? FontWeight.w300: FontWeight.w400,
                      height: 1.5,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(height: 10),
                // Watch Button
                GestureDetector(
                  onTap: onWatchPressed, // The tap event handler
                  child: Container(
                    height: 40,
                    width: 180,
                    decoration: BoxDecoration(
                      color: const Color(0x00ecc877).withOpacity(.9), // Button color
                      borderRadius: BorderRadius.circular(4), // Rounded corners
                    ),
                    // padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 0), // Padding for content
                    alignment: Alignment.center, // Center-align the text
                    child: const Text(
                      "WATCH",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w300,
                        letterSpacing: 1,
                        height: 1.6,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                // Movie Pricing Information
                Text(
                  pricing,
                  style: TextStyle(
                    color: Theme.of(context).primaryColor.withOpacity(0.6),
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
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
