import 'package:flutter/material.dart';
import 'package:beacons/beacons.dart';
import 'package:flutter_blue/flutter_blue.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'CS 125 App',
      theme: new ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
      home: new MyHomePage(title: 'CS 125 Home'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  final List<BeaconRegion> regions = [
    BeaconRegion(
        identifier: 'Home', ids: ['52e78b33-c131-4702-922b-fdb5d63666d9'])
  ];

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<String> _messages;
  FlutterBlue _flutterBlue;

  @override
  void initState() {
    _flutterBlue = FlutterBlue.instance;
    _messages = [];
    
    _startMonitoring();
    _flutterBlue.onStateChanged().listen((state) {
      if (state == BluetoothState.on) {
        print("Bluetooth turned on");
        _startMonitoring();
      } else if (state == BluetoothState.off) {
        print("Bluetooth turned off");
        _stopMonitoring();
      }
    });
    super.initState();
  }

  @override
  void dispose() async {
    _stopMonitoring();
    super.dispose();
  }

  void _startMonitoring() async {
    var bluetoothState = await _flutterBlue.state;
    if (bluetoothState != BluetoothState.on) {
      print("not starting monitoring: Bluetooth disabled");
      return;
    }

    for (final region in widget.regions) {
      Beacons
          .monitoring(region: region, inBackground: true)
          .listen((beaconResult) {
        setState(() {
          print("heard beacon: " + beaconResult.toString());
          _messages.insert(0, beaconResult.toString());
        });
      });
    }
    print("started monitoring");
  }

  void _stopMonitoring() async {
    for (final region in widget.regions) {
      await Beacons.stopMonitoring(region);
    }
    print("stopped monitoring");
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text(widget.title),
        ),
        body: new ListView(
            children: _messages.map((m) {
          return Text(m);
        }).toList()));
  }
}
