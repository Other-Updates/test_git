import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scotto/Scprogressdialog.dart';
import 'package:scotto/paymentform.dart';
import 'package:scotto/ridepostpaidscreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:scotto/constants.dart';
import 'package:scotto/utils/StorageUtil.dart';

class AddCreditCardScreen extends StatefulWidget {
  final scootoroAllDetails, radioValue;
  AddCreditCardScreen(this.scootoroAllDetails, this.radioValue);
  @override
  _AddCreditCardScreenState createState() =>
      _AddCreditCardScreenState(this.scootoroAllDetails, this.radioValue);
}

class _AddCreditCardScreenState extends State<AddCreditCardScreen> {
  var _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final scootoroAllDetails, radioValue;
  static const platform = const MethodChannel('Hyperpay.demo.fultter/channel');
  bool _status = true;
  final FocusNode myFocusNode = FocusNode();
  var checkoutId = "";
  var trip_number,
      customer_id,
      scooter_id,
      payment_id,
      ride_start,
      ride_mins,
      total_ride_amt,
      unlock_charge,
      sub_total,
      vat_charge,
      grand_total,
      scootertripdetails;
  _AddCreditCardScreenState(this.scootoroAllDetails, this.radioValue);

  TextEditingController cardnameController = TextEditingController();
  TextEditingController cardnumberController1 = TextEditingController();
  TextEditingController cardnumberController2 = TextEditingController();
  TextEditingController cardnumberController3 = TextEditingController();
  TextEditingController cardnumberController4 = TextEditingController();
  TextEditingController expirymonthController = TextEditingController();
  TextEditingController expiryyearController = TextEditingController();
  TextEditingController cvvController = TextEditingController();
  /* TextEditingController cardnameController = TextEditingController(text:'Test');
  TextEditingController cardnumberController1 = TextEditingController(text: '4200');
  TextEditingController cardnumberController2 = TextEditingController(text:'0000');
  TextEditingController cardnumberController3 = TextEditingController(text:'0000');
  TextEditingController cardnumberController4 = TextEditingController(text:'0000');
  TextEditingController expirymonthController = TextEditingController(text:'08');
  TextEditingController expiryyearController = TextEditingController(text:'2021');
  TextEditingController cvvController = TextEditingController(text: '123');*/

  FocusNode f1 = FocusNode();
  FocusNode f2 = FocusNode();
  FocusNode f3 = FocusNode();
  FocusNode f4 = FocusNode();
  FocusNode f5 = FocusNode();
  FocusNode f6 = FocusNode();
  FocusNode f7 = FocusNode();
  FocusNode f8 = FocusNode();

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

