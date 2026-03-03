import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

/// Singleton Custom Cache Manager
class MyCacheManager {
  static const key = 'myCustomCacheKey';

  static final CacheManager instance = CacheManager(
    Config(
      key,
      stalePeriod: const Duration(days: 3),
      maxNrOfCacheObjects: 50,
      repo: JsonCacheInfoRepository(databaseName: key),
      fileService: HttpFileService(),
    ),
  );
}

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
      return _buildErrorWidget();
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: SizedBox(
        width: width,
        height: height,
        child: CachedNetworkImage(
          imageUrl: imagePath,
          cacheManager: MyCacheManager.instance,
          fit: fit ?? BoxFit.cover,
          fadeInDuration: const Duration(milliseconds: 200),
          fadeOutDuration: const Duration(milliseconds: 100),
          placeholder: (context, url) => _buildPlaceholder(),
          errorWidget: (context, url, error) => _buildErrorWidget(),
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        gradient: LinearGradient(
          colors: [
            Colors.grey.shade300,
            Colors.grey.shade100,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        color: Colors.grey.shade200,
      ),
      child: Center(
        child: Icon(
          Icons.broken_image_outlined,
          color: Colors.grey.shade500,
          size: 40,
        ),
      ),
    );
  }
}