import 'dart:convert';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';

import '../models/images.dart';
import '../Constants/constants.dart';

class RemoteConfigService {
  final FirebaseRemoteConfig _remoteConfig;

  static RemoteConfigService? _instance;
  static RemoteConfigService getInstance() {
    _instance ??=
        RemoteConfigService(remoteConfig: FirebaseRemoteConfig.instance);
    return _instance!;
  }

  RemoteConfigService({required FirebaseRemoteConfig remoteConfig})
      : _remoteConfig = remoteConfig;

  FirebaseImages get getImages => FirebaseImages.fromJson(
      jsonDecode(_remoteConfig.getString(Constants.carouselKey)));

  bool get forceUpdate => _remoteConfig.getBool(Constants.forceUpdateKey);

  bool get updateAvailable =>
      _remoteConfig.getBool(Constants.updateAvailableKey);

  Future initialise() async {
    try {
      await _remoteConfig.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: const Duration(minutes: 1),
        minimumFetchInterval: const Duration(hours: 1),
      ));
      await _remoteConfig.setDefaults(
          {'name': "rico", 'power_level': "500", 'bio': "nice dude"});
      await _remoteConfig.fetch();
      await _remoteConfig.fetchAndActivate();
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }
}
