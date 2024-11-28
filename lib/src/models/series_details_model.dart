// To parse this JSON data, do
//
//     final showDetailModel = showDetailModelFromJson(jsonString);

import 'dart:convert';

SeriesDetailModel showDetailModelFromJson(String str) => SeriesDetailModel.fromJson(json.decode(str));

String showDetailModelToJson(SeriesDetailModel data) => json.encode(data.toJson());

class SeriesDetailModel {   
    bool? adult;
    String? backdropPath;
    List<CreatedBy>? createdBy;
    List<dynamic>? episodeRunTime;
    String? firstAirDate;
    List<Genre>? genres;
    String? homepage;
    int? id;
    bool? inProduction;
    List<String>? languages;
    String? lastAirDate;
    TEpisodeToAir? lastEpisodeToAir;
    String? name;
    TEpisodeToAir? nextEpisodeToAir;
    List<Network>? networks;
    int? numberOfEpisodes;
    int? numberOfSeasons;
    List<String>? originCountry;
    String? originalLanguage;
    String? originalName;
    String? overview;
    double? popularity;
    String? posterPath;
    List<Network>? productionCompanies;
    List<ProductionCountry>? productionCountries;
    List<Season>? seasons;
    List<SpokenLanguage>? spokenLanguages;
    String? status;
    String? tagline;
    String? type;
    double? voteAverage;
    int? voteCount;

    SeriesDetailModel({
        this.adult,
        this.backdropPath,
        this.createdBy,
        this.episodeRunTime,
        this.firstAirDate,
        this.genres,
        this.homepage,
        this.id,
        this.inProduction,
        this.languages,
        this.lastAirDate,
        this.lastEpisodeToAir,
        this.name,
        this.nextEpisodeToAir,
        this.networks,
        this.numberOfEpisodes,
        this.numberOfSeasons,
        this.originCountry,
        this.originalLanguage,
        this.originalName,
        this.overview,
        this.popularity,
        this.posterPath,
        this.productionCompanies,
        this.productionCountries,
        this.seasons,
        this.spokenLanguages,
        this.status,
        this.tagline,
        this.type,
        this.voteAverage,
        this.voteCount,
    });

    factory SeriesDetailModel.fromJson(Map<String, dynamic> json) => SeriesDetailModel(
        adult: json["adult"],
        backdropPath: json["backdrop_path"] ?? '',
        createdBy: List<CreatedBy>.from(json["created_by"].map((x) => CreatedBy.fromJson(x))),
        episodeRunTime: List<dynamic>.from(json["episode_run_time"].map((x) => x)),
        firstAirDate: json["first_air_date"],
        genres: List<Genre>.from(json["genres"].map((x) => Genre.fromJson(x))),
        homepage: json["homepage"],
        id: json["id"],
        inProduction: json["in_production"],
        languages: List<String>.from(json["languages"].map((x) => x)),
        lastAirDate: json["last_air_date"],
        lastEpisodeToAir: TEpisodeToAir.fromJson(json["last_episode_to_air"]),
        name: json["name"],
        nextEpisodeToAir: json["next_episode_to_air"] == null ? TEpisodeToAir() : TEpisodeToAir.fromJson(json["next_episode_to_air"]),
        networks: List<Network>.from(json["networks"].map((x) => Network.fromJson(x))),
        numberOfEpisodes: json["number_of_episodes"],
        numberOfSeasons: json["number_of_seasons"],
        originCountry: List<String>.from(json["origin_country"].map((x) => x)),
        originalLanguage: json["original_language"],
        originalName: json["original_name"],
        overview: json["overview"],
        popularity: json["popularity"]?.toDouble(),
        posterPath: json["poster_path"] ?? '',
        productionCompanies: List<Network>.from(json["production_companies"].map((x) => Network.fromJson(x))),
        productionCountries: List<ProductionCountry>.from(json["production_countries"].map((x) => ProductionCountry.fromJson(x))),
        seasons: List<Season>.from(json["seasons"].map((x) => Season.fromJson(x))),
        spokenLanguages: List<SpokenLanguage>.from(json["spoken_languages"].map((x) => SpokenLanguage.fromJson(x))),
        status: json["status"],
        tagline: json["tagline"],
        type: json["type"],
        voteAverage: json["vote_average"] != null ? json["vote_average"]?.toDouble() : 0.0,
        voteCount: json["vote_count"],
    );

    Map<String, dynamic> toJson() => {
        "adult": adult,
        "backdrop_path": backdropPath ?? '',
        "created_by": List<dynamic>.from(createdBy!.map((x) => x.toJson())),
        "episode_run_time": List<dynamic>.from(episodeRunTime!.map((x) => x)),
        "first_air_date": firstAirDate,
        "genres": List<dynamic>.from(genres!.map((x) => x.toJson())),
        "homepage": homepage,
        "id": id,
        "in_production": inProduction,
        "languages": List<dynamic>.from(languages!.map((x) => x)),
        "last_air_date": lastAirDate,
        "last_episode_to_air": lastEpisodeToAir!.toJson(),
        "name": name,
        "next_episode_to_air": nextEpisodeToAir!.toJson(),
        "networks": List<dynamic>.from(networks!.map((x) => x.toJson())),
        "number_of_episodes": numberOfEpisodes,
        "number_of_seasons": numberOfSeasons,
        "origin_country": List<dynamic>.from(originCountry!.map((x) => x)),
        "original_language": originalLanguage,
        "original_name": originalName,
        "overview": overview,
        "popularity": popularity,
        "poster_path": posterPath,
        "production_companies": List<dynamic>.from(productionCompanies!.map((x) => x.toJson())),
        "production_countries": List<dynamic>.from(productionCountries!.map((x) => x.toJson())),
        "seasons": List<dynamic>.from(seasons!.map((x) => x.toJson())),
        "spoken_languages": List<dynamic>.from(spokenLanguages!.map((x) => x.toJson())),
        "status": status,
        "tagline": tagline,
        "type": type,
        "vote_average": voteAverage,
        "vote_count": voteCount,
    };
}

