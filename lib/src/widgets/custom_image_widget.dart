import 'package:flutter/material.dart';
import 'package:showbox/src/widgets/custom_shimmer.dart';

class CustomImageNetworkWidget extends StatelessWidget {
  const CustomImageNetworkWidget({
    super.key,
    required this.imagePath,
  });

  final String imagePath;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Image.network(
        imagePath,
        width: double.infinity,
        fit: BoxFit.cover,
        loadingBuilder: (BuildContext context, Widget child,
            ImageChunkEvent? loadingProgress) {
          if (loadingProgress == null) {
            // Once the image is fully loaded, we return the high-res image
            return child;
          }
      
          // While the image is loading, display the image with a blur effect
          return Stack(
            children: [
              const CustomShimmer(),
              Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 1,
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                      : null,
                ),
              ),
            ],
          );
        },
        errorBuilder: (context, url, error) => const Icon(Icons.error),
      ),
    );
  }
}
