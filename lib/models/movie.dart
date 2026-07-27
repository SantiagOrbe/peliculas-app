import 'dart:convert';

class Movie {
    bool adult;
    String? backdropPath;
    List<int> genreIds;
    int id;
    String title;
    String originalLanguage;
    String originalTitle;
    String overview;
    double popularity;
    String? posterPath;
    String? releaseDate;
    bool softcore;
    bool video;
    double voteAverage;
    int voteCount;
    
    String? heroId;

    Movie({
        required this.adult,
        this.backdropPath,
        required this.genreIds,
        required this.id,
        required this.title,
        required this.originalLanguage,
        required this.originalTitle,
        required this.overview,
        required this.popularity,
        this.posterPath,
        this.releaseDate,
        required this.softcore,
        required this.video,
        required this.voteAverage,
        required this.voteCount,
    });

    get fullPosterImg {
      if (posterPath != null) {
        return 'https://image.tmdb.org/t/p/w500$posterPath';
      }
      return 'https://i.stack.imgur.com/GNhxO.png';
    }

    get fullBackdropPath {
      if (backdropPath != null) {
        return 'https://image.tmdb.org/t/p/w500$backdropPath';
      }
      return 'https://i.stack.imgur.com/GNhxO.png';
    }

    factory Movie.fromRawJson(String str) => Movie.fromJson(json.decode(str));


    factory Movie.fromJson(Map<String, dynamic> json) => Movie(
        adult: json["adult"],
        backdropPath: json["backdrop_path"],
        genreIds: List<int>.from(json["genre_ids"].map((x) => x)),
        id: json["id"],
        title: json["title"],
        originalLanguage: json["original_language"],
        originalTitle: json["original_title"],
        overview: json["overview"],
        popularity: json["popularity"]?.toDouble(),
        posterPath: json["poster_path"],
        releaseDate: json["release_date"],
        softcore: json["softcore"],
        video: json["video"],
        voteAverage: json["vote_average"]?.toDouble(),
        voteCount: json["vote_count"],
    );

}
