import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:scotto/adddebitcardscreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:scotto/constants.dart';
import 'package:scotto/rechargescreen.dart';
import 'package:scotto/utils/DatabaseHelper.dart';
import 'package:scotto/utils/Language.dart';
import 'package:scotto/utils/StorageUtil.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChooseRidePlanScreen extends StatefulWidget {
  final scootoroAllDetails, paymentType;
  ChooseRidePlanScreen(this.scootoroAllDetails, this.paymentType);
  @override
  _ChooseRidePlanScreenState createState() =>
      _ChooseRidePlanScreenState(this.scootoroAllDetails, this.paymentType);
}

class _ChooseRidePlanScreenState extends State<ChooseRidePlanScreen> {
  var _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  var scootoroAllDetails,
      paymentType,
      radioValue = "",
      unlock_charge,
      paymentParameter;

  _ChooseRidePlanScreenState(this.scootoroAllDetails, this.paymentType);
  var _GENERIC_CHOOSE_RIDE_PLAN = ' ', _GENERIC_ADD_PAYMENT_METHOD = ' ';

  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  SharedPreferences _sharedPreferences;

  List subscription_details = [];
  var id = '', Subscriptions = '', name = '', mins = '', amount = '';
  List<String> Names = [
    'Abhishek',
    'John',
    'Robert',
    'Shyam',
    'Sita',
    'Gita',
    'Nitish'
  ];
  List data;

  var detail_min, detail_amount, sub_total, vat, grantTotal;

  getLanguage() async {
    _sharedPreferences = await _prefs;
    setState(() {
      _GENERIC_CHOOSE_RIDE_PLAN = Language.getLocalLanguage(
          _sharedPreferences, 'GENERIC_CHOOSE_RIDE_PLAN');
    });
  }

  String customer_id = '';

  getTextFromFile() async {
    try {
      String data = await StorageUtil.getItem("login_customer_detail_id");

      setState(() {
        customer_id = data;
        print(data);
      });
    } catch (ex) {
      print(ex);
    }
  }

