import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scotto/Scprogressdialog.dart';
import 'package:scotto/rechargescreen.dart';
import 'package:scotto/rideprepaidscreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:scotto/constants.dart';
import 'package:scotto/utils/DatabaseHelper.dart';
import 'package:scotto/utils/SqliteModel.dart';
import 'package:scotto/utils/StorageUtil.dart';

class NewFile extends StatefulWidget {
  DebitCardSave selectedcard;

  NewFile([this.selectedcard]);

  bool isEdit = true;

  @override
  _NewFileState createState() => _NewFileState();
}

class _NewFileState extends State<NewFile> {
  var _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  var checkoutId = "";

  static const platform = const MethodChannel('Hyperpay.demo.fultter/channel');
  bool _status = true;
  final FocusNode myFocusNode = FocusNode();

  TextEditingController cardnameController = TextEditingController();
  TextEditingController cardnumberController1 = TextEditingController();
  TextEditingController cardnumberController2 = TextEditingController();
  TextEditingController cardnumberController3 = TextEditingController();
  TextEditingController cardnumberController4 = TextEditingController();
  TextEditingController expirymonthController = TextEditingController();
  TextEditingController expiryyearController = TextEditingController();
  TextEditingController cvvController = TextEditingController();

  FocusNode f1 = FocusNode();
  FocusNode f2 = FocusNode();
  FocusNode f3 = FocusNode();
  FocusNode f4 = FocusNode();
  FocusNode f5 = FocusNode();
  FocusNode f6 = FocusNode();
  FocusNode f7 = FocusNode();
  FocusNode f8 = FocusNode();

  var paymentType;

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
  }

  @override
  Widget build(BuildContext context) {
/*    if (widget.isEdit) {
      cardnameController.text = widget.selectedEmployee.cardName;
      cardnumberController1.text+cardnumberController2.text+cardnumberController3.text+cardnumberController4.text = widget.selectedEmployee.cardNumber.toString();
      expirymonthController.text = widget.selectedEmployee.cardExpiryMonth.toString();
      expiryyearController.text = widget.selectedEmployee.cardExpiryYear.toString();
      cvvController.text = widget.selectedEmployee.cardCvv.toString();


    }*/
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
          'Add Debit Card',
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
        child: new ListView(
          children: <Widget>[
            Container(
                padding: EdgeInsets.only(top: 10.0, left: 10.0),
                alignment: Alignment.centerLeft,
                child: Text(
                  'Pay through Debit card',
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
                  hintStyle:
                      TextStyle(color: Colors.grey, fontFamily: 'Montserrat'),
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
            Expanded(
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
                          decoration: InputDecoration(
                            isDense: true,
                            //  contentPadding: EdgeInsets.fromLTRB(5, 5, 5, 5),
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
                padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
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
                          borderRadius: BorderRadius.all(Radius.circular(8.0)),
                          borderSide:
                              BorderSide(color: Color(0xff00DD00), width: 0.8),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8.0)),
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
                        maxLength: 3,
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
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {
                    var getCardName = cardnameController.text;
                    var getCardNumber = cardnumberController1.text +
                        cardnumberController2.text +
                        cardnumberController3.text +
                        cardnumberController4.text;
                    var getCardExpiryMonth = expirymonthController.text;
                    var getCardExpiryYear = expiryyearController.text;
                    var getCardCvv = cvvController.text;
                    if (getCardName.isNotEmpty &&
                        getCardNumber.isNotEmpty &&
                        getCardExpiryMonth.isNotEmpty &&
                        getCardExpiryYear.isNotEmpty &&
                        getCardCvv.isNotEmpty) {
                      /*       if (widget.isEdit) {
                        DebitCardSave updateCard = new DebitCardSave(
                            cardId: widget.selectedcard.cardId,
                            cardName: getCardName,
                            cardNumber: getCardNumber,
                            cardExpiryMonth: getCardExpiryMonth,
                            cardExpiryYear: getCardExpiryYear,
                            cardCvv: getCardCvv);
                        DatabaseHelper.instance.update(updateCard.toMap());
                      } else {*/

                      DebitCardSave addCard = new DebitCardSave(
                          cardName: getCardName,
                          cardNumber: getCardNumber,
                          cardExpiryMonth: getCardExpiryMonth,
                          cardExpiryYear: getCardExpiryYear,
                          cardCvv: getCardCvv);
                      DatabaseHelper.instance.insert(addCard.toMapWithoutId());
                    }
                    ;
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) =>
                            RechargeScreen(paymentType)));
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
