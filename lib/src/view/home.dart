import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:showbox/src/constant/constants.dart';
import 'package:showbox/src/controller/home_controller.dart';
import 'package:showbox/src/widgets/custom_image_slider.dart';

class HomePage extends StatelessWidget {
  final ScrollController scrollController;

  const HomePage({super.key, required this.scrollController});

  @override
  Widget build(BuildContext context) {
    final homeCon = Get.put(HomeController());

    // Initialize the controller
    homeCon.initialize();

    return Scaffold(
      appBar: AppBar(
        title: Text('ShowBox', style: GoogleFonts.poppins(fontSize: 24)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
        controller: scrollController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20,),
            Obx(()=> homeCon.isTrendingListLoading.isTrue
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : CustomImageSlider(
                height: 240.0,
                cornerRadius: 15.0,
                showIndicator: false,
                onTap: (index) {},
                images: homeCon.trendingList.map((item) => item['poster_path']).where((path) => path != null).map((path) => '${AppConstants.imageUrl}$path').toList()
              ),
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
      ),
    );
  }
}

class MovieCard extends StatelessWidget {
  final String title;
  final int year;
  final double rating;
  final String imageUrl;

  const MovieCard({super.key, 
    required this.title,
    required this.year,
    required this.rating,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 200,
          width: 200,
          decoration: BoxDecoration(
            color: Colors.grey[900],
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              imageUrl,
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey,
                  child: const Icon(Icons.error, color: Colors.red),
                );
              },
            ),
          ),
        ),
        Positioned(
          top: 8,
          right: 8,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            color: Colors.black.withOpacity(0.5),
            child: Text(
              '$year\n${rating.toStringAsFixed(1)}',
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
        ),
        Positioned(
          bottom: 8,
          left: 8,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            color: Colors.black.withOpacity(0.5),
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
                overflow: TextOverflow.ellipsis,
              ),
              maxLines: 1,
            ),
          ),
        ),
      ],
    );
  }
}
