import 'package:flutter/cupertino.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:petani_film_v2/shared/shared_variables/constants.dart';

class OneSignalServices {
  oneSignalInit() async {
    await OneSignal.shared.setAppId(Constants.oneSignalAppId);
    await OneSignal.shared
        .promptUserForPushNotificationPermission()
        .then((accepted) {});
  }

  Future<OSDeviceState?> oneSignalGetDeviceInfo() async {
    OSDeviceState? data = await OneSignal.shared.getDeviceState();
    return data;
  }

  setExternalUserId(String externalId) async {
    try {
      await OneSignal.shared.setExternalUserId(externalId);
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
