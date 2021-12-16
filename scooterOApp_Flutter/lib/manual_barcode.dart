import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:scotto/Scprogressdialog.dart';
import 'package:scotto/paymentmethodscreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:scotto/constants.dart';
import 'package:scotto/utils/Language.dart';
import 'package:scotto/utils/StorageUtil.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ManualBarcodeScreen extends StatefulWidget {
  @override
  _ManualBarcodeScreenState createState() => _ManualBarcodeScreenState();
}

class _ManualBarcodeScreenState extends State<ManualBarcodeScreen> {
  var _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController entercodeController = TextEditingController();
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  SharedPreferences _sharedPreferences;
  var _GENERIC_ENTER_QR = ' ',
      _GENERIC_ENTER_QR_CODE = '',
      _GENERIC_UNLOCK_SCOOTER = '';
  var serial_number = '',
      battery_life = '',
      scooter_id = '',
      scootoroAllDetails;
  var customer_details, scootoroDetails;

  String customer_id = '';

  void getTextFromFile() async {
    try {
      String data = await StorageUtil.getItem("login_customer_detail_id");
      setState(() {
        customer_id = data;
      });
    } catch (ex) {
      print(ex);
    }
  }

  unlockScooter() async {
    final isValid = _formKey.currentState.validate();
    if (!isValid) {
      Navigator.pop(context);
      return;
    }
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Scprogressdialog(" Getting scooter details");
        });
    if (entercodeController.text == "") {
      _showMessageInScaffold("Enter QR code");
    }
    var cus = customer_id;
    var data = json.encode({
      "qr_code": entercodeController.text,
      "customer_id": cus,
      "scoo_lat": "12.12222",
      "scoo_long": "13.25666"
    });
    final response = await http.post(baseurl + 'scan_qr_code',
        headers: {'authorization': basicAuth}, body: data);

    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      if (jsonResponse['status'] == 'Success') {
        Navigator.pop(context);
        var scootoroDetails = jsonResponse['scootoro_details'];
        setState(() {
          scootoroAllDetails = scootoroDetails;
          scooter_id = scootoroDetails['scooter_id'];
          serial_number = scootoroDetails['serial_number'];
          battery_life = scootoroDetails['battery_life'];
        });
        showModalBottomSheet1();
      } else if (jsonResponse['status'] == 'Error') {
        Navigator.pop(context);
        _showMessageInScaffold(jsonResponse['message']);
      }
    } else {
      _showMessageInScaffold('Contact Admin!!');
    }
  }

  getLanguage() async {
    _sharedPreferences = await _prefs;
    setState(() {
      _GENERIC_ENTER_QR =
          Language.getLocalLanguage(_sharedPreferences, 'GENERIC_ENTER_QR');
      _GENERIC_ENTER_QR_CODE = Language.getLocalLanguage(
          _sharedPreferences, "GENERIC_ENTER_QR_CODE");
      _GENERIC_UNLOCK_SCOOTER = Language.getLocalLanguage(
          _sharedPreferences, "GENERIC_UNLOCK_SCOOTER");
    });
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

  @override
  void initState() {
    super.initState();
    getLanguage();
    getTextFromFile();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
        ),
        title: Text(
          _GENERIC_ENTER_QR,
          style: TextStyle(color: Colors.white, fontFamily: 'Montserrat'),
        ),
        centerTitle: true,
        backgroundColor: Color(0xff00DD00),
        actions: <Widget>[
          IconButton(
              icon: Icon(
                Icons.account_balance_wallet_rounded,
                color: Colors.white,
              ),
              onPressed: () {}),
        ],
      ),
      body: new Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/background.png'),
                colorFilter: ColorFilter.mode(
                    Color(0xffF1FDF0).withOpacity(1.0), BlendMode.dstATop),
                fit: BoxFit.cover)),
        child: ListView(
          children: <Widget>[
            Form(
              key: _formKey,
              child: Container(
                padding: EdgeInsets.fromLTRB(14, 15, 14, 0),
                child: TextFormField(
                  validator: (val) => val.isNotEmpty ? null : "Enter QR code",
                  controller: entercodeController,
                  decoration: InputDecoration(
                    isDense: true,
                    hintText: _GENERIC_ENTER_QR_CODE,
                    hintStyle:
                        TextStyle(color: Colors.grey, fontFamily: 'Montserrat'),
                    filled: true,
                    fillColor: Colors.white,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      borderSide:
                          BorderSide(color: Color(0xff00DD00), width: 0.8),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      borderSide:
                          BorderSide(color: Color(0xff00DD00), width: 0.8),
                    ),
                  ),
                ),
              ),
            ),
            Container(
                height: 50,
                margin: EdgeInsets.fromLTRB(14, 15, 14, 0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: RaisedButton(
                  textColor: Colors.white,
                  color: Color(0xff00DD00),
                  shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(8.0),
                  ),
                  child: Text(
                    _GENERIC_UNLOCK_SCOOTER,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  onPressed: () => unlockScooter(),
                )),
          ],
        ),
      ),
    );
  }

  Future showModalBottomSheet1() async {
    return showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25), topRight: Radius.circular(25)),
        ),
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context) {
          return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30)),
              ),
              // height: 250.0,
              child: new Column(mainAxisSize: MainAxisSize.min, children: [
                Container(
                    height: 200,
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: new Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Flexible(
                          child: Padding(
                            padding: EdgeInsets.only(right: 10.0),
                            child: Container(
                              height: 180,
                              width: 150,
                              //   height: MediaQuery.of(context).size.height ,
                              //  width:MediaQuery.of(context).size.width
                              child: Image.asset(
                                  'assets/images/img_scooter.png',
                                  fit: BoxFit.fill),
                            ),
                          ),
                          flex: 2,
                        ),
                        Flexible(
                          child: Padding(
                            padding: EdgeInsets.only(right: 10.0),
                            child: Container(
                                padding: EdgeInsets.only(top: 20.0, left: 10.0),
                                child: Column(
                                  // mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      alignment: Alignment.topLeft,
                                      child: Image.asset(
                                          'assets/images/ic_scooter.png',
                                          width: 25,
                                          height: 25,
                                          fit: BoxFit.fill),
                                    ),
                                    Container(
                                      padding: EdgeInsets.only(top: 5.0),
                                      child: new Row(children: <Widget>[
                                        Container(
                                          child: Text(
                                            'ScooterO',
                                            style: TextStyle(
                                                color: Colors.black54),
                                          ),
                                        ),
                                        Container(
                                          padding: EdgeInsets.only(left: 8.0),
                                          child: Text(
                                            '${serial_number}',
                                            style: TextStyle(
                                                color: Colors.black54),
                                          ),
                                        ),
                                      ]),
                                    ),
                                    Container(
                                      alignment: Alignment.topLeft,
                                      padding: EdgeInsets.only(top: 70.0),
                                      child: Image.asset(
                                          'assets/images/ic_battery.png',
                                          width: 20,
                                          height: 25,
                                          fit: BoxFit.fill),
                                    ),
                                    Container(
                                      padding: EdgeInsets.only(top: 5.0),
                                      child: new Row(children: <Widget>[
                                        Container(
                                          child: Text(
                                            'Battery',
                                            style: TextStyle(
                                                color: Colors.black54),
                                          ),
                                        ),
                                        Container(
                                          padding: EdgeInsets.only(left: 8.0),
                                          child: Text(
                                            '${battery_life}',
                                            style: TextStyle(
                                                color: Colors.black54),
                                          ),
                                        ),
                                      ]),
                                    ),
                                  ],
                                )),
                            //   height: MediaQuery.of(context).size.height ,
                            //  width:MediaQuery.of(context).size.width
                          ),
                          flex: 2,
                        ),
                      ],
                    )),
                Container(
                    height: 75,
                    width: double.infinity,
                    padding: EdgeInsets.fromLTRB(20, 14, 20, 15),
                    child: RaisedButton(
                      textColor: Colors.white,
                      color: Color(0xff00DD00),
                      child: Text(
                        _GENERIC_UNLOCK_SCOOTER,
                        style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold,
                            fontSize: 17),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(8.0),
                      ),
                      onPressed: () => Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (BuildContextcontext) =>
                                  PaymentMethodScreen(scootoroAllDetails))),
                    )),
              ]));
        });
  }
}
