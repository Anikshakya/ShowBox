import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class CustomImageNetworkWidget extends StatelessWidget {
  const CustomImageNetworkWidget({
    super.key,
    required this.imagePath,
    this.height,
    this.width,
    this.fit,
    this.borderRadius = 0,
  });

  final String imagePath;
  final double? height;
  final double? width;
  final BoxFit? fit;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    if (imagePath.isEmpty || imagePath == "null") {
      return _placeholder();
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: CachedNetworkImage(
        imageUrl: imagePath,
        cacheManager: myCacheManager, // <-- Use the custom cache manager here
        width: width,
        height: height,
        fit: fit ?? BoxFit.cover,
        placeholder: (context, url) => _placeholder(),
        errorWidget: (context, url, error) => _errorPlaceholder(),
      ),
    );
  }

  Widget _placeholder() {
    return SizedBox(
      width: width,
      height: height,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          gradient: LinearGradient(
            colors: [Colors.grey.withOpacity(0.3), Colors.transparent],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
      ),
    );
  }

  Widget _errorPlaceholder() {
    return SizedBox(
      width: width,
      height: height,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            "assets/images/app_logo.png",
            fit: BoxFit.fill,
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.grey.withOpacity(0.3), Colors.red],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Custom cache manager to limit memory/disk usage
final myCacheManager = CacheManager(
  Config(
    'myCacheKey', // Unique key
    stalePeriod: const Duration(days: 3), // Cache lifetime
    maxNrOfCacheObjects: 50, // Max number of images
  ),
);