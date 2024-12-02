import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:showbox/src/constant/constants.dart';
import 'package:showbox/src/controller/home_controller.dart';
import 'package:showbox/src/view/movie/movie_details.dart';
import 'package:showbox/src/view/series/series_details.dart';
import 'package:showbox/src/widgets/cards/item_card.dart';
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
          children: [
            const SizedBox(height: 100),
            // Trending Movies/Series
            Obx(() => homeCon.isTrendingListLoading.value
                ? const SizedBox(
                    height: 280,
                    child: Center(child: CircularProgressIndicator())
                  )
                : homeCon.trendingList.isEmpty
                    ? const SizedBox(height: 280, child: Center(child: Text('No Trending Data Available')))
                    : CustomImageSlider(
                        height: 280,
                        cornerRadius: 2.0,
                        showIndicator: false,
                        onTap: (index) {
                          if (homeCon.trendingList[index]["media_type"] == "movie") {
                            Get.to(() => MovieDetailsPage(movieId: homeCon.trendingList[index]["id"]));
                          }
                          if (homeCon.trendingList[index]["media_type"] == "tv") {
                            Get.to(() => SeriesDetailPage(id: homeCon.trendingList[index]["id"]));
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
            // UpComming Movies
            SectionWidget(
              title: "Upcomming Movies",
              loading: homeCon.isUpcommingMoviesLoding.value,
              dataList: homeCon.upcommingMovies,
              itemBuilder: (data) => ItemCard(
                width: 132,
                title: data["title"],
                year: "",
                rating: data["vote_average"]?.toDouble() ?? 0.0,
                image: '${AppConstants.imageUrl}${data["poster_path"]}',
              ),
            ),
            const SizedBox(height: 30),
            // Top Rated Series Section
            SectionWidget(
              title: "Top Rated Series",
              loading: homeCon.isTopRatedSeriesLoading.value,
              dataList: homeCon.topRatedSeries,
              itemBuilder: (movie) => ItemCard(
                width: 132,
                title: movie.name,
                year: "",
                rating: movie.voteAverage.toDouble(),
                image: '${AppConstants.imageUrl}${movie.posterPath}',
              ),
            ),
            const SizedBox(height: 30),
            // Top Rated Movies
            SectionWidget(
              title: "Top Rated Movies",
              loading: homeCon.isTopRatedMoviesLoading.value,
              dataList: homeCon.topRatedMovies,
              itemBuilder: (movie) => ItemCard(
                width: 132, 
                title: movie.title,
                year: "",
                rating: movie.voteAverage.toDouble(),
                image: '${AppConstants.imageUrl}${movie.posterPath}',
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

class SectionWidget<T> extends StatelessWidget {
  final String title;
  final bool loading;
  final List<T> dataList;
  final Widget Function(T data) itemBuilder;

  const SectionWidget({
    super.key,
    required this.title,
    required this.loading,
    required this.dataList,
    required this.itemBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
        ),
        const SizedBox(height: 12),
        loading
            ? const SizedBox(height: 180, child: Center(child: CircularProgressIndicator()))
            : dataList.isEmpty
                ? const SizedBox(height: 180, child: Center(child: Text('No Data Available')))
                : SizedBox(
                    height: 180,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      itemCount: dataList.length,
                      physics: const BouncingScrollPhysics(),
                      separatorBuilder: (context, index) => const SizedBox(width: 10),
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {},
                          child: itemBuilder(dataList[index]),
                        );
                      },
                    ),
                  ),
      ],
    );
  }
}
