import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:scotto/Scprogressdialog.dart';
import 'package:http/http.dart' as http;
import 'package:scotto/utils/Language.dart';
import 'package:scotto/utils/StorageUtil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'constants.dart';

class WalletScreen extends StatefulWidget {
  @override
  WalletScreenState createState() => WalletScreenState();
}

class WalletScreenState extends State<WalletScreen> {
  GlobalKey<ScaffoldState> _key = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  var _GENERIC_WALLET = ' ',
      _GENERIC_AVAILABLE_BAL = '',
      _GENERIC_TYPE = '',
      _GENERIC_AMOUNT = '',
      _GENERIC_SOURCE = '',
      _GENERIC_CODE = '',
      _GENERIC_DATE = '',
      _GENERIC_TXN_NO = '';

  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  SharedPreferences _sharedPreferences;

  getLanguage() async {
    _sharedPreferences = await _prefs;
    // print(Language.getLocalLanguage(_sharedPreferences,'GENERIC_LOGIN'));
    setState(() {
      _GENERIC_WALLET =
          Language.getLocalLanguage(_sharedPreferences, "GENERIC_WALLET");
      _GENERIC_AVAILABLE_BAL = Language.getLocalLanguage(
          _sharedPreferences, "GENERIC_AVAILABLE_BAL");
      _GENERIC_TYPE =
          Language.getLocalLanguage(_sharedPreferences, "GENERIC_TYPE");
      _GENERIC_AMOUNT =
          Language.getLocalLanguage(_sharedPreferences, "GENERIC_AMOUNT");
      _GENERIC_SOURCE =
          Language.getLocalLanguage(_sharedPreferences, "GENERIC_SOURCE");
      _GENERIC_CODE =
          Language.getLocalLanguage(_sharedPreferences, "GENERIC_CODE");
      _GENERIC_DATE =
          Language.getLocalLanguage(_sharedPreferences, "GENERIC_DATE");
      _GENERIC_TXN_NO =
          Language.getLocalLanguage(_sharedPreferences, "GENERIC_TXN_NO");
    });
  }

  String customer_id = '';

  getTextFromFile() async {
    try {
      String data = await StorageUtil.getItem("login_customer_detail_id");

      setState(() {
        customer_id = data;
      });
    } catch (ex) {
      print(ex);
    }
  }

  walletDetails() async {
    await getTextFromFile();
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Scprogressdialog("Fetching invoice details");
        });
    String basicAuth = "Basic YWRtaW46MTIzNA==";
    var data = json.encode({"customer_id": customer_id});
    print(data);
    final response = await http.post(baseurl + 'api_customer_wallet_details',
        headers: {'authorization': basicAuth}, body: data);
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      print(jsonResponse);
      if (jsonResponse['status'] == "Success") {
        Navigator.pop(context);
        _showMessageInScaffold(jsonResponse['message']);
        // Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => HomeScreen()), (Route<dynamic> route) => false);
      } else if (jsonResponse['status'] == 'Error') {
        Navigator.pop(context);
        _showMessageInScaffold(jsonResponse['message']);
      }
      //   sharedPreferences.setString("token", jsonResponse['token']);
    } else {
      Navigator.pop(context);
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
    getLanguage();
    walletDetails();
  }

  Widget build(BuildContext context) {
    return Scaffold(
        key: _key,
        appBar: AppBar(
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back_ios_rounded,
              color: Colors.white, // add custom icons also
            ),
          ),
          title: Text(
            _GENERIC_WALLET,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
                fontFamily: 'Montserrat',
                color: Colors.white),
          ),
          centerTitle: true,
          backgroundColor: Color(0xff00DD00),
          shadowColor: Color(0xff00DD00),
        ),
        body: Center(
            child: Container(
                child: ListView(children: <Widget>[
          Container(
              child: new CustomPaint(
            painter: ShapesPainter(),
            child: Container(
              height: 200,
              width: 460,
              child: Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(top: 100.0),
                    child: Text(
                      '0.00 SAR',
                      style: TextStyle(
                        fontSize: 20,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Text(
                    'Available Balance',
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  )
                ],
              ),
            ),
          )),
          new Container(
            alignment: Alignment.center,
            padding: EdgeInsets.only(top: 150.0),
            child: Text(
              'No Wallet details found',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff676767),
                  fontFamily: 'Montserrat'),
            ),
          ),
        ]))));
  }
}

const double _kCurveHeight = 35;

class ShapesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final p = Path();
    p.lineTo(0, size.height - _kCurveHeight);
    p.relativeQuadraticBezierTo(
        size.width / 2, 2 * _kCurveHeight, size.width, 0);
    p.lineTo(size.width, 0);
    p.close();

    canvas.drawPath(
      p,
      Paint()..color = Color(0xff00DD00),
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
