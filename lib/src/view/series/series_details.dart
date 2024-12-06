import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:showbox/src/app_config/styles.dart';
import 'package:showbox/src/constant/constants.dart';
import 'package:showbox/src/controller/series_controller.dart';
import 'package:showbox/src/widgets/custom_image_widget.dart';
import 'package:showbox/src/widgets/custom_webview.dart';

class SeriesDetailPage extends StatefulWidget {
  final int? id;
  const SeriesDetailPage({super.key, this.id});

  @override
  State<SeriesDetailPage> createState() => _SeriesDetailPageState();
}

class _SeriesDetailPageState extends State<SeriesDetailPage> {
  final SeriesController seriesCon = Get.put(SeriesController());
  int? selectedSeason;
  int? selectedEpisode;
  String? seasonPoster;

  @override
  void initState() {
    super.initState();
    initialise();
  }

  initialise() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await seriesCon.getSeriesDetail(widget.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Obx(() {
        if(seriesCon.isDetailLoading.isTrue){                     
          return const Center(
            child: CircularProgressIndicator(),
          );
        }                                                                                                                                        

        if (seriesCon.seriesDetail == null) {
          return Center(
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
                    color: AppStyles.goldenColor,
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
                    onPressed: initialise,
                    style: TextButton.styleFrom(
                      backgroundColor: AppStyles.goldenColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ).copyWith(
                      overlayColor: WidgetStateProperty.all(Colors.transparent),
                    ),
                    child: Obx(() => seriesCon.isDetailLoading.isTrue
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
          );
        }

        return Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Backdrop Image
                if (seriesCon.seriesDetail.backdropPath != null)
                  (selectedSeason == null && selectedEpisode == null) || seasonPoster == null
                      ? CustomImageNetworkWidget(
                          imagePath: "${AppConstants.imageUrl}${seriesCon.seriesDetail.backdropPath}",
                          height: 300,
                          width: double.infinity,
                        )
                      : selectedSeason != null && selectedEpisode == null
                          ? CustomImageNetworkWidget(                        
                              imagePath: "${AppConstants.imageUrl}/$seasonPoster",
                              height: 300, 
                              width: double.infinity,
                            )  
                          : SizedBox(
                              height: 300,
                              child: CustomWebView(
                                initialUrl: "${AppConstants.showEmbedUrl}?tmdb=${seriesCon.seriesDetail.id}&season=$selectedSeason&episode=$selectedEpisode",
                                showAppBar: false,
                                errorImageUrl: "${AppConstants.imageUrl}${seriesCon.seriesDetail.backdropPath}",
                              ),
                            ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Series Title
                          Text(
                            seriesCon.seriesDetail.name,
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                          const SizedBox(height: 8),
                          // Tagline (if available)
                          if (seriesCon.seriesDetail.tagline != null &&
                              seriesCon.seriesDetail.tagline.isNotEmpty)
                            Text(
                              seriesCon.seriesDetail.tagline!,
                              style: Theme.of(context).textTheme.labelSmall,
                            ),
                          const SizedBox(height: 16),
                          // Poster and Series Info
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Poster Image
                              if (seriesCon.seriesDetail.posterPath != null)
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: CustomImageNetworkWidget(
                                    imagePath: 'https://image.tmdb.org/t/p/w500${seriesCon.seriesDetail.posterPath}',
                                    height: 150,
                                    width: 100,
                                  ),
                                ),
                              const SizedBox(width: 16),
                              // Other Series Details
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "First Air Date: ${seriesCon.seriesDetail.firstAirDate ?? 'N/A'}",
                                      style: Theme.of(context).textTheme.bodyMedium,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      "Seasons: ${seriesCon.seriesDetail.numberOfSeasons}",
                                      style: Theme.of(context).textTheme.bodyMedium,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      "Episodes: ${seriesCon.seriesDetail.numberOfEpisodes}",
                                      style: Theme.of(context).textTheme.bodyMedium,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      "Rating: ${seriesCon.seriesDetail.voteAverage.toStringAsFixed(1)}",
                                      style: Theme.of(context).textTheme.bodyMedium,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          // Genres
                          const Text(
                            "Genres:",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8.0,
                            children: List<Chip>.generate(
                              seriesCon.seriesDetail.genres.length,
                              (index) => Chip(
                                label: Text(
                                  seriesCon.seriesDetail.genres[index].name ?? 'Unknown',
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          // Seasons Selection
                          const Text(
                            "Seasons:",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          // Seasons Horizontal Scroll List
                          SizedBox(
                            height: 60,
                            child: ListView.builder(
                                itemCount: seriesCon.seriesDetail.seasons.length,
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  var season = seriesCon.seriesDetail.seasons[index];
                                  return GestureDetector(
                                    onTap: () async {
                                      await seriesCon.getEpisodeList(seriesCon.seriesDetail.id, season.seasonNumber);
                                      setState(() {
                                        seasonPoster = season.posterPath;
                                        selectedSeason = season.seasonNumber;
                                        selectedEpisode = null; // Reset episode selection
                                      });
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(right: 8.0),
                                      child: Chip(
                                        label: Text(
                                          'Season ${season.seasonNumber}',
                                          style: TextStyle(
                                              color: selectedSeason == season.seasonNumber
                                                  ? AppStyles.goldenColor
                                                  : null),
                                        ),
                                        backgroundColor: selectedSeason == season.seasonNumber
                                            ? Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black
                                            : null,
                                      ),
                                    ),
                                  );
                                }),
                          ),
                          const SizedBox(height: 8),
                          // Episodes Selection (only show if a season is selected)
                          if (seriesCon.episodeList.isNotEmpty)
                            const Text(
                              "Episodes:",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          const SizedBox(height: 8),
                          if (seriesCon.episodeList.isNotEmpty)
                            SizedBox(
                              height: 120,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: seriesCon.episodeList.length,
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        selectedEpisode = seriesCon.episodeList[index]["episode_number"];
                                      });
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 7),
                                      child: Column(
                                        children: [
                                          SizedBox(
                                            width: 140,
                                            height: 90,
                                            child: Stack(
                                              children: [
                                                Container(
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                      color: selectedEpisode == seriesCon.episodeList[index]["episode_number"]
                                                          ?AppStyles.goldenColor
                                                          : Theme.of(context).colorScheme.surface,
                                                    ),
                                                    borderRadius: BorderRadius.circular(8),
                                                  ),
                                                  child: ClipRRect(
                                                    borderRadius: BorderRadius.circular(8),
                                                    child: CustomImageNetworkWidget(
                                                      width: 140,
                                                      height: 90,
                                                      imagePath: seriesCon.episodeList[index]["still_path"] == "" ||
                                                              seriesCon.episodeList[index]["still_path"] == null
                                                          ? "${AppConstants.imageUrl}${seriesCon.seriesDetail.backdropPath}"
                                                          : "${AppConstants.imageUrl}${seriesCon.episodeList[index]["still_path"]}",
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                                const Positioned.fill(
                                                  child: Center(
                                                    child: Icon(Icons.play_circle_outline),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          // Overview Section
                          const Text(
                            "Overview:",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            seriesCon.seriesDetail.overview,
                            style: const TextStyle(
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 16),
                          // Additional Information
                          const Divider(color: Colors.grey),
                          const Text(
                            "Additional Info:",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Language: ${seriesCon.seriesDetail.originalLanguage.toUpperCase()}",
                            style: const TextStyle(
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Status: ${seriesCon.seriesDetail.status}",
                            style: const TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ],
        );
      })
    );
  }
}