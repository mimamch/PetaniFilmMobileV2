class MovieItemModel {
  final String? title;
  final String? url;
  final String? duration;
  final String? posterUrl;
  final double? rating;
  final List<String>? genres;
  final String? type;
  final String? trailer;
  final int? totalStreamingServer;
  String? streamingLink;
  final List<Map<String, dynamic>>? downloadLinks;
  final List<Map<String, dynamic>>? episodes;
  final String? description;
  final String? releaseDate;
  final String? year;
  final List<String>? actors;
  final String? country;
  final List<MovieItemModel>? relatedPost;
  final String? quality;
  final String? currentEpisode;
  final int? currentPlayer;
  final String? note;
  MovieItemModel({
    this.title,
    this.duration,
    this.genres,
    this.posterUrl,
    this.rating,
    this.trailer,
    this.type,
    this.url,
    this.actors,
    this.country,
    this.description,
    this.downloadLinks,
    this.relatedPost,
    this.releaseDate,
    this.streamingLink,
    this.totalStreamingServer,
    this.year,
    this.quality,
    this.episodes,
    this.currentEpisode,
    this.currentPlayer,
    this.note,
  });

  factory MovieItemModel.fromJson(Map<String, dynamic> json) {
    return MovieItemModel(
      title: json['title'],
      duration: json['duration'],
      genres: List<String>.from(json['detail']?['genres'] ?? []),
      posterUrl: json['poster_url'],
      rating: double.tryParse((json['detail']?['rating']).toString()),
      trailer: json['trailer'],
      type: json['type'],
      url: json['url'],
      actors: List<String>.from(json['detail']?['actors'] ?? []),
      country: json['detail']?['country'],
      description: json['detail']?['description'],
      downloadLinks:
          List<Map<String, dynamic>>.from(json['download_links'] ?? []),
      episodes: List<Map<String, dynamic>>.from(json['episodes'] ?? []),
      relatedPost: MovieItemModel.fromArray(List<Map<String, dynamic>>.from(
          json['detail']?['related_post'] ?? [])),
      releaseDate: json['detail']?['release_date'],
      year: json['detail']?['year']?.toString(),
      streamingLink: json['streaming_link'],
      totalStreamingServer: (json['total_streaming_server'] ?? 0) as int,
      quality: json['quality'],
      currentEpisode: json['current_episode'],
      currentPlayer: json['current_player'],
      note: json['note'],
    );
  }
  static List<MovieItemModel> fromArray(List<Map<String, dynamic>> array) {
    return array.map((e) => MovieItemModel.fromJson(e)).toList();
  }

  copyWith({
    String? streamingLink,
    String? url,
    String? title,
    String? duration,
    String? posterUrl,
    List<String>? genres,
    double? rating,
    String? trailer,
    List<String>? actors,
    String? country,
    String? description,
    List<Map<String, dynamic>>? downloadLinks,
    List<MovieItemModel>? relatedPost,
    String? releaseDate,
    int? totalStreamingServer,
    String? year,
    String? quality,
    List<Map<String, dynamic>>? episodes,
    String? currentEpisode,
    int? currentPlayer,
    String? note,
  }) {
    return MovieItemModel(
      title: title ?? this.title,
      duration: duration ?? this.duration,
      genres: genres ?? this.genres,
      posterUrl: posterUrl ?? this.posterUrl,
      rating: rating ?? this.rating,
      trailer: trailer ?? this.trailer,
      type: type,
      url: url ?? this.url,
      actors: actors ?? this.actors,
      country: country ?? this.country,
      description: description ?? this.description,
      downloadLinks: downloadLinks ?? this.downloadLinks,
      relatedPost: relatedPost ?? this.relatedPost,
      releaseDate: releaseDate ?? this.releaseDate,
      streamingLink: streamingLink,
      totalStreamingServer: totalStreamingServer ?? this.totalStreamingServer,
      year: year ?? this.year,
      quality: quality ?? this.quality,
      episodes: episodes ?? this.episodes,
      currentEpisode: currentEpisode ?? this.currentEpisode,
      currentPlayer: currentPlayer ?? this.currentPlayer,
      note: note ?? this.note,
    );
  }
}
