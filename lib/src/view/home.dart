import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:showbox/src/constant/constants.dart';
import 'package:showbox/src/controller/home_controller.dart';
import 'package:showbox/src/view/movie/movie_details.dart';
import 'package:showbox/src/view/series/series_details.dart';
import 'package:showbox/src/widgets/cards/item_card.dart';
import 'package:showbox/src/widgets/cards/trending_card.dart';
import 'package:showbox/src/widgets/custom_pageview.dart';
import 'package:showbox/src/widgets/custom_shimmer.dart';

class HomePage extends StatelessWidget {
  final ScrollController scrollController;

  // Constructor to accept scroll controller from outside
  const HomePage({super.key, required this.scrollController});

  @override
  Widget build(BuildContext context) {
    // Initialize HomeController once, outside of build to avoid reinitialization
    final homeCon = Get.put(HomeController());

    // Ensure the controller is initialized
    homeCon.initialize();

    return Scaffold(
      body: SingleChildScrollView(
        controller: scrollController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Trending Movies/Series
            trendingSlider(homeCon, context),
        
            const SizedBox(height: 20),
        
            // Upcoming Movies
            buildUpcomingMoviesSection(homeCon),
        
            const SizedBox(height: 20),
        
            // Top Rated Series Section
            buildTopRatedSeriesSection(homeCon),
        
            const SizedBox(height: 20),
        
            // Top Rated Movies Section
            buildTopRatedMoviesSection(homeCon),
        
            const SizedBox(height: 40), // Extra spacer
          ],
        ),
      ),
    );
  }

  trendingSlider(HomeController homeCon, BuildContext context) {
    return Obx( ()=>  homeCon.isTrendingListLoading.isTrue
        ? Stack(
          children: [
            const SizedBox(
              height: 560,
              child: CustomShimmer()
            ),
            Positioned.fill(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 22,
                        fontWeight: FontWeight.w300,
                        letterSpacing: 1,
                        height: 1.5,
                      ),
                      children: const [
                        TextSpan(text: "Watch "),
                        TextSpan(
                          text: "Free",
                          style: TextStyle(color: Color(0XFFCBA84A)),
                        ),
                        TextSpan(text: " HD Movies &\nTV shows"),
                      ],
                    ),
                  ),
                  const SizedBox(height: 26),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w300,
                        letterSpacing: 1,
                        height: 1.6,
                      ),
                      children: const [
                        TextSpan(text: "Enjoy your "),
                        TextSpan(
                          text: "unlimited",
                          style: TextStyle(color: Color(0XFFCBA84A)),
                        ),
                        TextSpan(
                            text: " Movies & TV show collection.\nWe are the definitive source for the best\n curated 720p / 1080p HD Movies & TV shows,\nviewable by mobile phone and tablet, for "),
                        TextSpan(
                          text: "free",
                          style: TextStyle(color: Color(0XFFCBA84A)),
                        ),
                        TextSpan(text: "."),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                ]
              ),
            )
          ],
        )
        : CustomPageView(
          height: 560,
          enableAutoSwipe: true,
          showIndicator: true,
          animationDuration: const Duration(seconds: 1),
          widgets: [
            ...List.generate(
              homeCon.trendingList.length,
              (index) {
                var item = homeCon.trendingList[index];
                return TrendingCard(
                  imageUrl: '${AppConstants.imageUrl}${item['poster_path']}',
                  title: item["media_type"] == "tv" ? item["name"] : item["title"],
                  rating: item['vote_average'].toStringAsFixed(1),
                  year: item["media_type"] == "tv" ? item['first_air_date'] == null ?  "" : item['first_air_date'].split("-")[0] : item['release_date'] == null ?  "" : item['release_date'].split("-")[0],
                  description: item["overview"] ?? "",
                  pricing: 'UNLIMITED | FREE | SHOW BOX',
                  onWatchPressed: () {
                    final mediaType = homeCon.trendingList[index]["media_type"];
                    final id = homeCon.trendingList[index]["id"];
                    // Navigate based on media type (movie or TV)
                    if (mediaType == "movie") {
                      Get.to(() => MovieDetailsPage(movieId: id));
                    } else if (mediaType == "tv") {
                      Get.to(() => SeriesDetailPage(id: id));
                    }
                    // Handle Watch button press action
                  },
                );
              },
            )                                                   
          ]
        ),
      );
  }

  // Method to build Upcoming Movies section with conditional loading
  buildUpcomingMoviesSection(HomeController homeCon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 10),
          child: Text(
            "Upcoming Movies",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w300),
          ),
        ),
        const SizedBox(height: 4),
        Obx(
          () => homeCon.isUpcommingMoviesLoding.isTrue
              ? SizedBox(
                  height: 180,
                  child: AppShimmers().buildMovieSeriesShimmerList(),
                )
              : homeCon.upcommingMovies.isEmpty
                  ? const SizedBox(
                      height: 180,
                      child: Center(child: Text("No data available")),
                    )
                  : SizedBox(
                      height: 180,
                      child: ListView.separated(
                        separatorBuilder: (context, index) =>
                            const SizedBox(width: 10),
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        itemCount: homeCon.upcommingMovies.length,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          final data = homeCon.upcommingMovies[index];
                          return GestureDetector(
                            onTap: () {
                              Get.to(() => MovieDetailsPage(movieId: data["id"]));
                            },
                            child: ItemCard(
                              width: 118,
                              title: data["title"],
                              year: "", // You can customize to show release year if needed
                              rating: data["vote_average"]?.toDouble() ?? 0.0,
                              image:
                                  '${AppConstants.imageUrl}${data["poster_path"]}',
                            ),
                          );
                        },
                      ),
                    ),
        ),
      ],
    );
  }

  // Method to build Top Rated Series section with conditional loading
  buildTopRatedSeriesSection(HomeController homeCon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 10),
          child: Text(
            "Top Rated Series",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w300),
          ),
        ),
        const SizedBox(height: 4),
        Obx(
          () => homeCon.isTopRatedSeriesLoading.isTrue
              ? SizedBox(
                  height: 180,
                  child: AppShimmers().buildMovieSeriesShimmerList(),
                )
              : homeCon.topRatedSeries.isEmpty
                  ? const SizedBox(
                      height: 180,
                      child: Center(child: Text("No data available")),
                    )
                  : SizedBox(
                      height: 180,
                      child: ListView.separated(
                        separatorBuilder: (context, index) =>
                            const SizedBox(width: 10),
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        itemCount: homeCon.topRatedSeries.length,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          final movie = homeCon.topRatedSeries[index];
                          return GestureDetector(
                            onTap: () {
                              Get.to(() => SeriesDetailPage(id: movie.id));
                            },
                            child: ItemCard(
                              width: 118,
                              title: movie.name,
                              year: "", // You can customize to show release year if needed
                              rating: movie.voteAverage.toDouble(),
                              image:
                                  '${AppConstants.imageUrl}${movie.posterPath}',
                            ),
                          );
                        },
                      ),
                    ),
        ),
      ],
    );
  }

  // Method to build Top Rated Movies section with conditional loading
  buildTopRatedMoviesSection(HomeController homeCon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 10),
          child: Text(
            "Top Rated Movies",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w300),
          ),
        ),
        const SizedBox(height: 4),
        Obx(
          () => homeCon.isTopRatedMoviesLoading.isTrue
              ? SizedBox(
                  height: 180,
                  child: AppShimmers().buildMovieSeriesShimmerList(),
                )
              : homeCon.topRatedMovies.isEmpty
                  ? const SizedBox(
                      height: 180,
                      child: Center(child: Text("No data available")),
                    )
                  : SizedBox(
                      height: 180,
                      child: ListView.separated(
                        separatorBuilder: (context, index) =>
                            const SizedBox(width: 10),
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        itemCount: homeCon.topRatedMovies.length,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          final movie = homeCon.topRatedMovies[index];
                          return GestureDetector(
                            onTap: () {
                              Get.to(() => MovieDetailsPage(movieId: movie.id));
                            },
                            child: ItemCard(
                              width: 118,
                              title: movie.title,
                              year: "", // You can customize to show release year if needed
                              rating: movie.voteAverage.toDouble(),
                              image:
                                  '${AppConstants.imageUrl}${movie.posterPath}',
                            ),
                          );
                        },
                      ),
                    ),
        ),
      ],
    );
  }
}