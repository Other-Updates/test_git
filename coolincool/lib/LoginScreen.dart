import 'dart:ui';
import 'package:coolincool/Utils/Colors.dart';
import 'package:coolincool/Utils/Routes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController EmailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController forgetEmailController = TextEditingController();

  FocusNode myFocusNode1 = new FocusNode();
  FocusNode myFocusNode2 = new FocusNode();
  FocusNode myFocusNode3 = new FocusNode();

  bool _isChecked = false;

  void _onChecked (bool value) {
    setState(() {
      _isChecked = value ;

    });
  }


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
                    Colors.black,
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
                            color: Colors.black,
                            borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(60)),
                            image: new DecorationImage(
                              fit: BoxFit.cover,
                              colorFilter: new ColorFilter.mode(
                                  Colors.white.withOpacity(0.4),
                                  BlendMode.dstATop),
                              image: AssetImage('assets/images/app_background.jpg'),
                            )),
                        child: Align(

                              alignment: Alignment.center,
                                child: Image.asset(

                                      "assets/images/logo.png",height: 250,width: 250,),

                                ),



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
                              padding: EdgeInsets.fromLTRB(5, 20, 5, 0),
                              child: TextFormField(
                                autofocus: false,
                                // showCursor: false,
                                focusNode: myFocusNode1,
                                keyboardType: TextInputType.emailAddress,

                                controller: EmailController,
                                decoration: InputDecoration(

                                  labelText: 'Email Address',
                                  labelStyle: TextStyle(
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
                                        color: Palette.textlineColor, width: 3),
                                  ),
                                  alignLabelWithHint: true,
                                  focusedBorder: UnderlineInputBorder(
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(32.0)),
                                    borderSide: BorderSide(
                                        color: Palette.PrimaryColor, width: 3),
                                  ),
                                  errorBorder: UnderlineInputBorder(
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(32.0)),
                                    borderSide:
                                    BorderSide(color: Colors.red, width: 3),
                                  ),
                                  focusedErrorBorder: UnderlineInputBorder(
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(32.0)),
                                    borderSide: BorderSide(
                                        color: Palette.PrimaryColor, width: 3),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              //height: 70,
                              padding: EdgeInsets.fromLTRB(5, 20, 5, 0),
                              child: TextFormField(
                                obscureText: true,
                                autofocus: false,
                                // showCursor: false,
                                focusNode: myFocusNode2,
                                keyboardType: TextInputType.number,
                                maxLength: 10,
                                controller: passwordController,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  counterText: "",
                                  labelText: 'Password',
                                  labelStyle: TextStyle(
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
                                        color: Palette.textlineColor, width: 3),
                                  ),
                                  alignLabelWithHint: true,
                                  focusedBorder: UnderlineInputBorder(
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(32.0)),
                                    borderSide: BorderSide(
                                        color: Palette.PrimaryColor, width: 3),
                                  ),
                                  errorBorder: UnderlineInputBorder(
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(32.0)),
                                    borderSide:
                                    BorderSide(color: Colors.red, width: 3),
                                  ),
                                  focusedErrorBorder: UnderlineInputBorder(
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(32.0)),
                                    borderSide: BorderSide(
                                        color: Palette.PrimaryColor, width: 3),
                                  ),
                                ),
                              ),
                            ),

                            Container(
                              margin: EdgeInsets.only(left: 20,right: 5,top: 15,bottom: 20),
                          child:  new Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                new Row(
                                  children: <Widget>[
                                    new Checkbox(
                                      activeColor: Palette.PrimaryColor,
                                      checkColor: Palette.BackGroundColor,
                                      value: _isChecked,
                                      onChanged: (bool? value) {
                                        _onChecked(value!);
                                      },
                                    ),
                                    new GestureDetector(
                                      onTap: () => print("Remember me"),
                                      child: new Text(
                                        "Remember me",
                                        style: TextStyle(
                                            color: Colors.black54,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14),
                                      ),
                                    )
                                  ],
                                ),
                                // new Text(
                                //   "Forgot password ?",
                                //   style: TextStyle(
                                //       color: Colors.black54,
                                //       fontWeight: FontWeight.bold,
                                //       fontSize: 14),
                                // )
                                Container(

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
                                                        focusNode: myFocusNode3,
                                                        keyboardType:
                                                        TextInputType.number,
                                                        maxLength: 10,
                                                        controller:
                                                        forgetEmailController,
                                                        decoration: InputDecoration(
                                                          border: InputBorder.none,
                                                          counterText: "",
                                                          labelText:
                                                          'Email Address',
                                                          labelStyle: TextStyle(
                                                              fontWeight:
                                                              FontWeight.bold,
                                                              fontSize: 16,
                                                              color: myFocusNode3
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
                              ],
                            ),),
                            Container(
                                height: 60,
                                width: MediaQuery.of(context).size.width,
                                padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
                                child: RaisedButton(
                                  textColor: Colors.white,
                                  color: Palette.PrimaryColor,
                                  child: Text('LOGIN',
                                      style: TextStyle(
                                          fontFamily: 'Montserrat',
                                        fontSize: 20
                                         )),
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                    new BorderRadius.circular(8.0),
                                  ),
                                  onPressed: () {
                                    Navigator.pushNamed(
                                        context, Routes.HOME_SCREEN);
                                  },
                                )),

                          ])),
                    ),
                  ],
                ))));
  }

  // openAlertBox() {
  //   return showDialog(
  //       context: context,
  //       barrierDismissible: false,
  //       builder: (BuildContext context) {
  //         return AlertDialog(
  //           shape: RoundedRectangleBorder(
  //               borderRadius: BorderRadius.all(Radius.circular(32.0))),
  //           contentPadding: EdgeInsets.only(top: 10.0),
  //           content: Container(
  //             // width: 300.0,
  //             child: Column(
  //                 mainAxisAlignment: MainAxisAlignment.start,
  //                 crossAxisAlignment: CrossAxisAlignment.stretch,
  //                 mainAxisSize: MainAxisSize.min,
  //                 children: <Widget>[
  //                   SizedBox(
  //                     height: 5.0,
  //                   ),
  //                   Padding(
  //                       padding: EdgeInsets.all(15),
  //                       child: Text(
  //                         'Forgot password',
  //                         style: TextStyle(
  //                             color: Colors.black54,
  //                             fontWeight: FontWeight.bold),
  //                       )),
  //                   Container(
  //                     //height: 70,
  //                     padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
  //                     child: TextFormField(
  //                       obscureText: false,
  //                       autofocus: false,
  //                       // showCursor: false,
  //                       focusNode: myFocusNode3,
  //                       keyboardType: TextInputType.number,
  //                       maxLength: 10,
  //                       controller: forgetEmailController,
  //                       decoration: InputDecoration(
  //                         border: InputBorder.none,
  //                         counterText: "",
  //                         labelText: 'Mobile number',
  //                         labelStyle: TextStyle(
  //                             fontWeight: FontWeight.bold,
  //                             fontSize: 16,
  //                             color: myFocusNode3.hasFocus
  //                                 ? Colors.black54
  //                                 : Colors.grey),
  //                         contentPadding:
  //                         EdgeInsets.fromLTRB(25.0, 15.0, 20.0, 15.0),
  //                         //  hintStyle: TextStyle(color:Colors.grey),
  //                         fillColor: Colors.white,
  //                         enabledBorder: UnderlineInputBorder(
  //                           borderRadius:
  //                           BorderRadius.all(Radius.circular(32.0)),
  //                           borderSide:
  //                           BorderSide(color: Colors.grey, width: 2),
  //                         ),
  //                         alignLabelWithHint: true,
  //                         focusedBorder: UnderlineInputBorder(
  //                           borderRadius:
  //                           BorderRadius.all(Radius.circular(32.0)),
  //                           borderSide:
  //                           BorderSide(color: Colors.grey, width: 2),
  //                         ),
  //                         errorBorder: UnderlineInputBorder(
  //                           borderRadius:
  //                           BorderRadius.all(Radius.circular(32.0)),
  //                           borderSide: BorderSide(color: Colors.red, width: 2),
  //                         ),
  //                         focusedErrorBorder: UnderlineInputBorder(
  //                           borderRadius:
  //                           BorderRadius.all(Radius.circular(32.0)),
  //                           borderSide:
  //                           BorderSide(color: Colors.grey, width: 2),
  //                         ),
  //                       ),
  //                     ),
  //                   ),
  //                   InkWell(
  //                     onTap: () {
  //                       Navigator.pushNamed(context, Routes.LOGIN_SCREEN);
  //                     },
  //                     child: Container(
  //                       padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
  //                       decoration: BoxDecoration(
  //                         color: Palette.SecondaryColor,
  //                         borderRadius: BorderRadius.only(
  //                             bottomRight: Radius.circular(32.0),
  //                             bottomLeft: Radius.circular(32.0)),
  //                       ),
  //                       child: Text(
  //                         "SUBMIT",
  //                         style: TextStyle(color: Colors.white),
  //                         textAlign: TextAlign.center,
  //                       ),
  //                     ),
  //                   ),
  //                 ]),
  //           ),
  //         );
  //       });
  // }
}
