import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:showbox/src/controller/search_controller.dart';
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
          backgroundColor: Colors.transparent,
          toolbarHeight: 100,
          title: Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Material(
              elevation: 4,
              shadowColor: Colors.black.withOpacity(0.2),
              borderRadius: BorderRadius.circular(16),
              child: Container(
                decoration: BoxDecoration(
                  color: isDarkMode ? Colors.grey[800] : Colors.grey[200],
                  borderRadius: BorderRadius.circular(16),
                ),
                child: TextField(
                  onSubmitted: (value) {
                    if (value.isNotEmpty) {
                      controller.searchForMovie(value);
                    }
                  },
                  style: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black,
                    fontSize: 16,
                  ),
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.search,
                      color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                    ),
                    hintText: "Search movies or series...",
                    hintStyle: TextStyle(
                      color: isDarkMode ? Colors.grey[500] : Colors.grey[700],
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
            ),
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(50),
            child: TabBar(
              labelColor: Theme.of(context).primaryColor,
              unselectedLabelColor: isDarkMode ? Colors.grey[400] : Colors.grey[600],
              indicatorColor: Theme.of(context).primaryColor,
              tabs: const [
                Tab(text: 'Movies'),
                Tab(text: 'Series'),
              ],
            ),
          ),
        ),
        body: Obx(() {
          if (controller.isSearchListLoading.value) {
            return const Center(child: CircularProgressIndicator());
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
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    )
                  : GridView.builder(
                      padding: const EdgeInsets.all(8.0),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 8,
                        crossAxisSpacing: 8,
                        childAspectRatio: 0.7,
                      ),
                      itemCount: controller.movieSearchList.length,
                      itemBuilder: (context, index) {
                        var movie = controller.movieSearchList[index];
                        return ItemCard(
                          title: movie['title'] ?? 'Unknown Movie',
                          year: (movie['release_date'] ?? '').split('-').first,
                          rating: (movie['vote_average'] ?? 0).toDouble(),
                          image: movie['poster_path'] ?? '',
                          width: MediaQuery.of(context).size.width / 2 - 16,
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
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    )
                  : GridView.builder(
                      padding: const EdgeInsets.all(8.0),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 8,
                        crossAxisSpacing: 8,
                        childAspectRatio: 0.7,
                      ),
                      itemCount: controller.seriesSearchList.length,
                      itemBuilder: (context, index) {
                        var series = controller.seriesSearchList[index];
                        return ItemCard(
                          title: series['name'] ?? 'Unknown Series',
                          year: (series['first_air_date'] ?? '').split('-').first,
                          rating: (series['vote_average'] ?? 0).toDouble(),
                          image: series['poster_path'] ?? '',
                          width: MediaQuery.of(context).size.width / 2 - 16,
                        );
                      },
                    ),
            ],
          );
        }),
      ),
    );
  }
}