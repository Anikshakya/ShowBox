import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:showbox/src/constant/constants.dart';
import 'package:showbox/src/controller/movies_controller.dart';
import 'package:showbox/src/widgets/custom_image_widget.dart';
import 'package:showbox/src/widgets/custom_webview.dart';

class MovieDetailsPage extends StatefulWidget {
  final int movieId;

  const MovieDetailsPage({super.key, required this.movieId});

  @override
  State<MovieDetailsPage> createState() => _MovieDetailsPageState();
}

class _MovieDetailsPageState extends State<MovieDetailsPage> {
  final MovieController movieCon = Get.put(MovieController());

  late Color textColor;
  late Color subtitleColor;
  dynamic movie;

  @override
  void initState() {
    initialize();
    super.initState();
  }

  initialize() async {
    await movieCon.getMovieDetails(id: widget.movieId);
    if (movieCon.movieDetails == null) {
      Get.back();
    }
    movie = movieCon.movieDetails!;
  }

  @override
  Widget build(BuildContext context) {
    textColor = Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black;
    subtitleColor = Theme.of(context).textTheme.bodyMedium?.color ?? Colors.grey;

    return Obx(() {
      if (movieCon.isMovieDetailsLoading.isTrue) {
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      }

      if (movieCon.movieDetails == null) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Icon and error message
                  const Icon(
                    Icons.error_outline,
                    size: 120,
                    color: Color(0XFFCBA84A),
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    'Oops! Something went wrong.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    'We couldn\'t fetch the movie details. Please try again later.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Retry button
                  TextButton(
                    onPressed: initialize,
                    style: TextButton.styleFrom(
                      backgroundColor: const Color(0XFFCBA84A),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ).copyWith(
                      overlayColor: WidgetStateProperty.all(Colors.transparent),
                    ),
                    child: Obx(() => movieCon.isMovieDetailsLoading.isTrue
                        ? const SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2.5,
                            ),
                          )
                        : const Text(
                            "Retry",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          )),
                  )
                ],
              ),
            ),
          ),
        );
      }

      return Scaffold(
        appBar: AppBar(
          title: Text(movie.title ?? ''),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 280,
              child: CustomWebView(
                initialUrl: "${AppConstants.movieEmbedUrl}/${movie.imdbId}",
                showAppBar: false,
                errorImageUrl: "${AppConstants.imageUrl}${movie.backdropPath}",
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        movie.title ?? '',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      if (movie.tagline != null)
                        Text(
                          movie.tagline ?? '',
                          style: TextStyle(
                            fontSize: 16,
                            fontStyle: FontStyle.italic,
                            color: subtitleColor,
                          ),
                        ),
                      const SizedBox(height: 16),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (movie.posterPath != null)
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: CustomImageNetworkWidget(
                                imagePath: '${AppConstants.imageUrl}/${movie.posterPath}',
                                height: 100,
                                width: 70,
                              ),
                            ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Release Date: ${movie.releaseDate ?? 'N/A'}",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: textColor,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  "Rating: ${movie.voteAverage ?? 'N/A'}",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: textColor,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  "Runtime: ${movie.runtime} minutes",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: textColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        "Genres:",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      if (movie.genres != null && movie.genres!.isNotEmpty)
                        Wrap(
                          spacing: 8.0,
                          runSpacing: 4.0,
                          children: List<Chip>.generate(
                            movie.genres!.length,
                            (index) => Chip(
                              label: Text(movie.genres![index].name ?? 'Unknown'),
                            ),
                          ),
                        ),
                      const SizedBox(height: 16),
                      const Text(
                        "Overview:",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        movie.overview ?? 'No description available.',
                        style: TextStyle(
                          fontSize: 14,
                          color: subtitleColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
