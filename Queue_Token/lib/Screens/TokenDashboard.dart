import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:queue_token/Screens/CreateToken.dart';
import 'package:queue_token/Screens/FeedbackScreen.dart';
import 'package:queue_token/Screens/SubGeneralCategory.dart';
import 'package:queue_token/Screens/SubScanCategory.dart';
import 'package:queue_token/responsive.dart';

class TokenDashboard extends StatefulWidget {
  @override
  _TokenDashboardState createState() => _TokenDashboardState();
}

class _TokenDashboardState extends State<TokenDashboard> {
  final TextEditingController tokenController = TextEditingController();
  @override
  void initState() {
    super.initState();
  }

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
            body: Center(
                child: Container(
          // color: Color(0xffECECEC),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/images/loginback.jpg'),
                  colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.5), BlendMode.dstATop),
                  fit: BoxFit.cover)),
          child: Stack(
            children: [
              Container(
                  alignment: Alignment.center,
                  child: ListView(children: [
                    Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.only(bottom: 40.0, top: 100.0),
                      child: Text(
                        ' QUEUING EAZY',
                        style:
                            TextStyle(color: Color(0xff004080), fontSize: 24.0),
                      ),
                    ),
                    Padding(
                        padding: EdgeInsets.only(
                          left: 15.0,
                          right: 15.0,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  child: new InkWell(
                                      onTap: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder:
                                                    (BuildContext context) =>
                                                        SubGeneralCategory()));
                                      },
                                      child: new Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  right: 15.0,
                                                  left: 15.0,
                                                  top: 15.0,
                                                  bottom: 10.0),
                                              child: Image.asset(
                                                "assets/images/checkUp.png",
                                                height: !Responsive.isMobile(
                                                        context)
                                                    ? 85
                                                    : 85,
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  EdgeInsets.only(bottom: 15.0),
                                              child: Text(
                                                'General',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 20.0),
                                              ),
                                            ),
                                          ])),
                                ),
                                flex: 2),
                            Expanded(
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(12.0)),
                                  child: new InkWell(
                                      onTap: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder:
                                                    (BuildContext context) =>
                                                        CreateToken()));
                                      },
                                      child: new Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  right: 15.0,
                                                  left: 15.0,
                                                  top: 5.0,
                                                  bottom: 4.0),
                                              child: Image.asset(
                                                "assets/images/treatmentIc.jpg",
                                                height: !Responsive.isMobile(
                                                        context)
                                                    ? 103
                                                    : 103,
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  EdgeInsets.only(bottom: 15.0),
                                              child: Text(
                                                'Treatment',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 20.0),
                                              ),
                                            ),
                                          ])),
                                ),
                                flex: 2),
                          ],
                        )),
                    Padding(
                        padding: EdgeInsets.only(
                          left: 15.0,
                          right: 15.0,
                        ),
                        child: Row(children: [
                          Expanded(
                              child: Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.0)),
                                child: new InkWell(
                                    onTap: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  CreateToken()));
                                    },
                                    child: new Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(
                                                right: 15.0,
                                                left: 15.0,
                                                top: 15.0,
                                                bottom: 10.0),
                                            child: Image.asset(
                                              "assets/images/cashI.png",
                                              height:
                                                  !Responsive.isMobile(context)
                                                      ? 88
                                                      : 88,
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                                EdgeInsets.only(bottom: 15.0),
                                            child: Text(
                                              'Cash',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20.0),
                                            ),
                                          ),
                                        ])),
                              ),
                              flex: 2),
                          Expanded(
                              child: Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.0)),
                                child: new InkWell(
                                    onTap: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  SubScanCategory()));
                                    },
                                    child: new Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(
                                                right: 15.0,
                                                left: 15.0,
                                                top: 15.0,
                                                bottom: 15.0),
                                            child: Image.asset(
                                              "assets/images/scan3.png",
                                              height:
                                                  !Responsive.isMobile(context)
                                                      ? 81
                                                      : 81,
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                                EdgeInsets.only(bottom: 15.0),
                                            child: Text(
                                              'Scan',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20.0),
                                            ),
                                          ),
                                        ])),
                              ),
                              flex: 2),
                        ])),
                  ])),
              Align(
                  alignment: Alignment.bottomCenter,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(bottom: 20.0),
                          child: RaisedButton(
                            textColor: Colors.white,
                            color: Colors.orange,
                            child: Text('Hold',
                                style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.bold)),
                            shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(70.0),
                            ),
                            onPressed: () {
                              _showMyDialog();
                            },
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 5.0, bottom: 20.0),
                          child: RaisedButton(
                            textColor: Colors.white,
                            color: Colors.red,
                            child: Text('Missed',
                                style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.bold)),
                            shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(70.0),
                            ),
                            onPressed: () {
                              _showMyDialog();
                            },
                          ),
                        ),
                        Padding(
                            padding: EdgeInsets.only(left: 5.0, bottom: 20.0),
                            child: RaisedButton(
                              textColor: Colors.white,
                              color: Colors.lightBlueAccent,
                              child: Text('Feedback',
                                  style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontWeight: FontWeight.bold)),
                              shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(70.0),
                              ),
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        FeedbackScreen()));
                              },
                            )),
                      ])),
            ],
          ),
        ))));
  }

  Future<void> _showMyDialog() async {
    Timer(
        Duration(seconds: 20),
        () => Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => TokenDashboard())));
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
            content: SingleChildScrollView(
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
              Container(
                padding: EdgeInsets.fromLTRB(5, 8, 5, 10),
                child: Text('Please Enter your Token Number',
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54)),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(5, 8, 5, 10),
                child: TextFormField(
                  obscureText: true,
                  controller: tokenController,
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.fromLTRB(5, 15, 5, 0),
                    hintStyle:
                        TextStyle(color: Colors.grey, fontFamily: 'Montserrat'),
                    filled: true,
                    fillColor: Colors.white,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      borderSide: BorderSide(color: Colors.grey, width: 0.8),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      borderSide: BorderSide(color: Colors.grey, width: 0.8),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      borderSide: BorderSide(color: Colors.grey, width: 0.8),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      borderSide: BorderSide(color: Colors.grey, width: 0.8),
                    ),
                    //  labelText: 'Password',
                  ),
                ),
              ),
              Container(
                  height: 55,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(0, 0, 5, 0),
                          child: RaisedButton(
                            textColor: Colors.white,
                            color: Colors.red,
                            child: Text('Close',
                                style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.bold)),
                            shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(8.0),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                          child: RaisedButton(
                            textColor: Colors.white,
                            color: Colors.green,
                            child: Text('Go',
                                style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.bold)),
                            shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(8.0),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                              _showSuccessDialog();
                            },
                          ),
                        ),
                      ])),
            ])));
      },
    );
  }

  Future<void> _showSuccessDialog() async {
    Timer(
        Duration(seconds: 2),
        () => Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => TokenDashboard())));
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
            content: SingleChildScrollView(
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
              Container(
                padding: EdgeInsets.fromLTRB(0, 15, 0, 15),
                alignment: Alignment.center,
                height: 80,
                width: 80,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/images/check.png'),
                      fit: BoxFit.fill),
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(5, 8, 5, 10),
                child: Text('Success',
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54)),
              ),
              Container(
                child: Text('Your Token Reassigned Successfully',
                    maxLines: 1,
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black38)),
              ),
            ])));
      },
    );
  }
}
