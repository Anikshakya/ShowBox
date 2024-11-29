import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:showbox/src/constant/constants.dart';
import 'package:showbox/src/controller/series_controller.dart';
import 'package:showbox/src/view/series/series_details.dart';
import 'package:showbox/src/widgets/cards/item_card.dart';
import 'package:showbox/src/widgets/custom_slider.dart';

class SeriesListPage extends StatelessWidget {
  final ScrollController scrollController;

  const SeriesListPage({
    super.key,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    // Get Controller
    final seriesController = Get.put(SeriesController());

    seriesController.initialize(); // Pre-fetch initial movie data

    return Scaffold(
      body: Obx(() => seriesController.isSeriesListLoading.isTrue
        // Display a loading spinner while the movie list is loading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : NotificationListener<ScrollNotification>(
          onNotification: (scrollNotification) {  
            // Trigger pagination when the user scrolls to the bottom
            if (scrollNotification.metrics.pixels == scrollNotification.metrics.maxScrollExtent && !seriesController.isSeriesListPaginationLoading.value) {
              seriesController.isSeriesListPaginationLoading(true);
              seriesController.fetchNextPage();
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
                        seriesController.trendingSeriesList.length,
                        (index) {
                          var movie = seriesController.trendingSeriesList[index];
                        return GestureDetector(
                          onTap: (){
                            Get.to(()=> SeriesDetailPage(
                              id:  movie["id"],
                            ));
                          },
                          child: ItemCard(
                            width: 132,
                            title: movie["title"] ?? "",
                            year: movie["release_date"] == null ? "" : movie["release_date"].split("-")[0], // Extract year
                            rating: movie["vote_average"] ?? "",
                            image: movie["poster_path"] ?? "",
                          ),
                        );
                        },
                      ),
                    ],
                  )
                ),
                const SizedBox(height: 20),
                // Top Rated Series Section
                Column(
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
                    Obx(() => seriesController.isTopRatedSeriesLoading.isTrue
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
                          itemCount: seriesController.topRatedSeries.length,
                          physics: const BouncingScrollPhysics(),
                          separatorBuilder:(context, index) => const SizedBox(width: 10,),
                          itemBuilder: (context, index) {
                            final movie = seriesController.topRatedSeries[index];
                            return GestureDetector(
                              onTap: (){
                                Get.to(()=> SeriesDetailPage(
                                  id: movie.id,
                                ));
                              },
                              child: ItemCard(
                                width: 132,
                                title: movie.name, 
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
                  padding: EdgeInsets.only(left: 8.0),
                  child: Text(
                    "All Series",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 10,),
                // Series List Grid
                seriesGrid(seriesController),
                // Pagination Loading
                paginationLoading(seriesController),
              ],
            ),
          )
        ),
      ),
    );
  }

  seriesGrid(SeriesController seriesCon) {
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
      itemCount: seriesCon.seriesList.length,
      itemBuilder: (context, index) {
        final series = seriesCon.seriesList[index];
        return GestureDetector(
          onTap: () {
            Get.to(() => SeriesDetailPage(id: series["id"]));
          },
          child: ItemCard(
            width: 132,
            title: series["name"] ?? "",
            year: series["first_air_date"].split("-")[0] ?? "", // Extract year
            rating: series["vote_average"] ?? "",
            image: series["poster_path"] ?? "",
          ),
        );
      },
    );
  }

  paginationLoading(SeriesController seriesCon) {
    return Obx(()=> seriesCon.isSeriesListPaginationLoading.isTrue
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