class CreatedBy {
    int? id;
    String? creditId;
    String? name;
    String? originalName;
    int? gender;
    String? profilePath;

    CreatedBy({
        this.id,
        this.creditId,
        this.name,
        this.originalName,
        this.gender,
        this.profilePath,
    });

    factory CreatedBy.fromJson(Map<String, dynamic> json) => CreatedBy(
        id: json["id"],
        creditId: json["credit_id"],
        name: json["name"],
        originalName: json["original_name"],
        gender: json["gender"],
        profilePath: json["profile_path"] ?? '',
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "credit_id": creditId,
        "name": name,
        "original_name": originalName,
        "gender": gender,
        "profile_path": profilePath,
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
        id: json["id"],
        name: json["name"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
    };
}

class TEpisodeToAir {
    int? id;
    String? name;
    String? overview;
    double? voteAverage;
    int? voteCount;
    String? airDate;
    int? episodeNumber;
    String? episodeType;
    String? productionCode;
    int? runtime;
    int? seasonNumber;
    int? showId;
    String? stillPath;

    TEpisodeToAir({
        this.id,
        this.name,
        this.overview,
        this.voteAverage,
        this.voteCount,
        this.airDate,
        this.episodeNumber,
        this.episodeType,
        this.productionCode,
        this.runtime,
        this.seasonNumber,
        this.showId,
        this.stillPath,
    });

    factory TEpisodeToAir.fromJson(Map<String, dynamic> json) => TEpisodeToAir(
        id: json["id"],
        name: json["name"],
        overview: json["overview"],
        voteAverage: json["vote_average"],
        voteCount: json["vote_count"],
        airDate: json["air_date"],
        episodeNumber: json["episode_number"],
        episodeType: json["episode_type"],
        productionCode: json["production_code"],
        runtime: json["runtime"],
        seasonNumber: json["season_number"],
        showId: json["show_id"],
        stillPath: json["still_path"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "overview": overview,
        "vote_average": voteAverage,
        "vote_count": voteCount,
        "air_date": airDate,
        "episode_number": episodeNumber,
        "episode_type": episodeType,
        "production_code": productionCode,
        "runtime": runtime,
        "season_number": seasonNumber,
        "show_id": showId,
        "still_path": stillPath,
    };
}

class Network {
    int? id;
    String? logoPath;
    String? name;
    String? originCountry;

    Network({
        this.id,
        this.logoPath,
        this.name,
        this.originCountry,
    });

    factory Network.fromJson(Map<String, dynamic> json) => Network(
        id: json["id"],
        logoPath: json["logo_path"] ?? '',
        name: json["name"],
        originCountry: json["origin_country"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "logo_path": logoPath,
        "name": name,
        "origin_country": originCountry,
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
        iso31661: json["iso_3166_1"],
        name: json["name"],
    );

    Map<String, dynamic> toJson() => {
        "iso_3166_1": iso31661,
        "name": name,
    };
}

class Season {
    String? airDate;
    int? episodeCount;
    int? id;
    String? name;
    String? overview;
    String? posterPath;
    int? seasonNumber;
    double? voteAverage;

    Season({
        this.airDate,
        this.episodeCount,
        this.id,
        this.name,
        this.overview,
        this.posterPath,
        this.seasonNumber,
        this.voteAverage,
    });

    factory Season.fromJson(Map<String, dynamic> json) => Season(
        airDate: json["air_date"] ?? '',
        episodeCount: json["episode_count"],
        id: json["id"],
        name: json["name"],
        overview: json["overview"],
        posterPath: json["poster_path"] ?? '',
        seasonNumber: json["season_number"],
        voteAverage: json["vote_average"]?.toDouble(),
    );

    Map<String, dynamic> toJson() => {
        "air_date": airDate,
        "episode_count": episodeCount,
        "id": id,
        "name": name,
        "overview": overview,
        "poster_path": posterPath,
        "season_number": seasonNumber,
        "vote_average": voteAverage,
    };
}

class SpokenLanguage {
    String? englishName;
    String? iso6391;
    String? name;

    SpokenLanguage({
        this.englishName,
        this.iso6391,
        this.name,
    });

    factory SpokenLanguage.fromJson(Map<String, dynamic> json) => SpokenLanguage(
        englishName: json["english_name"],
        iso6391: json["iso_639_1"],
        name: json["name"],
    );

    Map<String, dynamic> toJson() => {
        "english_name": englishName,
        "iso_639_1": iso6391,
        "name": name,
    };
}