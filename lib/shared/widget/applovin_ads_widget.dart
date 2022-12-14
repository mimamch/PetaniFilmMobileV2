import 'dart:math';

import 'package:applovin_max/applovin_max.dart';
import 'package:flutter/cupertino.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:petani_film_v2/shared/shared_variables/constants.dart';

class ApplovinAdsWidget {
  Widget bannerAds = SizedBox(
    height: 50,
    child: MaxAdView(
        adUnitId: Constants.applovinBannerAdUnitId,
        adFormat: AdFormat.mrec,
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
        })),
  );
  Widget mercAds = SizedBox(
    // height: 50,
    child: Constants.applovinMrecAdUnitId.isEmpty
        ? null
        : MaxAdView(
            adUnitId: Constants.applovinMrecAdUnitId,
            adFormat: AdFormat.mrec,
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
            })),
  );

  Future<void> showInterstitialAds() async {
    if (!Constants.showAds || Constants.applovinInterstitialAdUnitId.isEmpty) {
      return;
    }
    bool isReady = (await AppLovinMAX.isInterstitialReady(
        Constants.applovinInterstitialAdUnitId))!;
    if (isReady) {
      Box box = await Hive.openBox('ads');
      DateTime? last = box.get('last_interstitial');
      if (last == null) {
        box.put(
            'last_interstitial',
            DateTime.now()
                .add(Duration(minutes: Constants.interstitialIntervalMinutes)));
        return;
      }
      if (DateTime.now().difference(last).inMinutes >=
          Constants.interstitialIntervalMinutes) {
        box.put('last_interstitial', DateTime.now());
        AppLovinMAX.showInterstitial(Constants.applovinInterstitialAdUnitId);
      }
    } else {
      AppLovinMAX.loadInterstitial(Constants.applovinInterstitialAdUnitId);
    }
  }

  void initializeInterstitialAds() {
    if (!Constants.showAds) return;
    AppLovinMAX.setInterstitialListener(InterstitialListener(
      onAdLoadedCallback: (ad) {
        Constants.interstitialRetryAttempt = 0;
      },
      onAdLoadFailedCallback: (adUnitId, error) {
        Constants.interstitialRetryAttempt =
            Constants.interstitialRetryAttempt + 1;

        int retryDelay =
            pow(2, min(6, Constants.interstitialRetryAttempt)).toInt();

        Future.delayed(Duration(milliseconds: retryDelay * 1000), () {
          AppLovinMAX.loadInterstitial(Constants.applovinInterstitialAdUnitId);
        });
      },
      onAdDisplayedCallback: (ad) {},
      onAdDisplayFailedCallback: (ad, error) {},
      onAdClickedCallback: (ad) {},
      onAdHiddenCallback: (ad) {},
      onAdRevenuePaidCallback: (ad) {},
    ));
    AppLovinMAX.loadInterstitial(Constants.applovinInterstitialAdUnitId);
  }
}
