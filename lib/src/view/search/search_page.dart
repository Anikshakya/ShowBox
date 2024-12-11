import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:showbox/src/app_config/styles.dart';
import 'package:showbox/src/controller/search_controller.dart';
import 'package:showbox/src/view/movie/movie_details.dart';
import 'package:showbox/src/view/series/series_details.dart';
import 'package:showbox/src/widgets/cards/item_card.dart';
import 'package:showbox/src/widgets/customGesturePatternPainter.dart';

class SearchPage extends StatefulWidget {

  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final SearchhController searchCon = Get.put(SearchhController());

  final ScrollController movieScrollController = ScrollController();
  final ScrollController seriesScrollController = ScrollController();
  final TextEditingController searchTextCon = TextEditingController();
  
  List<Offset> points = [];

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
              controller: searchTextCon,
              onFieldSubmitted: (value) {
                if (value.isNotEmpty) {
                  searchCon.searchMovie(value);
                  searchCon.searchSeries(value);
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
                if (searchCon.isMovieSearchLoading.value) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: AppStyles.goldenColor, // Golden progress indicator
                    ),
                  );
                }
                if (!searchCon.hasSearched.value) {
                  return GestureDetector(
                    onPanUpdate: (details) {
                        points.add(details.localPosition);
                        setState(() {
                          
                        });
                       print("asdfsdf");
                    },
                    onPanEnd: (details) {
                      if (UserGestures().detectZShape(points)) {
                          searchCon.isAdult.value = !searchCon.isAdult.value;
                      }
                      points.clear();
                      setState(() {

                      });
                    },
                    child: CustomPaint(
                      child: Container(
                        color: Colors.black.withOpacity(0.1),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Obx( ()=>
                              Center(
                                child: Text(
                                  "Nothing to show...${searchCon.isAdult.value == true ? "." : ""}",
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }
              
                return TabBarView(
                  children: [
                    // Movies Tab
                    searchCon.movieSearchList.isEmpty
                        ? const Center(
                            child: Text(
                              "No Movies Found....",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          )
                        : NotificationListener<ScrollNotification>(
                          onNotification: (scrollNotification) {                            
                            // Show Scroll To Top Button
                            if (movieScrollController.position.pixels  > 2000) {
                              searchCon.isMovieScrollToTopVisible(true);
                            } else if (movieScrollController.position.pixels  <= 2000) {
                              searchCon.isMovieScrollToTopVisible(false);
                            }
                      
                            // Trigger pagination when the user scrolls to the bottom
                            if (scrollNotification.metrics.pixels == scrollNotification.metrics.maxScrollExtent && !searchCon.isMoviePageSearchLoading.value) {
                              searchCon.isMoviePageSearchLoading(true);
                              searchCon.getSearchMoviePagination(searchTextCon.text); // Trigger pagination when scrolling reaches the bottom
                            }
                            return true;
                          },
                          child: SingleChildScrollView(
                            controller: movieScrollController,
                            child: Column(
                              children: [
                                GridView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  padding: const EdgeInsets.all(8.0),
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    mainAxisSpacing: 8,
                                    crossAxisSpacing: 8,
                                    childAspectRatio: 0.7,
                                  ),
                                  shrinkWrap: true,
                                  itemCount: searchCon.movieSearchList.length,
                                  itemBuilder: (context, index) {
                                    var movie = searchCon.movieSearchList[index];
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
                                // Pagination Loading
                                 searchCon.isMoviePageSearchLoading.value
                                    ? const Padding(
                                        padding: EdgeInsets.symmetric(vertical: 20),
                                        child: Center(child: CircularProgressIndicator()),
                                      )
                                    : const SizedBox.shrink()
                              ],
                            ),
                          ),
                        ),
              
                    // Series Tab
                    searchCon.seriesSearchList.isEmpty
                        ? const Center(
                            child: Text(
                              "No Series Found",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          )
                        : NotificationListener<ScrollNotification>(
                          onNotification: (scrollNotification) {                            
                            // Show Scroll To Top Button
                            if (seriesScrollController.position.pixels  > 2000) {
                              searchCon.isSeriesSearchLoading(true);
                            } else if (seriesScrollController.position.pixels  <= 2000) {
                              searchCon.isSeriesSearchLoading(false);
                            }
                      
                            // Trigger pagination when the user scrolls to the bottom
                            if (scrollNotification.metrics.pixels == scrollNotification.metrics.maxScrollExtent && !searchCon.isSeriesPageSearchLoading.value) {
                              searchCon.isSeriesPageSearchLoading(true);
                              searchCon.getSearchSeriesPagination(searchTextCon.text); // Trigger pagination when scrolling reaches the bottom
                            }
                            return true;
                          },
                          child: SingleChildScrollView(
                            controller: seriesScrollController,
                            child: Column(
                              children: [
                                GridView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  padding: const EdgeInsets.all(8.0),
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    mainAxisSpacing: 8,
                                    crossAxisSpacing: 8,
                                    childAspectRatio: 0.7,
                                  ),
                                  itemCount: searchCon.seriesSearchList.length,
                                  itemBuilder: (context, index) {
                                    var series = searchCon.seriesSearchList[index];
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
                                // Pagination Loading
                                searchCon.isSeriesPageSearchLoading.value
                                  ? const Padding(
                                      padding: EdgeInsets.symmetric(vertical: 20),
                                      child: Center(child: CircularProgressIndicator()),
                                    )
                                  : const SizedBox.shrink()
                              ],
                            ),
                          ),
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