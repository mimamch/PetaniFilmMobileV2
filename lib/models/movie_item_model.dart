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
  final String? streamingLink;
  final List<Map<String, dynamic>>? downloadLinks;
  final String? description;
  final String? releaseDate;
  final String? year;
  final List<String>? actors;
  final String? country;
  final List<MovieItemModel>? relatedPost;
  final String? quality;
  const MovieItemModel(
      {this.title,
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
      this.quality});

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
        relatedPost: MovieItemModel.fromArray(List<Map<String, dynamic>>.from(
            json['detail']?['related_post'] ?? [])),
        releaseDate: json['detail']?['release_date'],
        year: json['detail']?['year']?.toString(),
        streamingLink: json['streaming_link'],
        totalStreamingServer: (json['total_streaming_server'] ?? 0) as int,
        quality: json['quality']);
  }
  static List<MovieItemModel> fromArray(List<Map<String, dynamic>> array) {
    return array.map((e) => MovieItemModel.fromJson(e)).toList();
  }

  copyWith({String? streamingLink}) {
    return MovieItemModel(
        title: title,
        duration: duration,
        genres: genres,
        posterUrl: posterUrl,
        rating: rating,
        trailer: trailer,
        type: type,
        url: url,
        actors: actors,
        country: country,
        description: description,
        downloadLinks: downloadLinks,
        relatedPost: relatedPost,
        releaseDate: releaseDate,
        streamingLink: streamingLink,
        totalStreamingServer: totalStreamingServer,
        year: year,
        quality: quality);
  }
}
