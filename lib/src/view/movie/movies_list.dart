import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:showbox/src/constant/constants.dart';
import 'package:showbox/src/controller/movies_controller.dart';
import 'package:showbox/src/view/movie/movie_details.dart';
import 'package:showbox/src/widgets/cards/item_card.dart';
import 'package:showbox/src/widgets/custom_shimmer.dart';
import 'package:showbox/src/widgets/custom_slider.dart';

class MovieList extends StatelessWidget {
  final ScrollController scrollController;

  const MovieList({
    super.key,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    final movieController = Get.put(MovieController());
    movieController.initialize(); // Pre-fetch initial movie data

    return Scaffold(
      body: Obx(() => movieController.isMovieListLoading.isTrue
        ? const Center(child: CircularProgressIndicator()) // Display loading spinner while movie list loads
        : NotificationListener<ScrollNotification>(
            onNotification: (scrollNotification) {
              if (scrollNotification.metrics.pixels == scrollNotification.metrics.maxScrollExtent && !movieController.isMovieListPaginationLoading.value) {
                movieController.isMovieListPaginationLoading(true);
                movieController.fetchNextPage(); // Trigger pagination when scrolling reaches the bottom
              }
              return true;
            },
            child: SingleChildScrollView(
              controller: scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 100), // App bar space
                  // Trending Slider Section
                  buildTrendingSliderSection(movieController),
                  const SizedBox(height: 20),
                  // Top Rated Movies Section
                  buildTopRatedMoviesSection(movieController),
                  const SizedBox(height: 20),
                  // All Movies Grid Section
                  buildAllMoviesGrid(movieController),
                   // Loading indicator for pagination
                  paginationLoading(movieController),
                ],
              ),
            ),
          ),
      ),
    );
  }

  // Trending Slider Section with shimmer and empty data handling
  Widget buildTrendingSliderSection(MovieController movieController) {
    return movieController.isTrendingMoviesLoading.isTrue
        ? const SizedBox(
          height: 260,
          child: Center(
            child: CircularProgressIndicator(),
          ),
        )
        : movieController.trendingMovieList.isEmpty
            ? const SizedBox(
                height: 260,
                child: Center(child: Text("No trending movies available")),
              )
            : CustomItemSlider(
                height: 260,
                cornerRadius: 2,
                unActiveScale: 0.95,
                autoSlide: true,
                setLoop: false,
                itemMargin: const EdgeInsets.symmetric(horizontal: 4, vertical: 12),
                items: [
                  ...List.generate(
                    movieController.trendingMovieList.length,
                    (index) {
                      var movie = movieController.trendingMovieList[index];
                      return GestureDetector(
                        onTap: () {
                          Get.to(() => MovieDetailsPage(movieId: movie["id"]));
                        },
                        child: ItemCard(
                          width: 132,
                          title: movie["title"],
                          year: movie["release_date"].split("-")[0], // Extract year
                          rating: movie["vote_average"],
                          image: movie["poster_path"],
                        ),
                      );
                    },
                  ),
                ],
              );
  }

  // Top Rated Movies Section with shimmer and empty data handling
  Widget buildTopRatedMoviesSection(MovieController movieController) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 10),
          child: Text(
            "Top Rated Movies",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
        ),
        const SizedBox(height: 12),
        Obx(
          () => movieController.isTopRatedMoviesLoading.isTrue
              ? SizedBox(
                  height: 180,
                  child: AppShimmers().buildMovieSeriesShimmerList()
                )
              : movieController.topRatedMovies.isEmpty
                  ? const SizedBox(
                      height: 180,
                      child: Center(child: Text("No top-rated movies available")),
                    )
                  : SizedBox(
                      height: 180,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        itemCount: movieController.topRatedMovies.length,
                        physics: const BouncingScrollPhysics(),
                        separatorBuilder: (context, index) => const SizedBox(width: 10),
                        itemBuilder: (context, index) {
                          final movie = movieController.topRatedMovies[index];
                          return GestureDetector(
                            onTap: () {
                              Get.to(() => MovieDetailsPage(movieId: movie.id));
                            },
                            child: ItemCard(
                              width: 134,
                              title: movie.title,
                              year: "", // You can customize to show release year if needed
                              rating: movie.voteAverage?.toDouble() ?? 0.0,
                              image: '${AppConstants.imageUrl}${movie.posterPath}',
                            ),
                          );
                        },
                      ),
                    ),
        ),
      ],
    );
  }

  // All Movies Grid Section with shimmer and empty data handling
  Widget buildAllMoviesGrid(MovieController movieController) {
    return movieController.isMovieListLoading.isTrue
        ? AppShimmers().buildMovieSeriesShimmerList()
        : movieController.moviesList.isEmpty
            ? const SizedBox(
                height: 300,
                child: Center(child: Text("No movies available")),
              )
            : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // All Movies
                const Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Text(
                    "All Movies",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 10,),
                // Grid
                GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    itemCount: movieController.moviesList.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                      childAspectRatio: 0.7,
                    ),
                    itemBuilder: (context, index) {
                      final movie = movieController.moviesList[index];
                      return GestureDetector(
                        onTap: () {
                          Get.to(() => MovieDetailsPage(movieId: movie["id"]));
                        },
                        child: ItemCard(
                          width: 132,
                          title: movie["title"] ?? "",
                          year: movie["release_date"].toString().split("-")[0],
                          rating: movie["vote_average"].toDouble() ?? 0.0,
                          image: '${AppConstants.imageUrl}${movie["poster_path"]}',
                        ),
                      );
                    },
                  ),
              ],
            );
  }

  // Pagination loading indicator
  Widget paginationLoading(MovieController movieController) {
    return movieController.isMovieListPaginationLoading.value
        ? const Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Center(child: CircularProgressIndicator()),
          )
        : const SizedBox.shrink();
  }
}
