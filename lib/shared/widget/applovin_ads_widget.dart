import 'package:applovin_max/applovin_max.dart';
import 'package:flutter/cupertino.dart';
import 'package:petani_film_v2/shared/shared_variables/constants.dart';

class ApplovinAdsWidget {
  Widget bannerAds = MaxAdView(
      adUnitId: Constants.applovinBannerAdUnitId,
      adFormat: AdFormat.banner,
      listener: AdViewAdListener(onAdLoadedCallback: (ad) {
        debugPrint('Banner widget ad loaded from ${ad.networkName}');
      }, onAdLoadFailedCallback: (adUnitId, error) {
        debugPrint(
            'Banner widget ad failed to load with error code ${error.code} and message: ${error.message}');
      }, onAdClickedCallback: (ad) {
        debugPrint('Banner widget ad clicked');
      }, onAdExpandedCallback: (ad) {
        debugPrint('Banner widget ad expanded');
      }, onAdCollapsedCallback: (ad) {
        debugPrint('Banner widget ad collapsed');
      }, onAdRevenuePaidCallback: (ad) {
        debugPrint('Banner widget ad revenue paid: ${ad.revenue}');
      }));

  Future<void> showInterstitialAds() async {
    if (!Constants.showAds) return;
    bool isReady = (await AppLovinMAX.isInterstitialReady(
        Constants.applovinInterstitialAdUnitId))!;
    if (isReady) {
      AppLovinMAX.showInterstitial(Constants.applovinInterstitialAdUnitId);
    } else {
      AppLovinMAX.loadInterstitial(Constants.applovinInterstitialAdUnitId);
    }
  }

  void initializeInterstitialAds() {
    if (!Constants.showAds) return;
    AppLovinMAX.loadInterstitial(Constants.applovinInterstitialAdUnitId);
  }
}
