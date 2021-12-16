import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scotto/Menudrawer.dart';
import 'package:scotto/barcode_scan.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'barcode_scan.dart';
import 'package:scotto/utils/StorageUtil.dart';
import 'package:http/http.dart' as http;
import 'package:scotto/constants.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

import 'dart:math' show cos, sqrt, asin;

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var unlock_counts, total_distance, wallet_amount, total_ride_time;
  var _scaffoldKey = new GlobalKey<ScaffoldState>();
  GlobalKey<ScaffoldState> _key = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final PermissionHandler permissionHandler = PermissionHandler();
  Map<PermissionGroup, PermissionStatus> permissions;
  var customer_details;

  BitmapDescriptor pinLocationgreen, pinLocationred, pinLocationblue;

  Completer<GoogleMapController> _controller = Completer();

  GoogleMapController mapController;

  Position currentPosition;

//  List<Marker> _markers = [];
  // Set<Marker> _markers = {};
  final Set<Polyline> _polyline = {};

  _getCurrentLocation() async {
    await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    ).then((Position position) async {
      setState(() {
        currentPosition = position;
        print('CURRENT POS: $currentPosition');
        mapController.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: LatLng(position.latitude, position.longitude),
              zoom: 16.0,
              bearing: 60,
            ),
          ),
        );
      });
      //   await _getAddress();
    }).catchError((e) {
      print(e);
    });
  }

  Future<bool> _requestPermission(PermissionGroup permission) async {
    final PermissionHandler _permissionHandler = PermissionHandler();
    var result = await _permissionHandler.requestPermissions([permission]);
    if (result[permission] == PermissionStatus.granted) {
      return true;
    }
    return false;
  }

  Future<bool> requestLocationPermission({Function onPermissionDenied}) async {
    var granted = await _requestPermission(PermissionGroup.location);
    if (granted != true) {
      requestLocationPermission();
    }
    // debugPrint('requestContactsPermission $granted');
    return granted;
  }

/*Show dialog if GPS not enabled and open settings location*/
  /* Future _checkGps() async {
    if (!(await Geolocator().isLocationServiceEnabled())) {
      if (Theme.of(context).platform == TargetPlatform.android) {
        */ /*  showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                   // title: Text("Can't get gurrent location"),
                  //  content:const Text('Please make sure you enable GPS and try again'),
                  */ /* */ /*  actions: <Widget>[
                      FlatButton(child: Text('Ok'),
                          onPressed: () {
                          */ /* */ /**/ /* */ /*  final AndroidIntent intent = AndroidIntent(
                                action: 'android.settings.LOCATION_SOURCE_SETTINGS');
                            intent.launch();
                            Navigator.of(context, rootNavigator: true).pop();
                            _gpsService();*/ /* */ /**/ /* */ /*
                          })],*/ /* */ /*
                  );
                });*/ /*
      }
    }
  }*/

