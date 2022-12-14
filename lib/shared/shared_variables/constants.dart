import 'dart:io';

import 'package:flutter/material.dart';

class Constants {
  static const primaryblueColor = Color(0xFF556ee6);
  static const lightBlueColor = Color(0xFF50a5f1);
  static const backgroundBlueColor = Color(0xFFEBF1FA);
  static const blackColor = Color(0xFF14193F);
  static const whiteColor = Color(0xFFFFFFFF);
  static const greyColor = Color(0xff74788d);
  static const greenColor = Color(0xFF34c38f);
  static const redColor = Color(0xfff46a6a);
  static const purpleColor = Color(0xFF7E349D);

  static const apiBaseUrl = 'https://api.petanifilm.my.id/v2';
  // static const apiBaseUrl = 'http://192.168.18.83:3000/v2';

  // INIT CONFIGURATION
  static void setAppConfiguration({
    String? oneSignalAppId,
    bool? showAds,
    String? applovinSdkKey,
    Map? applovinBannerAdUnitId,
    Map? applovinMrecAdUnitId,
    Map? applovinInterstitialAdUnitId,
    int? interstitialIntervalMinutes,
    String? token,
  }) {
    Constants.oneSignalAppId = oneSignalAppId ?? '';

    Constants.showAds = showAds ?? false;
    Constants.applovinSdkKey = applovinSdkKey ?? '';
    Constants.applovinBannerAdUnitId = Platform.isAndroid
        ? (applovinBannerAdUnitId?['android'] ?? '')
        : (applovinBannerAdUnitId?['ios'] ?? '');
    Constants.applovinMrecAdUnitId = Platform.isAndroid
        ? (applovinMrecAdUnitId?['android'] ?? '')
        : (applovinMrecAdUnitId?['ios'] ?? '');
    Constants.applovinInterstitialAdUnitId = Platform.isAndroid
        ? (applovinInterstitialAdUnitId?['android'] ?? '')
        : (applovinInterstitialAdUnitId?['ios'] ?? '');
    Constants.interstitialIntervalMinutes = interstitialIntervalMinutes ?? 10;
    Constants.token = token ?? '';
  }

  // ONE SIGNAL
  static String oneSignalAppId = '538bd297-5880-4720-b2f8-0b86f283d2cc';

  static String token = '';

  // APPLOVIN ADS
  // static bool showAds = true;
  // static String applovinSdkKey =
  //     "eF97zKQbpUaTMGxDis07Jl75fR2uUtm5PnCTaJ_eTFzz0vA5EQlWw996BF6lu5AOv7I6TWfKw7kz4SZkWCboHz";
  // static String applovinBannerAdUnitId =
  //     Platform.isAndroid ? "9c9e2a4d7155e261" : "";
  // static String applovinInterstitialAdUnitId =
  //     Platform.isAndroid ? "aa1c03016bdc905f" : "";
  // static int interstitialRetryAttempt = 0;
  // static int interstitialIntervalMinutes = 10;

  static bool showAds = false;
  static String applovinSdkKey = "";
  static String applovinBannerAdUnitId = '';
  static String applovinMrecAdUnitId = '';
  static String applovinInterstitialAdUnitId = '';
  static int interstitialRetryAttempt = 0;
  static int interstitialIntervalMinutes = 10;
}
