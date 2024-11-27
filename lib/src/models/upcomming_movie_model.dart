// upcoming_movies_model.dart
class UpcomingMoviesModel {
  final String title;
  final String? posterPath;
  final String? releaseDate;
  final double voteAverage;

  UpcomingMoviesModel({
    required this.title,
    this.posterPath,
    this.releaseDate,
    required this.voteAverage,
  });

  factory UpcomingMoviesModel.fromJson(Map<String, dynamic> json) {
    return UpcomingMoviesModel(
      title: json['title'],
      posterPath: json['poster_path'],
      releaseDate: json['release_date'],
      voteAverage: json['vote_average']?.toDouble() ?? 0.0,
    );
  }
}
