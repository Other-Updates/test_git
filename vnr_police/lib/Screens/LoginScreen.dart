import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vnr_police/Components/Colors.dart';
import 'package:vnr_police/Utils/Routes.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController forgetNumberController = TextEditingController();

  FocusNode myFocusNode1 = new FocusNode();
  FocusNode myFocusNode2 = new FocusNode();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                //color: Colors.white,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    stops: [0.5, 0.5],
                    colors: [
                      Colors.white,
                      Palette.PrimaryColor,
                    ],
                  ),
                ),
                child: Column(
                  //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            color: Palette.PrimaryColor,
                            borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(60)),
                            image: new DecorationImage(
                              fit: BoxFit.cover,
                              colorFilter: new ColorFilter.mode(
                                  Colors.black.withOpacity(0.1),
                                  BlendMode.dstATop),
                              image: AssetImage('assets/images/policeBac.jpg'),
                            )),
                        child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(top: 25),
                                child: CircleAvatar(
                                  radius: 45,
                                  backgroundImage: AssetImage(
                                      "assets/images/loginLogin.png"),
                                  backgroundColor: Colors.white,
                                ),
                              ),
                              Padding(
                                  padding: EdgeInsets.only(bottom: 50, top: 15),
                                  child: Text(
                                    'Welcome Back!',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold),
                                  )),
                            ]),
                      ),
                    ),
                    Expanded(
                      child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.only(topLeft: Radius.circular(60)),
                          ),
                          alignment: Alignment.center,
                          child: ListView(children: [
                            Container(
                              //height: 70,
                              padding: EdgeInsets.fromLTRB(5, 5, 5, 0),
                              child: TextFormField(
                                obscureText: false,
                                autofocus: false,
                                // showCursor: false,
                                focusNode: myFocusNode1,
                                keyboardType: TextInputType.number,
                                maxLength: 10,
                                controller: phoneNumberController,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  counterText: "",
                                  labelText: 'Mobile number',
                                  labelStyle: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: myFocusNode1.hasFocus
                                          ? Colors.black54
                                          : Colors.grey),
                                  contentPadding: EdgeInsets.fromLTRB(
                                      25.0, 15.0, 20.0, 15.0),
                                  //  hintStyle: TextStyle(color:Colors.grey),
                                  fillColor: Colors.white,
                                  enabledBorder: UnderlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(32.0)),
                                    borderSide: BorderSide(
                                        color: Colors.grey, width: 2),
                                  ),
                                  alignLabelWithHint: true,
                                  focusedBorder: UnderlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(32.0)),
                                    borderSide: BorderSide(
                                        color: Colors.grey, width: 2),
                                  ),
                                  errorBorder: UnderlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(32.0)),
                                    borderSide:
                                        BorderSide(color: Colors.red, width: 2),
                                  ),
                                  focusedErrorBorder: UnderlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(32.0)),
                                    borderSide: BorderSide(
                                        color: Colors.grey, width: 2),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              //height: 70,
                              padding: EdgeInsets.fromLTRB(5, 20, 5, 0),
                              child: TextFormField(
                                obscureText: false,
                                autofocus: false,
                                // showCursor: false,
                                focusNode: myFocusNode2,
                                keyboardType: TextInputType.number,
                                maxLength: 10,
                                controller: phoneNumberController,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  counterText: "",
                                  labelText: 'Password',
                                  labelStyle: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: myFocusNode2.hasFocus
                                          ? Colors.black54
                                          : Colors.grey),
                                  contentPadding: EdgeInsets.fromLTRB(
                                      25.0, 15.0, 20.0, 15.0),
                                  //  hintStyle: TextStyle(color:Colors.grey),
                                  fillColor: Colors.white,
                                  enabledBorder: UnderlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(32.0)),
                                    borderSide: BorderSide(
                                        color: Colors.grey, width: 2),
                                  ),
                                  alignLabelWithHint: true,
                                  focusedBorder: UnderlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(32.0)),
                                    borderSide: BorderSide(
                                        color: Colors.grey, width: 2),
                                  ),
                                  errorBorder: UnderlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(32.0)),
                                    borderSide:
                                        BorderSide(color: Colors.red, width: 2),
                                  ),
                                  focusedErrorBorder: UnderlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(32.0)),
                                    borderSide: BorderSide(
                                        color: Colors.grey, width: 2),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              alignment: Alignment.centerRight,
                              padding: EdgeInsets.fromLTRB(5, 10, 5, 0),
                              child: FlatButton(
                                onPressed: () {
                                  showModalBottomSheet(
                                      isScrollControlled: true,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(25),
                                            topRight: Radius.circular(25)),
                                      ),
                                      context: context,
                                      builder: (BuildContext context) {
                                        return Padding(
                                            padding: MediaQuery.of(context)
                                                .viewInsets,
                                            child: new Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: <Widget>[
                                                Container(
                                                    padding:
                                                        EdgeInsets.fromLTRB(
                                                            18, 25, 12, 0),
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Text(
                                                        'Forgot Password',
                                                        style: TextStyle(
                                                            fontSize: 20,
                                                            color: Color(
                                                                0xff676767),
                                                            fontFamily:
                                                                'Montserrat',
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold))),
                                                Container(
                                                  //height: 70,
                                                  padding: EdgeInsets.fromLTRB(
                                                      5, 0, 5, 0),
                                                  child: TextFormField(
                                                    obscureText: false,
                                                    autofocus: false,
                                                    // showCursor: false,
                                                    focusNode: myFocusNode1,
                                                    keyboardType:
                                                        TextInputType.number,
                                                    maxLength: 10,
                                                    controller:
                                                        phoneNumberController,
                                                    decoration: InputDecoration(
                                                      border: InputBorder.none,
                                                      counterText: "",
                                                      labelText:
                                                          'Mobile number',
                                                      labelStyle: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 16,
                                                          color: myFocusNode1
                                                                  .hasFocus
                                                              ? Colors.black54
                                                              : Colors.grey),
                                                      contentPadding:
                                                          EdgeInsets.fromLTRB(
                                                              25.0,
                                                              15.0,
                                                              20.0,
                                                              15.0),
                                                      //  hintStyle: TextStyle(color:Colors.grey),
                                                      fillColor: Colors.white,
                                                      enabledBorder:
                                                          UnderlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    32.0)),
                                                        borderSide: BorderSide(
                                                            color: Colors.grey,
                                                            width: 2),
                                                      ),
                                                      alignLabelWithHint: true,
                                                      focusedBorder:
                                                          UnderlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    32.0)),
                                                        borderSide: BorderSide(
                                                            color: Colors.grey,
                                                            width: 2),
                                                      ),
                                                      errorBorder:
                                                          UnderlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    32.0)),
                                                        borderSide: BorderSide(
                                                            color: Colors.red,
                                                            width: 2),
                                                      ),
                                                      focusedErrorBorder:
                                                          UnderlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    32.0)),
                                                        borderSide: BorderSide(
                                                            color: Colors.grey,
                                                            width: 2),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  //height: 70,
                                                  padding: EdgeInsets.fromLTRB(
                                                      5, 20, 5, 15),
                                                  child: TextFormField(
                                                    obscureText: false,
                                                    autofocus: false,
                                                    // showCursor: false,
                                                    focusNode: myFocusNode2,
                                                    keyboardType:
                                                        TextInputType.number,
                                                    maxLength: 10,
                                                    controller:
                                                        phoneNumberController,
                                                    decoration: InputDecoration(
                                                      border: InputBorder.none,
                                                      counterText: "",
                                                      labelText:
                                                          'Aadhar number',
                                                      labelStyle: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 16,
                                                          color: myFocusNode2
                                                                  .hasFocus
                                                              ? Colors.black54
                                                              : Colors.grey),
                                                      contentPadding:
                                                          EdgeInsets.fromLTRB(
                                                              25.0,
                                                              15.0,
                                                              20.0,
                                                              15.0),
                                                      //  hintStyle: TextStyle(color:Colors.grey),
                                                      fillColor: Colors.white,
                                                      enabledBorder:
                                                          UnderlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    32.0)),
                                                        borderSide: BorderSide(
                                                            color: Colors.grey,
                                                            width: 2),
                                                      ),
                                                      alignLabelWithHint: true,
                                                      focusedBorder:
                                                          UnderlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    32.0)),
                                                        borderSide: BorderSide(
                                                            color: Colors.grey,
                                                            width: 2),
                                                      ),
                                                      errorBorder:
                                                          UnderlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    32.0)),
                                                        borderSide: BorderSide(
                                                            color: Colors.red,
                                                            width: 2),
                                                      ),
                                                      focusedErrorBorder:
                                                          UnderlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    32.0)),
                                                        borderSide: BorderSide(
                                                            color: Colors.grey,
                                                            width: 2),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                    height: 80,
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    padding:
                                                        EdgeInsets.fromLTRB(
                                                            20, 10, 20, 18),
                                                    child: RaisedButton(
                                                      textColor: Colors.white,
                                                      color:
                                                          Palette.PrimaryColor,
                                                      child: Text(
                                                        'SUBMIT',
                                                        style: TextStyle(
                                                            fontFamily:
                                                                'Montserrat',
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 17),
                                                      ),
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            new BorderRadius
                                                                .circular(8.0),
                                                      ),
                                                      onPressed: () {},
                                                    )),
                                              ],
                                            ));
                                      });
                                },
                                child: Text(
                                  'Forgot Password?',
                                  style: TextStyle(
                                      color: Colors.black54,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14),
                                ),
                              ),
                            ),
                            Container(
                                height: 55,
                                width: MediaQuery.of(context).size.width,
                                padding: EdgeInsets.fromLTRB(25, 10, 25, 0),
                                child: RaisedButton(
                                  textColor: Colors.white,
                                  color: Palette.PrimaryColor,
                                  child: Text('Login',
                                      style: TextStyle(
                                          fontFamily: 'Montserrat',
                                          fontWeight: FontWeight.bold)),
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        new BorderRadius.circular(8.0),
                                  ),
                                  onPressed: () {
                                    Navigator.pushNamed(
                                        context, Routes.DASHBOARD_SCREEN);
                                  },
                                )),
                            Container(
                              alignment: Alignment.center,
                              padding: EdgeInsets.fromLTRB(5, 10, 5, 0),
                              child: FlatButton(
                                  onPressed: () {},
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Don\'t have an account?',
                                          style: TextStyle(
                                              color: Colors.black54,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14),
                                        ),
                                        FlatButton(
                                          onPressed: () {
                                            Navigator.pushNamed(context,
                                                Routes.REGISTER_SCREEN);
                                          },
                                          child: Text(
                                            'SIGN UP',
                                            style: TextStyle(
                                                color: Colors.black54,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14),
                                          ),
                                        ),
                                      ])),
                            ),
                          ])),
                    ),
                  ],
                ))));
  }

  openAlertBox() {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(32.0))),
            contentPadding: EdgeInsets.only(top: 10.0),
            content: Container(
              // width: 300.0,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    SizedBox(
                      height: 5.0,
                    ),
                    Padding(
                        padding: EdgeInsets.all(15),
                        child: Text(
                          'Forgot password',
                          style: TextStyle(
                              color: Colors.black54,
                              fontWeight: FontWeight.bold),
                        )),
                    Container(
                      //height: 70,
                      padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                      child: TextFormField(
                        obscureText: false,
                        autofocus: false,
                        // showCursor: false,
                        focusNode: myFocusNode1,
                        keyboardType: TextInputType.number,
                        maxLength: 10,
                        controller: phoneNumberController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          counterText: "",
                          labelText: 'Mobile number',
                          labelStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: myFocusNode1.hasFocus
                                  ? Colors.black54
                                  : Colors.grey),
                          contentPadding:
                              EdgeInsets.fromLTRB(25.0, 15.0, 20.0, 15.0),
                          //  hintStyle: TextStyle(color:Colors.grey),
                          fillColor: Colors.white,
                          enabledBorder: UnderlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(32.0)),
                            borderSide:
                                BorderSide(color: Colors.grey, width: 2),
                          ),
                          alignLabelWithHint: true,
                          focusedBorder: UnderlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(32.0)),
                            borderSide:
                                BorderSide(color: Colors.grey, width: 2),
                          ),
                          errorBorder: UnderlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(32.0)),
                            borderSide: BorderSide(color: Colors.red, width: 2),
                          ),
                          focusedErrorBorder: UnderlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(32.0)),
                            borderSide:
                                BorderSide(color: Colors.grey, width: 2),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      //height: 70,
                      padding: EdgeInsets.fromLTRB(5, 20, 5, 15),
                      child: TextFormField(
                        obscureText: false,
                        autofocus: false,
                        // showCursor: false,
                        focusNode: myFocusNode2,
                        keyboardType: TextInputType.number,
                        maxLength: 10,
                        controller: phoneNumberController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          counterText: "",
                          labelText: 'Aadhar number',
                          labelStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: myFocusNode2.hasFocus
                                  ? Colors.black54
                                  : Colors.grey),
                          contentPadding:
                              EdgeInsets.fromLTRB(25.0, 15.0, 20.0, 15.0),
                          //  hintStyle: TextStyle(color:Colors.grey),
                          fillColor: Colors.white,
                          enabledBorder: UnderlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(32.0)),
                            borderSide:
                                BorderSide(color: Colors.grey, width: 2),
                          ),
                          alignLabelWithHint: true,
                          focusedBorder: UnderlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(32.0)),
                            borderSide:
                                BorderSide(color: Colors.grey, width: 2),
                          ),
                          errorBorder: UnderlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(32.0)),
                            borderSide: BorderSide(color: Colors.red, width: 2),
                          ),
                          focusedErrorBorder: UnderlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(32.0)),
                            borderSide:
                                BorderSide(color: Colors.grey, width: 2),
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, Routes.LOGIN_SCREEN);
                      },
                      child: Container(
                        padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                        decoration: BoxDecoration(
                          color: Palette.SecondaryColor,
                          borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(32.0),
                              bottomLeft: Radius.circular(32.0)),
                        ),
                        child: Text(
                          "SUBMIT",
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ]),
            ),
          );
        });
  }
}
