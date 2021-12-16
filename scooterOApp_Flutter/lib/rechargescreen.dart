import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:scotto/Scprogressdialog.dart';
import 'package:scotto/adddebitcardscreen.dart';
import 'package:scotto/constants.dart';
import 'package:scotto/home_screen.dart';
import 'package:scotto/rideprepaidscreen.dart';
import 'package:scotto/utils/DatabaseHelper.dart';
import 'package:scotto/utils/Language.dart';
import 'package:scotto/utils/SqliteModel.dart';
import 'package:scotto/utils/StorageUtil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class RechargeScreen extends StatefulWidget {
  final paymentType;
  RechargeScreen(this.paymentType);
  @override
  _RechargeScreenState createState() => _RechargeScreenState(this.paymentType);
}

class _RechargeScreenState extends State<RechargeScreen> {
  final paymentParameter;
  _RechargeScreenState(this.paymentParameter);
  var _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  var _GENERIC_RECHARGE = ' ',
      _GENERIC_PAYMENT = '',
      _GENERIC_ADD_NEW_CARD = '',
      _GENERIC_ADDED_CARDS = ' ',
      _GENERIC_PAY = '';

  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  SharedPreferences _sharedPreferences;
  var checkoutId = "";

  static const platform = const MethodChannel('Hyperpay.demo.fultter/channel');
  bool _status = true;

  getLanguage() async {
    _sharedPreferences = await _prefs;
    // print(Language.getLocalLanguage(_sharedPreferences,'GENERIC_LOGIN'));
    setState(() {
      _GENERIC_RECHARGE =
          Language.getLocalLanguage(_sharedPreferences, 'GENERIC_RECHARGE');
      _GENERIC_PAYMENT =
          Language.getLocalLanguage(_sharedPreferences, "GENERIC_PAYMENT");
      _GENERIC_ADD_NEW_CARD =
          Language.getLocalLanguage(_sharedPreferences, "GENERIC_ADD_NEW_CARD");
      _GENERIC_ADDED_CARDS =
          Language.getLocalLanguage(_sharedPreferences, "GENERIC_ADDED_CARDS");
      ;
      _GENERIC_PAY =
          Language.getLocalLanguage(_sharedPreferences, "GENERIC_PAY");
    });
  }

  List<DebitCardSave> listCard = [];

  Future<List<Map<String, dynamic>>> getCard() async {
    List<Map<String, dynamic>> listMap =
        await DatabaseHelper.instance.queryAllRows();
    setState(() {
      listMap.forEach((map) => listCard.add(DebitCardSave.fromMap(map)));
      print(listCard);
    });
  }

  var trip_number,
      customer_id,
      scooter_id,
      payment_id,
      subscription_id,
      ride_start,
      ride_mins,
      total_ride_amt,
      unlock_charge,
      sub_total,
      vat_charge,
      grand_total,
      scootertripdetails;

  String mobile_test = '';

  void getTextFromFile() async {
    try {
      String data = await StorageUtil.getItem("login_customer_detail_id");

      setState(() {
        mobile_test = data;
        print(mobile_test);
      });
    } catch (ex) {
      print(ex);
    }
  }

