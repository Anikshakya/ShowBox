import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:showbox/src/constant/constants.dart';
import 'package:showbox/src/controller/series_controller.dart';
import 'package:showbox/src/view/series/series_details.dart';
import 'package:showbox/src/widgets/cards/item_card.dart';
import 'package:showbox/src/widgets/custom_shimmer.dart';
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

    seriesController.initialize(); // Pre-fetch initial series data

    return Scaffold(
      body: Obx(() => seriesController.isSeriesListLoading.isTrue
        // Display a loading spinner while the series list is loading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : NotificationListener<ScrollNotification>(
          onNotification: (scrollNotification) {  
            // Show Scroll To Top Button
              if(scrollNotification.metrics.pixels > 2000){
                seriesController.isScrollToTopVisible(true);
              } else {
                seriesController.isScrollToTopVisible(false);
              }

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
                buildTrendingSliderSection(seriesController),
                const SizedBox(height: 20),
                // Top Rated Series Section
                buildTopRatedSeriesSection(seriesController),
                const SizedBox(height: 20),
                // All Series Grid Section
                buildAllSeriesGrid(seriesController),
                // Pagination loading indicator
                paginationLoading(seriesController),
              ],
            ),
          )
        ),
      ),
      floatingActionButton: Obx(()=>
         Visibility(
           visible: seriesController.isScrollToTopVisible.value == true,
           child: Padding(
             padding: const EdgeInsets.only(bottom: 60.0),
             child: FloatingActionButton(
              backgroundColor: const Color(0xffecc877),
              onPressed: () {
                scrollController.animateTo(
                  0,
                  duration: const Duration(milliseconds: 800),
                  curve: Curves.easeOut,
                );
              },
              child: const Icon(Icons.arrow_upward_outlined, color: Colors.black),
                         ),
           ),
         ),
      ),
    );
  }

  // Trending Slider Section with shimmer and empty data handling
  Widget buildTrendingSliderSection(SeriesController seriesController) {
    return seriesController.isTrendingSeriesLoading.isTrue
        ? const SizedBox(
          height: 260,
          child: Center(
            child: CircularProgressIndicator(),
          ),
        )
        : seriesController.trendingSeriesList.isEmpty
            ? const SizedBox(
                height: 260,
                child: Center(child: Text("No trending series available")),
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
                    seriesController.trendingSeriesList.length,
                    (index) {
                      var series = seriesController.trendingSeriesList[index];
                      return GestureDetector(
                        onTap: () {
                          Get.to(() => SeriesDetailPage(id: series["id"]));
                        },
                        child: ItemCard(
                          width: 132,
                          title: series["name"] ?? "",
                          year: series["first_air_date"]?.split("-")[0] ?? "",
                          rating: series["vote_average"] ?? "",
                          image: series["poster_path"] ?? "",
                        ),
                      );
                    },
                  ),
                ],
              );
  }

  // Top Rated Series Section with shimmer and empty data handling
  Widget buildTopRatedSeriesSection(SeriesController seriesController) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 10),
          child: Text(
            "Top Rated Series",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
        ),
        const SizedBox(height: 12),
        Obx(
          () => seriesController.isTopRatedSeriesLoading.isTrue
              ? SizedBox(
                  height: 180,
                  child: AppShimmers().buildMovieSeriesShimmerList()
                )
              : SizedBox(
                  height: 180,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    itemCount: seriesController.topRatedSeries.length,
                    physics: const BouncingScrollPhysics(),
                    separatorBuilder: (context, index) => const SizedBox(width: 10),
                    itemBuilder: (context, index) {
                      final series = seriesController.topRatedSeries[index];
                      return GestureDetector(
                        onTap: () {
                          Get.to(() => SeriesDetailPage(id: series.id));
                        },
                        child: ItemCard(
                          width: 132,
                          title: series.name ?? "",
                          year: "",
                          rating: series.voteAverage?.toDouble() ?? 0.0,
                          image: '${AppConstants.imageUrl}${series.posterPath}',
                        ),
                      );
                    },
                  ),
                ),
        ),
      ],
    );
  }

  // All Series Grid Section with shimmer and empty data handling
  Widget buildAllSeriesGrid(SeriesController seriesController) {
    return seriesController.isSeriesListLoading.isTrue
        ? const Center(child: CircularProgressIndicator()) // Shimmer or loading spinner for all series
        : seriesController.seriesList.isEmpty
          ? const SizedBox(
              height: 300,
              child: Center(child: Text("No series available")),
            )
          : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
               // All Series
                const Padding(
                  padding: EdgeInsets.only(left: 10),
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
              GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                  itemCount: seriesController.seriesList.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    childAspectRatio: 0.7,
                  ),
                  itemBuilder: (context, index) {
                    final series = seriesController.seriesList[index];
                    return GestureDetector(
                      onTap: () {
                        Get.to(() => SeriesDetailPage(id: series["id"]));
                      },
                      child: ItemCard(
                        width: 132,
                        title: series["name"] ?? "",
                        year: series["first_air_date"]?.split("-")[0] ?? "",
                        rating: series["vote_average"] ?? "",
                        image: series["poster_path"] ?? "",
                      ),
                    );
                  },
                ),
            ],
          );
  }

  // Pagination loading indicator
  Widget paginationLoading(SeriesController seriesController) {
    return seriesController.isSeriesListPaginationLoading.value
        ? const Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Center(child: CircularProgressIndicator()),
          )
        : const SizedBox.shrink();
  }
}