  subscriptions() async {
    await getTextFromFile();

    var data = json.encode({
      "id": customer_id,
    });
    final response = await http.post(baseurl + 'api_subscription_plan',
        headers: {'authorization': basicAuth}, body: data);
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      if (jsonResponse['status'] == 'Success') {
        print(jsonResponse);
        setState(() {
          subscription_details = jsonResponse['subscription_details'];
          var settings = jsonResponse['settings'];
          unlock_charge = settings['unlock_charge'];
          print(unlock_charge);
          print(sub_total);
        });
      } else if (jsonResponse['status'] == 'Error') {
        _showMessageInScaffold(jsonResponse['message']);
      }
    } else {
      _showMessageInScaffold('Contact Admin!!');
    }
  }

  // AddDebitCardScreen(paymentParameter)
  handleRadioValueChanged(value) {
    print(this.scootoroAllDetails);
    setState(() {
      radioValue = value;
    });
    for (int i = 0; i < subscription_details.length; i++) {
      if (subscription_details[i]['id'] == value) {
        print(subscription_details[i]);
        var detail = subscription_details[i];
        setState(() {
          detail_min = detail['mins'];
          detail_amount = detail['amount'];
          sub_total = int.parse(detail_amount) + int.parse(unlock_charge);
          vat = sub_total / 100;
          grantTotal = sub_total + vat;

          paymentParameter = {
            'min': detail_min,
            'amount': detail_amount,
            'sub_total': sub_total,
            'vat': vat,
            'grantTotal': grantTotal,
            'subscription_id': subscription_details[i]['id'],
            'paymentType': paymentType,
            'scooter_id': scootoroAllDetails['scooter_id'],
            'serial_number': scootoroAllDetails['serial_number'],
            'unlock_charge': unlock_charge
          };
        });
      }
    }
  }

  pay() async {
    if (DatabaseHelper.queryRowCount() == 0) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context) =>
              AddDebitCardScreen(paymentParameter)));
    } else {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context) => RechargeScreen(paymentParameter)));
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

  @override
  void initState() {
    super.initState();
    subscriptions();
    getLanguage();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        key: _scaffoldKey,
        backgroundColor: Color(0xffE6FFE6),
        appBar: AppBar(
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back_ios,
              color: Colors.white, // add custom icons also
            ),
          ),
          title: Text(
            _GENERIC_CHOOSE_RIDE_PLAN,
            style: TextStyle(
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.bold,
                color: Colors.white),
          ),
          centerTitle: true,
          backgroundColor: Color(0xff00DD00),
        ),
        body: new Column(children: <Widget>[
          Flexible(
              child: ListView.builder(
            // reverse: false,
            itemCount: subscription_details.length,
            itemBuilder: (context, int index) =>
                EachList(subscription_details[index]),
          )),

          //  ),
          (radioValue != '')
              ? Flexible(
                  child: new Card(
                    color: Colors.white,
                    child: new Column(children: [
                      Container(
                          padding: EdgeInsets.only(top: 15),
                          child: new Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Flexible(
                                  child: Padding(
                                      padding: EdgeInsets.only(right: 10.0),
                                      child: Container(
                                          alignment: Alignment.centerLeft,
                                          padding: EdgeInsets.only(left: 15),

                                          //   height: MediaQuery.of(context).size.height ,
                                          //  width:MediaQuery.of(context).size.width
                                          child: Text(
                                              'Total Ride Time- ${detail_min} Minutes'))),
                                  flex: 2,
                                ),
                                Flexible(
                                  child: Padding(
                                      padding: EdgeInsets.only(right: 10.0),
                                      child: Container(
                                        alignment: Alignment.centerRight,
                                        child: Text('${detail_amount}SAR'),
                                      )),
                                  flex: 2,
                                ),
                              ])),
                      Container(
                          padding: EdgeInsets.only(top: 15),
                          child: new Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Flexible(
                                  child: Padding(
                                      padding: EdgeInsets.only(right: 10.0),
                                      child: Container(
                                          alignment: Alignment.centerLeft,
                                          padding: EdgeInsets.only(left: 15),
                                          child: Text('Unlock Charge'))),
                                  flex: 2,
                                ),
                                Flexible(
                                  child: Padding(
                                      padding: EdgeInsets.only(right: 10.0),
                                      child: Container(
                                        alignment: Alignment.centerRight,
                                        child: Text('${unlock_charge} SAR'),
                                      )),
                                  flex: 2,
                                ),
                              ])),
                      Container(
                          padding: EdgeInsets.only(top: 15),
                          child: new Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Flexible(
                                  child: Padding(
                                      padding: EdgeInsets.only(right: 10.0),
                                      child: Container(
                                          alignment: Alignment.centerLeft,
                                          padding: EdgeInsets.only(left: 15),
                                          child: Text('Sub Total'))),
                                  flex: 2,
                                ),
                                Flexible(
                                  child: Padding(
                                      padding: EdgeInsets.only(right: 10.0),
                                      child: Container(
                                        alignment: Alignment.centerRight,
                                        child: Text('${sub_total} SAR'),
                                      )),
                                  flex: 2,
                                ),
                              ])),
                      Container(
                          padding: EdgeInsets.only(top: 10, bottom: 15),
                          child: new Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Flexible(
                                  child: Padding(
                                      padding: EdgeInsets.only(right: 10.0),
                                      child: Container(
                                          alignment: Alignment.centerLeft,
                                          padding: EdgeInsets.only(left: 15),

                                          //   height: MediaQuery.of(context).size.height ,
                                          //  width:MediaQuery.of(context).size.width
                                          child: Text('VAT'))),
                                  flex: 2,
                                ),
                                Flexible(
                                  child: Padding(
                                      padding: EdgeInsets.only(right: 10.0),
                                      child: Container(
                                        alignment: Alignment.centerRight,
                                        child: Text('${vat} SAR'),
                                      )),
                                  flex: 2,
                                ),
                              ])),
                      Container(
                          padding: EdgeInsets.only(top: 15, bottom: 15),
                          // child: new Card(
                          color: Color(0xffE6FFE6),
                          child: new Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Flexible(
                                  child: Padding(
                                      padding: EdgeInsets.only(right: 10.0),
                                      child: Container(
                                          alignment: Alignment.centerLeft,
                                          padding: EdgeInsets.only(left: 15),

                                          //   height: MediaQuery.of(context).size.height ,
                                          //  width:MediaQuery.of(context).size.width
                                          child: Text('Grand Total'))),
                                  flex: 2,
                                ),
                                Flexible(
                                  child: Padding(
                                      padding: EdgeInsets.only(right: 10.0),
                                      child: Container(
                                        alignment: Alignment.centerRight,
                                        child: Text('${grantTotal} SAR'),
                                      )),
                                  flex: 2,
                                ),
                              ])),
                    ]),
                  ),
                )
              : Container(),
          (radioValue != '')
              ? Flexible(
                  //  height: 55,
                  //    padding: EdgeInsets.fromLTRB(15,8, 15, 0),
                  child: Container(
                      height: 55,
                      width: double.infinity,
                      padding: EdgeInsets.fromLTRB(15, 8, 15, 0),
                      child: RaisedButton(
                        // padding:  EdgeInsets.fromLTRB(190,10, 190, 10),
                        textColor: Colors.white,
                        color: Color(0xff00DD00),
                        child: Text('Pay',
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold,
                            )),
                        shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(8.0),
                        ),
                        onPressed: () {
                          pay();
                        },
                      )))
              : Container(),
        ]));
  }

  Widget EachList(subscription_detail) {
    return Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
        color: Colors.white,
        child: new Column(children: [
          Container(
              padding: EdgeInsets.only(left: 10),
              child: new Row(
                  //      mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Flexible(
                      child: Container(
                          alignment: Alignment.centerLeft,
                          child: new Text(
                            '${subscription_detail["mins"]} Minutes',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          )),
                      flex: 3,
                    ),
                    Flexible(
                      child: Container(
                        alignment: Alignment.center,
                        child: new Text(
                          '${subscription_detail["amount"]} SAR',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            color: Colors.black54,
                          ),
                        ),
                      ),
                      flex: 3,
                    ),
                    Flexible(
                      child: Container(
                          alignment: Alignment.centerRight,
                          //    padding: EdgeInsets.only(left: 80.0),
                          child: new Radio(
                            autofocus: true,
                            value: '${subscription_detail["id"]}',
                            groupValue: radioValue,
                            hoverColor: Color(0xff00DD00),
                            focusColor: Color(0xff00DD00),
                            activeColor: Color(0xff00DD00),
                            onChanged: (String value) {
                              handleRadioValueChanged(value);
                            },
                          )),
                      flex: 3,
                    ),
                  ])),
        ]));
  }
}
