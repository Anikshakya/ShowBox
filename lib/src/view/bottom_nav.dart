import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:showbox/src/controller/bottom_nav_controller.dart';
import 'package:showbox/src/view/home.dart';
import 'package:showbox/src/view/movie/movies_list.dart';
import 'package:showbox/src/view/search_page.dart';
import 'package:showbox/src/view/series/series_list.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  // Get Controller
  BottomNavController bottomNavCon = Get.put(BottomNavController());

  List pages = [];

  int _selectedIndex = 0;
  final ScrollController _scrollController = ScrollController();

  void _onItemTapped(int index) {
    HapticFeedback.heavyImpact(); // Provide haptic feedback on item tap
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();

    pages = [
      HomePage(scrollController: _scrollController),
      MovieList(scrollController: _scrollController),
      SeriesListPage(scrollController: _scrollController),
      const PageContent(pageTitle: 'Page 4', color: Colors.orange),
    ];

    // Add a listener to the ScrollController
    bottomNavCon.toggleBottomNavAccToScroll(scrollController:_scrollController);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Stack(
        children: [
          pages[_selectedIndex],
          // App Bar
          Obx(() => AnimatedPositioned(
                duration: const Duration(milliseconds: 160),
                top: bottomNavCon.isAppbarVisible.isTrue ? 0 : -80, // Hide app bar when not visible
                left: 0,
                right: 0,
                child: AppBar(
                  title: Text(
                    _getAppBarTitle(_selectedIndex),
                    style: GoogleFonts.poppins(fontSize: 24),
                  ),
                  backgroundColor: Colors.transparent,
                  centerTitle: true,
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: () {
                        Get.to(() => const SearchPage());
                      },
                    ),
                  ],
                ),
              )),
          // Bottom Nav
          Obx(() => AnimatedPositioned(
                duration: const Duration(milliseconds: 160),
                bottom: bottomNavCon.isNavVisible.isTrue ? 0 : -80, // Position the nav bar to fall down
                left: 0,
                right: 0,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                  child: Container(
                    height: 56,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6), // Semi-transparent background
                      borderRadius: BorderRadius.circular(16), // Rounded corners
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
                          selectedLabelStyle: const TextStyle(fontSize: 0),
                          unselectedLabelStyle: const TextStyle(fontSize: 0),
                          showSelectedLabels: false,
                          showUnselectedLabels: false,
                          backgroundColor: Colors.black.withOpacity(0.5), // Transparent background
                          elevation: 0, // Remove shadow
                          type: BottomNavigationBarType.fixed,
                          selectedItemColor: Colors.white,
                          unselectedItemColor: const Color.fromARGB(255, 185, 185, 185),
                          currentIndex: _selectedIndex,
                          onTap: _onItemTapped,
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
                              icon: Icon(Icons.grid_view),
                              label: '',
                            ),
                            BottomNavigationBarItem(
                              icon: Icon(Icons.person),
                              label: '',
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              )),
        ],
      ),
    );
  }

  // Method to get the app bar title based on the selected index
  String _getAppBarTitle(int index) {
    switch (index) {
      case 0:
        return 'ShowBox';
      case 1:
        return 'ShowBox Movies';
      case 2:
        return 'ShowBox Series';
      case 3:
        return 'Page 4';
      default:
        return 'ShowBox';
    }
  }
}

class PageContent extends StatelessWidget {
  final String pageTitle;
  final Color color;

  const PageContent({super.key, required this.pageTitle, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              pageTitle,
              style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 20),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(), // Prevent nested scrolling
              itemCount: 30,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: const Icon(Icons.circle, color: Colors.white),
                  title: Text('Item #$index', style: const TextStyle(color: Colors.white)),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}