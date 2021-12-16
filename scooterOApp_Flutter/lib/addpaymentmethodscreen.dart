import 'package:flutter/material.dart';
import 'package:scotto/addcreditcardscreen.dart';
import 'package:scotto/chooserideplan.dart';
import 'package:flutter/cupertino.dart';
import 'package:scotto/utils/Language.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddPaymentMethodScreen extends StatefulWidget {
  @override
  final scootoroAllDetails;
  AddPaymentMethodScreen(this.scootoroAllDetails);
  _AddPaymentMethodScreenState createState() =>
      _AddPaymentMethodScreenState(this.scootoroAllDetails);
}

String _checkoutid = '';
String _resultText = '';
String _MadaRegexV = "";
String _MadaRegexM = "";
String _MadaHash = "";

class _AddPaymentMethodScreenState extends State<AddPaymentMethodScreen> {
  var _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  var _GENERIC_POST_PAID = ' ',
      _GENERIC_PRE_PAID = '',
      _GENERIC_ADD_PAYMENT_METHOD = '',
      _GENERIC_SCOOTERO_WALLET = '',
      _GENERIC_CONTINUE = '';

  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  SharedPreferences _sharedPreferences;

  final scootoroAllDetails;

  _AddPaymentMethodScreenState(this.scootoroAllDetails);

  getLanguage() async {
    _sharedPreferences = await _prefs;
    setState(() {
      _GENERIC_ADD_PAYMENT_METHOD = Language.getLocalLanguage(
          _sharedPreferences, 'GENERIC_ADD_PAYMENT_METHOD');
      _GENERIC_POST_PAID =
          Language.getLocalLanguage(_sharedPreferences, "GENERIC_POST_PAID");
      _GENERIC_PRE_PAID =
          Language.getLocalLanguage(_sharedPreferences, "GENERIC_PRE_PAID");
      _GENERIC_SCOOTERO_WALLET = Language.getLocalLanguage(
          _sharedPreferences, "GENERIC_SCOOTERO_WALLET");
      _GENERIC_CONTINUE =
          Language.getLocalLanguage(_sharedPreferences, "GENERIC_CONTINUE");
    });
  }

  String radioValue = '';

  void handleRadioValueChanged(String value) {
    print(value);
    setState(() {
      radioValue = value;
    });
  }

  @override
  void initState() {
    super.initState();
    getLanguage();
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
            color: Colors.white, // add custom icons also
          ),
        ),
        title: Text(
          _GENERIC_ADD_PAYMENT_METHOD,
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Montserrat',
          ),
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
        child: new ListView(
          children: <Widget>[
            Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0)),
                child: new Column(children: [
                  Container(
                      padding: EdgeInsets.only(left: 10),
                      child: new Row(
                          //      mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Flexible(
                              child: Container(
                                alignment: Alignment.centerLeft,
                                child: Image.asset(
                                    'assets/images/ic_credit_card.png',
                                    width: 40,
                                    height: 40,
                                    fit: BoxFit.fill),
                              ),
                              flex: 2,
                            ),
                            Flexible(
                              child: Container(
                                alignment: Alignment.centerLeft,
                                child: new Text(
                                  _GENERIC_POST_PAID,
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                      color: Color(0xff00DD00),
                                      fontFamily: 'Montserrat'),
                                ),
                              ),
                              flex: 2,
                            ),
                            Flexible(
                              child: Container(
                                  alignment: Alignment.centerRight,
                                  //    padding: EdgeInsets.only(left: 80.0),
                                  child: new Radio(
                                    autofocus: true,
                                    value: 'Credit',
                                    groupValue: radioValue,
                                    hoverColor: Color(0xff00DD00),
                                    focusColor: Color(0xff00DD00),
                                    activeColor: Color(0xff00DD00),
                                    onChanged: (String value) =>
                                        handleRadioValueChanged(value),
                                  )),
                              flex: 2,
                            ),
                          ])),
                ])),
            Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0)),
                child: new Column(children: [
                  Container(
                      padding: EdgeInsets.only(left: 10),
                      child: new Row(
                          //      mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Flexible(
                              child: Container(
                                alignment: Alignment.centerLeft,
                                child: Image.asset(
                                    'assets/images/ic_debit_card.png',
                                    width: 40,
                                    height: 40,
                                    fit: BoxFit.fill),
                              ),
                              flex: 2,
                            ),
                            Flexible(
                              child: Container(
                                alignment: Alignment.centerLeft,
                                child: new Text(
                                  _GENERIC_PRE_PAID,
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                      color: Color(0xff00DD00),
                                      fontSize: 11.5,
                                      fontFamily: 'Montserrat'),
                                ),
                              ),
                              flex: 2,
                            ),
                            Flexible(
                              child: Container(
                                  alignment: Alignment.centerRight,
                                  //    padding: EdgeInsets.only(left: 80.0),
                                  child: new Radio(
                                    autofocus: true,
                                    value: 'Debit',
                                    groupValue: radioValue,
                                    onChanged: (String value) =>
                                        handleRadioValueChanged(value),
                                    hoverColor: Color(0xff00DD00),
                                    focusColor: Color(0xff00DD00),
                                    activeColor: Color(0xff00DD00),
                                  )),
                              flex: 2,
                            ),
                          ])),
                ])),
            Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0)),
                child: new Column(children: [
                  Container(
                      padding: EdgeInsets.only(left: 10),
                      child: new Row(
                          //      mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Flexible(
                              child: Container(
                                alignment: Alignment.centerLeft,
                                child: Image.asset(
                                    'assets/images/ic_wallet_img.png',
                                    width: 40,
                                    height: 40,
                                    fit: BoxFit.fill),
                              ),
                              flex: 2,
                            ),
                            Flexible(
                              child: Container(
                                alignment: Alignment.centerLeft,
                                child: new Text(
                                  _GENERIC_SCOOTERO_WALLET,
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                      color: Color(0xff00DD00),
                                      fontFamily: 'Montserrat'),
                                ),
                              ),
                              flex: 2,
                            ),
                            Flexible(
                              child: Container(
                                  alignment: Alignment.centerRight,
                                  //    padding: EdgeInsets.only(left: 80.0),
                                  child: new Radio(
                                    autofocus: true,
                                    value: 'sw',
                                    groupValue: radioValue,
                                    onChanged: (String value) =>
                                        handleRadioValueChanged(value),
                                    hoverColor: Color(0xff00DD00),
                                    focusColor: Color(0xff00DD00),
                                    activeColor: Color(0xff00DD00),
                                  )),
                              flex: 2,
                            ),
                          ])),
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
                    _GENERIC_CONTINUE,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {
                    if (radioValue != '') {
                      if (radioValue == 'Debit') {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (BuildContext context) =>
                                ChooseRidePlanScreen(
                                    scootoroAllDetails, radioValue)));
                      }
                      if (radioValue == 'Credit') {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (BuildContext context) =>
                                AddCreditCardScreen(
                                    scootoroAllDetails, radioValue)));
                      }
                      if (radioValue == 'sw') {}
                    }
                  },
                )),
          ],
        ),
      ),
    );
  }

  int groupValue = 0;
  void selectRadio(int value) {
    setState(() {
      groupValue = value;
    });
  }
}
