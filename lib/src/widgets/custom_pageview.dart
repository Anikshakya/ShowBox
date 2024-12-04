import 'dart:async';
import 'package:flutter/material.dart';

class CustomPageView extends StatefulWidget {
  final double height;
  final double width;
  final List widgets;
  final double? indicatorTop;
  final double? indicatorBottom;
  final double? indicatorLeft;
  final double? indicatorRight;
  final Color indicatorColor;
  final double indicatorSize;
  final bool enableAutoSwipe;  // Flag to enable/disable auto swipe
  final Duration changePageDuration; // Duration for page change animation

  const CustomPageView({
    super.key,
    required this.height,
    required this.width,
    required this.widgets,
    this.indicatorTop,
    this.indicatorBottom = 16,
    this.indicatorLeft = 0,
    this.indicatorRight = 0,
    this.indicatorColor = Colors.white,
    this.indicatorSize = 8.0,
    this.enableAutoSwipe = false,
    this.changePageDuration = const Duration(milliseconds: 6000),
  });

  @override
  State<CustomPageView> createState() => _CustomPageViewState();
}

class _CustomPageViewState extends State<CustomPageView> {
  final PageController _pageController = PageController();
  final ValueNotifier<int> _currentPageNotifier = ValueNotifier<int>(0);
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      final currentPage = _pageController.page?.round() ?? 0;
      if (_currentPageNotifier.value != currentPage) {
        _currentPageNotifier.value = currentPage;
      }
    });

    // Start auto swipe if enabled
    if (widget.enableAutoSwipe) {
      _startAutoSwipe();
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _currentPageNotifier.dispose();
    super.dispose();
  }

  // Function to trigger auto swipe after a set duration
  void _startAutoSwipe() {
    _autoSwipe();
  }

  // Function to perform the page swipe with delay and animation
  void _autoSwipe() {
    _timer?.cancel(); // Cancel any existing timer
    _timer = Timer.periodic(widget.changePageDuration, (timer) {
      if (widget.enableAutoSwipe == true) {
        _pageController.nextPage(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          height: widget.height,
          width: widget.width,
          child: PageView.builder(
            controller: _pageController,
            itemCount: null, // Set to null for infinite loop
            onPageChanged: (index) {
              final currentPage = index % widget.widgets.length;
              _currentPageNotifier.value = currentPage;
              _startAutoSwipe();
            },
            itemBuilder: (context, index) {
              // Wrap around the widgets to loop infinitely using modulo
              final pageIndex = index % widget.widgets.length;
              return widget.widgets[pageIndex];
            },
          ),
        ),
        // Custom Page Indicator
        Positioned(
          bottom: widget.indicatorBottom,
          left: widget.indicatorLeft,
          right: widget.indicatorRight,
          top: widget.indicatorTop,
          child: ValueListenableBuilder<int>(
            valueListenable: _currentPageNotifier,
            builder: (context, currentPage, child) {
              // Using modulo to ensure the index is within bounds
              final currentIndicatorPage = currentPage % widget.widgets.length;
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(widget.widgets.length, (index) {
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    height: widget.indicatorSize,
                    width: currentIndicatorPage == index
                        ? widget.indicatorSize * 2
                        : widget.indicatorSize,
                    decoration: BoxDecoration(
                      color: currentIndicatorPage == index
                          ? widget.indicatorColor
                          : Colors.grey,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  );
                }),
              );
            },
          ),
        ),
      ],
    );
  }
}