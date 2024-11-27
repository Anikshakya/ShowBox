class TopRatedSeriesModel {
  final int id;
  final String name;
  final String overview;
  final String posterPath;
  final String firstAirDate;
  final double voteAverage;
  final int voteCount;
  final String backdropPath;

  TopRatedSeriesModel({
    required this.id,
    required this.name,
    required this.overview,
    required this.posterPath,
    required this.firstAirDate,
    required this.voteAverage,
    required this.voteCount,
    required this.backdropPath,
  });

  // Convert a JSON map into a TVSeries object
  factory TopRatedSeriesModel.fromJson(Map<String, dynamic> json) {
    return TopRatedSeriesModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? 'N/A',
      overview: json['overview'] ?? '',
      posterPath: json['poster_path'] ?? '',
      firstAirDate: json['first_air_date'] ?? '',
      voteAverage: json['vote_average']?.toDouble() ?? 0.0,
      voteCount: json['vote_count'] ?? 0,
      backdropPath: json['backdrop_path'] ?? '',
    );
  }

  // Convert TVSeries object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'overview': overview,
      'poster_path': posterPath,
      'first_air_date': firstAirDate,
      'vote_average': voteAverage,
      'vote_count': voteCount,
      'backdrop_path': backdropPath,
    };
  }
}
