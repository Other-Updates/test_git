import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scotto/profile_screen.dart';
import 'package:scotto/ridepostpaidscreen.dart';
import 'package:scotto/rideprepaidscreen.dart';
import 'package:scotto/utils/Language.dart';
import 'package:scotto/wallet_screen.dart';

import 'package:scotto/invoice_screen.dart';
import 'package:scotto/settings_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_screen.dart';
import 'package:scotto/utils/StorageUtil.dart';

class SideDrawerscreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: Colors.green),
        home: Sidedrawer());
  }
}

class Sidedrawer extends StatefulWidget {
  @override
  _SidedrawerState createState() => _SidedrawerState();
}

class _SidedrawerState extends State<Sidedrawer> {
  static const platform = const MethodChannel('Hyperpay.demo.fultter/channel');
  bool _status = true;
  final FocusNode myFocusNode = FocusNode();

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
  var unlock_counts, total_distance, wallet_amount, total_ride_time;

  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  SharedPreferences _sharedPreferences;

  var checkoutId = "";

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

  var scootertripdetails;

  String mobile_test = '';
  String mobile_test1 = '';
  String mobile_test2 = '';
  String mobile_test3 = '';
  String mobile_test4 = '';

  void getTextFromFile() async {
    try {
      String data = await StorageUtil.getItem("unlock_counts");
      String data1 = await StorageUtil.getItem("total_distance");
      String data2 = await StorageUtil.getItem("wallet_amount");
      String data3 = await StorageUtil.getItem("total_ride_time");
      String data4 = await StorageUtil.getItem("login_customer_detail_name");

      setState(() {
        mobile_test = data;
        mobile_test1 = data1;
        mobile_test2 = data2;
        mobile_test3 = data3;
        mobile_test4 = data4;
      });
    } catch (ex) {
      print(ex);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getTextFromFile();
    getLanguage();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          /* DrawerHeader(
            child: Center(
              child: Text(
                'Side menu  FlutterCorner',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 25),
              ),
            ),
            decoration: BoxDecoration(
              color: Colors.black,
            ),
          ),*/

          Padding(
              padding: EdgeInsets.only(left: 10.0, right: 0.0, top: 40.0),
              child: new Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    child: new Text(
                      _GENERIC_HI,
                      style: TextStyle(
                        fontSize: 16.0,
                        fontFamily: 'Montserrat',
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 20.0),
                    child: new Text(
                      '${mobile_test4}',
                      style: TextStyle(
                        fontSize: 16.0,
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
                      height: 25.0,
                      width: 25.0,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image:
                                AssetImage('assets/images/ic_menu_barcode.jpg')
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
                      height: 25.0,
                      width: 25.0,
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
                      height: 25.0,
                      width: 25.0,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage(
                                'assets/images/ic_menu_distance.jpg')),
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
                        '0',
                        //    '${mobile_test}',
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
                        '00:00:00',
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
                        '0',
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
              padding: EdgeInsets.only(left: 10.0, right: 0.0, top: 5.0),
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
          ListTile(
            //   leading: Icon(Icons.home),
            title: Text(
              _GENERIC_PROFILE,
              style:
                  TextStyle(color: Color(0xff747474), fontFamily: 'Montserrat'),
            ),
            onTap: () => {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (BuildContext context) => ProfileScreen())),
            },
          ),
          /*  ListTile(

    //        leading: Icon(Icons.shopping_cart),
              title: Text('Wallet'),
              onTap: () => {
                //     Navigator.of(context).pop()},
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                        builder: (BuildContext context) => WalletScreen()
                    )

                ),
              },




            ),*/
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
                            color: Color(0xff747474), fontFamily: 'Montserrat'),
                      ),
                      onTap: () => {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
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
                              '0.0',
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
              style:
                  TextStyle(color: Color(0xff747474), fontFamily: 'Montserrat'),
            ),
            onTap: () => {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (BuildContext context) => InvoiceScreen())),
            },
          ),
          ListTile(
            //       leading: Icon(Icons.exit_to_app),
            title: Text(
              _GENERIC_HELP,
              style:
                  TextStyle(color: Color(0xff747474), fontFamily: 'Montserrat'),
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
              _GENERIC_SETTINGS,
              style:
                  TextStyle(color: Color(0xff747474), fontFamily: 'Montserrat'),
            ),
            onTap: () => {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (BuildContext context) => SettingsScreen())),
            },
          ),
          ListTile(
            //       leading: Icon(Icons.exit_to_app),
            title: Text(
              _GENERIC_INVITE_FRDS,
              style:
                  TextStyle(color: Color(0xff747474), fontFamily: 'Montserrat'),
            ),
          ),
          ListTile(
            //       leading: Icon(Icons.exit_to_app),
            title: Text(
              _GENERIC_PROMO_CODE,
              style:
                  TextStyle(color: Color(0xff747474), fontFamily: 'Montserrat'),
            ),
            onTap: () => {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (BuildContext context) =>
                      RidePostpaidScreen(scootertripdetails))),
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
              style:
                  TextStyle(color: Color(0xff00DD00), fontFamily: 'Montserrat'),
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
        ],
      ),
    );
  }
}
/*
  Future<String> _requestCheckoutId() async {
    var status;
    String basicAuth = "Basic YWRtaW46MTIzNA==";
    String myUrl =
        "https://demo.f2fsolutions.co.in/ScooterO/api/api_prepare_checkout";
    var data = json.encode({
      "amount": "26.00",
      "card_holder_name": "Kalai",
      "card_number": "4200000000000000",
      "cvv": "123",
      "expire_month": "07",
      "expire_year": "2021",
      "grand_total": "28.75",
      "id": "36",
      "payment_method": "debit",
      "ride_time_taken": "10",
      "scootoro_id": "1",
      "subscription_id": "1",
      "total_rent": "20.0",
      "total_ride_rent": "20",
      "unlock_charge": "5",
      "vat_charge": "3.75",
      "currency": ""
    });
    final response = await http.post(myUrl,
        headers: {'authorization': basicAuth}, body: data);
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      print('api_prepare_checkout :$jsonResponse');
      if (jsonResponse['status'] == "Success") {
        var data = jsonResponse['data'];
        checkoutId = data['id'];
        print("Got Checkout ID: $checkoutId");
        _pay();
      } else if (jsonResponse['status'] == 'Error') {
        // _showMessageInScaffold(jsonResponse['message']);
      }
    } else {
      // _showMessageInScaffold('Contact Admin!!');
    }
  }

  Future<void> getpaymentstatus() async {
    var status;
    String basicAuth = "Basic YWRtaW46MTIzNA==";
    String myUrl =
        "https://demo.f2fsolutions.co.in/ScooterO/api/api_payment_status";
    var data = json.encode({"checkout_id": checkoutId});
    final response = await http.post(myUrl,
        headers: {'authorization': basicAuth}, body: data);
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      print('api_payment_status : $jsonResponse');
      if (jsonResponse['status'] == "Success") {
        var data = jsonResponse['data'];
      } else if (jsonResponse['status'] == 'Error') {
        // _showMessageInScaffold(jsonResponse['message']);
      }
    } else {
      // _showMessageInScaffold('Contact Admin!!');
    }
  }

  Future<void> _pay() async {
    String _MadaRegexV =
        "4(0(0861|1757|7(197|395)|9201)|1(0685|7633|9593)|2(281(7|8|9)|8(331|67(1|2|3)))|3(1361|2328|4107|9954)|4(0(533|647|795)|5564|6(393|404|672))|5(5(036|708)|7865|8456)|6(2220|854(0|1|2|3))|8(301(0|1|2)|4783|609(4|5|6)|931(7|8|9))|93428)";
    String _MadaRegexM =
        "5(0(4300|8160)|13213|2(1076|4(130|514)|9(415|741))|3(0906|1095|2013|5(825|989)|6023|7767|9931)|4(3(085|357)|9760)|5(4180|7606|8848)|8(5265|8(8(4(5|6|7|8|9)|5(0|1))|98(2|3))|9(005|206)))|6(0(4906|5141)|36120)|9682(0(1|2|3|4|5|6|7|8|9)|1(0|1))";
    String transactionStatus;
    try {
      final String result = await platform.invokeMethod('gethyperpayresponse', {
        "type": "customUI",
        "checkoutid": checkoutId,
        "mode": "TEST",
        "brand": "credit",
        "card_number": "4200000000000000",
        "holder_name": "Kalai",
        "month": "07",
        "year": "2021",
        "cvv": "123",
        "STCPAY": "disabled",
        "Amount": 1,
        "MadaRegexV": _MadaRegexV,
        "MadaRegexM": _MadaRegexM,
      });
      transactionStatus = '$result';
    } on PlatformException catch (e) {
      transactionStatus = "${e.message}";
    }

    if (transactionStatus != null ||
        transactionStatus == "success" ||
        transactionStatus == "SYNC") {
      print("Success");
      getpaymentstatus();
    } else {
      print("Failure");
    }
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    myFocusNode.dispose();
    super.dispose();
  }
}
*/
