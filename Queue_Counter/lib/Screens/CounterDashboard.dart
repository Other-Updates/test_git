import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:queuemanagement/Screens/CounterLogin.dart';
import 'dart:async';
import 'dart:io';

class CounterDashboard extends StatefulWidget {
  @override
  _CounterDashboardState createState() => _CounterDashboardState();
}

double headerCellWidth = 108.0;
double cellPadding = 8.0;
double focusedColumnWidth = 185.0;
double rowHeight = 36.0;

class _CounterDashboardState extends State<CounterDashboard> {
  final TextEditingController remarksController = TextEditingController();

  String radioButtonItem = 'ONE';
  int id = 1;

  bool showValue = false;
  bool showValue1 = false;
  bool showValue2 = false;
  bool showValue3 = false;

  bool transfer = false;
  bool remarks = false;

  bool cardSelected = false;

  void hideWidget() {
    setState(() {
      transfer = true;
      remarks = false;
    });
  }

  void showWidget() {
    setState(() {
      transfer = false;
      remarks = true;
    });
  }

  void hideBoth() {
    setState(() {
      transfer = false;
      remarks = false;
    });
  }

  String _dropDownValue = '';

  @override
  void initState() {
    super.initState();
    hideBoth();
  }

  bool toggle = false;
  bool isSwitched = false;

