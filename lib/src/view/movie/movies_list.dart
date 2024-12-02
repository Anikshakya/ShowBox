import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:showbox/src/constant/constants.dart';
import 'package:showbox/src/controller/movies_controller.dart';
import 'package:showbox/src/view/movie/movie_details.dart';
import 'package:showbox/src/widgets/cards/item_card.dart';
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
                const SizedBox(height: 100),
                // Trending Slider
                Center(
                  child: CustomItemSlider(
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
                          onTap: (){
                            Get.to(()=> MovieDetailsPage(movieId: movie["id"]));
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
                  )
                ),
                const SizedBox(height: 20,),
                // Top Rated Movie Section
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Text(
                        "Top Rated Movies",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Obx(() => movieController.isTopRatedMoviesLoading.isTrue
                        ? const SizedBox(
                          height: 180,
                          child: Center(
                            child: CircularProgressIndicator()
                          )
                        )
                        : SizedBox(
                          height: 180,
                          child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          itemCount: movieController.topRatedMovies.length,
                          physics: const BouncingScrollPhysics(),
                          separatorBuilder:(context, index) => const SizedBox(width: 10,),
                          itemBuilder: (context, index) {
                            final movie = movieController.topRatedMovies[index];
                            return GestureDetector(
                              onTap: (){
                                Get.to(()=> MovieDetailsPage(
                                  movieId: movie.id,
                                ));
                              },
                              child: ItemCard(
                                width: 134,
                                title: movie.title, 
                                year: "", 
                                rating: movie.voteAverage?.toDouble() ?? 0.0, 
                                image: '${AppConstants.imageUrl}${movie.posterPath}'
                              )
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20,),
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
          child: ItemCard(
            width: 132,
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