  Future<String> _requestCheckoutId() async {
    await getTextFromFile();
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Scprogressdialog("Payment in process");
        });
    var status;
    String basicAuth = "Basic YWRtaW46MTIzNA==";
    String myUrl = baseurl + 'api_prepare_checkout';
    var data = json.encode({
      "amount": paymentParameter['grantTotal'],
      "card_holder_name": card_name,
      "card_number": card_number,
      "cvv": card_cvv,
      "expire_month": card_month,
      "expire_year": card_year,
      "grand_total": paymentParameter['grantTotal'],
      "id": mobile_test,
      "payment_method": "debit",
      "ride_time_taken": paymentParameter['min'],
      "scootoro_id": paymentParameter['scooter_id'],
      "subscription_id": paymentParameter['subscription_id'],
      "total_rent": paymentParameter['grantTotal'],
      "total_ride_rent": paymentParameter['grantTotal'],
      "unlock_charge": paymentParameter['unlock_charge'],
      "vat_charge": paymentParameter['vat'],
      "currency": "SAR"
    });
    print(data);
    final response = await http.post(myUrl,
        headers: {'authorization': basicAuth}, body: data);
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      print('api_prepare_checkout :$jsonResponse');
      if (jsonResponse['status'] == "Success") {
        var data = jsonResponse['data'];
        checkoutId = data['id'];
        print("Got Checkout ID: $checkoutId");
        _showMessageInScaffold(jsonResponse['message']);
        _pay();
      } else if (jsonResponse['status'] == 'Error') {
        _showMessageInScaffold(jsonResponse['message']);
      }
    } else {
      _showMessageInScaffold('Contact Admin!!');
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
        "brand": "debit",
        "card_number": card_number,
        "holder_name": card_name,
        "month": card_month,
        "year": card_year,
        "cvv": card_cvv,
        "STCPAY": "disabled",
        "Amount": paymentParameter['grantTotal'],
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

  paymentapistatus() async {
    print(this.paymentParameter);
    var data = json.encode({
      "id": mobile_test,
      "scootoro_id": paymentParameter['scooter_id'],
      "ride_time_taken": paymentParameter['min'],
      "subscription_id": paymentParameter['subscription_id'],
      "total_rent": paymentParameter['grantTotal'],
      "total_ride_rent": paymentParameter['grantTotal'],
      "unlock_charge": paymentParameter['unlock_charge'],
      "vat_charge": paymentParameter['vat'],
      "grand_total": paymentParameter['grantTotal'],
      "payment_method": "debit",
      "card_holder_name": card_name,
      "card_number": card_number,
      "expire_year": card_year,
      "expire_month": card_month,
      "cvv": card_cvv,
      "amount": paymentParameter['grantTotal'],
    });

    print(data);
    final response = await http.post(baseurl + 'api_payments',
        headers: {'authorization': basicAuth}, body: data);
    print(response.body);
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      if (jsonResponse['status'] == 'Success') {
        var trip_details = jsonResponse['trip_details'];
        setState(() {
          scootertripdetails = trip_details;
          trip_number = trip_details['trip_number'];
          customer_id = trip_details['customer_id'];
          scooter_id = trip_details['scooter_id'];
          payment_id = trip_details['payment_id'];
          subscription_id = trip_details['subscription_id'];
          ride_start = trip_details['ride_start'];
          ride_mins = trip_details['ride_mins'];
          total_ride_amt = trip_details['total_ride_amt'];
          unlock_charge = trip_details['unlock_charge'];
          sub_total = trip_details['sub_total'];
          vat_charge = trip_details['vat_charge'];
          grand_total = trip_details['grand_total'];
        });
        _showMessageInScaffold(jsonResponse['message']);
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (BuildContext context) =>
                    RidePrepaidScreen(trip_details)),
            (Route<dynamic> route) => false);
      } else if (jsonResponse['status'] == 'Error') {
        _showMessageInScaffold(jsonResponse['message']);
      }
    } else {
      //    _showMessageInScaffold(Color(0xff00DD00), 'Contact Admin!!');
    }
  }

  Future<void> getpaymentstatus() async {
    var status;
    String basicAuth = "Basic YWRtaW46MTIzNA==";
    String myUrl = baseurl + "api_payment_status";
    var data = json.encode({"checkout_id": checkoutId});
    final response = await http.post(myUrl,
        headers: {'authorization': basicAuth}, body: data);
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      print('api_payment_status : $jsonResponse');
      if (jsonResponse['status'] == "Success") {
        var data = jsonResponse['data'];
        _showMessageInScaffold(jsonResponse['message']);
        paymentapistatus();
      } else if (jsonResponse['status'] == 'Error') {
        _showMessageInScaffold(jsonResponse['message']);
      }
    } else {
      _showMessageInScaffold('Contact Admin!!');
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
    getTextFromFile();
    getLanguage();
    getCard();
  }

  var radioValue = "";

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.close,
            color: Colors.white, // add custom icons also
          ),
        ),
        title: Text(
          _GENERIC_RECHARGE,
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
      body: new Column(
        children: <Widget>[
          Container(
            alignment: Alignment.topLeft,
            padding: EdgeInsets.only(left: 15, top: 15),
            child: Text(
              _GENERIC_PAYMENT,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Montserrat',
                  fontSize: 18,
                  color: Colors.black54),
            ),
          ),
          Container(
              padding: EdgeInsets.only(top: 15, bottom: 20.0),
              child:
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Expanded(
                  child: Container(
                      padding: EdgeInsets.only(left: 15),
                      height: 50,
                      child: RaisedButton(
                        textColor: Colors.white,
                        color: Color(0xff00DD00),
                        // color: _selectedValue ? Color(0xff00DD00) : Color(0xffE6FFE6),
                        //   color: isButtonPressed ? Colors.green : Colors.red,
                        child: Text(_GENERIC_ADDED_CARDS,
                            style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.bold,
                                fontSize: 18.0)),
                        shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0),
                        ),
                        onPressed: () {
                          /* setState(() {
               isButtonPressed =!isButtonPressed;
             });
*/
                        },
                      )),
                  flex: 2,
                ),
                Expanded(
                    child: Container(
                        height: 50,
                        padding: EdgeInsets.only(right: 15),
                        child: RaisedButton(
                          textColor: Colors.grey,
                          color: Color(0xffE6FFE6),
                          child: Text(_GENERIC_ADD_NEW_CARD,
                              style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.0)),
                          shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(30.0),
                          ),
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      AddDebitCardScreen(paymentParameter)),
                            );
                          },
                        )),
                    flex: 2)
              ])),
          Flexible(
              child: (listCard.length > 0)
                  ? ListView.builder(
                      //reverse: true,
                      itemCount: listCard.length,
                      itemBuilder: (context, int index) =>
                          EachList(listCard[index]),
                    )
                  : Center(
                      child: Text(
                      'No Card Details Found',
                      style: TextStyle(
                          color: Color(0xff676767),
                          fontFamily: 'Montserrat',
                          fontSize: 22.0,
                          fontWeight: FontWeight.bold),
                    ))),
          Container(
              alignment: Alignment.bottomCenter,
              padding: EdgeInsets.only(top: 15, bottom: 20.0),
              child:
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(left: 15.0, right: 15.0),
                    height: 50,
                    child: RaisedButton(
                      textColor: Colors.white,
                      color: Color(0xff00DD00),
                      child: Text(_GENERIC_PAY,
                          style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold)),
                      shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(8.0),
                      ),
                      onPressed: () {
                        _requestCheckoutId();
                      },
                    ),
                  ),
                  flex: 2,
                ),
              ])),
        ],
      ),
    );
  }

  Widget EachList(listCard2) {
    return Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
        color: Colors.white,
        child: new Row(mainAxisSize: MainAxisSize.min, children: [
          Container(
            padding: EdgeInsets.only(left: 10.0, right: 10.0),
            child: new Column(mainAxisSize: MainAxisSize.min,
                //      mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new FlatButton(
                      child: new Text(
                        '${listCard2.cardNumber}',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                      onPressed: () {}),
                  new FlatButton(
                      child: new Text(
                        "Expires on ${listCard2.cardExpiryMonth}/${listCard2.cardExpiryYear}",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          color: Colors.black54,
                        ),
                      ),
                      onPressed: () {}),
                ]),
          ),
          Flexible(
            child: Container(
              alignment: Alignment.centerRight,
              //    padding: EdgeInsets.only(left: 80.0),
              child: new Radio(
                autofocus: true,
                value: '${listCard2.cardId}',
                groupValue: radioValue,
                hoverColor: Color(0xff00DD00),
                focusColor: Color(0xff00DD00),
                activeColor: Color(0xff00DD00),
                onChanged: (value) {
                  getCardDetails(listCard2);
                  setState(() {
                    radioValue = listCard2.cardId.toString();
                  });
                },
              ),
            ),
            flex: 2,
          ),
        ]));
  }

  var card_name, card_cvv, card_year, card_month, card_number;
  getCardDetails(value) {
    print(value.cardId);
    card_name = value.cardName;
    card_number = value.cardNumber;
    card_month = value.cardExpiryMonth;
    card_year = value.cardExpiryYear;
    card_cvv = value.cardCvv;
  }
}
