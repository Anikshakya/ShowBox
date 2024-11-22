import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:showbox/src/constant/constants.dart';
import 'package:showbox/src/controller/bottom_nav_controller.dart';
import 'package:showbox/src/controller/movies_controller.dart';

class MovieList extends StatefulWidget {
  final String pageTitle;
  final Color color;

  const MovieList({super.key, required this.pageTitle, required this.color});

  @override
  State<MovieList> createState() => _MovieListState();
}

class _MovieListState extends State<MovieList> {
  // Get Controller
  BottomNavController bottomNavCon = Get.put(BottomNavController());
  MovieController movieCon = Get.put(MovieController());
  
  ScrollController scrollCon = ScrollController();

  @override
  void initState() {
    super.initState();
    initialize();
    // Add a listener to the ScrollController
    bottomNavCon.toggleBottomNavAccToScroll(scrollController: scrollCon);
    scrollCon.addListener(() async{
      if (scrollCon.position.pixels == scrollCon.position.maxScrollExtent) {
        movieCon.movielistPage.value ++;
        await movieCon.getMovieListPagination();
      }
    });
  }

  initialize() async{
    await movieCon.getMovieList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() =>
      movieCon.isMovieListLoading.isTrue
        ? const Center(
          child: CircularProgressIndicator(color: Colors.red,),
        )
        : Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: GridView.builder(
            controller: scrollCon,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: 0.7,
            ),
            itemCount: movieCon.moviesList.length,
            itemBuilder: (context, index) {
              return MovieCard(
                title: movieCon.moviesList[index]["title"],
                year: movieCon.moviesList[index]["release_date"],
                rating: movieCon.moviesList[index]["vote_average"],
                image: movieCon.moviesList[index]["poster_path"],
              );
            },
          ),
        ),
      ),
    ); 
  }
}

class MovieCard extends StatelessWidget {
  final String title;
  final String year;
  final double rating;
  final String image;

  const MovieCard({
    super.key,
    required this.title,
    required this.year,
    required this.rating,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Use an AspectRatio or SizedBox to constrain the image
          Image.network(
            "${AppConstants.posterUrl}$image",
            fit: BoxFit.cover,
            loadingBuilder: (context, child, progress) {
              if (progress == null) return child;
              return const Center(
                child: CircularProgressIndicator(color: Colors.orange),
              );
            },
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: Colors.grey,
                child: const Center(
                  child: Icon(
                    Icons.broken_image,
                    color: Colors.white,
                  ),
                ),
              );
            },
          ),
          Positioned(
            top: 8,
            left: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.orange,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                year,
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
          ),
          Positioned(
            top: 8,
            right: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                rating.toString(),
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}