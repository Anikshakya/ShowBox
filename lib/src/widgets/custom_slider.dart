import 'dart:async';
import 'package:flutter/material.dart';

class CustomItemSlider extends StatefulWidget {
  final List<Widget> items;
  final bool setLoop;
  final bool autoSlide;
  final Duration animationDuration;
  final bool showIndicator;
  final double height;
  final double width;
  final double activeScale;
  final double unActiveScale;
  final EdgeInsets itemMargin;
  final double cornerRadius;
  final double indicatorTop;
  final double indicatorLeft;
  final double indicatorRight;
  final double indicatorBottom;

  const CustomItemSlider({
    super.key,
    required this.items,
    this.setLoop = false,
    this.autoSlide = true,
    this.animationDuration = const Duration(milliseconds: 500),
    this.showIndicator = false,
    this.height = 200,
    this.width = 400,
    this.activeScale = 1,
    this.unActiveScale = 0.7,
    this.itemMargin = const EdgeInsets.all(8),
    this.cornerRadius = 12,
    this.indicatorTop = 0,
    this.indicatorLeft = 0,
    this.indicatorRight = 0,
    this.indicatorBottom = 10,
  });

  @override
  State<CustomItemSlider> createState() => _CustomItemSliderState();
}

class _CustomItemSliderState extends State<CustomItemSlider> {
  late PageController _pageController;
  Timer? _timer;
  late int _currentPage;
  late bool _isLoopEnabled;

  List<Widget> get _loopedItems => _isLoopEnabled
      ? [
          widget.items.last, // Dummy first item
          ...widget.items,
          widget.items.first, // Dummy last item
        ]
      : widget.items;

  @override
  void initState() {
    super.initState();

    // Disable loop automatically if items are 2 or fewer
    _isLoopEnabled = widget.items.length > 2 && widget.setLoop;
    _currentPage = _isLoopEnabled ? 1 : 0; // Set initial page based on loop state

    _pageController = PageController(
      viewportFraction: 0.5,
      initialPage: _currentPage,
    );

    // Start the auto-slide timer if autoSlide is enabled
    if (widget.autoSlide) {
      _startAutoSlideTimer();
    }
  }

  void _startAutoSlideTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 8), (timer) {
      if (widget.items.isNotEmpty) {
        if (!_isLoopEnabled) {
          // If not looping and at the last page, jump to the first page
          if (_currentPage == widget.items.length - 1) {
            _pageController.jumpToPage(0);
            setState(() {
              _currentPage = 0;
            });
          } else {
            _pageController.nextPage(
              duration: widget.animationDuration,
              curve: Curves.easeInOut,
            );
          }
        } else {
          // Looping case (already handled in _handlePageChange)
          _pageController.nextPage(
            duration: widget.animationDuration,
            curve: Curves.easeInOut,
          );
        }
      }
    });
  }

  void _handlePageChange(int index) {
    if (_isLoopEnabled) {
      if (index == 0) {
        Future.delayed(widget.animationDuration, () {
          _pageController.jumpToPage(widget.items.length);
        });
      } else if (index == _loopedItems.length - 1) {
        Future.delayed(widget.animationDuration, () {
          _pageController.jumpToPage(1);
        });
      }
    }

    setState(() {
      _currentPage = _isLoopEnabled ? index : index % widget.items.length;
    });

    // Reset the timer after user interaction if autoSlide is enabled
    if (widget.autoSlide) {
      _startAutoSlideTimer();
    }
  }

  Widget _buildItemCard(Widget item, bool isActive) {
    double scale = isActive ? widget.activeScale : widget.unActiveScale;
    return AnimatedScale(
      scale: scale,
      duration: const Duration(milliseconds: 350),
      child: Container(
        margin: widget.itemMargin,
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
        child: item,
      ),
    );
  }

  Widget _buildDots() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        widget.items.length,
        (index) => _buildDot(index == _currentPage % widget.items.length),
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
  Widget build(BuildContext context) {
    return Container(
      height: widget.showIndicator == true ? widget.height + 60 : widget.height + 30,
      alignment: widget.showIndicator != true ? Alignment.center : null,
      child: Stack(
        children: [
          // Custom Series Card Slider
          SizedBox(
            height: widget.height + 20,
            width: widget.width,
            child: PageView.builder(
              controller: _pageController,
              itemCount: _loopedItems.length,
              onPageChanged: _handlePageChange,
              itemBuilder: (context, index) {
                final widgetIndex = _isLoopEnabled
                    ? (index - 1) % widget.items.length
                    : index;
                final isActive = _isLoopEnabled
                    ? index == _currentPage
                    : widgetIndex == _currentPage;
                return _buildItemCard(_loopedItems[index], isActive);
              },
            ),
          ),
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

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }
}