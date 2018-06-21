import 'package:flutter/material.dart';
import 'package:beacons/beacons.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:logging/logging.dart';

Logger _log;
FlutterBlue _flutterBlue;

void main() {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((LogRecord rec) {
    print('${rec.level.name}: ${rec.time}: ${rec.message}');
  });
  _log = new Logger('CS125');

  _flutterBlue = FlutterBlue.instance;

  runApp(new MyApp());
}

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
  var _isMonitoring = false;
  List<String> _messages = [];

  @override
  void initState() {
    _log.fine("initState");

    _startMonitoring();
    _flutterBlue.onStateChanged().listen((state) {
      if (state == BluetoothState.on) {
        _log.fine("Bluetooth turned on");
        _startMonitoring();
      } else if (state == BluetoothState.off) {
        _log.fine("Bluetooth turned off");
        _stopMonitoring();
      }
    });
    super.initState();
  }

  @override
  void dispose() async {
    await _stopMonitoring();
    super.dispose();
  }

  void _startMonitoring() async {
    if (_isMonitoring) {
      _log.fine("alreading monitoring so not stopping");
      return;
    }
    var bluetoothState = await _flutterBlue.state;
    if (bluetoothState != BluetoothState.on) {
      _log.fine("not starting monitoring: Bluetooth disabled");
      return;
    }

    Beacons.backgroundMonitoringEvents().listen((event) {
      _log.fine("heard background beacon $event");
      setState(() {
        _messages.insert(0, event.toString());
      });
    });

    for (final region in widget.regions) {
      Beacons
          .monitoring(region: region, inBackground: true)
          .listen((beaconResult) {
        setState(() {
          _log.fine("heard beacon $beaconResult");
          _messages.insert(0, beaconResult.toString());
        });
      });
    }

    _log.fine("started monitoring");
    _isMonitoring = true;
  }

  void _stopMonitoring() async {
    if (!_isMonitoring) {
      _log.fine("not monitoring so not stopping");
      return;
    }
    for (final region in widget.regions) {
      await Beacons.stopMonitoring(region);
    }

    _log.fine("stopped monitoring");
    _isMonitoring = false;
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
