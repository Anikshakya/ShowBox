import 'package:flutter/material.dart';
import 'package:showbox/src/widgets/custom_image_widget.dart';

class CustomImageSlider extends StatefulWidget {
  final List images;
  final double height;
  final double width;
  final double cornerRadius;
  final bool showIndicator;
  final double indicatorTop;
  final double indicatorLeft;
  final double indicatorRight;
  final double indicatorBottom;
  final void Function(int index)? onTap;

  const CustomImageSlider({
    super.key,
    required this.images,
    this.height = 280.0,
    this.width = double.infinity,
    this.cornerRadius = 20.0,
    this.showIndicator = true,
    this.indicatorTop = 0.0,
    this.indicatorLeft = 0.0,
    this.indicatorRight = 0.0,
    this.indicatorBottom = 0.0, 
    required this.onTap,
  });

  @override
  State<CustomImageSlider> createState() => _CustomImageSliderState();
}

class _CustomImageSliderState extends State<CustomImageSlider> {
  late PageController _pageController;
  int _currentPage = 0;
  bool get _shouldLoop => widget.images.length > 2;

  @override
  void initState() {
    super.initState();

    // Start at index 0 for small lists, else start from the middle
    _currentPage = _shouldLoop ? widget.images.length : 0;
    _pageController = PageController(
      viewportFraction: 0.5,
      initialPage: _currentPage,
    );

    _pageController.addListener(() {
      int next = _pageController.page!.round();
      if (_currentPage != next) {
        setState(() {
          _currentPage = next;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Image Slider
        SizedBox(
          height: widget.height,
          width: widget.width,
          child: PageView.builder(
            controller: _pageController,
            itemCount: _shouldLoop ? null : widget.images.length,
            itemBuilder: (context, index) {
              int imageIndex = _shouldLoop ? index % widget.images.length : index;
              bool isActive = index == _currentPage;
              return GestureDetector(
                onTap: (){
                  widget.onTap!(index);
                },
                child: _buildImageCard(widget.images[imageIndex], isActive),
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
    );
  }

  Widget _buildImageCard(String imageUrl, bool isActive) {
    double scale = isActive ? 1.0 : 0.8;
    return AnimatedScale(
      scale: scale,
      duration: const Duration(milliseconds: 300),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(widget.cornerRadius),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: CustomImageNetworkWidget(
          imagePath: imageUrl,
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
        (index) => _buildDot(index == (_currentPage % widget.images.length)),
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
    _pageController.dispose();
    super.dispose();
  }
}
