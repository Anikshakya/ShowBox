
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:showbox/src/app_config/styles.dart';
import 'package:showbox/src/controller/bottom_nav_controller.dart';
import 'package:showbox/src/view/home.dart';
import 'package:showbox/src/view/movie/movies_list.dart';
import 'package:showbox/src/view/search/search_page.dart';
import 'package:showbox/src/view/series/series_list.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  // Initialize BottomNavController to manage the visibility of the AppBar and Bottom Navigation Bar
  final BottomNavController bottomNavCon = Get.put(BottomNavController());
  
  // Initialize a ScrollController to manage scroll position and trigger hiding/showing the app bar and bottom nav
  final ScrollController _scrollController = ScrollController();

  int _selectedIndex = 0; // Track the selected tab index

  late final List<Widget> pages; // List of pages for each tab

  @override
  void initState() {
    super.initState();

    // Define pages for each bottom navigation item (Home, Movies, Series)
    pages = [
      HomePage(scrollController: _scrollController),
      MovieList(scrollController: _scrollController),
      SeriesListPage(scrollController: _scrollController),
    ];

    // Set up the BottomNavController to manage the app bar and bottom nav visibility based on scrolling
    bottomNavCon.toggleBottomNavAccToScroll(scrollController: _scrollController);
  }

  @override
  void dispose() {
    _scrollController.dispose(); // Dispose the ScrollController when the widget is disposed
    super.dispose();
  }

  // Handle the navigation item selection and provide haptic feedback on tap
  void _onItemTapped(int index) {
    HapticFeedback.heavyImpact(); // Provide haptic feedback on item tap
    setState(() {
      _selectedIndex = index; // Update the selected index to show the appropriate page
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true, // Allows body to extend beneath the app bar
      body: Stack(
        children: [
          // Display the page corresponding to the selected index
          pages[_selectedIndex],

          // App Bar: Controls visibility based on scrolling
          Obx(
            () => AnimatedPositioned(
              duration: const Duration(milliseconds: 160),
              top: bottomNavCon.isAppbarVisible.isTrue ? 0 : -100, // Hide the app bar if not visible
              left: 0,
              right: 0,
              child: AppBar(
                title: Text(
                  _getAppBarTitle(_selectedIndex), // Set app bar title dynamically based on selected tab
                  style: GoogleFonts.poppins(fontSize: 24),
                ),
                backgroundColor: Colors.transparent, // Transparent background for the app bar
                centerTitle: true,
                actions: [
                  // Search icon to navigate to the SearchPage
                  IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () => Get.to(() => const SearchPage()),
                  ),
                ],
              ),
            ),
          ),

          // Bottom Navigation Bar: Controls visibility based on scrolling
          Obx(
            () => AnimatedPositioned(
              duration: const Duration(milliseconds: 160),
              bottom: bottomNavCon.isNavVisible.isTrue ? 0 : -80, // Hide the bottom nav if not visible
              left: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: SizedBox(
                  height: 60,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.black.withOpacity(0.5)
                          : Colors.white.withOpacity(0.84),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildNavItem(Icons.home, 0),
                        _buildNavItem(Icons.video_collection_sharp, 1),
                        _buildNavItem(Icons.live_tv_sharp, 2),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to return the title for the app bar based on the selected index
  String _getAppBarTitle(int index) {
    switch (index) {
      case 0:
        return ''; // Title for Home page
      case 1:
        return 'ShowBox Movies'; // Title for Movies page
      case 2:
        return 'ShowBox Series'; // Title for Series page
      default:
        return 'ShowBox'; // Default title
    }
  }

  Widget _buildNavItem(IconData icon, int index) {
    final bool isSelected = _selectedIndex == index;

    return Expanded(
      child: Material(
        color: Colors.transparent, // Required for ripple
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          splashColor: AppStyles.goldenColor.withOpacity(0.2),
          highlightColor: AppStyles.goldenColor.withOpacity(0.1),
          onTap: () => _onItemTapped(index),
          onLongPress: () {
            HapticFeedback.mediumImpact();
          },
          child: Center(
            child: AnimatedScale(
              scale: isSelected ? 1.15 : 1.0,
              duration: const Duration(milliseconds: 200),
              child: Icon(
                icon,
                size: 26,
                color: isSelected
                    ? AppStyles.goldenColor
                    : Theme.of(context).brightness == Brightness.dark
                        ? const Color.fromARGB(255, 185, 185, 185)
                        : const Color.fromARGB(255, 104, 104, 104),
              ),
            ),
          ),
        ),
      ),
    );
  }
}