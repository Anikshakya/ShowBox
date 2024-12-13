import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:showbox/src/app_config/styles.dart';
import 'package:showbox/src/constant/constants.dart';
import 'package:showbox/src/controller/series_controller.dart';
import 'package:showbox/src/widgets/custom_fades.dart';
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
  late Color textColor;
  late Color subtitleColor;
  bool isWatchClicked = false;

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
    textColor = Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black;
    subtitleColor = Theme.of(context).textTheme.bodyMedium?.color ?? Colors.grey;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
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
                    'We couldn\'t fetch the seriesCon.seriesDetail details. Please try again later.',
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

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Backdrop Image
            if (seriesCon.seriesDetail.backdropPath != null)
              (selectedSeason == null && selectedEpisode == null) || seasonPoster == null
                  ? _buildSeriesBanner(isDark, context)
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
            const SizedBox(height: 18),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Upper Banner Section
                      if (isWatchClicked)
                        FadeInUp(
                          from: -40,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                seriesCon.seriesDetail.name  ?? "",
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
                                "${seriesCon.seriesDetail.firstAirDate .split("-")[0]} • ${seriesCon.seriesDetail.voteAverage.toStringAsFixed(1)} • ${seriesCon.seriesDetail.originalLanguage.toUpperCase()}",
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor.withOpacity(0.8),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                seriesCon.seriesDetail.productionCompanies
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
                      if (isWatchClicked)
                        const SizedBox(height: 8),
                      // Seasons Selection
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
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
                                        isWatchClicked = true;
                                        seasonPoster = season.posterPath;
                                        selectedSeason = season.seasonNumber;
                                        selectedEpisode = null;
                                        setState(() {
                                          selectedEpisode = seriesCon.episodeList[0]["episode_number"];
                                        });
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
                          const SizedBox(height: 16),
                        ],
                      ),
                      // Episode List
                      Visibility(
                        visible: seriesCon.episodeList.isNotEmpty,
                        child: FadeInUp(
                          from: -40,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Episodes Selection (only show if a season is selected)
                              const Text(
                                "Episodes:",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 8),
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
                            ],
                          ),
                        ),
                      ),
                      // Tagline (if available)
                      if (seriesCon.seriesDetail.tagline != null &&
                          seriesCon.seriesDetail.tagline.isNotEmpty)
                        Text(seriesCon.seriesDetail.tagline ?? '', style: const TextStyle(fontSize: 15, fontStyle: FontStyle.italic)),
                      const SizedBox(height: 16),
                      // Poster and Series Info
                      _builsSeriesInfo(),
                      const SizedBox(height: 16),
                      // OverView
                      _buildOverview(),
                      const SizedBox(height: 16),
                      // Genres
                      _buildGenres(),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ),
            )
          ],
        );
      })
    );
  }

  _buildSeriesBanner(bool isDark, BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          height: 400,
          child: CustomImageNetworkWidget(
            imagePath: "${AppConstants.imageUrl}${seriesCon.seriesDetail.backdropPath}",
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
                    seriesCon.seriesDetail.name  ?? "",
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
                    "${seriesCon.seriesDetail.firstAirDate .split("-")[0]} • ${seriesCon.seriesDetail.voteAverage.toStringAsFixed(1)} • ${seriesCon.seriesDetail.originalLanguage.toUpperCase()}",
                    style: TextStyle(
                      color: Theme.of(context).primaryColor.withOpacity(0.8),
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    seriesCon.seriesDetail.productionCompanies
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

  _builsSeriesInfo() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (seriesCon.seriesDetail.posterPath != null)
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: CustomImageNetworkWidget(
              imagePath: '${AppConstants.imageUrl}/${seriesCon.seriesDetail.posterPath}',
              height: 150,
              width: 110,
            ),
          ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("First Aired Date: ${seriesCon.seriesDetail.firstAirDate ?? 'N/A'}", style: TextStyle(fontSize: 14, color: textColor)),
            const SizedBox(height: 8),
            Text("Rating: ${seriesCon.seriesDetail.voteAverage ?? 'N/A'}", style: TextStyle(fontSize: 14, color: textColor)),
            const SizedBox(height: 8),
            Text("Seasons: ${seriesCon.seriesDetail.numberOfSeasons}", style: TextStyle(fontSize: 14, color: textColor)),
            const SizedBox(height: 8),
            Text("Language: ${seriesCon.seriesDetail.originalLanguage.toString().toUpperCase()}", style: TextStyle(fontSize: 14, color: textColor)),
            const SizedBox(height: 8),
            Text("Status: ${seriesCon.seriesDetail.status ?? "N/A"}", style: TextStyle(fontSize: 14, color: textColor)),
          ],
        ),
      ],
    );
  }

  /// Action buttons for play and watch later
  Widget _buildActionButtons(isDark) {
    return Row(
      children: [
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

  /// Display genres of the movie
  Widget _buildGenres() {
    return Wrap(
      spacing: 8.0,
      runSpacing: 4.0,
      children: seriesCon.seriesDetail.genres
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

  /// Display Series overview
  Widget _buildOverview() {
    return Text(
      seriesCon.seriesDetail.overview ?? 'No description available.',
      style: TextStyle(fontSize: 14, color: textColor.withOpacity(0.8)),
    );
  }
}