class Movie {
  final String? movieId;
  final String title;
  final String? posterPath;
  final String? imdbUrl;
  final String? overview;
  final double? voteAverage;
  final int? voteCount;
  final double? popularity;
  final String? releaseDate;
  final List<String>? genres;
  final int? runtime;
  final int? budget;
  final int? revenue;
  final String? productionCompany;
  final String? director;
  final String? cast;
  final String? keywords;
  final double? rating;
  final double? predictedRating;
  final int? year;

  Movie({
    this.movieId,
    required this.title,
    this.posterPath,
    this.imdbUrl,
    this.overview,
    this.voteAverage,
    this.voteCount,
    this.popularity,
    this.releaseDate,
    this.genres,
    this.runtime,
    this.budget,
    this.revenue,
    this.productionCompany,
    this.director,
    this.cast,
    this.keywords,
    this.rating,
    this.predictedRating,
    this.year,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      movieId: json['movie_id'] as String?,
      title: json['title'] as String? ?? '',
      posterPath: json['poster_path'] as String?,
      imdbUrl: json['imdb_url'] as String?,
      overview: json['overview'] as String?,
      voteAverage: (json['vote_average'] as num?)?.toDouble(),
      voteCount: json['vote_count'] as int?,
      popularity: (json['popularity'] as num?)?.toDouble(),
      releaseDate: json['release_date'] as String?,
      genres: json['genres'] != null ? List<String>.from(json['genres']) : null,
      runtime: json['runtime'] as int?,
      budget: json['budget'] as int?,
      revenue: json['revenue'] as int?,
      productionCompany: json['production_company'] as String?,
      director: json['director'] as String?,
      cast: json['cast'] as String?,
      keywords: json['keywords'] as String?,
      rating: (json['rating'] as num?)?.toDouble(),
      predictedRating: (json['predicted_rating'] as num?)?.toDouble(),
      year: json['year'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'movie_id': movieId,
      'title': title,
      'poster_path': posterPath,
      'imdb_url': imdbUrl,
      'overview': overview,
      'vote_average': voteAverage,
      'vote_count': voteCount,
      'popularity': popularity,
      'release_date': releaseDate,
      'genres': genres,
      'runtime': runtime,
      'budget': budget,
      'revenue': revenue,
      'production_company': productionCompany,
      'director': director,
      'cast': cast,
      'keywords': keywords,
      'rating': rating,
      'predicted_rating': predictedRating,
      'year': year,
    };
  }

  Movie copyWith({
    String? movieId,
    String? title,
    String? posterPath,
    String? imdbUrl,
    String? overview,
    double? voteAverage,
    int? voteCount,
    double? popularity,
    String? releaseDate,
    List<String>? genres,
    int? runtime,
    int? budget,
    int? revenue,
    String? productionCompany,
    String? director,
    String? cast,
    String? keywords,
    double? rating,
    double? predictedRating,
    int? year,
  }) {
    return Movie(
      movieId: movieId ?? this.movieId,
      title: title ?? this.title,
      posterPath: posterPath ?? this.posterPath,
      imdbUrl: imdbUrl ?? this.imdbUrl,
      overview: overview ?? this.overview,
      voteAverage: voteAverage ?? this.voteAverage,
      voteCount: voteCount ?? this.voteCount,
      popularity: popularity ?? this.popularity,
      releaseDate: releaseDate ?? this.releaseDate,
      genres: genres ?? this.genres,
      runtime: runtime ?? this.runtime,
      budget: budget ?? this.budget,
      revenue: revenue ?? this.revenue,
      productionCompany: productionCompany ?? this.productionCompany,
      director: director ?? this.director,
      cast: cast ?? this.cast,
      keywords: keywords ?? this.keywords,
      rating: rating ?? this.rating,
      predictedRating: predictedRating ?? this.predictedRating,
      year: year ?? this.year,
    );
  }

  // 格式化评分显示
  String get formattedRating {
    final rating = voteAverage ?? this.rating ?? predictedRating ?? 0.0;
    return rating.toStringAsFixed(1);
  }

  // 格式化年份显示
  String get formattedYear {
    if (year != null) return year.toString();
    if (releaseDate != null && releaseDate!.isNotEmpty) {
      return releaseDate!.substring(0, 4);
    }
    return '未知';
  }

  // 格式化类型显示
  String get formattedGenres {
    if (genres == null || genres!.isEmpty) return '未分类';
    return genres!.take(3).join(', ');
  }

  // 格式化时长显示
  String get formattedRuntime {
    if (runtime == null) return '未知';
    final hours = runtime! ~/ 60;
    final minutes = runtime! % 60;
    if (hours > 0) {
      return '${hours}h ${minutes}m';
    }
    return '${minutes}m';
  }
}

class MovieSearchResponse {
  final List<Movie> results;
  final int count;
  final String query;

  MovieSearchResponse({
    required this.results,
    required this.count,
    required this.query,
  });

  factory MovieSearchResponse.fromJson(Map<String, dynamic> json) {
    return MovieSearchResponse(
      results: (json['results'] as List?)?.map((item) => Movie.fromJson(item)).toList() ?? [],
      count: json['count'] as int? ?? 0,
      query: json['query'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'results': results.map((movie) => movie.toJson()).toList(),
      'count': count,
      'query': query,
    };
  }
}

class MovieDetailsResponse {
  final Movie details;
  final String movie;

  MovieDetailsResponse({
    required this.details,
    required this.movie,
  });

  factory MovieDetailsResponse.fromJson(Map<String, dynamic> json) {
    return MovieDetailsResponse(
      details: Movie.fromJson(json['details']),
      movie: json['movie'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'details': details.toJson(),
      'movie': movie,
    };
  }
}

class MovieRecommendationResponse {
  final List<Movie> recommendations;

  MovieRecommendationResponse({
    required this.recommendations,
  });

  factory MovieRecommendationResponse.fromJson(Map<String, dynamic> json) {
    return MovieRecommendationResponse(
      recommendations: (json['recommendations'] as List?)?.map((item) => Movie.fromJson(item)).toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'recommendations': recommendations.map((movie) => movie.toJson()).toList(),
    };
  }
}

class KnowledgeGraphResponse {
  final List<Movie> similarMovies;

  KnowledgeGraphResponse({
    required this.similarMovies,
  });

  factory KnowledgeGraphResponse.fromJson(Map<String, dynamic> json) {
    return KnowledgeGraphResponse(
      similarMovies: (json['similar_movies'] as List?)?.map((item) => Movie.fromJson(item)).toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'similar_movies': similarMovies.map((movie) => movie.toJson()).toList(),
    };
  }
}

class CollaborativeRecommendationResponse {
  final String userId;
  final int count;
  final List<Movie> recommendations;

  CollaborativeRecommendationResponse({
    required this.userId,
    required this.count,
    required this.recommendations,
  });

  factory CollaborativeRecommendationResponse.fromJson(Map<String, dynamic> json) {
    return CollaborativeRecommendationResponse(
      userId: json['user_id'] as String? ?? '',
      count: json['count'] as int? ?? 0,
      recommendations: (json['recommendations'] as List?)?.map((item) => Movie.fromJson(item)).toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'count': count,
      'recommendations': recommendations.map((movie) => movie.toJson()).toList(),
    };
  }
}

