import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:showbox/src/controller/bottom_nav_controller.dart';
import 'package:showbox/src/view/home.dart';
import 'package:showbox/src/view/movie/movie.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  // Get Controller
  BottomNavController movieCon = Get.put(BottomNavController());

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
      const PageContent(pageTitle: 'Page 3', color: Colors.green),
      const PageContent(pageTitle: 'Page 4', color: Colors.orange),
    ];

    // Add a listener to the ScrollController
    movieCon.toggleBottomNavAccToScroll(scrollController:_scrollController);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true, // Ensures the content extends behind the nav bar
      body: Stack(
        children: [
          pages[_selectedIndex],
          Obx(()=>
            Positioned(
              bottom: movieCon.isNavVisible.isTrue ? 0 : -80, // Position the nav bar to fall down
              left: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                child: Container(
                  height: 48,
                  decoration: BoxDecoration(
                    color:Colors.black.withOpacity(0.6), // Semi-transparent background
                    borderRadius: BorderRadius.circular(16), // Rounded corners
                    boxShadow: [
                      BoxShadow(
                        color: const Color.fromARGB(255, 37, 35, 39).withOpacity(0.2),
                        blurRadius: 16,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: BottomNavigationBar(
                      selectedLabelStyle: const TextStyle(fontSize: 0),
                      unselectedLabelStyle: const TextStyle(fontSize: 0),
                      showSelectedLabels: false,
                      showUnselectedLabels: false,
                      backgroundColor: Colors.transparent, // Transparent background
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
          ),
        ],
      ),
    );
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