import 'dart:async';

import 'package:flutter/services.dart';

class AmapLocation {
  factory AmapLocation() {
    if (_instance == null) {
      final MethodChannel methodChannel =
          const MethodChannel('plugin.kinsomy.com/methodchannel');
      final EventChannel eventChannel =
          const EventChannel('plugin.kinsomy.com/eventchannel');
      _instance = AmapLocation.private(methodChannel, eventChannel);
    }
    return _instance;
  }

  AmapLocation.private(this._methodChannel, this._eventChannel);

  static AmapLocation _instance;

  final MethodChannel _methodChannel;
  final EventChannel _eventChannel;
  Stream<String> _onCityFetched;

  /// Fires whenever the city send.
  Stream<String> get onLocationChanged {
    if (_onCityFetched == null) {
      _onCityFetched =
          _eventChannel.receiveBroadcastStream().map((dynamic event) => event);
    }
    return _onCityFetched;
  }

  Future<void> get startLocation =>
      _methodChannel.invokeMethod("startLocation");

  Future<void> get stopLocation => _methodChannel.invokeMethod("stopLocation");

  Future<String> get getCity => _methodChannel
      .invokeMethod("getCity")
      .then<String>((dynamic result) => result);
}
