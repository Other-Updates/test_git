/*
Timer _timer;
int seconds = 0;
int minutes = 0;
int hours = 0;
void startTimer() {
  const oneSec = const Duration(seconds: 1);
  _timer = new Timer.periodic(
    oneSec,
        (Timer timer) => setState(
          () {
        if (seconds < 0) {
          timer.cancel();
        } else {
          seconds = seconds + 1;
          if (seconds > 59) {
            minutes += 1;
            seconds = 0;
            if (minutes > 59) {
              hours += 1;
              minutes = 0;
            }
          }
        }
      },
    ),
  );
}*/
/*
import 'dart:async';

import 'package:geolocator/geolocator.dart';

class _LocationPageState extends State<LocationPage> {
  Position _currentPosition;
  Position _previousPosition;
  StreamSubscription<Position> _positionStream;
  double _totalDistance = 0;

  List<Position> locations = List<Position>();

  @override
  void initState() {
    super.initState();
    _calculateDistance();
  }

  Future _calculateDistance() async {
    _positionStream = Geolocator.getPositionStream(
        distanceFilter: 10, desiredAccuracy: LocationAccuracy.high)
        .listen((Position position) async {
      if ((await Geolocator.isLocationServiceEnabled())) {
        Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
            .then((Position position) {
          setState(() {
            _currentPosition = position;
            locations.add(_currentPosition);

            if (locations.length > 1) {
              _previousPosition = locations.elementAt(locations.length - 2);

              var _distanceBetweenLastTwoLocations = Geolocator.distanceBetween(
                _previousPosition.latitude,
                _previousPosition.longitude,
                _currentPosition.latitude,
                _currentPosition.longitude,
              );
              _totalDistance += _distanceBetweenLastTwoLocations;
              print('Total Distance: $_totalDistance');
            }
          });
        }).catchError((err) {
          print(err);
        });
      } else {
        print("GPS is off.");
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                content: const Text('Make sure your GPS is on in Settings !'),
                actions: <Widget>[
                  FlatButton(
                      child: Text('OK'),
                      onPressed: () {
                        Navigator.of(context, rootNavigator: true).pop();
                      })
                ],
              );
            });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _positionStream.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Location Manager'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Previous Latitude: ${_previousPosition?.latitude ?? '-'} \nPrevious Longitude: ${_previousPosition?.longitude ?? '-'}',
            ),
            SizedBox(height: 50),
            Text(
              'Current Latitude: ${_currentPosition?.latitude ?? '-'} \nCurrent Longitude: ${_currentPosition?.longitude ?? '-'}',
            ),
            SizedBox(height: 50),
            Text(
                'Distance: ${_totalDistance != null ? _totalDistance > 1000 ? (_totalDistance / 1000).toStringAsFixed(2) : _totalDistance.toStringAsFixed(2) : 0} ${_totalDistance != null ? _totalDistance > 1000 ? 'KM' : 'meters' : 0}')
          ],
        ),
      ),
    );
  }
}*/
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Distance between Locations',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LocationPage(),
    );
  }
}

class LocationPage extends StatefulWidget {
  LocationPage({Key key}) : super(key: key);

  @override
  _LocationPageState createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  Position _currentPosition;
  Position _previousPosition;
  StreamSubscription<Position> _positionStream;
  double _distance;

  @override
  void initState() {
    super.initState();
  //  _calculateDistance();
  }

 /* Future _calculateDistance() async {
    _positionStream = Geolocator.getPositionStream(
        distanceFilter: 10, desiredAccuracy: LocationAccuracy.high)
        .listen((Position position) async {
      if ((await Geolocator.isLocationServiceEnabled())) {
        Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
            .then((Position position) {
          setState(() {
            _currentPosition = position;
            _distance = Geolocator.distanceBetween(
                51.9021777, // how to get the previous Latitude position ?
                -0.5257026, // how to get the previous Longitude position ?
                position.latitude,
                position.longitude) as double;
          });
        }).catchError((err) {
          print(err);
        });
      } else {
        print("GPS is off.");
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                content: const Text('Make sure your GPS is on in Settings !'),
                actions: <Widget>[
                  FlatButton(
                      child: Text('OK'),
                      onPressed: () {
                        Navigator.of(context, rootNavigator: true).pop();
                      })
                ],
              );
            });
      }
    });
  }
*/
  @override
  void dispose() {
    super.dispose();
    _positionStream.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Location Manager'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Previous Latitude: ${_previousPosition?.latitude ?? '-'} \nPrevious Longitude: ${_previousPosition?.longitude ?? '-'}',
            ),
            SizedBox(height: 50),
            Text(
              'Current Latitude: ${_currentPosition?.latitude ?? '-'} \nCurrent Longitude: ${_currentPosition?.longitude ?? '-'}',
            ),
            SizedBox(height: 50),
            Text(
                'Distance: ${_distance != null ? _distance.toStringAsFixed(2) : 0} meters.')
          ],
        ),
      ),
    );
  }
}

