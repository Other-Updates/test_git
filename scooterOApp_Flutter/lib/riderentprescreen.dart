import 'dart:async';
import 'package:flutter/material.dart';
import 'package:scotto/contactsupportscreen.dart';
import 'package:scotto/feedbackscreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:scotto/home_screen.dart';
import 'package:scotto/utils/Language.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';




class RideRentPreScreen extends StatefulWidget {
  @override
  final trip_details;
  RideRentPreScreen(this.trip_details);
  _RideRentPreScreenState createState() => _RideRentPreScreenState(this.trip_details);
}
class _RideRentPreScreenState extends State<RideRentPreScreen> {

  final trip_details;
  _RideRentPreScreenState(this.trip_details);


  BitmapDescriptor pinLocationIcon;
  Set<Marker> _markers = {};
  Completer<GoogleMapController> _controller = Completer();

  var _GENERIC_RIDE_RENT = ' ', _GENERIC_RIDE_PAYMENT = '', _GENERIC_PLAN_PURCHASED ='', _GENERIC_PAID_AMOUNT = ' ', _GENERIC_START_TIME = '', _GENERIC_END_TIME= '', _GENERIC_UNLOCK_CHARGE = ' ', _GENERIC_SUB_TOTAL = '', _GENERIC_VAT ='',_GENERIC_GRAND_TOTAL = ' ', _GENERIC_CONTINUE = '', _GENERIC_REPORT_ISSUE_MSG ='',_GENERIC_UTILIZED_TIME = ' ', _GENERIC_REMAINING_TIME = '', _GENERIC_WALLET_REMAIN_AMT ='',_GENERIC_RIDE_DISTANCE='' ;


  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  SharedPreferences _sharedPreferences;

  getLanguage() async {
    _sharedPreferences = await _prefs;
    // print(Language.getLocalLanguage(_sharedPreferences,'GENERIC_LOGIN'));
    setState(() {
      _GENERIC_RIDE_RENT = Language.getLocalLanguage(_sharedPreferences, 'GENERIC_RIDE_RENT');
      _GENERIC_RIDE_PAYMENT = Language.getLocalLanguage(_sharedPreferences, "GENERIC_RIDE_PAYMENT");
      _GENERIC_START_TIME = Language.getLocalLanguage(_sharedPreferences, "GENERIC_START_TIME");
      _GENERIC_END_TIME = Language.getLocalLanguage(_sharedPreferences, "GENERIC_END_TIME");
      _GENERIC_UNLOCK_CHARGE = Language.getLocalLanguage(_sharedPreferences, 'GENERIC_UNLOCK_CHARGE');
      _GENERIC_SUB_TOTAL = Language.getLocalLanguage(_sharedPreferences, "GENERIC_SUB_TOTAL");
      _GENERIC_VAT = Language.getLocalLanguage(_sharedPreferences, "GENERIC_VAT");
      _GENERIC_GRAND_TOTAL = Language.getLocalLanguage(_sharedPreferences, 'GENERIC_GRAND_TOTAL');
      _GENERIC_CONTINUE = Language.getLocalLanguage(_sharedPreferences, "GENERIC_CONTINUE");
      _GENERIC_REPORT_ISSUE_MSG = Language.getLocalLanguage(_sharedPreferences, "GENERIC_REPORT_ISSUE_MSG");
      _GENERIC_PLAN_PURCHASED = Language.getLocalLanguage(_sharedPreferences, 'GENERIC_PLAN_PURCHASED');
      _GENERIC_PAID_AMOUNT = Language.getLocalLanguage(_sharedPreferences, "GENERIC_PAID_AMOUNT");
      _GENERIC_UTILIZED_TIME = Language.getLocalLanguage(_sharedPreferences, "GENERIC_UTILIZED_TIME");
      _GENERIC_REMAINING_TIME = Language.getLocalLanguage(_sharedPreferences, 'GENERIC_REMAINING_TIME');
      _GENERIC_WALLET_REMAIN_AMT = Language.getLocalLanguage(_sharedPreferences, "GENERIC_WALLET_REMAIN_AMT");
      _GENERIC_RIDE_DISTANCE = Language.getLocalLanguage(_sharedPreferences, "GENERIC_RIDE_DISTANCE");



    });

  }

