import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:showbox/src/controller/favourite_controller.dart';
import 'package:showbox/src/view/movie/movie_details.dart';
import 'package:showbox/src/view/series/series_details.dart';
import 'package:showbox/src/widgets/cards/item_card.dart';

class FavoritesPage extends StatelessWidget {
  FavoritesPage({super.key});

  final FavoritesController favController = Get.put(FavoritesController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Favorites"),
        actions: [
          Obx(() => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Center(
                  child: Text(
                    "❤️ ${favController.favorites.length}",
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Obx(() {
          // Separate favorites by type
          final movieFavorites = favController.favorites
              .where((item) => item.type == "movie")
              .toList();
          final seriesFavorites = favController.favorites
              .where((item) => item.type == "series")
              .toList();

          return ListView(
            children: [
              // Movie Section
              if (movieFavorites.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Favorite Movies",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    GridView.builder(
                      padding: const EdgeInsets.all(0),
                      itemCount: movieFavorites.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                        childAspectRatio: 0.7,
                      ),
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        final movie = movieFavorites[index];
                        return favoriteItemCard(movie.id, movie.title,
                            movie.image, movie.type);
                      },
                    ),
                  ],
                ),

              // Series Section
              if (seriesFavorites.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Favorite Series",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    GridView.builder(
                      padding: const EdgeInsets.all(0),
                      itemCount: seriesFavorites.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                        childAspectRatio: 0.7,
                      ),
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        final series = seriesFavorites[index];
                        return favoriteItemCard(series.id, series.title,
                            series.image, series.type);
                      },
                    ),
                  ],
                ),
            ],
          );
        }),
      ),
    );
  }

  /// ================= FAVORITE ITEM CARD =================
  Widget favoriteItemCard(int id, String title, String image, String type) {
    return GestureDetector(
      onTap: () {
        if (type == "movie") {
          Get.to(() => MovieDetailsPage(movieId: id));
        } else if (type == "series") {
          Get.to(() => SeriesDetailPage(id: id));
        }
      },
      child: ItemCard(
        width: 132,
        title: title,
        year: "", // You can store year in FavoriteItem if needed
        rating: 0, // You can store rating in FavoriteItem if needed
        image: image,
        type: type,
        id: id
      ),
    );
  }
}