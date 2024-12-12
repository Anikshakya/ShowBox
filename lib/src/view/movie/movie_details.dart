import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:showbox/src/app_config/styles.dart';
import 'package:showbox/src/constant/constants.dart';
import 'package:showbox/src/controller/movies_controller.dart';
import 'package:showbox/src/widgets/custom_fades.dart';
import 'package:showbox/src/widgets/custom_image_widget.dart';
import 'package:showbox/src/widgets/custom_webview.dart';

/// Page to display detailed information about a selected movie
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
  bool isWatchClicked = false;

  @override
  void initState() {
    super.initState();
    initialize();
  }

  /// Fetch movie details when the page is loaded
  Future<void> initialize() async {
    await movieCon.getMovieDetails(id: widget.movieId);
    if (movieCon.movieDetails == null) {
      Get.back();
    } else {
      movie = movieCon.movieDetails!;
    }
  }

  @override
  Widget build(BuildContext context) {
    textColor = Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black;
    subtitleColor = Theme.of(context).textTheme.bodyMedium?.color ?? Colors.grey;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return PopScope(
      canPop: Platform.isAndroid ? !isWatchClicked : true,
      onPopInvokedWithResult: (_, __) {
        setState(() {
          isWatchClicked = false;
        });
      },
      child: Obx(() {
        if (movieCon.isMovieDetailsLoading.isTrue) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (movieCon.movieDetails == null) {
          return _buildErrorPage();
        }

        return Scaffold(
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  if (isWatchClicked)
                    FadeIn(child: _buildMovieWebView()),

                  if (!isWatchClicked) _buildMovieBanner(isDark),
                ],
              ),
              Expanded(child: FadeInUp(child: _buildMovieDetails(isDark))),
            ],
          ),
        );
      }),
    );
  }

  /// Error page when movie details are unavailable
  Widget _buildErrorPage() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 120, color: AppStyles.goldenColor),
            const SizedBox(height: 30),
            const Text(
              'Oops! Something went wrong.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            const Text(
              'We couldn\'t fetch the movie details. Please try again later.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 30),
            TextButton(
              onPressed: initialize,
              style: TextButton.styleFrom(
                backgroundColor: AppStyles.goldenColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
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
                  : const Text("Retry", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
            ),
          ],
        ),
      ),
    );
  }

  /// WebView for movie playback
  Widget _buildMovieWebView() {
    return SizedBox(
      height: 300,
      child: CustomWebView(
        initialUrl: "${AppConstants.movieEmbedUrl}/${movie.imdbId}",
        showAppBar: false,
        errorImageUrl: "${AppConstants.imageUrl}${movie.backdropPath}",
      ),
    );
  }

  /// Movie banner widget
  Widget _buildMovieBanner(bool isDark) {
    return Stack(
      children: [
        SizedBox(
          height: 400,
          child: CustomImageNetworkWidget(
            imagePath: "${AppConstants.imageUrl}${movie.backdropPath}",
          ),
        ),
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.center,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  isDark ? Colors.black : Colors.white,
                ],
              ),
            ),
          ),
        ),
        Positioned.fill(
          child: FadeInUp(
            from: 80,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Spacer(),
                  Text(
                    movie.title ?? "",
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.white.withOpacity(0.8),
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  const SizedBox(height: 4),
                  _buildActionButtons(isDark),
                  const SizedBox(height: 14),
                  Text(
                    "${movie.releaseDate.split("-")[0]} • ${movie.runtime} min • ${movie.voteAverage.toStringAsFixed(1)} • ${movie.originalLanguage.toUpperCase()}",
                    style: TextStyle(
                      color: Theme.of(context).primaryColor.withOpacity(0.8),
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    movie.productionCompanies
                        .map((company) => company.name) // Map the list to extract names
                        .join(', '), // Join names with a comma separator
                    style: TextStyle(
                      color: Theme.of(context).primaryColor.withOpacity(0.6),
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        // Back Button
        Positioned(
          top: 45,
          left: 10,
          child: FadeIn(
            child: Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.5),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back),
                padding: EdgeInsets.zero
              ),
            ),
          )
        )
      ],
    );
  }

  /// Action buttons for play and watch later
  Widget _buildActionButtons(isDark) {
    return Row(
      children: [
        Visibility(
          visible: isWatchClicked != true,
          child: GestureDetector(
            onTap: () {
              setState(() {
                isWatchClicked = true;
              });
            },
            child: Container(
              height: 32,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: const Color(0x00ecc877).withOpacity(.9),
                borderRadius: BorderRadius.circular(2),
              ),
              child: const Row(
                children: [
                  Icon(Icons.play_arrow),
                  SizedBox(width: 6),
                  Text("PLAY", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400)),
                ],
              ),
            ),
          ),
        ),
        if(isWatchClicked != true)
          const SizedBox(width: 10),
        GestureDetector(
          onTap: () {}, // Implement Watch Later logic
          child: Container(
            height: 36,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(isDark ? .3: .5),
              borderRadius: BorderRadius.circular(2),
            ),
            child: const Row(
              children: [
                Icon(Icons.add, color: Colors.white),
                SizedBox(width: 6),
                Text("Watch Later", style: TextStyle(fontSize: 14, color: Colors.white)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// Movie details section
  Widget _buildMovieDetails(isDark) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Upper Section
            if (isWatchClicked)
              Column(
                children: [
                  Positioned.fill(
                    child: FadeInUp(
                      from: -40,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            movie.title ?? "",
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          const SizedBox(height: 4),
                          _buildActionButtons(isDark),
                          const SizedBox(height: 8),
                          Text(
                            "${movie.releaseDate.split("-")[0]} • ${movie.runtime} min • ${movie.voteAverage.toStringAsFixed(1)} • ${movie.originalLanguage.toUpperCase()}",
                            style: TextStyle(
                              color: Theme.of(context).primaryColor.withOpacity(0.5),
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            if (isWatchClicked)
              const SizedBox(height: 8),
            // Tag Line
            if (movie.tagline != null)
              Text(movie.tagline ?? '', style: TextStyle(fontSize: 15, fontStyle: FontStyle.italic, color: subtitleColor)),
            const SizedBox(height: 10),
            _buildMovieInfoRow(),
            const SizedBox(height: 10),
            _buildOverview(),
            const SizedBox(height: 10),
            _buildGenres(),
            const SizedBox(height: 25),
            // _buildMovieInfoRow()
          ],
        ),
      ),
    );
  }

  // Build the row showing movie info (release date, rating, runtime)
  Widget _buildMovieInfoRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (movie.posterPath != null)
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: CustomImageNetworkWidget(
              imagePath: '${AppConstants.imageUrl}/${movie.posterPath}',
              height: 150,
              width: 110,
            ),
          ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Release Date: ${movie.releaseDate ?? 'N/A'}", style: TextStyle(fontSize: 14, color: textColor)),
            const SizedBox(height: 8),
            Text("Rating: ${movie.voteAverage ?? 'N/A'}", style: TextStyle(fontSize: 14, color: textColor)),
            const SizedBox(height: 8),
            Text("Runtime: ${movie.runtime} minutes", style: TextStyle(fontSize: 14, color: textColor)),
            const SizedBox(height: 8),
            Text("Language: ${movie.originalLanguage.toString().toUpperCase()}", style: TextStyle(fontSize: 14, color: textColor)),
            const SizedBox(height: 8),
            Text("Status: ${movie.status ?? "N/A"}", style: TextStyle(fontSize: 14, color: textColor)),
          ],
        ),
      ],
    );
  }

  /// Display genres of the movie
  Widget _buildGenres() {
    return Wrap(
      spacing: 8.0,
      runSpacing: 4.0,
      children: movie.genres
          .map<Widget>(
            (genre) => Chip(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              label: Text(genre.name),
              side: const BorderSide(
                width: 0,
                color: Colors.transparent
              ),
              backgroundColor: Theme.of(context).primaryColor.withOpacity(0.2),
            ),
          )
          .toList(),
    );
  }

  /// Display movie overview
  Widget _buildOverview() {
    return Text(
      movie.overview ?? 'No description available.',
      style: TextStyle(fontSize: 14, color: textColor.withOpacity(0.8)),
    );
  }
}
