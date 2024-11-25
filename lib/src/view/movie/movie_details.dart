import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:showbox/src/controller/movies_controller.dart';

class MovieDetailsPage extends StatelessWidget {
  final int movieId;

  const MovieDetailsPage({super.key, required this.movieId});

  @override
  Widget build(BuildContext context) {
    final MovieController controller = Get.put(MovieController());

    // Fetch movie details
    controller.getMovieDetails(id: movieId);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Movie Details'),
        backgroundColor: Colors.black,
      ),
      body: Obx(() {
        if (controller.isMovieDetailsLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final movie = controller.movieDetails;

        if (movie.isEmpty) {
          return const Center(
            child: Text(
              'Failed to load movie details.',
              style: TextStyle(fontSize: 18, color: Colors.red),
            ),
          );
        }

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Backdrop Image
              Stack(
                children: [
                  Image.network(
                    movie["backdrop_url"] ?? '',
                    fit: BoxFit.cover,
                    height: 200,
                    width: double.infinity,
                    errorBuilder: (context, error, stackTrace) =>
                        const Center(child: Text('Image not available')),
                  ),
                  Positioned(
                    bottom: 10,
                    left: 10,
                    child: Text(
                      movie["title"] ?? '',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(
                            offset: Offset(2, 2),
                            blurRadius: 3,
                            color: Colors.black,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Tagline
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  movie["tagline"] ?? '',
                  style: const TextStyle(
                    fontSize: 16,
                    fontStyle: FontStyle.italic,
                    color: Colors.grey,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Overview
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  movie["overview"] ?? '',
                  style: const TextStyle(fontSize: 14),
                ),
              ),

              const SizedBox(height: 16),

              // Genres
              if (movie["genres"] != null)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Wrap(
                    spacing: 8.0,
                    runSpacing: 4.0,
                    children: List<Chip>.generate(
                      movie["genres"].length,
                      (index) => Chip(
                        label: Text(movie["genres"][index]),
                      ),
                    ),
                  ),
                ),

              const SizedBox(height: 16),

              // Release Date and Runtime
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Release Date: ${movie["release_date"] ?? ''}'),
                    Text('Runtime: ${movie["runtime"] ?? ''} mins'),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Budget and Revenue
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Budget: \$${movie["budget"]}'),
                    Text('Revenue: \$${movie["revenue"]}'),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Production Companies
              if (movie["production_companies"] != null)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Production Companies:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      ...movie["production_companies"].map<Widget>((company) {
                        return Text('- $company');
                      }).toList(),
                    ],
                  ),
                ),

              const SizedBox(height: 16),

              // Homepage Link
              if (movie["homepage"] != null)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: InkWell(
                    onTap: () {
                      // Open the movie's homepage
                      Get.toNamed(movie["homepage"]);
                    },
                    child: const Text(
                      'Visit Homepage',
                      style: TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),

              const SizedBox(height: 16),

              // Vote Average and Count
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Rating: ${movie["vote_average"] ?? ''}/10'),
                    Text('${movie["vote_count"] ?? ''} Votes'),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
