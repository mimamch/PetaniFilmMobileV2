import 'package:dio/dio.dart';
import 'package:petani_film_v2/models/movie_item_model.dart';
import 'package:petani_film_v2/shared/shared_variables/constants.dart';

class HomePageServices {
  Future<List<MovieItemModel>> getHomePageItem({page = 1}) async {
    try {
      Response response =
          await Dio().get('${Constants.apiBaseUrl}/home_page?page=$page');
      return MovieItemModel.fromArray(List<Map<String, dynamic>>.from(
          response.data['data']['last_uploaded']['data'] ?? []));
    } catch (e) {
      rethrow;
    }
  }
}