  addcredit() async {
    var data = json.encode({
      "id": mobile_test,
      "scootoro_id": scootoroAllDetails['scooter_id'],
      "payment_method": "credit",
      "card_holder_name": cardnameController.text,
      "card_number": cardnumberController1.text +
          cardnumberController2.text +
          cardnumberController3.text +
          cardnumberController4.text,
      "expire_year": expiryyearController.text,
      "expire_month": expirymonthController.text,
      "cvv": cvvController.text,
      "amount": "100"
    });
    final response = await http.post(baseurl + 'api_payments',
        headers: {'authorization': basicAuth}, body: data);
    print(response.body);

    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      if (jsonResponse['status'] == 'Success') {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (BuildContext context) =>
                    payment_form(type: "credit")),
            (Route<dynamic> route) => false);
      } else if (jsonResponse['status'] == 'Error') {
        _showMessageInScaffold(jsonResponse['message']);
      }
    } else {
      _showMessageInScaffold('Contact Admin!!');
    }
  }

  Future _requestCheckoutId() async {
    final isValid = _formKey.currentState.validate();
    if (!isValid) {
      return;
    }

    if (cardnameController.text == "") {
      _showMessageInScaffold("Please enter name");
    } else if (cardnumberController1.text == "") {
      _showMessageInScaffold("Please enter valid card number");
    } else if (cardnumberController2.text == "") {
      _showMessageInScaffold("Please enter valid card number");
    } else if (cardnumberController3.text == "") {
      _showMessageInScaffold("Please enter valid card number");
    } else if (cardnumberController4.text == "") {
      _showMessageInScaffold("Please enter valid card number");
    } else if (cvvController.text == "") {
      _showMessageInScaffold("Please enter cvv");
    } else if (expirymonthController.text == "") {
      _showMessageInScaffold("Please enter card expiry details ");
    } else if (expiryyearController.text == "") {
      _showMessageInScaffold("Please enter card expiry details ");
    }

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Scprogressdialog("Payment in process");
        });
    var status;
    String basicAuth = "Basic YWRtaW46MTIzNA==";
    String myUrl = baseurl + "api_prepare_checkout";
    var data = json.encode({
      "id": mobile_test,
      "scootoro_id": scootoroAllDetails['scooter_id'],
      "payment_method": "credit",
      "card_holder_name": cardnameController.text,
      "card_number": cardnumberController1.text +
          cardnumberController2.text +
          cardnumberController3.text +
          cardnumberController4.text,
      "expire_year": expiryyearController.text,
      "expire_month": expirymonthController.text,
      "cvv": cvvController.text,
      "amount": "100"
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
        "mode": "TEST", //change this to LIVE
        "brand": "credit",
        "card_number": cardnumberController1.text +
            cardnumberController2.text +
            cardnumberController3.text +
            cardnumberController4.text,
        "holder_name": cardnameController.text,
        "month": expirymonthController.text,
        "year": expiryyearController.text,
        "cvv": cvvController.text,
        "STCPAY": "disabled",
        "Amount": 100.0, //float
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

  paymentstatus() async {
    print(this.scootoroAllDetails);
    var data = json.encode({
      "id": mobile_test,
      "scootoro_id": scootoroAllDetails['scooter_id'],
      "payment_method": "credit",
      "card_holder_name": cardnameController.text,
      "card_number": cardnumberController1.text +
          cardnumberController2.text +
          cardnumberController3.text +
          cardnumberController4.text,
      "expire_year": expiryyearController.text,
      "expire_month": expirymonthController.text,
      "cvv": cvvController.text,
      "amount": "100",
      "pay_description": "Unlocking Charge",
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
          ride_start = trip_details['ride_start'];
        });
        _showMessageInScaffold(jsonResponse['message']);
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (BuildContext context) =>
                    RidePostpaidScreen(trip_details)),
            (Route<dynamic> route) => false);
      } else if (jsonResponse['status'] == 'Error') {
        _showMessageInScaffold(jsonResponse['message']);
      }
    } else {
      _showMessageInScaffold('Contact Admin!!');
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
        paymentstatus();
      } else if (jsonResponse['status'] == 'Error') {
        _showMessageInScaffold(jsonResponse['message']);
      }
    } else {
      _showMessageInScaffold('Contact Admin!!');
    }
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    myFocusNode.dispose();
    super.dispose();
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
  }

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
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
          ),
          title: Text(
            'Add Credit Card',
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Montserrat',
            ),
          ),
          centerTitle: true,
          backgroundColor: Color(0xff00DD00),
        ),
        body: new Container(
          color: Color(0xffE6FFE6),
          child: Form(
            key: _formKey,
            child: new ListView(
              children: <Widget>[
                Container(
                    padding: EdgeInsets.only(top: 10.0, left: 10.0),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Pay through Credit card',
                      style: TextStyle(
                          color: Color(0xff676767),
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Montserrat',
                          fontSize: 20),
                    )),
                Container(
                    padding: EdgeInsets.only(top: 15.0, bottom: 10, left: 10.0),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Name on the card',
                      style: TextStyle(
                          color: Color(0xff676767),
                          fontFamily: 'Montserrat',
                          fontSize: 14),
                    )),
                Container(
                  //  height: 50,
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: TextField(
                    controller: cardnameController,
                    decoration: InputDecoration(
                      isDense: true,
                      hintText: 'Name as printed on the card',
//  prefixIcon: Icon(Icons.lock_outline_rounded,color: Colors.green,size: 20),
                      hintStyle: TextStyle(
                          color: Colors.grey, fontFamily: 'Montserrat'),
                      filled: true,
                      fillColor: Colors.white,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(6.0)),
                        borderSide:
                            BorderSide(color: Color(0xff00DD00), width: 0.8),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(6.0)),
                        borderSide:
                            BorderSide(color: Color(0xff00DD00), width: 0.8),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                        borderSide:
                            BorderSide(color: Color(0xff00DD00), width: 0.8),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                        borderSide:
                            BorderSide(color: Color(0xff00DD00), width: 0.8),
                      ),
                    ),
                  ),
                ),
                Container(
                    padding: EdgeInsets.only(top: 10.0, bottom: 10, left: 10.0),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Card Number',
                      style: TextStyle(
                          color: Color(0xff676767),
                          fontFamily: 'Montserrat',
                          fontSize: 14),
                    )),
                Container(
                    //   alignment: Alignment.center,
                    //   padding: EdgeInsets.only(top: 5.0),
                    child: new Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                      new Flexible(
                        child: Container(
                          padding: EdgeInsets.fromLTRB(10, 0, 0, 5),
                          child: TextField(
                            keyboardType: TextInputType.number,
                            controller: cardnumberController1,
                            textAlign: TextAlign.center,
                            focusNode: f2,
                            onChanged: (String newVal) {
                              if (newVal.length == 4) {
                                f2.unfocus();
                                FocusScope.of(context).requestFocus(f3);
                              }
                            },
                            showCursor: false,
                            maxLength: 4,
                            maxLines: 1,
                            decoration: InputDecoration(
                              isDense: true,
                              // contentPadding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                              border: InputBorder.none,
                              counterText: "",

                              hintText: '* * * *',
//  prefixIcon: Icon(Icons.lock_outline_rounded,color: Colors.green,size: 20),
                              hintStyle: TextStyle(
                                  color: Colors.grey, fontFamily: 'Montserrat'),
                              filled: true,
                              fillColor: Colors.white,
                              enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(6.0)),
                                borderSide: BorderSide(
                                    color: Color(0xff00DD00), width: 0.8),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(6.0)),
                                borderSide: BorderSide(
                                    color: Color(0xff00DD00), width: 0.8),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8.0)),
                                borderSide: BorderSide(
                                    color: Color(0xff00DD00), width: 0.8),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8.0)),
                                borderSide: BorderSide(
                                    color: Color(0xff00DD00), width: 0.8),
                              ),
                            ),
                          ),
                        ),
                        flex: 4,
                      ),
                      new Flexible(
                        child: Container(
                          padding: EdgeInsets.fromLTRB(5, 0, 5, 5),
                          child: TextField(
                            keyboardType: TextInputType.number,
                            controller: cardnumberController2,
                            textAlign: TextAlign.center,
                            focusNode: f3,
                            onChanged: (String newVal) {
                              if (newVal.length == 4) {
                                f3.unfocus();
                                FocusScope.of(context).requestFocus(f4);
                              }
                            },
                            maxLength: 4,
                            maxLines: 1,
                            showCursor: false,
                            decoration: InputDecoration(
                              isDense: true,
                              // contentPadding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                              border: InputBorder.none,
                              counterText: "",
                              hintText: '* * * *',
//  prefixIcon: Icon(Icons.lock_outline_rounded,color: Colors.green,size: 20),
                              hintStyle: TextStyle(
                                  color: Colors.grey, fontFamily: 'Montserrat'),
                              filled: true,
                              fillColor: Colors.white,
                              enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(6.0)),
                                borderSide: BorderSide(
                                    color: Color(0xff00DD00), width: 0.8),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(6.0)),
                                borderSide: BorderSide(
                                    color: Color(0xff00DD00), width: 0.8),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8.0)),
                                borderSide: BorderSide(
                                    color: Color(0xff00DD00), width: 0.8),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8.0)),
                                borderSide: BorderSide(
                                    color: Color(0xff00DD00), width: 0.8),
                              ),
                            ),
                          ),
                        ),
                        flex: 4,
                      ),
                      new Flexible(
                        child: Container(
                          padding: EdgeInsets.fromLTRB(0, 0, 5, 5),
                          child: TextField(
                            keyboardType: TextInputType.number,
                            controller: cardnumberController3,
                            textAlign: TextAlign.center,
                            showCursor: false,
                            focusNode: f4,
                            onChanged: (String newVal) {
                              if (newVal.length == 4) {
                                f4.unfocus();
                                FocusScope.of(context).requestFocus(f5);
                              }
                            },
                            maxLength: 4,
                            maxLines: 1,
                            decoration: InputDecoration(
                              isDense: true,
                              // contentPadding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                              border: InputBorder.none,
                              counterText: "",
                              hintText: '* * * *',
//  prefixIcon: Icon(Icons.lock_outline_rounded,color: Colors.green,size: 20),
                              hintStyle: TextStyle(
                                  color: Colors.grey, fontFamily: 'Montserrat'),
                              filled: true,
                              fillColor: Colors.white,
                              enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(6.0)),
                                borderSide: BorderSide(
                                    color: Color(0xff00DD00), width: 0.8),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(6.0)),
                                borderSide: BorderSide(
                                    color: Color(0xff00DD00), width: 0.8),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8.0)),
                                borderSide: BorderSide(
                                    color: Color(0xff00DD00), width: 0.8),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8.0)),
                                borderSide: BorderSide(
                                    color: Color(0xff00DD00), width: 0.8),
                              ),
                            ),
                          ),
                        ),
                        flex: 4,
                      ),
                      new Flexible(
                          child: Container(
                            padding: EdgeInsets.fromLTRB(0, 0, 10, 5),
                            child: TextField(
                              keyboardType: TextInputType.number,
                              controller: cardnumberController4,
                              focusNode: f5,
                              showCursor: false,
                              textAlign: TextAlign.center,
                              onChanged: (String newVal) {
                                if (newVal.length == 4) {
                                  f5.unfocus();
                                  FocusScope.of(context).requestFocus(f6);
                                }
                              },
                              maxLength: 4,
                              maxLines: 1,
                              decoration: InputDecoration(
                                isDense: true,
                                //  contentPadding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                                border: InputBorder.none,
                                counterText: "",
                                hintText: '* * * *',
//  prefixIcon: Icon(Icons.lock_outline_rounded,color: Colors.green,size: 20),
                                hintStyle: TextStyle(
                                    color: Colors.grey,
                                    fontFamily: 'Montserrat'),
                                filled: true,
                                fillColor: Colors.white,
                                enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(6.0)),
                                  borderSide: BorderSide(
                                      color: Color(0xff00DD00), width: 0.8),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(6.0)),
                                  borderSide: BorderSide(
                                      color: Color(0xff00DD00), width: 0.8),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8.0)),
                                  borderSide: BorderSide(
                                      color: Color(0xff00DD00), width: 0.8),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8.0)),
                                  borderSide: BorderSide(
                                      color: Color(0xff00DD00), width: 0.8),
                                ),
                              ),
                            ),
                          ),
                          flex: 4),
                    ])),
                Container(
                    padding: EdgeInsets.only(top: 10.0),
                    child: new Row(children: <Widget>[
                      Expanded(
                        child: Container(
                            padding: EdgeInsets.only(left: 10.0),
                            //  alignment: Alignment.centerLeft,
                            child: Text(
                              'Expiry',
                              style: TextStyle(
                                  color: Color(0xff676767),
                                  fontFamily: 'Montserrat',
                                  fontSize: 14),
                            )),
                        flex: 2,
                      ),
                      Expanded(
                          child: Container(
                              padding: EdgeInsets.only(left: 30.0),
                              child: Text(
                                'CVV',
                                style: TextStyle(
                                    color: Color(0xff676767),
                                    fontFamily: 'Montserrat',
                                    fontSize: 14),
                              )),
                          flex: 2),
                    ])),
                Container(
                    padding:
                        EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
                    child: new Row(children: <Widget>[
                      Expanded(
                          child: new Row(children: <Widget>[
                        new Flexible(
                            child: TextField(
                          keyboardType: TextInputType.number,
                          controller: expirymonthController,
                          focusNode: f6,
                          textAlign: TextAlign.center,
                          onChanged: (String newVal) {
                            if (newVal.length == 2) {
                              f6.unfocus();
                              FocusScope.of(context).requestFocus(f7);
                            }
                          },
                          maxLength: 2,
                          maxLines: 1,
                          showCursor: false,
                          decoration: InputDecoration(
                            isDense: true,
                            border: InputBorder.none,
                            counterText: "",
                            hintText: 'MM',
                            hintStyle: TextStyle(
                                color: Colors.grey, fontFamily: 'Montserrat'),
                            filled: true,
                            fillColor: Colors.white,
                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.0)),
                              borderSide: BorderSide(
                                  color: Color(0xff00DD00), width: 0.8),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.0)),
                              borderSide: BorderSide(
                                  color: Color(0xff00DD00), width: 0.8),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.0)),
                              borderSide: BorderSide(
                                  color: Color(0xff00DD00), width: 0.8),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.0)),
                              borderSide: BorderSide(
                                  color: Color(0xff00DD00), width: 0.8),
                            ),
                          ),
                        )),
                        Container(
                            padding: EdgeInsets.only(left: 5.0, right: 5.0),
                            child: new Flexible(
                              //  height: 50,//   padding: EdgeInsets.fromLTRB(10, 0, 260, 0),
                              child: Text('/',
                                  style: TextStyle(
                                    fontSize: 30.0,
                                    color: Colors.grey,
                                  )),
                            )),
                        new Flexible(
                          //  height: 50,
                          //   padding: EdgeInsets.fromLTRB(10, 0, 260, 0),
                          child: TextField(
                            keyboardType: TextInputType.number,
                            controller: expiryyearController,
                            textAlign: TextAlign.center,
                            maxLength: 4,
                            maxLines: 1,
                            focusNode: f7,
                            onChanged: (String newVal) {
                              if (newVal.length == 4) {
                                f7.unfocus();
                                FocusScope.of(context).requestFocus(f8);
                              }
                            },
                            showCursor: false,
                            decoration: InputDecoration(
                              isDense: true,
                              border: InputBorder.none,
                              counterText: "",
                              hintText: 'YYYY',
//  prefixIcon: Icon(Icons.lock_outline_rounded,color: Colors.green,size: 20),
                              hintStyle: TextStyle(
                                  color: Colors.grey, fontFamily: 'Montserrat'),
                              filled: true,
                              fillColor: Colors.white,
                              enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8.0)),
                                borderSide: BorderSide(
                                    color: Color(0xff00DD00), width: 0.8),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8.0)),
                                borderSide: BorderSide(
                                    color: Color(0xff00DD00), width: 0.8),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8.0)),
                                borderSide: BorderSide(
                                    color: Color(0xff00DD00), width: 0.8),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8.0)),
                                borderSide: BorderSide(
                                    color: Color(0xff00DD00), width: 0.8),
                              ),
                            ),
                          ),
                        ),
                      ])),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(left: 30.0, right: 60.0),
                          child: TextField(
                            keyboardType: TextInputType.number,
                            controller: cvvController,
                            obscureText: true,
                            maxLength: 3,
                            maxLines: 1,
                            showCursor: false,
                            textAlign: TextAlign.center,
                            focusNode: f8,
                            decoration: InputDecoration(
                              isDense: true,
                              border: InputBorder.none,
                              counterText: "",
                              hintText: '* * *',
//  prefixIcon: Icon(Icons.lock_outline_rounded,color: Colors.green,size: 20),
                              hintStyle: TextStyle(
                                  color: Colors.grey, fontFamily: 'Montserrat'),
                              filled: true,
                              fillColor: Colors.white,
                              enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8.0)),
                                borderSide: BorderSide(
                                    color: Color(0xff00DD00), width: 0.8),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8.0)),
                                borderSide: BorderSide(
                                    color: Color(0xff00DD00), width: 0.8),
                              ),
                            ),
                          ),
                        ),
                        flex: 1,
                      ),
                    ])),
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
                      child: Text(
                        'Add',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      onPressed: () {
                        _requestCheckoutId();
                      }),
                ),
              ],
            ),
          ),
        ));
  }
}

