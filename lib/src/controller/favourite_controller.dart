import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get_storage/get_storage.dart';

/// ================= MODEL =================

class FavoriteItem {
  final int id;
  final String title;
  final String image;
  final String type; // Added type (movie/series)

  FavoriteItem({
    required this.id,
    required this.title,
    required this.image,
    required this.type,
  });

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "image": image,
        "type": type,  // Store type (movie/series)
      };

  factory FavoriteItem.fromJson(Map<String, dynamic> json) {
    return FavoriteItem(
      id: json["id"],
      title: json["title"],
      image: json["image"],
      type: json["type"], // Load type (movie/series)
    );
  }
}

/// ================= CONTROLLER =================

class FavoritesController extends GetxController {
  final box = GetStorage();
  final favorites = <FavoriteItem>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadFavorites();
  }

  void loadFavorites() {
    final data = box.read("favorites") ?? [];
    favorites.value = List<FavoriteItem>.from(
      data.map((e) => FavoriteItem.fromJson(e)),
    );
  }

  void toggleFavorite(FavoriteItem item) {
    if (isFavorite(item.id)) {
      favorites.removeWhere((e) => e.id == item.id);
    } else {
      favorites.add(item);
    }
    box.write("favorites", favorites.map((e) => e.toJson()).toList());
  }

  bool isFavorite(int id) {
    return favorites.any((e) => e.id == id);
  }
}
