import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:scotto/Endbarcodecredit.dart';
import 'package:flutter/cupertino.dart';
import 'package:scotto/home_screen.dart';
import 'package:http/http.dart' as http;
import 'package:scotto/constants.dart';
import 'package:scotto/utils/Language.dart';
import 'package:scotto/utils/StorageUtil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:math' show cos, sqrt, asin;

class RidePostpaidScreen extends StatefulWidget {
  @override
  final trip_details;
  RidePostpaidScreen(this.trip_details);
  _RidePostpaidScreenState createState() => _RidePostpaidScreenState(this.trip_details);
  }

  class _RidePostpaidScreenState extends State<RidePostpaidScreen> {
    final trip_details;
    _RidePostpaidScreenState(this.trip_details);
    GlobalKey<ScaffoldState> _key = new GlobalKey<ScaffoldState>();
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

    var trip_number,customer_id,scooter_id,payment_id,subscription_id,status,ride_start,ride_mins,ride_distance,ride_end,total_ride_amt,unlock_charge,sub_total,vat_charge,grand_total,scootertripenddetails;
  var _GENERIC_SCOOTERO_RIDE = '', _GENERIC_RIDING_TIME = '', _GENERIC_RIDING_RANGE ='', _GENERIC_DISTANCE = ' ', _GENERIC_END_RIDE= '', _GENERIC_PARK_SCOOTER_SAFE = ' ', _GENERIC_PARK_SCOOTER_SAFE_MSG = '', _GENERIC_OK ='';

    BitmapDescriptor pinLocationIcon;
    Set<Marker> _markers = {};
    Completer<GoogleMapController> _controller = Completer();

    int totalRideTime = 0;

    int _startTimer = 0;
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  SharedPreferences _sharedPreferences;

  getLanguage() async {
    _sharedPreferences = await _prefs;
    // print(Language.getLocalLanguage(_sharedPreferences,'GENERIC_LOGIN'));
    setState(() {
      _GENERIC_SCOOTERO_RIDE = Language.getLocalLanguage(_sharedPreferences, 'GENERIC_SCOOTERO_RIDE');
      _GENERIC_RIDING_TIME = Language.getLocalLanguage(_sharedPreferences, "GENERIC_RIDING_TIME");
      _GENERIC_RIDING_RANGE = Language.getLocalLanguage(_sharedPreferences, "GENERIC_RIDING_RANGE");
      _GENERIC_DISTANCE = Language.getLocalLanguage(_sharedPreferences, "GENERIC_DISTANCE");;
      _GENERIC_END_RIDE = Language.getLocalLanguage(_sharedPreferences, "GENERIC_END_RIDE");
      _GENERIC_PARK_SCOOTER_SAFE = Language.getLocalLanguage(_sharedPreferences, "GENERIC_PARK_SCOOTER_SAFE");
      _GENERIC_PARK_SCOOTER_SAFE_MSG = Language.getLocalLanguage(_sharedPreferences, 'GENERIC_PARK_SCOOTER_SAFE_MSG');
      _GENERIC_OK = Language.getLocalLanguage(_sharedPreferences, "GENERIC_OK");


    });

  }
    LatLng _center;

    Position currentLocation;
    var locations;

    Position currentPosition;
    GoogleMapController mapController;
    double currentLatitude=1,currentLongitude=1,StartLatitude=1,startLongitude=1;

    _getLiveLocation() async {
      await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high,)
          .then((Position position) async {
        // print(currentPosition.longitude);
        setState(() {
          currentLatitude = position.latitude;
          currentLongitude = position.longitude;
        });
        //   await _getAddress();
      }).catchError((e) {
        print(e);
      });
    }

    _getCurrentLocation() async {
      await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high,)
          .then((Position position) async {
        // print(currentPosition.longitude);
        setState(() {
          StartLatitude = position.latitude;
          startLongitude = position.longitude;
          currentLatitude = position.latitude;
          currentLongitude = position.longitude;
          currentPosition = position;
          print('CURRENT POS: $currentPosition');
          mapController.animateCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(
                target: LatLng(position.latitude, position.longitude),
                zoom: 16.0,  bearing: 60,
              ),
            ),
          );
        });
        //   await _getAddress();
      }).catchError((e) {
        print(e);
      });
    }


    double _coordinateDistance(lat1, lon1, lat2, lon2) {
      var p = 0.017453292519943295;
      var c = cos;
      var a = 0.5 -
          c((lat2 - lat1) * p) / 2 +
          c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
      var number = 12742 * asin(sqrt(a));
      return num.parse(number.toStringAsFixed(2));
    }


    String mobile_test = '';

    void getTextFromFile() async {
      try {
        String data = await StorageUtil.getItem("login_customer_detail_id");

        setState(() {
          mobile_test = data;
        });
      } catch (ex) {
        print(ex);
      }
    }
  endride() async {
    _getLiveLocation();
    String basicAuth = "Basic YWRtaW46MTIzNA==";
    var data = json.encode({
      "id": mobile_test ,
      "scootoro_id": trip_details['scooter_id'],
      "trip_number": trip_details['trip_number'],
      "distance": _coordinateDistance(StartLatitude,startLongitude,currentLatitude,currentLongitude).toString(),
      "customer_id": mobile_test,
      "scoo_lat": currentPosition.latitude,
      "scoo_long": currentPosition.longitude
    });
    final response = await http.post(baseurl + 'api_ride_end', headers: {'authorization': basicAuth}, body: data);
    if (response.statusCode == 200) {
      var  jsonResponse = json.decode(response.body);
      print(jsonResponse);
      if(jsonResponse['status'] == "Success"){
        var trip_details = jsonResponse['trip_details'];
        setState(() {
          scootertripenddetails= trip_details;
          trip_number = trip_details ['trip_number'];
          customer_id =trip_details ['customer_id'];
          scooter_id = trip_details ['scooter_id'];
          payment_id = trip_details ['payment_id'];
          subscription_id = trip_details ['subscription_id'];
          ride_start = trip_details ['ride_start'];
          ride_end= trip_details ['ride_end'];
          ride_mins =trip_details ['ride_mins'];
          ride_distance=trip_details ['ride_distance'];
          total_ride_amt = trip_details ['total_ride_amt'];
          unlock_charge = trip_details ['unlock_charge'];
          sub_total = trip_details ['sub_total'];
          vat_charge  =trip_details ['vat_charge'];
          grand_total = trip_details ['grand_total'];
          status= trip_details ['status'];
        });
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => EndBarCredit(trip_details)), (Route<dynamic> route) => false);
      }else if(jsonResponse['status'] == 'Error'){
        print(jsonResponse['message']);
        _showMessageInScaffold(jsonResponse['message']);
      }
      //   sharedPreferences.setString("token", jsonResponse['token']);
    }else {
      _showMessageInScaffold('Contact Admin!!');
    }
  }

    void _showMessageInScaffold(String message) {
      _key.currentState.showSnackBar(
        SnackBar(
          content: Text(
            message,
            style: TextStyle(
              color: Colors.white,
            ),

            textAlign: TextAlign.center,
            softWrap: true,
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }






    @override
  void initState() {
    super.initState();
    getTextFromFile();
    getLanguage();
    _getCurrentLocation();
    rideTimer(this.trip_details['ride_mins']);
    setState(() {
      totalRideTime = this.trip_details['ride_mins'];
    });
  }


    @override
  Widget build(BuildContext context) {
      Timer.periodic(Duration(seconds: 10), (Timer t) {
        /*  setState(() {
            startLongitude = startLongitude + 0.0001;
          });*/
        _getLiveLocation();
      } );
      LatLng pinPosition = LatLng(0,0);
      CameraPosition initialLocation =
      CameraPosition(zoom: 16, bearing: 30, target: pinPosition);
      var result;
    return new Scaffold(
      key:_key ,
      appBar: AppBar(

        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                    builder: (BuildContext context) =>HomeScreen()
                )
            );
          },
          child: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,// add custom icons also
          ),
        ),
        title: Text(_GENERIC_SCOOTERO_RIDE),
        centerTitle: true,

        backgroundColor:Color(0xff00DD00),

      ),
        body: Stack(children: [

          Container(
            height: MediaQuery
                .of(context)
                .size
                .height,
            width: MediaQuery
                .of(context)
                .size
                .width,
            //  color: Colors.transparent,

            child: FutureBuilder(

              builder: (context, AsyncSnapshot snapshot) {
                return GoogleMap(
                  //  myLocationEnabled: true,
                  //  compassEnabled: true,
                  // markers: _markers,
                    initialCameraPosition: initialLocation,
                    onMapCreated: (GoogleMapController controller) {
                      controller.setMapStyle(Utils.mapStyles);
                      _controller.complete(controller);

                    });
              },
            ),
          ),
          Container(
              height: 110,
              // padding: EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0),
              child: new Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0)),
                  color: Colors.white,

                  child: new Column(
                      children: [
                        Container(
                            padding: EdgeInsets.only(left: 10),
                            child: new Row(
                              //      mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[


                                  new FlatButton(
                                    child: new Text(
                                      _GENERIC_DISTANCE,
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          color: Color(0xff676767),fontFamily: 'Montserrat'),
                                    ),
                                  ),
                                  new FlatButton(
                                    child: new Text(
                                      _GENERIC_RIDING_TIME,
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          color: Color(0xff676767),fontFamily: 'Montserrat'),
                                    ),

                                  ),
                                  new FlatButton(
                                    child: new Text(
                                      _GENERIC_RIDING_RANGE,
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          color: Color(0xff676767),fontFamily: 'Montserrat'),
                                    ),


                                  ),
                                ])),
                        Container(
                            padding: EdgeInsets.only(left: 10),
                            child: new Row(
                              //      mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  new FlatButton(
                                    child: new Text(
                                      '0m',
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          color: Color(0xff3D3D3D),fontFamily: 'Montserrat'),
                                    ),


                                  ),
                            /*      new FlatButton(
                                    child: new Text(
                                      '00:08:46',
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          color: Color(0xff3D3D3D),fontFamily: 'Montserrat'),
                                    ),

                                  ),*/
                                  buildTimer(),

                                  new FlatButton(
                                    child: new Text(
                                      '0kmph',
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          color: Color(0xff3D3D3D),fontFamily: 'Montserrat'),
                                    ),


                                  ),
                                ])),
                      ]
                  ))),
          Container(
              alignment: Alignment.bottomCenter,
              padding: EdgeInsets.only(left: 10,bottom: 40,right: 10),
              child: new Row(
                //      mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                        child: Container(
                          padding: EdgeInsets.only(left: 5),
                          height: 50,
                          // margin: EdgeInsets.fromLTRB(14, 15, 14, 0),
                          color: Colors.white,

                          child: RaisedButton(
                              textColor: Colors.white,
                              color: Color(0xff00DD00),
                              shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(
                                    8.0),
                              ),

                              child: Text(
                                  _GENERIC_END_RIDE, style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,fontFamily: 'Montserrat')),
                              onPressed: () {
                                endride();
                              }
                          ),


                        ),flex: 2),


                  ]))

        ]));
    }

    String _calculateDurationToTime(Duration duration) {
      String twoDigits(int n) => n.toString().padLeft(2, "0");
      String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
      String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
      return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
    }

    Duration parseDuration(timeSeconds) {
      print(timeSeconds.toString());
      int hours = 0;
      int minutes = 0;
      int seconds =0;
      var s = Duration(seconds:timeSeconds).toString();
      List<String> parts = s.split(':');
      if (parts.length > 2) {
        hours = int.parse(parts[parts.length - 3]);
      }
      if (parts.length > 1) {
        minutes = int.parse(parts[parts.length - 2]);
      }
      seconds = (double.parse(parts[parts.length - 1]) * 1).round();
      return Duration(hours: hours, minutes: minutes,seconds: seconds);
    }

    @override
    void dispose() {
      _timer.cancel();
      super.dispose();
    }

    Timer _timer;

    rideTimer(second) {
      _startTimer = 0;
      _timer = new Timer.periodic(
        Duration(seconds: 1), (Timer timer) {
        if (_startTimer == totalRideTime) {
          setState(() {
            timer.cancel();
          });
        } else {
          setState(() {
            _startTimer++;
            ridetime = _calculateDurationToTime(parseDuration(_startTimer));
          });
        }
      },
      );
    }

    var ridetime = "00:00:00";
    Row buildTimer() {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // TweenAnimationBuilder(
          //   tween: Tween(begin: 10.0, end: 0.0),
          //   duration: Duration(minutes: 10),
          //   builder: (_, value, child) =>
          /*  Text(
              "${_startTimer}"
          ),*/
          Text(
              "${ridetime}"
            // _calculateDurationToTime(parseDuration(_start)),
            //    style: TextStyle(color: kPrimaryColor),
          ),

        ],
      );
    }




    void mapCreated(controller) {
      setState(() {
        mapController = controller;
      });
    }
  }


