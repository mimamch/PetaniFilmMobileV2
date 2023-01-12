import 'package:dio/dio.dart';
import 'package:petani_film_v2/models/movie_item_model.dart';
import 'package:petani_film_v2/shared/shared_variables/constants.dart';

class HomePageServices {
  Future<Map<String, dynamic>> getHomePageItem({page = 1}) async {
    try {
      Response response = await Dio(BaseOptions(
              headers: {'authorization': 'Bearer ${Constants.token}'}))
          .get('${Constants.apiBaseUrl}/home_page?page=$page');
      final lastUploaded = MovieItemModel.fromArray(
          List<Map<String, dynamic>>.from(
              response.data['data']['last_uploaded']['data'] ?? []));
      final featured = MovieItemModel.fromArray(List<Map<String, dynamic>>.from(
          response.data['data']['featured_post'] ?? []));
      return {
        "total_pages":
            (response.data['data']?['last_uploaded']?['total_pages'] ?? 1)
                as int,
        "current_page":
            (response.data['data']?['last_uploaded']?['current_page'] ?? 1)
                as int,
        "annoucements": List<Map<String, dynamic>>.from(
            response.data['data']['announcements'] ?? []),
        "last_uploaded": lastUploaded,
        "featured": featured,
        "title1": response.data['data']['title1'],
        "title2": response.data['data']['title2'],
        "genres": response.data['data']['genres'],
      };
    } on DioError catch (e) {
      if (e.response == null) {
        throw 'Periksa Koneksi Internet Anda';
      }
      throw e.response?.data?['message'] ?? 'Terjadi Kesalahan';
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getByGenre({page = 1, slug = 'action'}) async {
    try {
      Response response = await Dio(
          BaseOptions(
              headers: {'authorization': 'Bearer ${Constants.token}'})).get(
          '${Constants.apiBaseUrl}/get-movie-by-genre?page=$page&genre=$slug');
      final lastUploaded = MovieItemModel.fromArray(
          List<Map<String, dynamic>>.from(
              response.data['data']['last_uploaded']['data'] ?? []));
      return {
        "total_pages":
            (response.data['data']?['last_uploaded']?['total_pages'] ?? 1)
                as int,
        "current_page":
            (response.data['data']?['last_uploaded']?['current_page'] ?? 1)
                as int,
        "last_uploaded": lastUploaded,
      };
    } on DioError catch (e) {
      if (e.response == null) {
        throw 'Periksa Koneksi Internet Anda';
      }
      throw e.response?.data?['message'] ?? 'Terjadi Kesalahan';
    } catch (e) {
      rethrow;
    }
  }

  Future<List<MovieItemModel>> getSearchQuery({String? query}) async {
    try {
      Response response = await Dio(BaseOptions(
              headers: {'authorization': 'Bearer ${Constants.token}'}))
          .get('${Constants.apiBaseUrl}/search?search=${query ?? ''}');
      final data = MovieItemModel.fromArray(
          List<Map<String, dynamic>>.from(response.data['data'] ?? []));
      return data;
    } on DioError catch (e) {
      if (e.response == null) {
        throw 'Periksa Koneksi Internet Anda';
      }
      throw e.response?.data?['message'] ?? 'Terjadi Kesalahan';
    } catch (e) {
      rethrow;
    }
  }
}
