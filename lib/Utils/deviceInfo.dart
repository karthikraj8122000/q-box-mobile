import 'dart:io';

import 'package:device_info/device_info.dart';

class DeviceInfo {
  final deviceInfo = DeviceInfoPlugin();

  Future<String> getDeviceId() async {
    AndroidDeviceInfo androidInfo;
    IosDeviceInfo iosInfo;
    try {
      if(Platform.isAndroid){
        androidInfo = await deviceInfo.androidInfo;
        return androidInfo.androidId;
      }else{
        iosInfo = await deviceInfo.iosInfo;
        return iosInfo.identifierForVendor;
      }
    } catch (e) {
      return 'Error';
    }
  }
}