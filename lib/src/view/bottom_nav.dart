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
  final BottomNavController bottomNavCon = Get.put(BottomNavController());
  final ScrollController _scrollController = ScrollController();

  int _selectedIndex = 0;

  late final List<Widget> pages;

  @override
  void initState() {
    super.initState();
    pages = [
      HomePage(scrollController: _scrollController),
      MovieList(scrollController: _scrollController),
      SeriesListPage(scrollController: _scrollController),
    ];
    bottomNavCon.toggleBottomNavAccToScroll(scrollController: _scrollController);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    HapticFeedback.heavyImpact();
    setState(() {
      _selectedIndex = index;
    });
  }

  // Theme toggle method
  void _toggleTheme() {
    Get.changeThemeMode(
      Get.isDarkMode ? ThemeMode.light : ThemeMode.dark,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Stack(
        children: [
          pages[_selectedIndex],

          // App Bar
          Obx(
            () => AnimatedPositioned(
              duration: const Duration(milliseconds: 160),
              top: bottomNavCon.isAppbarVisible.isTrue ? 0 : -100,
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
                    onPressed: () => Get.to(() => const SearchPage()),
                  ),
                  IconButton(
                    icon: Icon(
                      Get.isDarkMode ? Icons.wb_sunny_outlined : Icons.nights_stay_outlined,
                    ),
                    onPressed: _toggleTheme,
                  ),
                ],
              ),
            ),
          ),

          // Bottom Navigation Bar
          Obx(
            () => AnimatedPositioned(
              duration: const Duration(milliseconds: 160),
              bottom: bottomNavCon.isNavVisible.isTrue ? 0 : -80,
              left: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: SizedBox(
                  height: 60,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.black.withOpacity(0.8)
                          : Colors.white.withOpacity(0.9),
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

  String _getAppBarTitle(int index) {
    switch (index) {
      case 0:
        return '';
      case 1:
        return 'ShowBox Movies';
      case 2:
        return 'ShowBox Series';
      default:
        return 'ShowBox';
    }
  }

  Widget _buildNavItem(IconData icon, int index) {
    final bool isSelected = _selectedIndex == index;

    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          splashColor: AppStyles.goldenColor.withOpacity(0.2),
          highlightColor: AppStyles.goldenColor.withOpacity(0.1),
          onTap: () => _onItemTapped(index),
          onLongPress: () => HapticFeedback.mediumImpact(),
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