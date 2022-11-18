import 'package:dio/dio.dart';
import 'package:petani_film_v2/models/movie_item_model.dart';
import 'package:petani_film_v2/shared/shared_variables/constants.dart';

class MovieServices {
  Future<MovieItemModel> getMovieDetail(String url) async {
    try {
      Response response = await Dio(BaseOptions(
              headers: {'authorization': 'Bearer ${Constants.token}'}))
          .post('${Constants.apiBaseUrl}/get-movie-by-link/',
              data: {"link": url});
      return MovieItemModel.fromJson(response.data['data']);
    } on DioError catch (e) {
      if (e.response == null) {
        throw 'Perika Koneksi Internet';
      }
      throw e.response?.data['message'] ?? 'Terjadi Kesalahan!';
    } catch (e) {
      rethrow;
    }
  }

  Future<MovieItemModel> getTvDetail(String url) async {
    try {
      Response response = await Dio(BaseOptions(
              headers: {'authorization': 'Bearer ${Constants.token}'}))
          .post('${Constants.apiBaseUrl}/get-tv-by-link/', data: {"link": url});
      return MovieItemModel.fromJson(response.data['data']);
    } on DioError catch (e) {
      if (e.response == null) {
        throw 'Perika Koneksi Internet';
      }
      throw e.response?.data['message'] ?? 'Terjadi Kesalahan!';
    } catch (e) {
      rethrow;
    }
  }

  Future<MovieItemModel> getTvEpisode(String url) async {
    try {
      Response response = await Dio(BaseOptions(
              headers: {'authorization': 'Bearer ${Constants.token}'}))
          .post('${Constants.apiBaseUrl}/get-tv-episode/', data: {"link": url});
      return MovieItemModel.fromJson(response.data['data']);
    } on DioError catch (e) {
      if (e.response == null) {
        throw 'Perika Koneksi Internet';
      }
      throw e.response?.data['message'] ?? 'Terjadi Kesalahan!';
    } catch (e) {
      rethrow;
    }
  }
}
