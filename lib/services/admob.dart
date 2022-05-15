import 'dart:io';
import 'package:flutter/material.dart';

class AdMobService {
  String? getBannerAdUnitId() {
    // iOSとAndroidで広告ユニットIDを分岐させる
    if (Platform.isAndroid) {
      // Androidの広告ユニットID
      return 'ca-app-pub-2086626166062713/4825121500';
    } else if (Platform.isIOS) {
      // iOSの広告ユニットID
      return 'ca-app-pub-2086626166062713/6521346552';
    }
  return null;
  }

  // 表示するバナー広告の高さを計算
  double getHeight(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final percent = (height * 0.08).toDouble();

    return percent;
  }
}