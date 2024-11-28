import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:showbox/src/controller/search_controller.dart';
import 'package:showbox/src/view/movie/movie_details.dart';
import 'package:showbox/src/view/series/series_details.dart';
import 'package:showbox/src/widgets/custom_image_widget.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final SearchAllController searchCon = Get.put(SearchAllController());
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(),
      body: Obx(() =>
        searchCon.isSearchListLoading.isTrue ?
          // Show a loading indicator while fetching results
           const Center(child: CircularProgressIndicator(color: Colors.red,))
        : GridView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: searchCon.searchList.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 0.7,
          ),
          itemBuilder: (context, index) {
            var movie = searchCon.searchList[index];
            // Extract movie details
            String title = movie['name'] ?? 'Untitled';
            String year = (movie['first_air_date'] ?? '').split('-').first;
            double rating = (movie['vote_average'] ?? 0).toDouble();
            String image = movie['poster_path'] ?? '';
            return GestureDetector(
              onTap: (){
                if( movie["media_type"] == "movie"){
                  Get.to(()=> MovieDetailsPage(movieId: movie["id"]));
                }
                          
                if( movie["media_type"] == "tv"){
                  Get.to(()=> SeriesDetailPage(id:  movie["id"]));
                }
              },
              child: MovieCard(
                title: title,
                year: year.isNotEmpty ? year : 'Unknown',
                rating: rating,
                image: image,
              ),
            );
          },
        )
      ),
    );
  }
  
  customAppBar() {
    return PreferredSize(
      preferredSize: const Size(double.infinity, 65),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 26,),
          Container(
            padding: const EdgeInsets.only(top : 18, bottom : 0, left : 18),
            child: Row(
              children: [
                const SizedBox(width: 30),
                SizedBox(
                  height: 36,
                  width: 280.0,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(25.0),
                    child: TextFormField(
                      controller: _searchController,
                      autofocus: true,
                      onFieldSubmitted: (value) {
                        searchCon.searchForMovie(keyWord: value);
                      },
                      decoration: InputDecoration(
                        filled: true,
                        contentPadding: const EdgeInsets.only(top: 6.0, left: 15.0, right: 10),
                        fillColor: const Color.fromARGB(255, 221, 221, 221),
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        hintText: 'Search',
                        hintStyle:  const TextStyle(fontSize: 14, color: Color.fromARGB(255, 110, 108, 110)),
                        prefixIconConstraints: const BoxConstraints(
                          maxWidth: 62.0,
                          minWidth: 52.0
                        ),
                        prefixIcon: const Icon(Icons.search, color: Color.fromARGB(255, 110, 108, 110))
                      ),
                    ),
                  ),
                ),                
                const SizedBox(width: 30),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


class MovieCard extends StatelessWidget {
  final String title;
  final String year;
  final double rating;
  final String image;

  const MovieCard({
    super.key,
    required this.title,
    required this.year,
    required this.rating,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
        borderRadius: BorderRadius.circular(2),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(2),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Movie image
            CustomImageNetworkWidget(
              borderRadius: 2,
              imagePath: "https://image.tmdb.org/t/p/w500$image",
            ),
            // Display the release year at the top-left corner
            Positioned(
              top: 0,
              left: 0,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  borderRadius: const BorderRadius.only(
                      bottomRight: Radius.circular(8)),
                ),
                child: Text(
                  year,
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ),
            // Display the rating at the top-right corner
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 233, 198, 0).withOpacity(0.9),
                  borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(8)),
                ),
                child: Text(
                  rating.toStringAsFixed(1), // Format rating to 1 decimal
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


