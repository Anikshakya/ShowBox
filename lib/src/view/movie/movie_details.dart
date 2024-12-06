import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:showbox/src/app_config/styles.dart';
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
  // MovieController instance to manage the movie data
  final MovieController movieCon = Get.put(MovieController());

  late Color textColor;
  late Color subtitleColor;
  dynamic movie;

  @override
  void initState() {
    super.initState();
    initialize();
  }

  // Initialize the movie details by calling the API
  Future<void> initialize() async {
    await movieCon.getMovieDetails(id: widget.movieId);
    if (movieCon.movieDetails == null) {
      Get.back(); // If no movie details, go back
    } else {
      movie = movieCon.movieDetails!; // Store the fetched movie data
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get colors for text and subtitle based on the app theme
    textColor = Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black;
    subtitleColor = Theme.of(context).textTheme.bodyMedium?.color ?? Colors.grey;

    return Obx(() {
      // Show loading indicator if movie details are still being fetched
      if (movieCon.isMovieDetailsLoading.isTrue) {
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      }

      // Show error page if movie details are null
      if (movieCon.movieDetails == null) {
        return _buildErrorPage();
      }

      // Return movie details page if data is available
      return Scaffold(
        appBar: AppBar(
          title: Text(movie.title ?? 'Movie Details'),
        ),
        body: Column( 
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildMovieWebView(),
            Expanded(child: _buildMovieDetails())
          ],
        ),
      );
    });
  }

  // Build the error page when something goes wrong
  Widget _buildErrorPage() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 120,
              color: AppStyles.goldenColor,
            ),
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
              onPressed: initialize, // Retry fetching the movie details
              style: TextButton.styleFrom(
                backgroundColor:AppStyles.goldenColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              ).copyWith(overlayColor: WidgetStateProperty.all(Colors.transparent)),
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
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    )),
            )
          ],
        ),
      ),
    );
  }

  // Build the WebView to display the movie's embed URL
  Widget _buildMovieWebView() {
    return SizedBox(
      height: 280,
      child: CustomWebView(
        initialUrl: "${AppConstants.movieEmbedUrl}/${movie.imdbId}",
        showAppBar: false,
        errorImageUrl: "${AppConstants.imageUrl}${movie.backdropPath}",
      ),
    );
  }

  // Build the section displaying the movie details
  Widget _buildMovieDetails() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildMovieTitle(),
            const SizedBox(height: 8),
            if (movie.tagline != null) _buildMovieTagline(),
            const SizedBox(height: 16),
            _buildMovieInfoRow(),
            const SizedBox(height: 16),
            _buildGenres(),
            const SizedBox(height: 16),
            _buildOverview(),
          ],
        ),
      ),
    );
  }

  // Build the movie title
  Widget _buildMovieTitle() {
    return Text(
      movie.title ?? '',
      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
    );
  }

  // Build the movie tagline
  Widget _buildMovieTagline() {
    return Text(
      movie.tagline ?? '',
      style: TextStyle(
        fontSize: 16,
        fontStyle: FontStyle.italic,
        color: subtitleColor,
      ),
    );
  }

  // Build the row showing movie info (release date, rating, runtime)
  Widget _buildMovieInfoRow() {
    return Row(
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
              Text("Release Date: ${movie.releaseDate ?? 'N/A'}", style: TextStyle(fontSize: 14, color: textColor)),
              const SizedBox(height: 8),
              Text("Rating: ${movie.voteAverage ?? 'N/A'}", style: TextStyle(fontSize: 14, color: textColor)),
              const SizedBox(height: 8),
              Text("Runtime: ${movie.runtime} minutes", style: TextStyle(fontSize: 14, color: textColor)),
            ],
          ),
        ),
      ],
    );
  }

  // Build the genres section with chips
  Widget _buildGenres() {
    return const Text(
      "Genres:",
      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    );
  }

  // Build the movie overview
  Widget _buildOverview() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Overview:",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          movie.overview ?? 'No description available.',
          style: TextStyle(fontSize: 14, color: subtitleColor),
        ),
      ],
    );
  }
}
