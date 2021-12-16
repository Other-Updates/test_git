import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:scotto/utils/Language.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'addpaymentmethodscreen.dart';

class PaymentMethodScreen extends StatefulWidget {
  @override
  final scootoroAllDetails;
  PaymentMethodScreen(this.scootoroAllDetails);
  _PaymentMethodScreenState createState() => _PaymentMethodScreenState(this.scootoroAllDetails);
}

class _PaymentMethodScreenState extends State<PaymentMethodScreen> {
  var _GENERIC_PAYMENT_METHOD = ' ',
      _GENERIC_PAYMENT_METHOD_MSG = '',
      _GENERIC_ADD_PAYMENT_METHOD = '';
  var _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  SharedPreferences _sharedPreferences;

  final scootoroAllDetails;
  _PaymentMethodScreenState(this.scootoroAllDetails);

  getLanguage() async {
    _sharedPreferences = await _prefs;
    setState(() {
      _GENERIC_PAYMENT_METHOD = Language.getLocalLanguage(
          _sharedPreferences, 'GENERIC_PAYMENT_METHOD');
      _GENERIC_PAYMENT_METHOD_MSG = Language.getLocalLanguage(
          _sharedPreferences, "GENERIC_PAYMENT_METHOD_MSG");
      _GENERIC_ADD_PAYMENT_METHOD = Language.getLocalLanguage(
          _sharedPreferences, "GENERIC_ADD_PAYMENT_METHOD");
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
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,// add custom icons also
          ),
        ),
        title: Text(_GENERIC_PAYMENT_METHOD,style: TextStyle(fontFamily: 'Montserrat',color: Colors.white),),
      //  ${scootoroAllDetails["scooter_id"]}
        centerTitle: true,
        backgroundColor: Color(0xff00DD00),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.account_balance_wallet_rounded, color: Colors.white,), onPressed: () {}),
        ],
      ),
      body: new Container(
        child: new ListView(
          children: <Widget>[
            Container(
              //   height: MediaQuery.of(context).size.height ,
              //  width:MediaQuery.of(context).size.width
              alignment: Alignment.center,
              child: Image.asset('assets/images/nopaymentmethod.png',
                  width: 280, height: 260, fit: BoxFit.fill),
            ),
            Container(
              //   height: MediaQuery.of(context).size.height ,
              //  width:MediaQuery.of(context).size.width
                alignment: Alignment.center,
                child: Text(
                  _GENERIC_PAYMENT_METHOD_MSG,
                  maxLines: 3,
                  textAlign: TextAlign.center, overflow:TextOverflow.ellipsis,
                  style: TextStyle(
                      color: Color(0xff676767),
                      fontFamily: 'Montserrat',
                      fontSize: 16),
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
                  child: Text(
                    _GENERIC_ADD_PAYMENT_METHOD ,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,fontFamily: 'Montserrat'),
                  ),
                  onPressed: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (BuildContext context) =>
                                AddPaymentMethodScreen(scootoroAllDetails)));
                  },
                )),
          ],
        ),
      ),
    );
  }
}
