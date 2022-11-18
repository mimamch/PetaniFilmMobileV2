import 'package:dio/dio.dart';
import 'package:petani_film_v2/services/hive_services.dart';
import 'package:petani_film_v2/shared/shared_variables/constants.dart';
import 'package:flutter/cupertino.dart';

class AppCofigurationServices {
  static Future<void> initAssets() async {
    try {
      await HiveService().clearBoxes(boxName: 'app_configuration');
      var cache = await HiveService().getBoxesKey('app_configuration', 'main');
      if (cache != null) {
        Constants.setAppConfiguration(
          showAds: cache['ads']['show_ads'],
          applovinSdkKey: cache['ads']['applovin_sdk_key'],
          applovinBannerAdUnitId: cache['ads']['applovin_banner_ad_unit_id'],
          applovinInterstitialAdUnitId: cache['ads']
              ['applovin_interstitial_ad_unit_id'],
          token: cache['credentials']['token'],
        );
      } else {
        Response response =
            await Dio().get('${Constants.apiBaseUrl}/app-configuration');
        cache = response.data['data'];
        HiveService().addSingleBoxKeyMap(
            item: response.data['data'],
            boxName: 'app_configuration',
            boxKey: 'main',
            duration: Duration(
                minutes: (response.data['data']['caching']['expired_minutes'] ??
                    60 * 12)));
      }
      Constants.setAppConfiguration(
        oneSignalAppId: cache['one_signal']['app_id'],
        showAds: cache['ads']['show_ads'],
        applovinSdkKey: cache['ads']['applovin_sdk_key'],
        applovinBannerAdUnitId: cache['ads']['applovin_banner_ad_unit_id'],
        applovinInterstitialAdUnitId: cache['ads']
            ['applovin_interstitial_ad_unit_id'],
        interstitialIntervalMinutes: cache['ads']
            ['interstitial_interval_minutes'],
        token: cache['credentials']?['token'],
      );
      return;
    } catch (e) {
      debugPrint(e.toString());
      return;
    }
  }
}
