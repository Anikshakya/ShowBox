import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:showbox/src/constant/constants.dart';
import 'package:showbox/src/controller/movies_controller.dart';
import 'package:showbox/src/view/movie/movie_details.dart';
import 'package:showbox/src/widgets/custom_image_widget.dart';
import 'package:showbox/src/widgets/custom_slider.dart';

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

    movieController.initialize(); // Pre-fetch initial movie data

    return Scaffold(
      body: Obx(() => movieController.isMovieListLoading.isTrue
        // Display a loading spinner while the movie list is loading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : NotificationListener<ScrollNotification>(
          onNotification: (scrollNotification) {
            // Trigger pagination when the user scrolls to the bottom
            if (scrollNotification.metrics.pixels == scrollNotification.metrics.maxScrollExtent && !movieController.isMovieListPaginationLoading.value) {
              movieController.isMovieListPaginationLoading(true);
              movieController.fetchNextPage();
            }
            return true;
          },
          child: SingleChildScrollView(
            controller: scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // For App Bar
                const SizedBox(height: 120),
                // Trending
                const Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: Text(
                    "Trending Movies",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                // Trending Slider
                Center(
                  child: CustomItemSlider(
                    height: 260,
                    cornerRadius: 2,
                    unActiveScale: 0.9,
                    autoSlide: true,
                    setLoop: false                                   ,
                    itemMargin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                    items: [
                      ...List.generate(
                        movieController.trendingMovieList.length,
                        (index) {
                          var movie = movieController.trendingMovieList[index];
                        return GestureDetector(
                          onTap: (){
                            Get.to(()=> MovieDetailsPage(movieId: movie["id"]));
                          },
                          child: MovieCard(
                            title: movie["title"],
                            year: movie["release_date"].split("-")[0], // Extract year
                            rating: movie["vote_average"],
                            image: movie["poster_path"],
                          ),
                        );
                        },
                      ),
                    ],
                  )
                ),
                const SizedBox(height: 30,),
                // All Movies
                const Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: Text(
                    "All Movies",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 10,),
                // Movie List Grid
                movieGrid(movieController),
                // Pagination Loading
                paginationLoading(movieController),
              ],
            ),
          )
        ),
      ),
    );
  }

  movieGrid(MovieController movieController) {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(), // Disable internal scrolling
      shrinkWrap: true, // Adjust to fit content
      padding: const EdgeInsets.symmetric(horizontal: 8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        childAspectRatio: 0.7,
      ),
      itemCount: movieController.moviesList.length,
      itemBuilder: (context, index) {
        final movie = movieController.moviesList[index];
        return GestureDetector(
          onTap: () {
            Get.to(() => MovieDetailsPage(movieId: movie["id"]));
          },
          child: MovieCard(
            title: movie["title"],
            year: movie["release_date"].split("-")[0], // Extract year
            rating: movie["vote_average"],
            image: movie["poster_path"],
          ),
        );
      },
    );
  }

  paginationLoading(MovieController movieController) {
    return Obx(()=> movieController.isMovieListPaginationLoading.isTrue
      ? const SizedBox(
        height: 100,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      )
      : const SizedBox(),
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
        borderRadius: BorderRadius.circular(2),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(2),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Movie image
            CustomImageNetworkWidget(
              borderRadius: 2,
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
                  color: const Color.fromARGB(255, 233, 198, 0).withOpacity(0.9),
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