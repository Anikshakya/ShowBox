import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:showbox/src/constant/constants.dart';
import 'package:showbox/src/controller/bottom_nav_controller.dart';
import 'package:showbox/src/controller/movies_controller.dart';
import 'package:showbox/src/view/movie/movie_details.dart';
import 'package:showbox/src/widgets/custom_image_widget.dart';

class MovieList extends StatelessWidget {
  final ScrollController scrollController;

  const MovieList({
    super.key,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    // Get Controller
    final movieController = Get.put(MovieController());
    BottomNavController bottomNavCon = Get.put(BottomNavController());

    movieController.initialize(); // Pre-fetch initial movie data

    return Scaffold(
      body: Obx(
        () => movieController.isMovieListLoading.isTrue
            // Display a loading spinner while the movie list is loading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Stack(
                children: [
                  Positioned.fill(
                    // Listen To Scroll
                    child: NotificationListener<ScrollNotification>(
                      onNotification: (scrollNotification) {
                        // Trigger pagination when the user scrolls to the bottom
                        if (scrollNotification.metrics.pixels == scrollNotification.metrics.maxScrollExtent && !movieController.isMovieListPaginationLoading.value) {
                          bottomNavCon.isNavVisible.value = true;
                          movieController.fetchNextPage();
                        }
                        return true;
                      },
                      child: Stack(
                        children: [
                          // Movie grid
                          movieGrid(movieController),
                          // Pagination Loading
                          if (movieController.isMovieListPaginationLoading.isTrue)
                            paginationLoading(),
                        ],
                      ),
                    ),
                  ),
                  // Search Bar
                  Positioned(
                    top: 30,
                    left: 20,
                    right: 20,
                    child: _buildSearchBar(movieController),
                  ),
                ],
              ),
      ),
    );
  }

  paginationLoading() {
    return Stack(
      children: [
        // Transparent full-screen layer
        Container(
          color: Colors.black.withOpacity(0.5), // Semi-transparent black background
          width: double.infinity,
          height: double.infinity,
        ),
        // Loading spinner in the center
        const Center(
          child: CircularProgressIndicator(color: Colors.orange),
        ),
      ],
    );
  }

  movieGrid(MovieController movieController) {
    return GridView.builder(
      controller: scrollController,
      padding: const EdgeInsets.only(
        top: 120, // Leave space for the search bar
        left: 8,
        right: 8,
      ),
      gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        childAspectRatio: 0.7, // Adjust card size
      ),
      itemCount: movieController.moviesList.length,
      itemBuilder: (context, index) {
        final movie =
            movieController.moviesList[index];
        return GestureDetector(
          onTap: () {
            // Navigate to the movie details page
            Get.to(() => MovieDetailsPage(
                  movieId: movie["id"],
                ));
          },
          child: MovieCard(
            title: movie["title"],
            year: movie["release_date"]
                .split("-")[0], // Extract year
            rating: movie["vote_average"],
            image: movie["poster_path"],
          ),
        );
      },
    );
  }

  // Builds the search bar with filtering functionality
  Widget _buildSearchBar(MovieController movieController) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.7), // Semi-transparent background
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 5), // Shadow position
          ),
        ],
      ),
      padding: const EdgeInsets.all(10.0),
      child: TextField(
        onChanged: (query) {
          // Implement search functionality
          // movieController.filterMovies(query);
        },
        decoration: InputDecoration(
          hintText: 'Search Movies...',
          hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
          filled: true,
          fillColor: Colors.transparent, // Transparent text field background
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: Colors.white.withOpacity(0.7)),
          ),
          prefixIcon: const Icon(Icons.search, color: Colors.white),
        ),
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}

// MovieCard widget to display individual movie details
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
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Movie image
            CustomImageNetworkWidget(
              imagePath: "${AppConstants.imageUrl}$image",
            ),
            // Display the release year at the top-left corner
            Positioned(
              top: 0,
              left: 0,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  borderRadius: const BorderRadius.only(
                      bottomRight: Radius.circular(8)),
                ),
                child: Text(
                  year,
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ),
            // Display the rating at the top-right corner
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.9),
                  borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(8)),
                ),
                child: Text(
                  rating.toStringAsFixed(1), // Format rating to 1 decimal
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}