  LatLng _center;

  Position currentLocation;




  @override
  void initState() {
    super.initState();
    getLanguage();

  }





  @override
  Widget build(BuildContext context) {
    LatLng pinPosition = LatLng(11.0285903, 76.9472747);
    CameraPosition initialLocation =
    CameraPosition(zoom: 16, bearing: 30, target: pinPosition);
    var result;
    return new Scaffold(
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
              color:Colors.white,
          ),
        ),
        title: Text(_GENERIC_RIDE_RENT,style: TextStyle(color:Colors.white,fontWeight: FontWeight.bold,fontFamily:'Montserrat' ),),
        centerTitle: true,
        backgroundColor:Color(0xff00DD00),
      ),
      body: new Container(
        color: Color(0xffF1FDF0),
        child: new ListView(
          children: <Widget>[
            Container(
                height: 230,

                child: new Card(
                  color: Color(0xff00DD00),
                  child:Container(
                    padding:EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 15),
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
                )),
            Container(
                padding: EdgeInsets.fromLTRB(15.0, 10.0, 10.0, 10),
              child: Text(_GENERIC_RIDE_PAYMENT, style: TextStyle(color: Color(0xff676767),fontFamily: 'Montserrat',fontSize: 20,fontWeight: FontWeight.bold),)
            ),
            Container(
               // height: 120,
                padding: EdgeInsets.fromLTRB(15.0, 5.0, 10.0, 10),
                child: new Card(
                  color: Colors.white,
                  child: new Column(
                      children: [
                        Container(
                            padding: EdgeInsets.only(top:15),
                            child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                MainAxisAlignment.start,
                                children: <Widget>[
                                  Flexible(
                                    child: Padding(
                                        padding:
                                        EdgeInsets.only(right: 10.0),
                                        child: Container(
                                            alignment: Alignment.centerLeft,
                                            padding: EdgeInsets.only(left: 15),

                                            //   height: MediaQuery.of(context).size.height ,
                                            //  width:MediaQuery.of(context).size.width
                                            child: Text(_GENERIC_START_TIME,style: TextStyle(fontFamily: 'Montserrat',color: Color(0xff676767)))
                                        )     ),
                                    flex: 2,
                                  ),
                                  Flexible(
                                    child: Padding(
                                        padding: EdgeInsets.only(right: 10.0),
                                        child: Container(
                                          alignment: Alignment.centerRight,
                                          child: Text(trip_details['ride_start'],style: TextStyle(fontFamily: 'Montserrat',color: Color(0xff676767)))
                                        ) ),
                                    flex: 2,
                                  ),
                                ] )  ),
                        Container(
                            padding: EdgeInsets.only(top:15),
                            child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                MainAxisAlignment.start,
                                children: <Widget>[
                                  Flexible(
                                    child: Padding(
                                        padding:
                                        EdgeInsets.only(right: 10.0),
                                        child: Container(
                                            alignment: Alignment.centerLeft,
                                            padding: EdgeInsets.only(left: 15),

                                            child: Text(_GENERIC_END_TIME,style: TextStyle(fontFamily: 'Montserrat',color: Color(0xff676767)))
                                        )     ),
                                    flex: 2,
                                  ),
                                  Flexible(
                                    child: Padding(
                                        padding: EdgeInsets.only(right: 10.0),
                                        child: Container(
                                          alignment: Alignment.centerRight,
                                          child: Text(trip_details['ride_end'],style: TextStyle(fontFamily: 'Montserrat',color: Color(0xff676767))),
                                        )  ),
                                    flex: 2,
                                  ),
                                ] )  ),
                        Container(
                            padding: EdgeInsets.only(top:15,bottom: 10),
                            child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                MainAxisAlignment.start,
                                children: <Widget>[
                                  Flexible(
                                    child: Padding(
                                        padding:
                                        EdgeInsets.only(right: 10.0),
                                        child: Container(
                                            alignment: Alignment.centerLeft,
                                            padding: EdgeInsets.only(left: 15),


                                            child: Text(_GENERIC_RIDE_DISTANCE,style: TextStyle(fontFamily: 'Montserrat',color: Color(0xff676767)))
                                        )     ),
                                    flex: 2,
                                  ),
                                  Flexible(
                                    child: Padding(
                                        padding: EdgeInsets.only(right: 10.0),
                                        child: Container(
                                          alignment: Alignment.centerRight,
                                          child: Text(
                                              '${trip_details['ride_distance']}KM',style: TextStyle(fontFamily: 'Montserrat',color: Color(0xff676767))),
                                        )  ),
                                    flex: 2,
                                  ),
                                ] )  ),
                      ]),
                )),
            Container(
                padding: EdgeInsets.fromLTRB(15.0, 0.0, 10.0, 10),
                child: new Card(
                  color: Colors.white,
                  child: new Column(
                      children: [
                        Container(
                            padding: EdgeInsets.only(top:15),
                            child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                MainAxisAlignment.start,
                                children: <Widget>[
                                  Flexible(
                                    child: Padding(
                                        padding:
                                        EdgeInsets.only(right: 10.0),
                                        child: Container(
                                            alignment: Alignment.centerLeft,
                                            padding: EdgeInsets.only(left: 15),

                                            //   height: MediaQuery.of(context).size.height ,
                                            //  width:MediaQuery.of(context).size.width
                                            child: Text(_GENERIC_PLAN_PURCHASED,style: TextStyle(fontFamily: 'Montserrat',color: Color(0xff676767)))
                                        )     ),
                                    flex: 2,
                                  ),
                                  Flexible(
                                    child: Padding(
                                        padding: EdgeInsets.only(right: 10.0),
                                        child: Container(
                                          alignment: Alignment.centerRight,
                                          child: Text(
                                              '${trip_details['ride_mins']}minutes',style: TextStyle(fontFamily: 'Montserrat',color: Color(0xff676767))),
                                        )  ),
                                    flex: 2,
                                  ),
                                ] )  ),
                        Container(
                            padding: EdgeInsets.only(top:15),
                            child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                MainAxisAlignment.start,
                                children: <Widget>[
                                  Flexible(
                                    child: Padding(
                                        padding:
                                        EdgeInsets.only(right: 10.0),
                                        child: Container(
                                            alignment: Alignment.centerLeft,
                                            padding: EdgeInsets.only(left: 15),

                                            //   height: MediaQuery.of(context).size.height ,
                                            //  width:MediaQuery.of(context).size.width
                                            child: Text(_GENERIC_PAID_AMOUNT,style: TextStyle(fontFamily: 'Montserrat',color: Color(0xff676767)))
                                        )     ),
                                    flex: 2,
                                  ),
                                  Flexible(
                                    child: Padding(
                                        padding: EdgeInsets.only(right: 10.0),
                                        child: Container(
                                          alignment: Alignment.centerRight,
                                          child: Text('${trip_details['total_ride_amt']}SAR',style: TextStyle(fontFamily: 'Montserrat',color: Color(0xff676767))),
                                        )  ),
                                    flex: 2,
                                  ),
                                ] )  ),
                        Container(
                            padding: EdgeInsets.only(top:15),
                            child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                MainAxisAlignment.start,
                                children: <Widget>[
                                  Flexible(
                                    child: Padding(
                                        padding:
                                        EdgeInsets.only(right: 10.0),
                                        child: Container(
                                            alignment: Alignment.centerLeft,
                                            padding: EdgeInsets.only(left: 15),

                                            //   height: MediaQuery.of(context).size.height ,
                                            //  width:MediaQuery.of(context).size.width
                                            child: Text(_GENERIC_UTILIZED_TIME,style: TextStyle(fontFamily: 'Montserrat',color: Color(0xff676767)))
                                        )     ),
                                    flex: 2,
                                  ),
                                  Flexible(
                                    child: Padding(
                                        padding: EdgeInsets.only(right: 10.0),
                                        child: Container(
                                          alignment: Alignment.centerRight,
                                          child: Text('6 Minutes',style: TextStyle(fontFamily: 'Montserrat',color: Color(0xff676767))),
                                        )  ),
                                    flex: 2,
                                  ),
                                ] )  ),
                        Container(
                            padding: EdgeInsets.only(top:15),
                            child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                MainAxisAlignment.start,
                                children: <Widget>[
                                  Flexible(
                                    child: Padding(
                                        padding:
                                        EdgeInsets.only(right: 10.0),
                                        child: Container(
                                            alignment: Alignment.centerLeft,
                                            padding: EdgeInsets.only(left: 15),

                                            //   height: MediaQuery.of(context).size.height ,
                                            //  width:MediaQuery.of(context).size.width
                                            child: Text(_GENERIC_REMAINING_TIME,style: TextStyle(fontFamily: 'Montserrat',color: Color(0xff676767)))
                                        )     ),
                                    flex: 2,
                                  ),
                                  Flexible(
                                    child: Padding(
                                        padding:
                                        EdgeInsets.only(right: 10.0),
                                        child: Container(
                                          alignment: Alignment.centerRight,
                                          child: Text('4 Minutes',style: TextStyle(fontFamily: 'Montserrat',color: Color(0xff676767))),
                                        )  ),
                                    flex: 2,
                                  ),
                                ] )  ),
                        Container(
                            padding: EdgeInsets.only(top:15),
                            child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                MainAxisAlignment.start,
                                children: <Widget>[
                                  Flexible(
                                    child: Padding(
                                        padding:
                                        EdgeInsets.only(right: 10.0),
                                        child: Container(
                                            alignment: Alignment.centerLeft,
                                            padding: EdgeInsets.only(left: 15),

                                            //   height: MediaQuery.of(context).size.height ,
                                            //  width:MediaQuery.of(context).size.width
                                            child: Text(_GENERIC_UNLOCK_CHARGE,style: TextStyle(fontFamily: 'Montserrat',color: Color(0xff676767)))
                                        )     ),
                                    flex: 2,
                                  ),
                                  Flexible(
                                    child: Padding(
                                        padding:
                                        EdgeInsets.only(right: 10.0),
                                        child: Container(
                                          alignment: Alignment.centerRight,
                                          child: Text('${trip_details['unlock_charge']}SAR',style: TextStyle(fontFamily: 'Montserrat',color: Color(0xff676767))),
                                        )  ),
                                    flex: 2,
                                  ),
                                ] )  ),
                        Container(
                            padding: EdgeInsets.only(top:15),
                            child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                MainAxisAlignment.start,
                                children: <Widget>[
                                  Flexible(
                                    child: Padding(
                                        padding:
                                        EdgeInsets.only(right: 10.0),
                                        child: Container(
                                            alignment: Alignment.centerLeft,
                                            padding: EdgeInsets.only(left: 15),

                                            //   height: MediaQuery.of(context).size.height ,
                                            //  width:MediaQuery.of(context).size.width
                                            child: Text(_GENERIC_SUB_TOTAL,style: TextStyle(fontFamily: 'Montserrat',color: Color(0xff676767)))
                                        )     ),
                                    flex: 2,
                                  ),
                                  Flexible(
                                    child: Padding(
                                        padding:
                                        EdgeInsets.only(right: 10.0),
                                        child: Container(
                                          alignment: Alignment.centerRight,
                                          child: Text('${trip_details['sub_total']}SAR',style: TextStyle(fontFamily: 'Montserrat',color: Color(0xff676767))),
                                        )  ),
                                    flex: 2,
                                  ),
                                ] )  ),
                        Container(
                            padding: EdgeInsets.only(top:10,bottom: 10),
                            child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                MainAxisAlignment.start,
                                children: <Widget>[
                                  Flexible(
                                    child: Padding(
                                        padding:
                                        EdgeInsets.only(right: 10.0),
                                        child: Container(
                                            alignment: Alignment.centerLeft,
                                            padding: EdgeInsets.only(left: 15),

                                            //   height: MediaQuery.of(context).size.height ,
                                            //  width:MediaQuery.of(context).size.width
                                            child: Text('${_GENERIC_VAT}(15%)',style: TextStyle(fontFamily: 'Montserrat',color: Color(0xff676767)))
                                        )     ),
                                    flex: 2,
                                  ),
                                  Flexible(
                                    child: Padding(
                                        padding:
                                        EdgeInsets.only(right: 10.0),
                                        child: Container(
                                          alignment: Alignment.centerRight,
                                          child: Text('${trip_details['vat_charge']}SAR',style: TextStyle(fontFamily: 'Montserrat',color: Color(0xff676767))),
                                        )  ),
                                    flex: 2,
                                  ),
                                ] )  ),

                      ]),
                )),
            Container(
                padding: EdgeInsets.fromLTRB(15.0, 0.0, 10.0, 0),
                child: new Card(
                  color: Color(0xffE6FFE6),
                  child: new Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment:
                      MainAxisAlignment.start,
                      children: <Widget>[
                        Flexible(
                          child: Padding(
                              padding:
                              EdgeInsets.only(right: 10.0),
                              child: Container(
                                  alignment: Alignment.centerLeft,
                                  padding: EdgeInsets.only(left: 15,bottom: 25,top: 25.0),
                                  //   height: MediaQuery.of(context).size.height ,
                                  //  width:MediaQuery.of(context).size.width
                                  child: Text(_GENERIC_GRAND_TOTAL,style: TextStyle(fontFamily: 'Montserrat',color: Color(0xff676767)))
                              )     ),
                          flex: 2,
                        ),
                        Flexible(
                          child: Padding(
                              padding:
                              EdgeInsets.only(right: 10.0),
                              child: Container(
                                alignment: Alignment.centerRight,
                                child: Text('${trip_details['grand_total']}SAR',style: TextStyle(fontFamily: 'Montserrat',color: Color(0xff676767))),
                              )  ),
                          flex: 2,
                        ),

                      ]   ),
                )),

            Container(
                padding: EdgeInsets.fromLTRB(15.0, 0.0, 10.0, 0),
                child: new Card(

                  color: Color(0xffE6FFE6),
                  child: new Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment:
                      MainAxisAlignment.start,
                      children: <Widget>[
                        Flexible(
                          child: Padding(
                              padding:
                              EdgeInsets.only(right: 10.0),
                              child: Container(
                                  alignment: Alignment.centerLeft,
                                  padding: EdgeInsets.only(left: 15,bottom: 20,top: 20.0),
                                  child: Text(_GENERIC_WALLET_REMAIN_AMT,style: TextStyle(fontFamily: 'Montserrat',color: Color(0xff676767)))
                              )     ),
                          flex: 2,
                        ),
                        Flexible(
                          child: Padding(
                              padding:
                              EdgeInsets.only(right: 10.0),
                              child: Container(
                                alignment: Alignment.centerRight,
                                child: Text('20SAR',style: TextStyle(fontFamily: 'Montserrat',color: Color(0xff676767))),
                              )  ),
                          flex: 2,
                        ),
                      ]   ),
                )),
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

                  child: Text(_GENERIC_CONTINUE, style: TextStyle(
                      fontSize: 18,fontFamily: 'Montserrat', fontWeight: FontWeight.bold),),
                  onPressed: () {
                    setState(() {
                      var scooter_id = trip_details ['scooter_id'];
                      var trip_id = trip_details ['id'];
                    });
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) => FeedbackScreen(trip_details)));
                  }
              ),


            ),
            Container(
              padding: EdgeInsets.only(top: 10,bottom: 20),
              alignment: Alignment.center,
              child: FlatButton(
                  textColor: Color(0xff00DD00),

                  child: Text(_GENERIC_REPORT_ISSUE_MSG, style: TextStyle(
                    fontSize: 18,fontFamily: 'Montserrat'),),
                  onPressed: () {
                    setState(() {

                      var scooter_id = trip_details ['scooter_id'];
                      var trip_id = trip_details ['id'];

                    });
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) => ContactSupportScreen()));
                  }
              ),
            )

          ],
        ),
      ),
    );
  }
  void mapCreated(controller) {
    setState(() {
      _controller = controller;
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

