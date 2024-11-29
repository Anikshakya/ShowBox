import 'package:flutter/material.dart';
import 'package:showbox/src/constant/constants.dart';
import 'package:showbox/src/widgets/custom_image_widget.dart';

class ItemCard extends StatelessWidget {
  final String title;
  final String year;
  final double rating;
  final String image;
  final dynamic width;

  const ItemCard({
    super.key,
    required this.title,
    required this.year,
    required this.rating,
    required this.image, 
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width?.toDouble(),
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).primaryColor.withOpacity(0.1), width: 1),
        borderRadius: BorderRadius.circular(2),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(2),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Movie image
            CustomImageNetworkWidget(
              borderRadius: 2,
              imagePath: "${AppConstants.imageUrl}$image",
            ),
            // Display the release year at the top-left corner
            Visibility(
              visible: year != "",
              child: Positioned(
                top: 0,
                left: 0,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    borderRadius: const BorderRadius.only(
                        bottomRight: Radius.circular(8)),
                  ),
                  child: Text(
                    year,
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ),
            ),
            // Display the rating at the top-right corner
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0XFFCBA84A).withOpacity(0.9),
                  borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(8)),
                ),
                child: Text(
                  rating.toStringAsFixed(1), // Format rating to 1 decimal
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}