/*
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scotto/Scprogressdialog.dart';
import 'package:scotto/chooserideplan.dart';
import 'package:scotto/paymentform.dart';
import 'package:scotto/paymentmethodscreen.dart';
import 'package:scotto/rechargescreen.dart';
import 'package:scotto/ridepostpaidscreen.dart';
//import 'package:scotto/redirectingpaymentgateway.dart';
import 'package:scotto/side_Drawer.dart';
import 'package:scotto/otp_verification.dart';
import 'package:flutter/cupertino.dart';
import 'package:scotto/home_screen.dart';
import 'package:http/http.dart' as http;
import 'package:scotto/constants.dart';
import 'package:scotto/utils/StorageUtil.dart';

class AddCreditCardScreen extends StatefulWidget {
  final scootoroAllDetails, radioValue;
  AddCreditCardScreen(this.scootoroAllDetails, this.radioValue);
  @override
  _AddCreditCardScreenState createState() =>
      _AddCreditCardScreenState(this.scootoroAllDetails, this.radioValue);
}

class _AddCreditCardScreenState extends State<AddCreditCardScreen> {
  var _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final scootoroAllDetails, radioValue;
  static const platform = const MethodChannel('Hyperpay.demo.fultter/channel');
  bool _status = true;
  final FocusNode myFocusNode = FocusNode();
  var checkoutId = "";
  var trip_number,customer_id,scooter_id,payment_id,ride_start,ride_mins,total_ride_amt,unlock_charge,sub_total,vat_charge,grand_total,scootertripdetails;
  _AddCreditCardScreenState(this.scootoroAllDetails, this.radioValue);

  TextEditingController cardnameController = TextEditingController();
  TextEditingController cardnumberController1 = TextEditingController();
  TextEditingController cardnumberController2 = TextEditingController();
  TextEditingController cardnumberController3 = TextEditingController();
  TextEditingController cardnumberController4 = TextEditingController();
  TextEditingController expirymonthController = TextEditingController();
  TextEditingController expiryyearController = TextEditingController();
  TextEditingController cvvController = TextEditingController();

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

  addcredit() async {
    */
