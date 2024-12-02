import 'package:flutter/material.dart';
import 'package:showbox/src/widgets/custom_shimmer.dart';

class CustomImageNetworkWidget extends StatefulWidget {
  const CustomImageNetworkWidget({
    super.key,
    required this.imagePath,
    this.height,
    this.width,
    this.fit,
    this.fromPage,
    this.borderRadius = 0,
  });

  final String imagePath;
  final double? height;
  final double? width;
  final BoxFit? fit;
  final String? fromPage;
  final double borderRadius; // Add borderRadius property

  @override
  State<CustomImageNetworkWidget> createState() => _CustomImageNetworkWidgetState();
}

class _CustomImageNetworkWidgetState extends State<CustomImageNetworkWidget> {
  @override
  Widget build(BuildContext context) {
    return widget.imagePath == "null" || widget.imagePath.isEmpty || widget.imagePath == ''
        ? placeHolder()
        : ClipRRect(
            borderRadius: BorderRadius.circular(widget.borderRadius), // Use the borderRadius parameter
            child: Image.network(
              widget.imagePath,
              width: widget.width,
              height: widget.height,
              fit: widget.fit ?? BoxFit.cover,
              headers: const {"Connection": "Keep-Alive"},
              loadingBuilder: (context, child, loadingProgress) {
                return loadingProgress == null
                    ? child
                    : SizedBox(
                        width: widget.width,
                        height: widget.height,
                        child: Stack(
                          children: [
                            CustomShimmer(
                              borderRadius: widget.borderRadius,
                            ),
                            Center(
                              child: CircularProgressIndicator(
                                strokeWidth: 1,
                                value: loadingProgress.expectedTotalBytes != null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                    : null,
                              ),
                            ),
                          ],
                        ),
                      );
              },
              errorBuilder: (context, error, stackTrace) => placeHolder(),
            ),
          );
  }

  placeHolder() {
    return Opacity(
      opacity: 1,
      child: Container(color: Colors.grey),
    );
  }
}