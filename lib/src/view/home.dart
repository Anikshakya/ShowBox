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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // For App Bar
              const SizedBox(height: 100),
              // Trending Movies/Series
              Obx(() => homeCon.isTrendingListLoading.isTrue
                  ? const SizedBox(
                      height: 280,
                      child: Center(
                        child: CircularProgressIndicator()
                      )
                    )
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
              // UpComming Movies
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Upcomming Movies",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Obx(() => homeCon.isUpcommingMoviesLoding.isTrue
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
                        itemCount: homeCon.upcommingMovies.length,
                        physics: const BouncingScrollPhysics(),
                        separatorBuilder:(context, index) => const SizedBox(width: 10,),
                        itemBuilder: (context, index) {
                          final data = homeCon.upcommingMovies[index];
                          return GestureDetector(
                            onTap: (){
                              Get.to(()=> MovieDetailsPage(
                                movieId: data["id"],
                              ));
                            },
                            child: ItemCard(
                              width: 132,
                              title: data["title"], 
                              year: "", 
                              rating: data["vote_average"]?.toDouble() ?? 0.0, 
                              image: '${AppConstants.imageUrl}${data["poster_path"]}'
                            )
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
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
                  Obx(() => homeCon.isTopRatedSeriesLoading.isTrue
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
                        itemCount: homeCon.topRatedSeries.length,
                        physics: const BouncingScrollPhysics(),
                        separatorBuilder:(context, index) => const SizedBox(width: 10,),
                        itemBuilder: (context, index) {
                          final movie = homeCon.topRatedSeries[index];
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
              const SizedBox(height: 30),
              // Top Rated Movies
              Column(
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
                        itemCount: homeCon.topRatedMovies.length,
                        physics: const BouncingScrollPhysics(),
                        separatorBuilder:(context, index) => const SizedBox(width: 10,),
                        itemBuilder: (context, index) {
                          final movie = homeCon.topRatedMovies[index];
                          return GestureDetector(
                            onTap: (){
                              Get.to(()=> MovieDetailsPage(
                                movieId: movie.id,
                              ));
                            },
                            child: ItemCard(
                              width: 132,
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
              const SizedBox(height: 40),
            ],
          ),
        ),
      );
    }
  }