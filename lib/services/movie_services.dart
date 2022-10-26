import 'package:dio/dio.dart';
import 'package:petani_film_v2/models/movie_item_model.dart';
import 'package:petani_film_v2/shared/shared_variables/constants.dart';

class MovieServices {
  Future<MovieItemModel> getMovieDetail(String url) async {
    try {
      Response response = await Dio().post(
          '${Constants.apiBaseUrl}/get-movie-by-link/',
          data: {"link": url});
      return MovieItemModel.fromJson(response.data['data']);
    } catch (e) {
      rethrow;
    }
  }
}