class Utils {
  static String mapStyles = '''[
  {
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#f5f5f5"
      }
    ]
  },
  {
    "elementType": "labels.icon",
    "stylers": [
      {
        "visibility": "off"
      }
    ]
  },
  {
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#616161"
      }
    ]
  },
  {
    "elementType": "labels.text.stroke",
    "stylers": [
      {
        "color": "#f5f5f5"
      }
    ]
  },
  {
    "featureType": "administrative.land_parcel",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#bdbdbd"
      }
    ]
  },
  {
    "featureType": "poi",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#eeeeee"
      }
    ]
  },
  {
    "featureType": "poi",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#757575"
      }
    ]
  },
  {
    "featureType": "poi.park",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#e5e5e5"
      }
    ]
  },
  {
    "featureType": "poi.park",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#9e9e9e"
      }
    ]
  },
  {
    "featureType": "road",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#ffffff"
      }
    ]
  },
  {
    "featureType": "road.arterial",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#757575"
      }
    ]
  },
  {
    "featureType": "road.highway",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#dadada"
      }
    ]
  },
  {
    "featureType": "road.highway",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#616161"
      }
    ]
  },
  {
    "featureType": "road.local",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#9e9e9e"
      }
    ]
  },
  {
    "featureType": "transit.line",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#e5e5e5"
      }
    ]
  },
  {
    "featureType": "transit.station",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#eeeeee"
      }
    ]
  },
  {
    "featureType": "water",
    "elementType": "geometry",
    "stylers": [
      {
        "color": "#c9c9c9"
      }
    ]
  },
  {
    "featureType": "water",
    "elementType": "labels.text.fill",
    "stylers": [
      {
        "color": "#9e9e9e"
      }
    ]
  }
]''';
}





