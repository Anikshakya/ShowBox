import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
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
              top: bottomNavCon.isAppbarVisible.isTrue ? 0 : -80, // Hide the app bar if not visible
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
                    onPressed: () => Get.to(() => SearchPage()),
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
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                child: Container(
                  height: 56,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).primaryColor.withOpacity(0.3),
                        blurRadius: 2,
                        offset: const Offset(0, 0),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 1.0, sigmaY: 1.0),
                      child: BottomNavigationBar(
                        selectedLabelStyle: const TextStyle(fontSize: 0), // Hide labels
                        unselectedLabelStyle: const TextStyle(fontSize: 0), // Hide labels
                        showSelectedLabels: false, // Hide selected label
                        showUnselectedLabels: false, // Hide unselected label
                        backgroundColor: Colors.black.withOpacity(0.5),
                        elevation: 0,
                        type: BottomNavigationBarType.fixed,
                        selectedItemColor: const Color(0XFFCBA84A), // Selected item color
                        unselectedItemColor: const Color.fromARGB(255, 185, 185, 185), // Unselected item color
                        currentIndex: _selectedIndex,
                        selectedIconTheme: const IconThemeData(size: 28), // Size of selected icon
                        unselectedIconTheme: const IconThemeData(size: 22), // Size of unselected icon
                        onTap: _onItemTapped, // Handle item tap to change tab
                        items: const [
                          BottomNavigationBarItem(
                            icon: Icon(Icons.home),
                            label: '',
                          ),
                          BottomNavigationBarItem(
                            icon: Icon(Icons.video_collection_sharp),
                            label: '',
                          ),
                          BottomNavigationBarItem(
                            icon: Icon(Icons.tv_rounded),
                            label: '',
                          ),
                        ],
                      ),
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
}