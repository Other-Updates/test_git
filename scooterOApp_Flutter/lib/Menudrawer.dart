import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:scotto/constants.dart';
import 'package:scotto/login_screen.dart';
import 'package:scotto/newFile.dart';
import 'package:scotto/profile_screen.dart';
import 'package:scotto/rechargescreen.dart';
import 'package:scotto/ridepostpaidscreen.dart';
import 'package:scotto/rideprepaidscreen.dart';
import 'package:scotto/utils/Language.dart';
import 'package:scotto/wallet_screen.dart';
import 'package:scotto/invoice_screen.dart';
import 'package:scotto/settings_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'package:scotto/utils/StorageUtil.dart';

class HomeMenuDrawer extends StatefulWidget {
  _HomeMenuDrawerState createState() => _HomeMenuDrawerState();
}

class _HomeMenuDrawerState extends State<HomeMenuDrawer> {
  // static const platform = const MethodChannel('Hyperpay.demo.fultter/channel');
  bool _status = true;
  var _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  var _GENERIC_HI = ' ',
      _GENERIC_UNLOCKS = '',
      _GENERIC_DISTANCE = '',
      _GENERIC_MINUTES = '',
      _GENERIC_PROFILE = '',
      _GENERIC_WALLET = '',
      _GENERIC_INVITE_FRDS = '',
      _GENERIC_PAYMENTS = '',
      _GENERIC_INVOICE = '',
      _GENERIC_HELP = '',
      _GENERIC_SETTINGS = '',
      _GENERIC_PROMO_CODE = '',
      _GENERIC_LOGOUT = '';
  var unlock_counts = '0',
      total_distance = '0',
      wallet_amount = '0.00',
      total_ride_time = '00.00.00',
      customertripdetails;

  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  SharedPreferences _sharedPreferences;

  var checkoutId = "";

  var paymentType;

  getLanguage() async {
    _sharedPreferences = await _prefs;
    // print(Language.getLocalLanguage(_sharedPreferences,'GENERIC_LOGIN'));
    setState(() {
      _GENERIC_HI = Language.getLocalLanguage(_sharedPreferences, 'GENERIC_HI');
      _GENERIC_UNLOCKS =
          Language.getLocalLanguage(_sharedPreferences, "GENERIC_UNLOCKS");
      _GENERIC_DISTANCE =
          Language.getLocalLanguage(_sharedPreferences, "GENERIC_DISTANCE");
      _GENERIC_MINUTES =
          Language.getLocalLanguage(_sharedPreferences, "GENERIC_MINUTES");
      _GENERIC_PROFILE =
          Language.getLocalLanguage(_sharedPreferences, "GENERIC_PROFILE");
      _GENERIC_WALLET =
          Language.getLocalLanguage(_sharedPreferences, "GENERIC_WALLET");
      _GENERIC_INVITE_FRDS =
          Language.getLocalLanguage(_sharedPreferences, "GENERIC_INVITE_FRDS");
      _GENERIC_PAYMENTS =
          Language.getLocalLanguage(_sharedPreferences, "GENERIC_PAYMENTS");
      _GENERIC_INVOICE =
          Language.getLocalLanguage(_sharedPreferences, "GENERIC_INVOICE");
      _GENERIC_HELP =
          Language.getLocalLanguage(_sharedPreferences, "GENERIC_HELP");
      _GENERIC_SETTINGS =
          Language.getLocalLanguage(_sharedPreferences, "GENERIC_SETTINGS");
      _GENERIC_PROMO_CODE =
          Language.getLocalLanguage(_sharedPreferences, "GENERIC_PROMO_CODE");
      _GENERIC_LOGOUT =
          Language.getLocalLanguage(_sharedPreferences, "GENERIC_LOGOUT");
    });
  }