/*
body: new Container(
          color: Color(0xffE6FFE6),
          child: new ListView(
              children: <Widget>[
                Container(
                    height: 110,
                    // padding: EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0),
                    child: new Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0)),
                        color: Colors.white,

                        child: new Column(
                            children: [
                              Container(
                                //    padding: EdgeInsets.only(left: 10),
                                  child:new Row(
                                    //      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[


                                        new FlatButton(
                                          child: new Text(
                                            _GENERIC_DISTANCE,textAlign: TextAlign.start,style: TextStyle(color:Color(0xff00DD00), ),
                                          ),
                                        ),
                                        new FlatButton(
                                          child: new Text(
                                            _GENERIC_RIDING_TIME,textAlign: TextAlign.start,style: TextStyle(color:Color(0xff00DD00), ),
                                          ),

                                        ),
                                        new FlatButton(
                                          child: new Text(
                                            _GENERIC_RIDING_RANGE,textAlign: TextAlign.start,style: TextStyle(color:Color(0xff00DD00), ),
                                          ),



                                        ),
                                      ]   )),
                              Container(
                                  padding: EdgeInsets.only(left: 10),
                                  child:new Row(
                                    //      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        new FlatButton(
                                          child: new Text(
                                            '0m',textAlign: TextAlign.start,style: TextStyle(color:Color(0xff00DD00), ),
                                          ),



                                        ),
                                        new FlatButton(
                                          child: new Text(
                                            '00:08:46',textAlign: TextAlign.start,style: TextStyle(color:Color(0xff00DD00), ),
                                          ),

                                        ),
                                        new FlatButton(
                                          child: new Text(
                                            '0kmph',textAlign: TextAlign.start,style: TextStyle(color:Color(0xff00DD00), ),
                                          ),



                                        ),
                                      ]   )),
                            ]
                        ))),
                          Container(
                            height: 50,
                            margin: EdgeInsets.fromLTRB(14, 15, 14, 0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              //  border: EdgeInsets.fromLTRB(10,8, 10, 0),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: RaisedButton(
                                textColor: Colors.white,
                                color: Color(0xff00DD00),
                                shape: RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(8.0),

                                ),

                                child: Text(_GENERIC_END_RIDE, style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),),
                                onPressed: () {
                                  endride();
                                  */
/*    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
                        builder: (BuildContext context) => RechargeScreen()), (
                        Route<dynamic> route) => false);
*//*
                   //   addcredit();
                                }
                            ),


                          ),




                        ]
                    )),


    );
  }
}*/
