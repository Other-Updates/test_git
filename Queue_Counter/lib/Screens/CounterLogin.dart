import 'dart:ui';
import 'package:flutter/material.dart';

import 'package:queuemanagement/Screens/CounterDashboard.dart';

class CounterLogin extends StatefulWidget {
  @override
  _CounterLoginState createState() => _CounterLoginState();
}

class _CounterLoginState extends State<CounterLogin> {
  final TextEditingController userNumberController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Container(
                alignment: Alignment.center,
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/images/loginback.jpg'),
                        colorFilter: ColorFilter.mode(
                            Colors.black.withOpacity(0.5), BlendMode.dstATop),
                        fit: BoxFit.cover)),
                child: ListView(children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(
                        top: 100.0, bottom: 30.0, left: 60.0, right: 60.0),
                    child: Image.asset('assets/images/logo.png',
                        height: MediaQuery.of(context).size.height * 0.10,
                        width: MediaQuery.of(context).size.width * 0.30,
                        fit: BoxFit.fill),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 15.0, bottom: 10.0),
                    child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Login',
                          style: TextStyle(
                              color: Color(0xff676767),
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Montserrat',
                              fontSize: 40),
                        )),
                  ),
                  Container(
                    child: Form(
                      child: Column(
                        children: [
                          Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.fromLTRB(15, 20, 15, 10),
                            child: TextFormField(
                              controller: userNumberController,
                              decoration: InputDecoration(
                                isDense: true,
                                contentPadding:
                                    EdgeInsets.fromLTRB(15, 30, 5, 0),
                                border: InputBorder.none,
                                counterText: "",
                                hintText: 'Field Required',
                                hintStyle: TextStyle(
                                    color: Colors.grey,
                                    fontFamily: 'Montserrat'),
                                filled: true,
                                fillColor: Colors.white,
                                enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30.0)),
                                  borderSide: BorderSide(
                                      color: Colors.blueGrey, width: 0.8),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30.0)),
                                  borderSide: BorderSide(
                                      color: Colors.blueGrey, width: 0.8),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30.0)),
                                  borderSide: BorderSide(
                                      color: Colors.blueGrey, width: 0.8),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30.0)),
                                  borderSide: BorderSide(
                                      color: Colors.blueGrey, width: 0.8),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(15, 8, 15, 10),
                            child: TextFormField(
                              key: ValueKey('password'),
                              obscureText: true,
                              controller: passwordController,
                              decoration: InputDecoration(
                                isDense: true,
                                contentPadding:
                                    EdgeInsets.fromLTRB(15, 30, 5, 0),
                                hintText: 'password',

                                hintStyle: TextStyle(
                                    color: Colors.grey,
                                    fontFamily: 'Montserrat'),
                                filled: true,
                                fillColor: Colors.white,
                                enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30.0)),
                                  borderSide: BorderSide(
                                      color: Colors.blueGrey, width: 0.8),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30.0)),
                                  borderSide: BorderSide(
                                      color: Colors.blueGrey, width: 0.8),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30.0)),
                                  borderSide: BorderSide(
                                      color: Colors.blueGrey, width: 0.8),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30.0)),
                                  borderSide: BorderSide(
                                      color: Colors.blueGrey, width: 0.8),
                                ),
                                //  labelText: 'Password',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                      height: 60,
                      padding: EdgeInsets.fromLTRB(15, 8, 15, 0),
                      child: RaisedButton(
                        textColor: Colors.white,
                        color: Color(0xffADDFDE),
                        child: Text('Login',
                            style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold)),
                        shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0),
                        ),
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      CounterDashboard()),
                              (Route<dynamic> route) => false);
                        },
                      )),
                ]))));
  }
}