/*Check if gps service is enabled or not*/
  /*Future _gpsService() async {
    if (!(await Geolocator().isLocationServiceEnabled())) {
      _checkGps();
      return null;
    } else
      return true;
  }
*/

  var latlnglocation, latlng;
  String _currentAddress = '';

  void setCustomMapPin() async {
    pinLocationgreen = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(size: Size(48, 48)),
      'assets/images/ic_sc_maker_3.png',
    );
    pinLocationred = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(
        devicePixelRatio: 2.5,
      ),
      'assets/images/ic_sc_maker_3red.png',
    );
    pinLocationblue = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(
        devicePixelRatio: 2.5,
      ),
      'assets/images/ic_sc_maker_3_blue.png',
    );
  }

  String mobile_test = '';

  void getTextFromFile() async {
    try {
      String data = await StorageUtil.getItem("login_customer_detail_id");

      setState(() {
        mobile_test = data;
      });
      print("mobile" + mobile_test);
    } catch (ex) {
      print(ex);
    }
  }

  List<Marker> _markers = [];
  Future<Set<Marker>> ScooterLocationsAPI() async {
    await getTextFromFile();
    var url = baseurl + 'api_get_scooter_details';
    var data = json.encode({"id": mobile_test});
    print(data);
    // print("customeroriginal"+data.toString());
    final resp =
        await http.post(url, headers: {'authorization': basicAuth}, body: data);
    if (resp.statusCode == 200) {
      //  Navigator.of(context).pop();
      _markers = [];
      final responsebody = jsonDecode(resp.body);
      var i = 0;
      for (i; i < responsebody['data'].length; i++) {
        var scoo_lat = double.parse(responsebody['data'][i]['scoo_lat']);
        var scoo_long = double.parse(responsebody['data'][i]['scoo_long']);

        setState(() {
          /*       if(responsebody['data'][i]['gps'] == 'OFF' && responsebody['data'][i]['lock_status'] == 0) {
              _markers.add(Marker(
                icon: pinLocationred,
                onTap: () {
                  _getPolyline(scoo_lat,scoo_long,i);
                },
                markerId: MarkerId(responsebody['data'][i]['id']),
                position: LatLng(
                    double.parse(responsebody['data'][i]['scoo_lat']),
                    double.parse(responsebody['data'][i]['scoo_long'])),
                infoWindow: InfoWindow(
                    title: 'ScooterO ${responsebody['data'][i]['serial_number']}',
                    snippet: 'battery_life:  ${responsebody['data'][i]['battery_life']}'),
              )
              );
            }else if(responsebody['data'][i]['gps'] == 'OFF') {
              _markers.add(Marker(
                icon: pinLocationred,
                onTap: () {
                  _getPolyline(scoo_lat,scoo_long,i);
                },
                markerId: MarkerId(responsebody['data'][i]['id']),
                position: LatLng(
                    double.parse(responsebody['data'][i]['scoo_lat']),
                    double.parse(responsebody['data'][i]['scoo_long'])),
                infoWindow: InfoWindow(
                    title: 'ScooterO ${responsebody['data'][i]['serial_number']}',
                    snippet: 'battery_life:  ${responsebody['data'][i]['battery_life']}'),
              )
              );
            }else*/
          if (responsebody['data'][i]['lock_status'] == '0' &&
              responsebody['data'][i]['gps'] == 'ON') {
            _markers.add(Marker(
              icon: pinLocationgreen,
              onTap: () {
                _getPolyline(scoo_lat, scoo_long, i);
              },
              markerId: MarkerId(responsebody['data'][i]['id']),
              position: LatLng(
                  double.parse(responsebody['data'][i]['scoo_lat']),
                  double.parse(responsebody['data'][i]['scoo_long'])),
              infoWindow: InfoWindow(
                  title: 'ScooterO ${responsebody['data'][i]['serial_number']}',
                  snippet:
                      'Battery life:  ${responsebody['data'][i]['battery_life']}'),
            ));
          } /*else if(responsebody['data'][i]['lock_status'] == '1') {
              _markers.add(Marker(
                icon: pinLocationblue,
                onTap: () {
                  _getPolyline(scoo_lat,scoo_long,i);
                },
                markerId: MarkerId(responsebody['data'][i]['id']),
                position: LatLng(
                    double.parse(responsebody['data'][i]['scoo_lat']),
                    double.parse(responsebody['data'][i]['scoo_long'])),
                infoWindow: InfoWindow(
                    title: 'ScooterO ${responsebody['data'][i]['serial_number']}',
                    snippet: 'battery_life:  ${responsebody['data'][i]['battery_life']}'),
              )
              );
            }*/
          else {
            setState(() {
              _markers.remove(_markers);
            });
          }
        });
      }
      return _markers.toSet();
    } else {
      print('Server Error');
    }
  }

/*
  _getAddress() async {
    try {
      List<Placemark> p = await placemarkFromCoordinates(
          currentPosition.latitude, currentPosition.longitude);
print(Placemark);
      Placemark place = p[0];

      setState(() {
        _currentAddress =
        "${place.name}, ${place.locality}, ${place.postalCode}, ${place.country}";
       // startAddressController.text = _currentAddress;
    //    _startAddress = _currentAddress;
      });
    } catch (e) {
      print(e);
    }
  }
*/

  PolylinePoints polylinePoints = PolylinePoints();
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];

  _getPolyline(scoo_lat1, scoo_long1, scooterId) async {
    polylineCoordinates.clear();
    // polylineCoordinates = [];
    print(scoo_lat1.toString() + "===Hello===" + scoo_long1.toString());
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      'AIzaSyDwpXSYswuXaJyfDoBxXTxYeAYRwzZIjGE',
      PointLatLng(currentPosition.latitude, currentPosition.longitude),
      PointLatLng(scoo_lat1, scoo_long1),
      travelMode: TravelMode.driving,
    );
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    } else {
      print(result.errorMessage);
    }
    _addPolyLine(polylineCoordinates, scooterId);
  }

  _addPolyLine(List<LatLng> polylineCoordinates, scooterId) {
    PolylineId id = PolylineId("poly" + scooterId.toString());
    Polyline polyline = Polyline(
      polylineId: id,
      visible: true,
      color: Color(0xff00DD00),
      points: polylineCoordinates,
      width: 8,
    );
    polylines[id] = polyline;
  }
