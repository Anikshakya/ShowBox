import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:showbox/src/app_config/styles.dart';
import 'package:showbox/src/controller/search_controller.dart';
import 'package:showbox/src/view/movie/movie_details.dart';
import 'package:showbox/src/view/series/series_details.dart';
import 'package:showbox/src/widgets/cards/item_card.dart';

class SearchPage extends StatelessWidget {
  final SearchhController controller = Get.put(SearchhController());

  SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Theme.of(context).brightness == Brightness.dark ? Colors.white.withOpacity(0.11) : Theme.of(context).primaryColor.withOpacity(0.09),
          toolbarHeight: 100,
          title: Container(
            height: 45,
            decoration: BoxDecoration(
              color: isDarkMode ? Colors.grey[800] : Colors.grey[200],
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).primaryColor.withOpacity(isDarkMode ? 0.5 : 0.2), // Golden shadow
                  offset: const Offset(0, 0.5),
                  blurRadius: 6,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: TextFormField(
              onFieldSubmitted: (value) {
                if (value.isNotEmpty) {
                  controller.searchMovie(value);
                  controller.searchSeries(value);
                }
              },
              style: TextStyle(
                color: isDarkMode ? Colors.white : Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w300,
              ),
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.search,
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
                hintText: "Search movies or series...",
                hintStyle: TextStyle(
                  color: isDarkMode ? Colors.grey[400] : Colors.grey[700],
                ),
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
              ),
              textAlignVertical: TextAlignVertical.center,
            ),
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(50),
            child: TabBar(
              labelColor: isDarkMode
                  ? Colors.grey[100]
                  : Colors.grey[900],
              unselectedLabelColor:Colors.grey[500],
              indicatorColor: AppStyles.goldenColor,
              labelStyle: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500
              ),
              unselectedLabelStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400
              ),
              tabs: const [
                Tab(text: 'Movies'),
                Tab(text: 'Series'),
              ],
            ),
          ),
        ),
        body: Stack(
          children: [
            // Gradient Underlay
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).primaryColor.withOpacity(Theme.of(context).brightness == Brightness.dark ? .0001 : 0.1),
                    Colors.transparent,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.white.withOpacity(.2),
                    Colors.transparent,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Obx(() {
                if (controller.isMovieSearchLoading.value) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: AppStyles.goldenColor, // Golden progress indicator
                    ),
                  );
                }
              
                if (!controller.hasSearched.value) {
                  return const Center(
                    child: Text(
                      "Nothing to show",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  );
                }
              
                return TabBarView(
                  children: [
                    // Movies Tab
                    controller.movieSearchList.isEmpty
                        ? const Center(
                            child: Text(
                              "No Movies Found",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          )
                        : GridView.builder(
                            padding: const EdgeInsets.all(8.0),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              mainAxisSpacing: 8,
                              crossAxisSpacing: 8,
                              childAspectRatio: 0.7,
                            ),
                            itemCount: controller.movieSearchList.length,
                            itemBuilder: (context, index) {
                              var movie = controller.movieSearchList[index];
                              return GestureDetector(
                                onTap: (){
                                    Get.to(()=> MovieDetailsPage(movieId: movie["id"]));
                                },
                                child: ItemCard(
                                  title: movie['title'] ?? 'Unknown Movie',
                                  year: (movie['release_date'] ?? '').split('-').first,
                                  rating: (movie['vote_average'] ?? 0).toDouble(),
                                  image: movie['poster_path'] ?? '',
                                  width: MediaQuery.of(context).size.width / 2 - 16,
                                ),
                              );
                            },
                          ),
              
                    // Series Tab
                    controller.seriesSearchList.isEmpty
                        ? const Center(
                            child: Text(
                              "No Series Found",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          )
                        : GridView.builder(
                          shrinkWrap: true,
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.all(8.0),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            mainAxisSpacing: 8,
                            crossAxisSpacing: 8,
                            childAspectRatio: 0.7,
                          ),
                          itemCount: controller.seriesSearchList.length,
                          itemBuilder: (context, index) {
                            var series = controller.seriesSearchList[index];
                            return GestureDetector(
                              onTap : (){
                                if( series["media_type"] == "tv"){
                                  Get.to(()=> SeriesDetailPage(
                                    id: series["id"],
                                  ));
                                }
                              },
                              child: ItemCard(
                                title: series['name'] ?? 'Unknown Series',
                                year: (series['first_air_date'] ?? '')
                                    .split('-')
                                    .first,
                                rating: (series['vote_average'] ?? 0).toDouble(),
                                image: series['poster_path'] ?? '',
                                width: MediaQuery.of(context).size.width / 2 - 16,
                              ),
                            );
                          },
                        ),
                  ],
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}