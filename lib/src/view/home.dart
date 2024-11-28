  import 'package:flutter/material.dart';
  import 'package:get/get.dart';
  import 'package:showbox/src/constant/constants.dart';
  import 'package:showbox/src/controller/home_controller.dart';
import 'package:showbox/src/view/movie/movie_details.dart';
import 'package:showbox/src/view/series/series_details.dart';
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
        body: SingleChildScrollView(
          controller: scrollController,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // For App Bar
              const SizedBox(height: 100),
              // Trending Movies/Series
              Obx(() => homeCon.isTrendingListLoading.isTrue
                  ? const Center(child: CircularProgressIndicator())
                  : CustomImageSlider(
                      height: 280,
                      cornerRadius: 2.0,
                      showIndicator: false,
                      onTap: (index) {
                        if( homeCon.trendingList[index]["media_type"] == "movie"){
                          Get.to(()=> MovieDetailsPage(movieId: homeCon.trendingList[index]["id"]));
                        }
                                 
                        if( homeCon.trendingList[index]["media_type"] == "tv"){
                          Get.to(()=> SeriesDetailPage(
                            id:  homeCon.trendingList[index]["id"],
                          ));
                        }
                      },
                      images: homeCon.trendingList.map((item) {
                        return item['poster_path'] != null
                            ? '${AppConstants.imageUrl}${item['poster_path']}'
                            : '';
                      }).toList(),
                    ),
              ),
              const SizedBox(height: 20),
              // Top Rated Movies
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Top Rated Movies",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Obx(() => homeCon.isTopRatedMoviesLoading.isTrue
                        ? const Center(child: CircularProgressIndicator())
                        : SizedBox(
                            height: 240,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: homeCon.topRatedMovies.length,
                              itemBuilder: (context, index) {
                                final movie = homeCon.topRatedMovies[index];
                                return GestureDetector(
                                  onTap: (){
                                    Get.to(()=> MovieDetailsPage(
                                      movieId: movie.id,
                                    ));
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 16),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(16),
                                      child: Container(
                                        width: 160,
                                        decoration: BoxDecoration(
                                          color: Colors.black,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Theme.of(context).primaryColor.withOpacity(0.3),
                                              spreadRadius: 1,
                                              blurRadius: 10,
                                              offset: const Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              child: Image.network(
                                                '${AppConstants.imageUrl}${movie.posterPath}',
                                                fit: BoxFit.cover,
                                                width: double.infinity,
                                                height: double.infinity,
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Text(
                                                movie.title ?? 'N/A',
                                                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.white,
                                                    ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 8),
                                              child: Text(
                                                '⭐ ${movie.voteAverage?.toDouble() ?? 0.0}',
                                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                                      fontSize: 14,
                                                      color: Colors.white,
                                                    ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // Top Rated Series Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Top Rated Series",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Obx(() => homeCon.isTopRatedSeriesLoading.isTrue
                        ? const Center(child: CircularProgressIndicator())
                        : SizedBox(
                            height: 240,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: homeCon.topRatedSeries.length,
                              itemBuilder: (context, index) {
                                final series = homeCon.topRatedSeries[index];
                                return GestureDetector(
                                  onTap: (){
                                    Get.to(()=> SeriesDetailPage(
                                      id: series.id,
                                    ));
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 16),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(16),
                                      child: Container(
                                        width: 160,
                                        decoration: BoxDecoration(
                                          color: Colors.black,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(0.3),
                                              spreadRadius: 1,
                                              blurRadius: 10,
                                              offset: const Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              child: Image.network(
                                                '${AppConstants.imageUrl}${series.posterPath}',
                                                fit: BoxFit.cover,
                                                width: double.infinity,
                                                height: double.infinity,
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Text(
                                                series.name ?? 'N/A',
                                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.white,
                                                    ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 8),
                                              child: Text(
                                                '⭐ ${series.voteAverage?.toDouble() ?? 0.0}',
                                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                                      fontSize: 14,
                                                      color: Colors.white,
                                                    ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                    ),
                  ],
                ),
              ),
              // Upcomming Movies
              // UpComming Series
            ],
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

    const MovieCard({
      super.key,
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