/*
  PolylinePoints polylinePoints;
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];


  PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(// Google Maps API Key
  PointLatLng(currentPosition.latitude,currentPosition.longitude),
  PointLatLng(responsebody['data'][i]['scoo_lat'], responsebody['data'][i]['scoo_long']),
  travelMode: TravelMode.transit,
  );
*/

  void _showMessageInScaffold(String message) {
    _scaffoldKey.currentState.showSnackBar(
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

  String result;

  Future _ScooterLocationsAPI;
  @override
  void initState() {
    super.initState();
    requestLocationPermission();
    _getCurrentLocation();
    ScooterLocationsAPI();
    setCustomMapPin();

    // _getPolyline(scoo_lat, scoo_long);
  }

  @override
  Widget build(BuildContext context) {
    //  Timer.periodic(Duration(seconds: 300), (Timer t) => ScooterLocationsAPI());
    //11.028345,76.949513
    CameraPosition initialLocation =
        CameraPosition(target: LatLng(0, 0), zoom: 16.0, bearing: 60);
    var result;
    return Scaffold(
      key: _key,
      //   drawer: SideDrawer(),
      drawer: Drawer(
        child: HomeMenuDrawer(),
      ),
      body: Stack(children: [
        Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          //  color: Colors.transparent,
          child: GoogleMap(
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              compassEnabled: true,
              mapToolbarEnabled: false,
              zoomControlsEnabled: false,
              zoomGesturesEnabled: false,
              scrollGesturesEnabled: true,
              markers: Set<Marker>.of(_markers),
              polylines: Set<Polyline>.of(polylines.values),
              initialCameraPosition: initialLocation,
              onMapCreated: (GoogleMapController controller) {
                controller.setMapStyle(Utils.mapStyles);
                mapController = controller;
              }),
        ),
        Container(
            alignment: Alignment.topLeft,
            padding: const EdgeInsets.fromLTRB(25.0, 50.0, 10.0, 20),
            child: GestureDetector(
              //   padding: EdgeInsets.only(left:15,top: 20),
              // alignment: Alignment.topLeft,
              child: new Icon(
                Icons.segment_sharp,
                color: Colors.black,
                size: 30.0,
              ),

              onTap: () {
                _key.currentState.openDrawer();
              },
            )),
        Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                color: Colors.white, // button color
                child: InkWell(
                  splashColor: Colors.white, // inkwell color
                  child: SizedBox(
                    width: 40,
                    height: 40,
                    child: Icon(
                      Icons.add,
                      color: Colors.black54,
                      size: 30.0,
                    ),
                  ),
                  onTap: () {
                    mapController.animateCamera(
                      CameraUpdate.zoomIn(),
                    );
                  },
                ),
              ),
              SizedBox(height: 2),
              Container(
                  color: Colors.white, // button color
                  child: InkWell(
                    splashColor: Colors.white, // inkwell color
                    child: SizedBox(
                      width: 40,
                      height: 40,
                      child: Icon(
                        Icons.remove,
                        color: Colors.black54,
                        size: 30.0,
                      ),
                    ),
                    onTap: () {
                      mapController.animateCamera(
                        CameraUpdate.zoomOut(),
                      );
                    },
                  )),
            ],
          ),
        ),
        Container(
            padding: const EdgeInsets.only(bottom: 30.0),
            child: new Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: Container(
                        width: 30.0,
                        //     width: MediaQuery.of(context).size.height*0.15,

                        alignment: Alignment.bottomLeft,
                        padding:
                            const EdgeInsets.fromLTRB(50.0, 20.0, 10.0, 20),
                        child: new Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0)),
                            color: Colors.white,
                            child: Container(
                              child: InkWell(
                                  child: Container(
                                width:
                                    MediaQuery.of(context).size.height * 0.07,
                                height:
                                    MediaQuery.of(context).size.height * 0.07,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(120.0),
                                  image: DecorationImage(
                                      image: AssetImage(
                                          'assets/images/ic_questio.png')),
                                ),
                              )),
                            ))),
                    flex: 2,
                  ),
                  Expanded(
                    child: Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.height,
                      padding: const EdgeInsets.only(bottom: 30.0),
                      alignment: Alignment.bottomCenter,
                      child: new CircleAvatar(
                        backgroundColor: Color(0xff00DD00),
                        radius: 50.0,
                        child: InkWell(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      BarCode()));
                            },
                            child: Container(
                              height: MediaQuery.of(context).size.height * 0.06,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(120.0),
                                image: DecorationImage(
                                    image: AssetImage(
                                        'assets/images/ic_barcode.png')),
                              ),
                            )),
                      ),
                    ),
                    flex: 2,
                  ),
                  Expanded(
                    child: Container(
                      alignment: Alignment.bottomRight,
                      padding: const EdgeInsets.fromLTRB(10.0, 20.0, 50.0, 20),
                      child: new Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0)),
                        color: Colors.white,
                        child: Container(
                          child: InkWell(
                              onTap: () {
                                _getCurrentLocation();
                                print("destination");
                              },
                              child: Container(
                                  width:
                                      MediaQuery.of(context).size.height * 0.07,
                                  height:
                                      MediaQuery.of(context).size.height * 0.07,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: AssetImage(
                                            'assets/images/ic_location.png')),
                                  ))),
                        ),
                      ),
                    ),
                    flex: 2,
                  ),
                ])),
      ]),
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

class PermissionStatus {
  static Object granted;
}

/*
@override
Widget EachList() {
  return AlertDialog(

    child: Container(
      child: Text('scooterO'),
    ),
  );
}*/
