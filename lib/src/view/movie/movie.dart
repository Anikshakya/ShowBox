import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:showbox/src/constant/constants.dart';
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
    final movieCon = Get.put(MovieController());

    // Initialize the controller
    movieCon.initialize();

    return Scaffold(
      body: Obx(
        () => movieCon.isMovieListLoading.isTrue
            ? const Center(
                child: CircularProgressIndicator(color: Colors.red),
              )
            : Stack(
                children: [
                  // Scrolling content
                  Positioned.fill(
                    child: NotificationListener<ScrollNotification>(
                      onNotification: (scrollNotification) {
                        if (scrollNotification.metrics.pixels ==
                                scrollNotification.metrics.maxScrollExtent &&
                            !movieCon.isMovieListPaginationLoading.value) {
                          movieCon.fetchNextPage();
                        }
                        return true;
                      },
                      child: GridView.builder(
                        controller: scrollController,
                        padding: const EdgeInsets.only(
                          top: 120, // Space for the search bar
                          left: 8,
                          right: 8,
                        ),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          mainAxisSpacing: 8,
                          crossAxisSpacing: 8,
                          childAspectRatio: 0.7,
                        ),
                        itemCount: movieCon.moviesList.length,
                        itemBuilder: (context, index) {
                          final movie = movieCon.moviesList[index];
                          return GestureDetector(
                            onTap: () {
                              Get.to(() => const ExactImageSlider());
                            },
                            child: MovieCard(
                              title: movie["title"],
                              year: movie["release_date"].split("-")[0],
                              rating: movie["vote_average"],
                              image: movie["poster_path"],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  // Transparent search bar
                  Positioned(
                    top: 30,
                    left: 20,
                    right: 20,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.7), // Slightly opaque for better readability
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
                          // movieCon.filterMovies(query); // Implement search filtering in the controller
                        },
                        decoration: InputDecoration(
                          hintText: 'Search Movies...',
                          hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
                          filled: true,
                          fillColor: Colors.transparent, // Transparent background for text field
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(color: Colors.white.withOpacity(0.7)),
                          ),
                          prefixIcon: const Icon(Icons.search, color: Colors.white),
                        ),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),

                ],
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
            // Movie Image
            CustomImageNetworkWidget(
              imagePath: "${AppConstants.posterUrl}$image",
            ),
            // Year
            Positioned(
              top: 0,
              left: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  borderRadius: const BorderRadius.only(bottomRight: Radius.circular(8)),
                ),
                child: Text(
                  year,
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ),
            // Rating
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.9),
                  borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(8)),
                ),
                child: Text(
                  rating.toString().substring(0, 3),
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