  logout() async {
    StorageUtil.remove('login_customer_detail_id');
    await Future.delayed(Duration(seconds: 2));
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (BuildContext context) => LoginScreen(),
      ),
      (Route route) => false,
    );
  }

  endride() async {
    await getTextFromFile();

    String basicAuth = "Basic YWRtaW46MTIzNA==";
    //   SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var data = json.encode({"customer_id": mobile_test5});
    print(data);
    final response = await http.post(baseurl + 'api_customer_dashboard',
        headers: {'authorization': basicAuth}, body: data);
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      print(jsonResponse);
      if (jsonResponse['status'] == "Success") {
        var customertrip = jsonResponse['data'];
        setState(() {
          customertripdetails = customertrip;
          unlock_counts = customertrip['unlock_counts'];
          total_distance = customertrip['total_distance'];
          wallet_amount = customertrip['wallet_amount'];
          total_ride_time = customertrip['total_ride_time'];
        });
      } else if (jsonResponse['status'] == 'Error') {
        print(jsonResponse['message']);
      }
      //   sharedPreferences.setString("token", jsonResponse['token']);
    } else {
      //   _showMessageInScaffold('Contact Admin!!');
    }
  }

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

  var scootertripdetails;

  String mobile_test = '';
  String mobile_test1 = '';
  String mobile_test2 = '';
  String mobile_test3 = '';
  String mobile_test4 = '';
  String mobile_test5 = '';

  void getTextFromFile() async {
    try {
      String data = await StorageUtil.getItem("unlock_counts");
      String data1 = await StorageUtil.getItem("total_distance");
      String data2 = await StorageUtil.getItem("wallet_amount");
      String data3 = await StorageUtil.getItem("total_ride_time");
      String data4 = await StorageUtil.getItem("login_customer_detail_name");
      String data5 = await StorageUtil.getItem("login_customer_detail_id");

      setState(() {
        mobile_test = data;
        mobile_test1 = data1;
        mobile_test2 = data2;
        mobile_test3 = data3;
        mobile_test4 = data4;
        mobile_test5 = data5;
      });
    } catch (ex) {
      print(ex);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLanguage();
    endride();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        Padding(
            padding: EdgeInsets.only(left: 10.0, right: 0.0, top: 20.0),
            child: new Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  child: new Text(
                    _GENERIC_HI,
                    style: TextStyle(
                      fontSize: 18.0,
                      fontFamily: 'Montserrat',
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 20.0),
                  child: new Text(
                    '${mobile_test4}',
                    style: TextStyle(
                      fontSize: 18.0,
                      color: Color(0xff00DD00),
                      fontFamily: 'Montserrat',
                    ),
                  ),
                ),
              ],
            )),
        Padding(
            padding: EdgeInsets.only(left: 10.0, right: 0.0, top: 15.0),
            child: new Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    height: 30.0,
                    width: 30.0,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/images/ic_menu_barcode.jpg')
                          /* borderRadius: BorderRadius.circular(20.0),
        colorFilter: ColorFilter.mode(Colors.green, BlendMode.color),*/

                          ),
                    ),
                  ),
                  flex: 2,
                ),
                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    height: 30.0,
                    width: 30.0,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/images/ic_menu_time.jpg')
                          /*  borderRadius: BorderRadius.circular(20.0),
        colorFilter: ColorFilter.mode(Colors.green, BlendMode.color),
*/
                          ),
                    ),
                  ),
                  flex: 2,
                ),
                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    height: 30.0,
                    width: 30.0,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image:
                              AssetImage('assets/images/ic_menu_distance.jpg')),
                    ),
                  ),
                  flex: 2,
                ),
              ],
            )),
        Padding(
            padding: EdgeInsets.only(left: 10.0, right: 0.0, top: 5.0),
            child: new Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    child: new Text(
                      '${unlock_counts}',
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  flex: 3,
                ),
                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    child: new Text(
                      // '00:00:00',
                      '${total_ride_time}',
                      //   '${mobile_test1}',
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  flex: 3,
                ),
                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    child: new Text(
                      '${total_distance}',
                      //   '${mobile_test2}',
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  flex: 3,
                ),
              ],
            )),
        Padding(
            padding:
                EdgeInsets.only(left: 10.0, right: 0.0, top: 5.0, bottom: 25),
            child: new Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    child: new Text(
                      _GENERIC_UNLOCKS,
                      style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.black38,
                          fontFamily: 'Montserrat'),
                    ),
                  ),
                  flex: 3,
                ),
                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    child: new Text(
                      _GENERIC_MINUTES,
                      style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.black38,
                          fontFamily: 'Montserrat'),
                    ),
                  ),
                  flex: 3,
                ),
                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    child: new Text(
                      _GENERIC_DISTANCE,
                      style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.black38,
                          fontFamily: 'Montserrat'),
                    ),
                  ),
                  flex: 3,
                ),
              ],
            )),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
          ListTile(
            //   leading: Icon(Icons.home),
            title: Text(
              _GENERIC_PROFILE,
              style: TextStyle(
                  color: Color(0xff747474),
                  fontSize: 18,
                  fontFamily: 'Montserrat'),
            ),
            onTap: () => {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => ProfileScreen())),
            },
          ),
          Padding(
              padding: EdgeInsets.only(left: 15.0, right: 0.0, top: 5.0),
              child: new Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: GestureDetector(
                      child: new Text(
                        _GENERIC_WALLET,
                        style: TextStyle(
                            color: Color(0xff747474),
                            fontFamily: 'Montserrat',
                            fontSize: 18),
                      ),
                      onTap: () => {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (BuildContext context) => WalletScreen())),
                      },
                    ),
                    flex: 2,
                  ),
                  Expanded(
                    child: new Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0)),
                        color: Color(0xff00DD00),
                        child: Container(
                          child: InkWell(
                              child: Container(
                            alignment: Alignment.center,
                            child: new Text(
                              '${wallet_amount}',
                              style: TextStyle(
                                fontSize: 20.0,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            height: 40.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(120.0),
                            ),
                          )),
                        )),
                    flex: 2,
                  ),
                ],
              )),

          /*    ListTile(
        //      leading: Icon(Icons.border_color),
              title: Text(_GENERIC_PAYMENTS),
              onTap: () => {  Navigator.of(context).pushReplacement(
    MaterialPageRoute(
    builder: (BuildContext context) => PaymentsScreen()
    )
    ),
    },
            ),*/
          ListTile(
            //       leading: Icon(Icons.exit_to_app),
            title: Text(
              _GENERIC_INVOICE,
              style: TextStyle(
                  color: Color(0xff747474),
                  fontFamily: 'Montserrat',
                  fontSize: 18),
            ),
            onTap: () => {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => InvoiceScreen())),
            },
          ),
          ListTile(
            //       leading: Icon(Icons.exit_to_app),
            title: Text(
              _GENERIC_HELP,
              style: TextStyle(
                  color: Color(0xff747474),
                  fontFamily: 'Montserrat',
                  fontSize: 18),
            ),
            onTap: () => {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) =>
                      RechargeScreen(paymentType))),
            },
          ),
          ListTile(
            //       leading: Icon(Icons.exit_to_app),
            title: Text(
              _GENERIC_SETTINGS,
              style: TextStyle(
                  color: Color(0xff747474),
                  fontFamily: 'Montserrat',
                  fontSize: 18),
            ),
            onTap: () => {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => SettingsScreen())),
            },
          ),
          ListTile(
            //       leading: Icon(Icons.exit_to_app),
            title: Text(
              _GENERIC_INVITE_FRDS,
              style: TextStyle(
                  color: Color(0xff747474),
                  fontFamily: 'Montserrat',
                  fontSize: 18),
            ),
            onTap: () => {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (BuildContext context) =>
                      RidePrepaidScreen(scootertripdetails))),
            },
          ),
          ListTile(
            //       leading: Icon(Icons.exit_to_app),
            title: Text(
              _GENERIC_PROMO_CODE,
              style: TextStyle(
                  color: Color(0xff747474),
                  fontFamily: 'Montserrat',
                  fontSize: 18),
            ),
            onTap: () => {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (BuildContext context) => NewFile())),
            },
          ),
/*          ListTile(
            //       leading: Icon(Icons.exit_to_app),
            title: Text(
              "Hyper Pay",
              style:
                  TextStyle(color: Color(0xff747474), fontFamily: 'Montserrat'),
            ),
            onTap: () => {_requestCheckoutId()},
          ),*/
          ListTile(
            //       leading: Icon(Icons.exit_to_app),
            title: Text(
              _GENERIC_LOGOUT,
              style: TextStyle(
                  color: Color(0xff00DD00),
                  fontSize: 18,
                  fontFamily: 'Montserrat'),
            ),

            onTap: () => {
              /*Navigator.of(context).pushReplacement(
    MaterialPageRoute(
    builder: (BuildContext context) => LoginScreen()
    )
    ),*/
              logout(),
            },
          ),
        ]),
      ],
    );
  }
}

Widget linkMenuDrawer(String title, Function onPressed) {
  return InkWell(
    onTap: onPressed,
    splashColor: Colors.black,
    child: Container(
      padding: EdgeInsets.symmetric(vertical: 13, horizontal: 15),
      width: double.infinity,
      child: Text(
        title,
        style: TextStyle(fontSize: 15.0),
      ),
    ),
  );
}