/*  if (entercodeController.text == "") {
      _showMessageInScaffold(Color(0xff00DD00),"Enter QR code");
    }*/ /*


    var data = json.encode({
      "id": mobile_test,
      "scootoro_id": scootoroAllDetails['scooter_id'],
      "payment_method": "credit",
      "card_holder_name": cardnameController.text,
      "card_number": cardnumberController1.text +
          cardnumberController2.text +
          cardnumberController3.text +
          cardnumberController4.text,
      "expire_year": expiryyearController.text,
      "expire_month": expirymonthController.text,
      "cvv": cvvController.text,
      "amount": "100"
    });
    final response = await http.post(baseurl + 'api_payments',
        headers: {'authorization': basicAuth}, body: data);
    print(response.body);

    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      if (jsonResponse['status'] == 'Success') {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (BuildContext context) =>
                    payment_form(type: "credit")),
            (Route<dynamic> route) => false);
      } else if (jsonResponse['status'] == 'Error') {
      //  _showMessageInScaffold(Color(0xff00DD00), jsonResponse['message']);
      }
    } else {
     // _showMessageInScaffold(Color(0xff00DD00), 'Contact Admin!!');
    }
  }

  Future<String> _requestCheckoutId() async {
   */
/* showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context)
        {
          return Scprogressdialog("Payment in process");
        }

    );*/ /*

    var status;
    String basicAuth = "Basic YWRtaW46MTIzNA==";
    String myUrl = baseurl + "api_prepare_checkout";
    var data = json.encode({
      "id": mobile_test,
      "scootoro_id": scootoroAllDetails['scooter_id'],
      "payment_method": "credit",
      "card_holder_name": cardnameController.text,
      "card_number": cardnumberController1.text +
          cardnumberController2.text +
          cardnumberController3.text +
          cardnumberController4.text,
      "expire_year": expiryyearController.text,
      "expire_month": expirymonthController.text,
      "cvv": cvvController.text,
      "amount": "100"
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
        //    _showMessageInScaffold(Color(0xff00dd00), jsonResponse['message']);
      }
    } else {
      // _showMessageInScaffold(Color(0xff00DD00), 'Contact Admin!!');
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
        "mode": "TEST", //change this to LIVE
        "brand": "credit",
        "card_number": cardnumberController1.text +
            cardnumberController2.text +
            cardnumberController3.text +
            cardnumberController4.text,
        "holder_name": cardnameController.text,
        "month": expirymonthController.text,
        "year": expiryyearController.text,
        "cvv": cvvController.text,
        "STCPAY": "disabled",
        "Amount": 100.0, //float
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

  paymentstatus() async {
    print(this.scootoroAllDetails);
    var data = json.encode({
      "id": mobile_test,
      "scootoro_id": scootoroAllDetails['scooter_id'],
      "payment_method": "credit",
      "card_holder_name": cardnameController.text,
      "card_number": cardnumberController1.text +
          cardnumberController2.text +
          cardnumberController3.text +
          cardnumberController4.text,
      "expire_year": expiryyearController.text,
      "expire_month": expirymonthController.text,
      "cvv": cvvController.text,
      "amount": "100",
      "pay_description": "Unlocking Charge",
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
          scootertripdetails= trip_details;
          trip_number = trip_details['trip_number'];
          customer_id =trip_details['customer_id'];
          scooter_id = trip_details['scooter_id'];
          payment_id = trip_details['payment_id'];
          ride_start = trip_details['ride_start'];

        });
        //  _showMessageInScaffold(Color(0xff00DD00), 'Payment successfull');
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (BuildContext context) => RidePostpaidScreen(scootertripdetails)),
            (Route<dynamic> route) => false);
      } else if (jsonResponse['status'] == 'Error') {
        // _showMessageInScaffold(Color(0xff00DD00), 'Payment unsuccessfull');
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (BuildContext context) => RidePostpaidScreen(scootertripdetails)),
            (Route<dynamic> route) => false);
      }
    } else {
      // _showMessageInScaffold(Color(0xff00DD00), 'Contact Admin!!');
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
        // _showMessageInScaffold(Color(0xff00DD00), 'Payment successfull');
        paymentstatus();
      } else if (jsonResponse['status'] == 'Error') {
        //    _showMessageInScaffold(Color(0xff00DD00), 'Payment unsuccessfull');

      }
    } else {
      //  _showMessageInScaffold(Color(0xff00DD00), 'Contact Admin!!');
    }
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    myFocusNode.dispose();
    super.dispose();
  }

  void _showMessageInScaffold(Color color, String message) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: color,
    ));
  }

  @override
  void initState() {
    super.initState();
    getTextFromFile();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (BuildContext context) => HomeScreen()));
          },
          child: Icon(
            Icons.arrow_back_ios,
          ),
        ),
        title: Text('Add Credit Card'),
        centerTitle: true,
        backgroundColor: Color(0xff00DD00),
      ),
      body: new Container(
        child: new ListView(
          children: <Widget>[
            Container(
                padding: EdgeInsets.only(top: 10.0, left: 10.0),
                alignment: Alignment.centerLeft,
                child: Text(
                  'Name on the card',
                  style: TextStyle(
                      color: Color(0xff676767),
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Montserrat',
                      fontSize: 20),
                )),
            Container(
                padding: EdgeInsets.only(top: 15.0, bottom: 10, left: 10.0),
                alignment: Alignment.centerLeft,
                child: Text(
                  'Name on the card',
                  style: TextStyle(
                      color: Color(0xff676767),
                      fontFamily: 'Montserrat',
                      fontSize: 14),
                )),
            Container(
              height: 50,
              padding: EdgeInsets.fromLTRB(14, 0, 14, 0),
              child: TextField(
                controller: cardnameController,
                decoration: InputDecoration(
                  hintText: 'Name as printed on the card',
//  prefixIcon: Icon(Icons.lock_outline_rounded,color: Colors.green,size: 20),
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
            Container(
                padding: EdgeInsets.only(top: 10.0, bottom: 10, left: 10.0),
                alignment: Alignment.centerLeft,
                child: Text(
                  'Card Number',
                  style: TextStyle(
                      color: Color(0xff676767),
                      fontFamily: 'Montserrat',
                      fontSize: 14),
                )),
            Container(
                height: 45,
                padding: EdgeInsets.only(left: 10.0, right: 10.0),
                child: new Row(children: <Widget>[
                  new Flexible(
                    //  height: 50,

                    child: TextField(
                      keyboardType: TextInputType.number,
                      controller: cardnumberController1,

                      maxLength: 4,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        counterText: "",
                        hintText: '****',
//  prefixIcon: Icon(Icons.lock_outline_rounded,color: Colors.green,size: 20),
                        hintStyle: TextStyle(
                            color: Colors.grey, fontFamily: 'Montserrat'),
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
                  new Flexible(
                    //  height: 50,

                    //   padding: EdgeInsets.fromLTRB(10, 0, 260, 0),
                    child: TextField(
                      keyboardType: TextInputType.number,
                      controller: cardnumberController2,
// controller: entercodeController,
                      maxLength: 4,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        counterText: "",
                        hintText: '****',
//  prefixIcon: Icon(Icons.lock_outline_rounded,color: Colors.green,size: 20),
                        hintStyle: TextStyle(
                            color: Colors.grey, fontFamily: 'Montserrat'),
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
                  new Flexible(
                    //  height: 50,

                    //   padding: EdgeInsets.fromLTRB(10, 0, 260, 0),
                    child: TextField(
                      keyboardType: TextInputType.number,
                      controller: cardnumberController3,
// controller: entercodeController,
                      maxLength: 4,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        counterText: "",
                        hintText: '****',
//  prefixIcon: Icon(Icons.lock_outline_rounded,color: Colors.green,size: 20),
                        hintStyle: TextStyle(
                            color: Colors.grey, fontFamily: 'Montserrat'),
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
                  new Flexible(
                    //  height: 50,

                    //   padding: EdgeInsets.fromLTRB(10, 0, 260, 0),
                    child: TextField(
                      keyboardType: TextInputType.number,
                      controller: cardnumberController4,
// controller: entercodeController,
                      maxLength: 4,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        counterText: "",
                        hintText: '****',
//  prefixIcon: Icon(Icons.lock_outline_rounded,color: Colors.green,size: 20),
                        hintStyle: TextStyle(
                            color: Colors.grey, fontFamily: 'Montserrat'),
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
                ])),
            Container(
                child: new Row(children: <Widget>[
              Container(
                  padding: EdgeInsets.only(top: 15.0, bottom: 10, left: 10.0),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Expiry',
                    style: TextStyle(
                        color: Color(0xff676767),
                        fontFamily: 'Montserrat',
                        fontSize: 14),
                  )),
              Container(
                  padding: EdgeInsets.only(top: 15.0, bottom: 10, left: 160.0),
                  alignment: Alignment.center,
                  child: Text(
                    'CVV',
                    style: TextStyle(
                        color: Color(0xff676767),
                        fontFamily: 'Montserrat',
                        fontSize: 14),
                  )),
            ])),
            Container(
                height: 45,
                padding: EdgeInsets.only(left: 10.0, right: 10.0),
                child: new Row(children: <Widget>[
                  new Flexible(
                    //  height: 50,

                    child: TextField(
                      keyboardType: TextInputType.number,
                      controller: expirymonthController,
                      maxLength: 2,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        counterText: "",
                        hintText: 'MM',
//  prefixIcon: Icon(Icons.lock_outline_rounded,color: Colors.green,size: 20),
                        hintStyle: TextStyle(
                            color: Colors.grey, fontFamily: 'Montserrat'),
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
                  new Flexible(
                    //  height: 50,//   padding: EdgeInsets.fromLTRB(10, 0, 260, 0),
                    child: Text('/'),
                  ),
                  new Flexible(
                    //  height: 50,

                    //   padding: EdgeInsets.fromLTRB(10, 0, 260, 0),
                    child: TextField(
                      keyboardType: TextInputType.number,
                      controller: expiryyearController,
                      maxLength: 4,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        counterText: "",
                        hintText: 'YYYY',
//  prefixIcon: Icon(Icons.lock_outline_rounded,color: Colors.green,size: 20),
                        hintStyle: TextStyle(
                            color: Colors.grey, fontFamily: 'Montserrat'),
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
                  new Flexible(
                    //  height: 50,

                    //   padding: EdgeInsets.fromLTRB(10, 0, 260, 0),
                    child: TextField(
                      keyboardType: TextInputType.number,
                      controller: cvvController,
                      maxLength: 3,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        counterText: "",
                        hintText: '***',
//  prefixIcon: Icon(Icons.lock_outline_rounded,color: Colors.green,size: 20),
                        hintStyle: TextStyle(
                            color: Colors.grey, fontFamily: 'Montserrat'),
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
                ])),
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
                  child: Text(
                    'Add',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {
                    */
/*    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
                        builder: (BuildContext context) => RechargeScreen()), (
                        Route<dynamic> route) => false);
*/ /*

                    _requestCheckoutId();
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
*/
