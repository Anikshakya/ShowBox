import 'dart:convert';

import 'package:showbox/src/constant/constants.dart';

MovieDetails movieDetailsFromJson(String str) => MovieDetails.fromJson(json.decode(str));

String movieDetailsToJson(MovieDetails data) => json.encode(data.toJson());

class MovieDetails {
  bool? adult;
  String? backdropPath;
  dynamic belongsToCollection;
  int? budget;
  List<Genre>? genres;
  String? homepage;
  int? id;
  String? imdbId;
  List<String>? originCountry;
  String? originalLanguage;
  String? originalTitle;
  String? overview;
  double? popularity;
  String? posterPath;
  List<ProductionCompany>? productionCompanies;
  List<ProductionCountry>? productionCountries;
  String? releaseDate;
  int? revenue;
  int? runtime;
  List<SpokenLanguage>? spokenLanguages;
  String? status;
  String? tagline;
  String? title;
  bool? video;
  double? voteAverage;
  int? voteCount;

  MovieDetails({
    this.adult,
    this.backdropPath,
    this.belongsToCollection,
    this.budget,
    this.genres,
    this.homepage,
    this.id,
    this.imdbId,
    this.originCountry,
    this.originalLanguage,
    this.originalTitle,
    this.overview,
    this.popularity,
    this.posterPath,
    this.productionCompanies,
    this.productionCountries,
    this.releaseDate,
    this.revenue,
    this.runtime,
    this.spokenLanguages,
    this.status,
    this.tagline,
    this.title,
    this.video,
    this.voteAverage,
    this.voteCount,
  });

  factory MovieDetails.fromJson(Map<String, dynamic> json) => MovieDetails(
        adult: json["adult"] ?? false,
        backdropPath: "${AppConstants.imageUrl}${json["backdrop_path"]}",
        belongsToCollection: json["belongs_to_collection"],
        budget: json["budget"] ?? 0,
        genres: json["genres"] != null
            ? List<Genre>.from(json["genres"].map((x) => Genre.fromJson(x)))
            : [],
        homepage: json["homepage"] ?? "",
        id: json["id"] ?? 0,
        imdbId: json["imdb_id"] ?? "",
        originCountry: json["origin_country"] != null
            ? List<String>.from(json["origin_country"].map((x) => x))
            : [],
        originalLanguage: json["original_language"] ?? "",
        originalTitle: json["original_title"] ?? "",
        overview: json["overview"] ?? "No overview available.",
        popularity: (json["popularity"] ?? 0).toDouble(),
        posterPath: "${AppConstants.imageUrl}${json["poster_path"]}",
        productionCompanies: json["production_companies"] != null
            ? List<ProductionCompany>.from(json["production_companies"]
                .map((x) => ProductionCompany.fromJson(x)))
            : [],
        productionCountries: json["production_countries"] != null
            ? List<ProductionCountry>.from(json["production_countries"]
                .map((x) => ProductionCountry.fromJson(x)))
            : [],
        releaseDate: json["release_date"] ?? "",
        revenue: json["revenue"] ?? 0,
        runtime: json["runtime"] ?? 0,
        spokenLanguages: json["spoken_languages"] != null
            ? List<SpokenLanguage>.from(json["spoken_languages"]
                .map((x) => SpokenLanguage.fromJson(x)))
            : [],
        status: json["status"] ?? "Unknown",
        tagline: json["tagline"] ?? "",
        title: json["title"] ?? "Untitled",
        video: json["video"] ?? false,
        voteAverage: (json["vote_average"] ?? 0).toDouble(),
        voteCount: json["vote_count"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "adult": adult ?? false,
        "backdrop_path": backdropPath ?? "",
        "belongs_to_collection": belongsToCollection,
        "budget": budget ?? 0,
        "genres": genres != null
            ? List<dynamic>.from(genres!.map((x) => x.toJson()))
            : [],
        "homepage": homepage ?? "",
        "id": id ?? 0,
        "imdb_id": imdbId ?? "",
        "origin_country": originCountry != null
            ? List<dynamic>.from(originCountry!.map((x) => x))
            : [],
        "original_language": originalLanguage ?? "",
        "original_title": originalTitle ?? "",
        "overview": overview ?? "No overview available.",
        "popularity": popularity ?? 0.0,
        "poster_path": posterPath ?? "",
        "production_companies": productionCompanies != null
            ? List<dynamic>.from(productionCompanies!.map((x) => x.toJson()))
            : [],
        "production_countries": productionCountries != null
            ? List<dynamic>.from(productionCountries!.map((x) => x.toJson()))
            : [],
        "release_date": releaseDate ?? "",
        "revenue": revenue ?? 0,
        "runtime": runtime ?? 0,
        "spoken_languages": spokenLanguages != null
            ? List<dynamic>.from(spokenLanguages!.map((x) => x.toJson()))
            : [],
        "status": status ?? "Unknown",
        "tagline": tagline ?? "",
        "title": title ?? "Untitled",
        "video": video ?? false,
        "vote_average": voteAverage ?? 0.0,
        "vote_count": voteCount ?? 0,
      };
}

class Genre {
  int? id;
  String? name;

  Genre({
    this.id,
    this.name,
  });

  factory Genre.fromJson(Map<String, dynamic> json) => Genre(
        id: json["id"] ?? 0,
        name: json["name"] ?? "Unknown",
      );

  Map<String, dynamic> toJson() => {
        "id": id ?? 0,
        "name": name ?? "Unknown",
      };
}

class SpokenLanguage {
  String? iso6391;
  String? name;

  SpokenLanguage({
    this.iso6391,
    this.name,
  });

  factory SpokenLanguage.fromJson(Map<String, dynamic> json) => SpokenLanguage(
        iso6391: json["iso_639_1"] ?? "",
        name: json["name"] ?? "Unknown",
      );

  Map<String, dynamic> toJson() => {
        "iso_639_1": iso6391 ?? "",
        "name": name ?? "Unknown",
      };
}

class ProductionCompany {
  int? id;
  String? logoPath;
  String? name;
  String? originCountry;

  ProductionCompany({
    this.id,
    this.logoPath,
    this.name,
    this.originCountry,
  });

  factory ProductionCompany.fromJson(Map<String, dynamic> json) => ProductionCompany(
        id: json["id"] ?? 0,
        logoPath: json["logo_path"] ?? "",
        name: json["name"] ?? "Unknown",
        originCountry: json["origin_country"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "id": id ?? 0,
        "logo_path": logoPath ?? "",
        "name": name ?? "Unknown",
        "origin_country": originCountry ?? "",
      };
}

class ProductionCountry {
  String? iso31661;
  String? name;

  ProductionCountry({
    this.iso31661,
    this.name,
  });

  factory ProductionCountry.fromJson(Map<String, dynamic> json) => ProductionCountry(
        iso31661: json["iso_3166_1"] ?? "",
        name: json["name"] ?? "Unknown",
      );

  Map<String, dynamic> toJson() => {
        "iso_3166_1": iso31661 ?? "",
        "name": name ?? "Unknown",
      };
}



