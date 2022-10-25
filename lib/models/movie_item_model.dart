class MovieItemModel {
  final String? title;
  final String? url;
  final String? duration;
  final String? posterUrl;
  final double? rating;
  final List<String>? genres;
  final String? type;
  final String? trailer;
  const MovieItemModel(
      {this.title,
      this.duration,
      this.genres,
      this.posterUrl,
      this.rating,
      this.trailer,
      this.type,
      this.url});

  factory MovieItemModel.fromJson(Map<String, dynamic> json) {
    return MovieItemModel(
        title: json['title'],
        duration: json['duration'],
        genres: List<String>.from(json['genres']),
        posterUrl: json['poster_url'],
        rating: double.tryParse(json['rating'].toString()),
        trailer: json['trailer'],
        type: json['type'],
        url: json['url']);
  }
  static List<MovieItemModel> fromArray(List<Map<String, dynamic>> array) {
    return array.map((e) => MovieItemModel.fromJson(e)).toList();
  }
}
