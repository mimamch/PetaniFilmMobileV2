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

  static const imageBaseUrl = 'http://mimamch.online:5002/images';
  static const apiBaseUrl = 'http://116.193.190.155:4001/v2';
  // static const apiBaseUrl = 'http://192.168.18.83:3000/v2';

  static const oneSignalAppId = 'a833874c-0e62-4c57-ac59-8eeac79f8bc4';
  static const applovinSdkKey =
      "eF97zKQbpUaTMGxDis07Jl75fR2uUtm5PnCTaJ_eTFzz0vA5EQlWw996BF6lu5AOv7I6TWfKw7kz4SZkWCboHz";
  static var applovinBannerAdUnitId =
      Platform.isAndroid ? "9c9e2a4d7155e261" : "";
}
