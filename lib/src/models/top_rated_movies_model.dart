class TopRatedMoviesModel {
  final int id;
  final String title;
  final String overview;
  final String posterPath;
  final String releaseDate;
  final double voteAverage;
  final int voteCount;
  final String backdropPath;

  TopRatedMoviesModel({
    required this.id,
    required this.title,
    required this.overview,
    required this.posterPath,
    required this.releaseDate,
    required this.voteAverage,
    required this.voteCount,
    required this.backdropPath,
  });

  // Convert a JSON map into a Movie object
  factory TopRatedMoviesModel.fromJson(Map<String, dynamic> json) {
    return TopRatedMoviesModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? 'N/A',
      overview: json['overview'] ?? '',
      posterPath: json['poster_path'] ?? '',
      releaseDate: json['release_date'] ?? '',
      voteAverage: json['vote_average']?.toDouble() ?? 0.0,
      voteCount: json['vote_count'] ?? 0,
      backdropPath: json['backdrop_path'] ?? '',
    );
  }

  // Convert Movie object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'overview': overview,
      'poster_path': posterPath,
      'release_date': releaseDate,
      'vote_average': voteAverage,
      'vote_count': voteCount,
      'backdrop_path': backdropPath,
    };
  }
}