  List cardList = [
    {'token_number': 'CH0001', 'status': 'HOLD', 'remarks': 'Document'},
    {'token_number': 'CH0002', 'status': 'TRANSFER', 'remarks': ''},
    {'token_number': 'CH0003', 'status': 'SUCCESS', 'remarks': ''},
    {'token_number': 'CH0004', 'status': 'MISSED', 'remarks': ''},
    {'token_number': 'CH0005', 'status': 'TRANSFER', 'remarks': ''},
    {'token_number': 'CH0006', 'status': 'HOLD', 'remarks': 'Missing'},
    {'token_number': 'CH0007', 'status': 'MISSED', 'remarks': ''},
    {'token_number': 'CH0008', 'status': 'HOLD', 'remarks': 'File missing'},
    {'token_number': 'CH0009', 'status': 'SUCCESS', 'remarks': ''},
    {'token_number': 'CH0010', 'status': 'TRANSFER', 'remarks': ''},
    {'token_number': 'CH0011', 'status': 'SUCCESS', 'remarks': ''},
    {'token_number': 'CH0012', 'status': 'MISSED', 'remarks': ''},
  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          bool willLeave = false;
          // show the confirm dialog
          await showDialog(
              context: context,
              builder: (_) => AlertDialog(
                    title: Text('Are you sure want to exit the app?'),
                    actions: [
                      TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text(
                            'No',
                            style: TextStyle(
                                color: Colors.black54,
                                fontWeight: FontWeight.bold,
                                fontSize: 18.0),
                          )),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Color(0xffADDFDE), // background
                            onPrimary: Colors.black54,
                          ),
                          onPressed: () {
                            willLeave = false;
                            SystemNavigator.pop();
                          },
                          child: Text(
                            'Yes',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18.0),
                          )),
                    ],
                  ));
          return willLeave;
        },
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            leading: Container(
              // padding: EdgeInsets.only(left: 2.0),
              height: 60,
              width: 80,
              child: Switch(
                value: isSwitched,
                onChanged: (value) {
                  setState(() {
                    isSwitched = value;
                    print(isSwitched);
                  });
                },
                activeTrackColor: Colors.green,
                activeColor: Colors.green,
                inactiveTrackColor: Colors.red,
                inactiveThumbColor: Colors.red,
              ),
            ),
            title: Text(
              ' ${isSwitched ? ' Cash - Active' : 'Cash - Hold'}',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 22.0,
                  fontWeight: FontWeight.bold),
            ),
            actions: <Widget>[
              IconButton(
                  icon: Icon(
                    Icons.power_settings_new_sharp,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    _showMyDialog();
                  }),
            ],
            centerTitle: true,
            backgroundColor: Color(0xffADDFDE),
          ),
          body: Container(
              color: Color(0xffECECEC),
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: ListView.builder(
                itemCount: cardList.length,
                itemBuilder: (context, index) => EachList(cardList[index]),
              )),
        ));
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Are you sure want to logout?'),
          actions: <Widget>[
            TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  'No',
                  style: TextStyle(
                      color: Colors.black54,
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0),
                )),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Color(0xffADDFDE), // background
                  onPrimary: Colors.black54,
                ),
                onPressed: () {
                  //  Navigator.popUntil(context, ModalRoute.withName('/login'));
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => CounterLogin()),
                      (Route<dynamic> route) => false);
                },
                child: Text(
                  'Yes',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
                )),
          ],
        );
      },
    );
  }

  @override
  Widget EachList(cardList) {
    return GestureDetector(
        onTap: () {
          (cardList['status'] == 'SUCCESS' || cardList['status'] == 'TRANSFER')
              ? false
              : showModalBottomSheet(
                  isScrollControlled: true,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(25),
                        topRight: Radius.circular(25)),
                  ),
                  context: context,
                  builder: (BuildContext context) {
                    return Padding(
                        padding: MediaQuery.of(context).viewInsets,
                        child: new Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                alignment: Alignment.topLeft,
                                padding: EdgeInsets.only(left: 15.0, top: 20.0),
                                child: Text(
                                  'Token Number',
                                  style: TextStyle(fontSize: 20.0),
                                ),
                              ),
                              Container(
                                  height: 70.0,
                                  // width: 90.0,
                                  margin: EdgeInsets.only(
                                      left: 15.0,
                                      right: 15.0,
                                      top: 10.0,
                                      bottom: 10.0),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(color: Colors.grey)),
                                  child: Text(
                                    'CH0001',
                                    style: TextStyle(
                                        color: Colors.black54,
                                        fontSize: 24.0,
                                        fontWeight: FontWeight.bold),
                                  )),
                              Container(
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                    Flexible(
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            //  Checkbox(
                                            //   checkColor: Colors.white,
                                            //   activeColor: Color(0xffADDFDE),
                                            //   value: this.showValue,
                                            //   onChanged: (value) {
                                            //     setState(() {
                                            //       this.showValue = value!;
                                            //       showValue1 = false;
                                            //       showValue2 = false;
                                            //       showValue3 = false;
                                            //       showValue = true;
                                            //       hideBoth();
                                            //     });
                                            //   },
                                            // ),
                                            Radio(
                                              value: 1,
                                              groupValue: id,
                                              activeColor: Color(0xffADDFDE),
                                              onChanged: (val) {
                                                showWidget();
                                                setState(() {
                                                  radioButtonItem = 'ONE';
                                                  id = 1;
                                                  showValue1 = false;
                                                  showValue2 = false;
                                                  showValue3 = false;
                                                  showValue = true;
                                                  hideBoth();
                                                });
                                              },
                                            ),

                                            Text(
                                              'Success',
                                              style: TextStyle(
                                                  color: Colors.green,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18.0),
                                            ),
                                          ]),
                                      flex: 2,
                                    ),
                                    Flexible(
                                        child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              // Checkbox(
                                              //   checkColor: Colors.white,
                                              //   activeColor: Color(0xffADDFDE),
                                              //   value: this.showValue1,
                                              //   onChanged: (value) {
                                              //     setState(() {
                                              //       this.showValue1 = value!;
                                              //       showValue1 = true;
                                              //       showValue = false;
                                              //       showValue2 = false;
                                              //       showValue3 = false;
                                              //       showWidget();
                                              //     });
                                              //   },
                                              // ),
                                              Radio(
                                                value: 2,
                                                groupValue: id,
                                                activeColor: Color(0xffADDFDE),
                                                onChanged: (val) {
                                                  showWidget();
                                                  setState(() {
                                                    radioButtonItem = 'TWO';
                                                    id = 2;
                                                    showValue1 = true;
                                                    showValue = false;
                                                    showValue2 = false;
                                                    showValue3 = false;
                                                    showWidget();
                                                  });
                                                },
                                              ),
                                              Text(
                                                'Hold',
                                                style: TextStyle(
                                                    color:
                                                        Colors.lightBlueAccent,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18.0),
                                              ),
                                            ]),
                                        flex: 2),
                                  ])),
                              Container(
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                    Flexible(
                                        child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              // Checkbox(
                                              //   checkColor: Colors.white,
                                              //   activeColor: Color(0xffADDFDE),
                                              //   value: this.showValue2,
                                              //   onChanged: (value) {
                                              //     setState(() {
                                              //       this.showValue2 = value!;
                                              //       showValue1 = false;
                                              //       showValue = false;
                                              //       showValue3 = false;
                                              //       showValue2 = true;
                                              //       hideWidget();
                                              //     });
                                              //   },
                                              // ),
                                              Radio(
                                                value: 3,
                                                groupValue: id,
                                                activeColor: Color(0xffADDFDE),
                                                onChanged: (val) {
                                                  showWidget();
                                                  setState(() {
                                                    radioButtonItem = 'THREE';
                                                    id = 3;
                                                    showValue1 = false;
                                                    showValue = false;
                                                    showValue3 = false;
                                                    showValue2 = true;
                                                    hideWidget();
                                                  });
                                                },
                                              ),
                                              Text(
                                                'Transfer',
                                                style: TextStyle(
                                                    color: Color(0xfff48f0a),
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18.0),
                                              ),
                                            ]),
                                        flex: 2),
                                    Flexible(
                                        child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              // Checkbox(
                                              //   checkColor: Colors.white,
                                              //   activeColor: Color(0xffADDFDE),
                                              //   value: this.showValue3,
                                              //   onChanged: (value) {
                                              //     setState(() {
                                              //       this.showValue3 = value!;
                                              //       showValue = false;
                                              //       showValue2 = false;
                                              //       showValue1 = false;
                                              //       showValue3 = true;
                                              //       hideBoth();
                                              //     });
                                              //   },
                                              // ),
                                              Radio(
                                                value: 4,
                                                groupValue: id,
                                                activeColor: Color(0xffADDFDE),
                                                onChanged: (val) {
                                                  showWidget();
                                                  setState(() {
                                                    radioButtonItem = 'FOUR';
                                                    id = 4;
                                                    showValue = false;
                                                    showValue2 = false;
                                                    showValue1 = false;
                                                    showValue3 = true;
                                                    hideBoth();
                                                  });
                                                },
                                              ),
                                              Text(
                                                'Missed',
                                                style: TextStyle(
                                                    color: Colors.red,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18.0),
                                              ),
                                            ]),
                                        flex: 2),
                                  ])),
                              Visibility(
                                maintainSize: false,
                                maintainAnimation: true,
                                maintainState: true,
                                visible: transfer,
                                child: Container(
                                  color: Colors.white,
                                  margin: EdgeInsets.only(left: 15, right: 15),
                                  child: DropdownButtonFormField(
                                    decoration: InputDecoration(
                                      hintText: 'Select Counter Name',
                                      //  hintText: leads_list['description']??" ",
                                      contentPadding: EdgeInsets.fromLTRB(
                                          20.0, 1.0, 20.0, 1.0),

                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8.0)),
                                    ),
                                    hint: _dropDownValue == null
                                        ? Text(
                                            'Select Counter Name',
                                            style:
                                                TextStyle(color: Colors.black),
                                          )
                                        : Text(
                                            _dropDownValue,
                                            style:
                                                TextStyle(color: Colors.black),
                                          ),
                                    isExpanded: true,
                                    iconSize: 30.0,
                                    style: TextStyle(color: Colors.black),
                                    items: [
                                      'Select Counter Name',
                                      'Reception',
                                      'Scan',
                                    ].map(
                                      (val) {
                                        return DropdownMenuItem<String>(
                                          value: val,
                                          child: Text(val),
                                        );
                                      },
                                    ).toList(),
                                    onChanged: (val) {
                                      setState(
                                        () {
                                          _dropDownValue = val.toString();
                                        },
                                      );
                                    },
                                  ),
                                ),
                              ),
                              Visibility(
                                maintainSize: false,
                                maintainAnimation: true,
                                maintainState: true,
                                visible: remarks,
                                child: Padding(
                                  padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                                  child: TextFormField(
                                    obscureText: true,
                                    controller: remarksController,
                                    decoration: InputDecoration(
                                      //  contentPadding: EdgeInsets.fromLTRB(8, 0, 5, 0),
                                      hintText: 'Please enter remarks',

                                      hintStyle: TextStyle(
                                          color: Colors.grey,
                                          fontFamily: 'Montserrat'),
                                      filled: true,
                                      fillColor: Colors.white,
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8.0)),
                                        borderSide: BorderSide(
                                            color: Colors.grey, width: 0.8),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8.0)),
                                        borderSide: BorderSide(
                                            color: Colors.grey, width: 0.8),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8.0)),
                                        borderSide: BorderSide(
                                            color: Colors.grey, width: 0.8),
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8.0)),
                                        borderSide: BorderSide(
                                            color: Colors.grey, width: 0.8),
                                      ),
                                      //  labelText: 'Password',
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                  height: 55,
                                  width: double.infinity,
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(0, 0, 5, 10),
                                          child: RaisedButton(
                                            textColor: Colors.white,
                                            color: Colors.red,
                                            child: Text('Cancel',
                                                style: TextStyle(
                                                    fontFamily: 'Montserrat',
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  new BorderRadius.circular(
                                                      8.0),
                                            ),
                                            onPressed: () {
                                              Navigator.of(context)
                                                  .pushReplacement(
                                                      MaterialPageRoute(
                                                          builder: (BuildContext
                                                                  context) =>
                                                              CounterDashboard()));
                                            },
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(5, 0, 0, 10),
                                          child: RaisedButton(
                                            textColor: Colors.white,
                                            color: Colors.green,
                                            child: Text('Submit',
                                                style: TextStyle(
                                                    fontFamily: 'Montserrat',
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  new BorderRadius.circular(
                                                      8.0),
                                            ),
                                            onPressed: () {
                                              Navigator.of(context)
                                                  .pushReplacement(
                                                      MaterialPageRoute(
                                                          builder: (BuildContext
                                                                  context) =>
                                                              CounterDashboard()));
                                            },
                                          ),
                                        ),
                                      ])),
                            ]));
                  });
        },
        child: new Card(
            shape: new RoundedRectangleBorder(
                side: new BorderSide(color: Color(0xffADDFDE), width: 2.0),
                borderRadius: BorderRadius.circular(12.0)),
            child: BackdropFilter(
                filter: (cardList['status'] == 'SUCCESS')
                    ? ImageFilter.blur(sigmaX: 0.0, sigmaY: 0.0)
                    : ImageFilter.blur(sigmaX: 0.0, sigmaY: 0.0),
                child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.0),
                      color: (cardList['status'] == 'SUCCESS')
                          ? Colors.black12
                          : Colors.white.withOpacity(0.0),
                    ),

                    // color: (cardList['status'] == 'SUCCESS')
                    //     ? Colors.black12
                    //     : Colors.white,
                    // elevation: 0.0,

                    child: new Column(children: [
                      Container(
                          child: new Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                            Flexible(
                              child: Padding(
                                  padding:
                                      EdgeInsets.only(right: 10.0, top: 15.0),
                                  child: Container(
                                      alignment: Alignment.centerLeft,
                                      padding: EdgeInsets.only(left: 10),
                                      child: Text(
                                        cardList['token_number'],
                                        style: TextStyle(
                                            color: (cardList['status']
                                                        .toString() ==
                                                    "SUCCESS")
                                                ? Colors.black38
                                                : Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20.0,
                                            fontFamily: 'Montserrat'),
                                      ))),
                              flex: 2,
                            ),
                            Flexible(
                              child: Padding(
                                  padding:
                                      EdgeInsets.only(right: 10.0, top: 15.0),
                                  child: Container(
                                      alignment: Alignment.centerLeft,
                                      padding: EdgeInsets.only(left: 60),
                                      child: Text(
                                        cardList['status'],
                                        style: TextStyle(
                                            color: (cardList['status']
                                                        .toString() ==
                                                    "HOLD")
                                                ? Colors.blue
                                                : (cardList['status']
                                                            .toString() ==
                                                        "SUCCESS")
                                                    ? Color(0xff3CD184)
                                                    : (cardList['status']
                                                                .toString() ==
                                                            "TRANSFER")
                                                        ? Color(0xfff48f0a)
                                                        : Colors.red,
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Montserrat'),
                                      ))),
                              flex: 2,
                            ),
                          ])),
                      Container(
                          child: new Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                            Flexible(
                              child: Padding(
                                  padding: EdgeInsets.only(
                                      left: 15.0, top: 15.0, bottom: 20.0),
                                  child: Container(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        (cardList['remarks'] == '')
                                            ? '--'
                                            : cardList['remarks'],
                                        style: TextStyle(
                                            color: Colors.black54,
                                            fontFamily: 'Montserrat',
                                            fontSize: 18.0),
                                      ))),
                              flex: 2,
                            ),
                          ])),
                    ])))));
  }
}
