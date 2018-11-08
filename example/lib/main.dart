import 'package:amap_location_plugin/amap_location_plugin.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _location = 'Unknown';
  AmapLocation _amapLocation = AmapLocation();
  StreamSubscription<String> _locationSubscription;

  @override
  void initState() {
    super.initState();
    _locationSubscription = _amapLocation.onLocationChanged.listen((String location) {
      print(location);
      if (!mounted) return;
      setState(() {
        _location = location;
      });
    });
//    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> getLocation() async {
    String location;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      location = await _amapLocation.getLocation;
      print(location);
    } on PlatformException {
      location = 'Failed to get location.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _location = location;
    });
  }

  Future<void> startLocation() async {
    await _amapLocation.startLocation;
  }

  Future<void> stopLocation() async {
    await _amapLocation.stopLocation;
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          title: const Text('Plugin example app'),
        ),
        body: new Center(
          child: Column(
            children: <Widget>[
              new FlatButton(onPressed: startLocation, child: Text("开始定位")),
              new FlatButton(onPressed: stopLocation, child: Text("停止定位")),
              new Text('Running on: $_location\n'),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    if (_locationSubscription != null) {
      _locationSubscription.cancel();
    }
  }
}
