import 'dart:async';
import 'package:flutter/material.dart';
import 'package:showbox/src/widgets/custom_image_widget.dart';

class CustomImageSlider extends StatefulWidget {
  final List<String> images;
  final double height;
  final double width;
  final double imageWidth;
  final double imageHeight;
  final double cornerRadius;
  final bool showIndicator;
  final double indicatorTop;
  final double indicatorLeft;
  final double indicatorRight;
  final double indicatorBottom;
  final double activeScale;
  final double unActiveScale;
  final EdgeInsets imageMargin;
  final void Function(int index)? onTap;

  const CustomImageSlider({
    super.key,
    required this.images,
    this.height = 300.0,
    this.width = double.infinity,
    this.cornerRadius = 20.0,
    this.showIndicator = false,
    this.indicatorTop = 0.0,
    this.indicatorLeft = 0.0,
    this.indicatorRight = 0.0,
    this.indicatorBottom = 0.0,
    this.activeScale = 1.0,
    this.unActiveScale = 0.7,
    this.imageMargin = const EdgeInsets.symmetric(horizontal: 2, vertical: 12),
    required this.onTap,
    this.imageWidth = 100,
    this.imageHeight = 200,
  });

  @override
  State<CustomImageSlider> createState() => _CustomImageSliderState();
}

class _CustomImageSliderState extends State<CustomImageSlider> {
  late PageController _pageController;
  Timer? _timer;
  int _currentPage = 1; // Start at the first real item

  List<String> get _loopedImages => [
        widget.images.last, // Dummy first item
        ...widget.images,
        widget.images.first, // Dummy last item
      ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      viewportFraction: 0.5,
      initialPage: _currentPage,
    );

    // Start the auto-slide timer
    _startAutoSlideTimer();
  }

  void _startAutoSlideTimer() {
    _timer?.cancel(); // Cancel any existing timer
    _timer = Timer.periodic(const Duration(seconds: 8), (timer) {
      if (widget.images.isNotEmpty) {
        _pageController.nextPage(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  void _handlePageChange(int index) {
    if (index == 0) {
      // Jump to the last real image
      Future.delayed(const Duration(milliseconds: 500), () {
        _pageController.jumpToPage(widget.images.length);
      });
    } else if (index == _loopedImages.length - 1) {
      // Jump to the first real image
      Future.delayed(const Duration(milliseconds: 500), () {
        _pageController.jumpToPage(1);
      });
    }
    setState(() {
      _currentPage = index;
    });

    // Reset the timer after user interaction
    _startAutoSlideTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.showIndicator == true ? widget.height + 60 : widget.height + 30,
      alignment: widget.showIndicator != true ? Alignment.center : null,
      child: Stack(
        children: [
          // Image Slider
          SizedBox(
            height: widget.height + 20,
            width: widget.width,
            child: PageView.builder(
              controller: _pageController,
              itemCount: _loopedImages.length,
              onPageChanged: _handlePageChange,
              itemBuilder: (context, index) {
                final imageIndex = (index - 1) % widget.images.length;
                final isActive = index == _currentPage;
                return GestureDetector(
                  onTap: () {
                    widget.onTap?.call(imageIndex);
                  },
                  child: _buildImageCard(_loopedImages[index], isActive),
                );
              },
            ),
          ),
          // Conditional rendering of indicator based on `showIndicator`
          if (widget.showIndicator)
            Positioned(
              top: widget.indicatorTop,
              left: widget.indicatorLeft,
              right: widget.indicatorRight,
              bottom: widget.indicatorBottom,
              child: _buildDots(),
            ),
        ],
      ),
    );
  }

  Widget _buildImageCard(String imageUrl, bool isActive) {
    double scale = isActive ? widget.activeScale : widget.unActiveScale;
    return AnimatedScale(
      scale: scale,
      duration: const Duration(milliseconds: 350),
      child: Container(
        height: widget.imageHeight,
        width: widget.imageWidth,
        margin: widget.imageMargin,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(widget.cornerRadius),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).primaryColor.withOpacity(0.4),
              blurRadius: 8,
              spreadRadius: 1,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: CustomImageNetworkWidget(
          borderRadius: widget.cornerRadius,
          height: widget.imageHeight,
          width: widget.imageWidth,
          imagePath: imageUrl,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  // Builds the dots indicator
  Widget _buildDots() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        widget.images.length,
        (index) => _buildDot(index == (_currentPage - 1) % widget.images.length),
      ),
    );
  }

  Widget _buildDot(bool isActive) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: isActive ? 12 : 8,
      height: isActive ? 12 : 8,
      decoration: BoxDecoration(
        color: isActive ? Colors.white : Colors.grey,
        shape: BoxShape.circle,
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }
}