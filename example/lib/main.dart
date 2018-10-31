import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:amap_location/amap_location.dart';

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _city = 'Unknown';
  AmapLocation _amapLocation = AmapLocation();
  StreamSubscription<String> _citySubscription;

  @override
  void initState() {
    super.initState();
    _citySubscription = _amapLocation.onLocationChanged.listen((String city) {
      print(city);
      if (!mounted) return;
      setState(() {
        _city = city;
      });
    });
//    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> getCity() async {
    String city;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      city = await _amapLocation.getCity;
      print(city);
    } on PlatformException {
      city = 'Failed to get city.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _city = city;
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
              new Text('Running on: $_city\n'),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    if (_citySubscription != null) {
      _citySubscription.cancel();
    }
  }
}
