import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vnr_police/Components/Colors.dart';
import 'package:vnr_police/Utils/Routes.dart';
import 'package:vnr_police/Utils/help_line.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController aadharNumberController = TextEditingController();
  final TextEditingController dobNumberController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController pinCodeController = TextEditingController();
  final TextEditingController professionController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  FocusNode myFocusNode1 = new FocusNode();
  FocusNode myFocusNode2 = new FocusNode();
  FocusNode myFocusNode3 = new FocusNode();
  FocusNode myFocusNode4 = new FocusNode();
  FocusNode myFocusNode5 = new FocusNode();
  FocusNode myFocusNode6 = new FocusNode();
  FocusNode myFocusNode7 = new FocusNode();
  FocusNode myFocusNode8 = new FocusNode();
  FocusNode myFocusNode9 = new FocusNode();

  String _dropDownValue = '';

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
                decoration: BoxDecoration(color: Palette.SecondaryColor
                    // gradient: LinearGradient(
                    //   begin: Alignment.topRight,
                    //   end: Alignment.bottomLeft,
                    //   stops: [-0.9, -0.5],
                    //   colors: [
                    //     Colors.white,
                    //     Palette.backgroundColor,
                    //   ],
                    // ),
                    ),
                child: Column(
                  //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Container(
                      height: 100,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: Palette.SecondaryColor,
                        borderRadius:
                            BorderRadius.only(bottomRight: Radius.circular(60)),
                      ),
                      child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Container(
                                  height: 30,
                                  margin: EdgeInsets.only(left: 20, top: 45),
                                  decoration: BoxDecoration(
                                      // color: Palette.SecondaryColor,
                                      borderRadius:
                                          BorderRadius.circular(30.0)),
                                  child: Icon(
                                    Icons.arrow_back_ios_rounded,
                                    size: 30.0,
                                    color: Colors.white,
                                  )),
                            ),
                            Padding(
                                padding: EdgeInsets.only(left: 100, top: 45),
                                child: Text(
                                  'Profile',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 22,
                                  ),
                                )),
                          ]),
                    ),
                    Expanded(
                      child: Container(
                          decoration: BoxDecoration(
                            color: Palette.BackgroundColor,
                            borderRadius:
                                BorderRadius.only(topLeft: Radius.circular(60)),
                          ),
                          alignment: Alignment.center,
                          child: ListView(children: [
                            Container(
                              padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                              child: TextFormField(
                                obscureText: false,
                                autofocus: false,
                                focusNode: myFocusNode1,
                                controller: userNameController,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  counterText: "",
                                  labelText: 'Name',
                                  labelStyle: TextStyle(
                                      fontSize: 16,
                                      color: myFocusNode1.hasFocus
                                          ? Colors.black54
                                          : Colors.black54),
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
                              padding: EdgeInsets.fromLTRB(5, 5, 5, 0),
                              child: TextFormField(
                                obscureText: false,
                                autofocus: false,
                                // showCursor: false,
                                focusNode: myFocusNode2,
                                controller: emailController,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  counterText: "",
                                  labelText: 'Email Id',
                                  labelStyle: TextStyle(
                                      fontSize: 16,
                                      color: myFocusNode2.hasFocus
                                          ? Colors.black54
                                          : Colors.black54),
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
                                padding: EdgeInsets.fromLTRB(5, 5, 5, 0),
                                child: Row(children: [
                                  Expanded(
                                    //height: 70,
                                    // padding: EdgeInsets.fromLTRB(5, 15, 5, 0),
                                    child: TextFormField(
                                      obscureText: false,
                                      autofocus: false,
                                      // showCursor: false,
                                      focusNode: myFocusNode3,
                                      keyboardType: TextInputType.number,
                                      maxLength: 10,
                                      controller: phoneNumberController,
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        counterText: "",
                                        labelText: 'Mobile number',
                                        labelStyle: TextStyle(
                                            fontSize: 16,
                                            color: myFocusNode3.hasFocus
                                                ? Colors.black54
                                                : Colors.black54),
                                        contentPadding: EdgeInsets.fromLTRB(
                                            25.0, 15.0, 20.0, 15.0),
                                        //  hintStyle: TextStyle(color:Colors.grey),
                                        fillColor: Colors.white,
                                        enabledBorder: UnderlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(32.0)),
                                          borderSide: BorderSide(
                                              color: Colors.grey, width: 2),
                                        ),
                                        alignLabelWithHint: true,
                                        focusedBorder: UnderlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(32.0)),
                                          borderSide: BorderSide(
                                              color: Colors.grey, width: 2),
                                        ),
                                        errorBorder: UnderlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(32.0)),
                                          borderSide: BorderSide(
                                              color: Colors.red, width: 2),
                                        ),
                                        focusedErrorBorder:
                                            UnderlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(32.0)),
                                          borderSide: BorderSide(
                                              color: Colors.grey, width: 2),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    //height: 70,
                                    //   padding: EdgeInsets.fromLTRB(5, 15, 5, 0),
                                    child: TextFormField(
                                      obscureText: false,
                                      autofocus: false,
                                      // showCursor: false,
                                      focusNode: myFocusNode5,
                                      controller: dobNumberController,
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        counterText: "",
                                        labelText: 'DOB',
                                        labelStyle: TextStyle(
                                            fontSize: 16,
                                            color: myFocusNode5.hasFocus
                                                ? Colors.black54
                                                : Colors.black54),
                                        contentPadding: EdgeInsets.fromLTRB(
                                            25.0, 15.0, 20.0, 15.0),
                                        //  hintStyle: TextStyle(color:Colors.grey),
                                        fillColor: Colors.white,
                                        enabledBorder: UnderlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(32.0)),
                                          borderSide: BorderSide(
                                              color: Colors.grey, width: 2),
                                        ),
                                        alignLabelWithHint: true,
                                        focusedBorder: UnderlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(32.0)),
                                          borderSide: BorderSide(
                                              color: Colors.grey, width: 2),
                                        ),
                                        errorBorder: UnderlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(32.0)),
                                          borderSide: BorderSide(
                                              color: Colors.red, width: 2),
                                        ),
                                        focusedErrorBorder:
                                            UnderlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(32.0)),
                                          borderSide: BorderSide(
                                              color: Colors.grey, width: 2),
                                        ),
                                      ),
                                    ),
                                  ),
                                ])),
                            Container(
                              //height: 70,
                              padding: EdgeInsets.fromLTRB(5, 5, 5, 0),
                              child: TextFormField(
                                obscureText: false,
                                autofocus: false,
                                // showCursor: false,
                                focusNode: myFocusNode4,
                                keyboardType: TextInputType.number,
                                controller: aadharNumberController,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  counterText: "",
                                  labelText: 'Aadhar number',
                                  labelStyle: TextStyle(
                                      fontSize: 16,
                                      color: myFocusNode4.hasFocus
                                          ? Colors.black54
                                          : Colors.black54),
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
                              padding: EdgeInsets.fromLTRB(5, 5, 5, 0),
                              child: TextFormField(
                                obscureText: false,
                                autofocus: false,
                                // showCursor: false,
                                focusNode: myFocusNode6,
                                controller: addressController,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  counterText: "",
                                  labelText: 'Address',
                                  labelStyle: TextStyle(
                                      fontSize: 16,
                                      color: myFocusNode6.hasFocus
                                          ? Colors.black54
                                          : Colors.black54),
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
                                padding: EdgeInsets.fromLTRB(5, 5, 5, 0),
                                child: Row(children: [
                                  Expanded(
                                    //height: 70,
                                    // padding: EdgeInsets.fromLTRB(5, 20, 5, 0),
                                    child: TextFormField(
                                      obscureText: false,
                                      autofocus: false,
                                      // showCursor: false,
                                      focusNode: myFocusNode7,
                                      keyboardType: TextInputType.number,
                                      maxLength: 6,
                                      controller: pinCodeController,
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        counterText: "",
                                        labelText: 'Pincode',
                                        labelStyle: TextStyle(
                                            fontSize: 16,
                                            color: myFocusNode7.hasFocus
                                                ? Colors.black54
                                                : Colors.black54),
                                        contentPadding: EdgeInsets.fromLTRB(
                                            25.0, 15.0, 20.0, 15.0),
                                        //  hintStyle: TextStyle(color:Colors.grey),
                                        fillColor: Colors.white,
                                        enabledBorder: UnderlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(32.0)),
                                          borderSide: BorderSide(
                                              color: Colors.grey, width: 2),
                                        ),
                                        alignLabelWithHint: true,
                                        focusedBorder: UnderlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(32.0)),
                                          borderSide: BorderSide(
                                              color: Colors.grey, width: 2),
                                        ),
                                        errorBorder: UnderlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(32.0)),
                                          borderSide: BorderSide(
                                              color: Colors.red, width: 2),
                                        ),
                                        focusedErrorBorder:
                                            UnderlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(32.0)),
                                          borderSide: BorderSide(
                                              color: Colors.grey, width: 2),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    //height: 70,
                                    // padding: EdgeInsets.fromLTRB(5, 20, 5, 0),
                                    child: DropdownButtonFormField(
                                      autofocus: false,
                                      // showCursor: false,
                                      focusNode: myFocusNode8,
                                      // ignore: unnecessary_null_comparison
                                      hint: _dropDownValue == null
                                          ? Text('Dropdown')
                                          : Text(
                                              _dropDownValue,
                                              style: TextStyle(
                                                color: Colors.black54,
                                              ),
                                            ),
                                      decoration: InputDecoration(
                                        hintText: 'Profession',
                                        border: InputBorder.none,
                                        counterText: "",

                                        //   labelText: 'Profession',

                                        contentPadding: EdgeInsets.fromLTRB(
                                            25.0, 25.0, 20.0, 15.0),
                                        //  hintStyle: TextStyle(color:Colors.grey),
                                        fillColor: Colors.white,
                                        enabledBorder: UnderlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(32.0)),
                                          borderSide: BorderSide(
                                              color: Colors.grey, width: 2),
                                        ),
                                        alignLabelWithHint: true,
                                        focusedBorder: UnderlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(32.0)),
                                          borderSide: BorderSide(
                                              color: Colors.grey, width: 2),
                                        ),
                                        errorBorder: UnderlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(32.0)),
                                          borderSide: BorderSide(
                                              color: Colors.red, width: 2),
                                        ),
                                        focusedErrorBorder:
                                            UnderlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(32.0)),
                                          borderSide: BorderSide(
                                              color: Colors.grey, width: 2),
                                        ),
                                      ),
                                      items: [
                                        'Profession',
                                        'Bussiness',
                                        'Farmer',
                                        'ShopKeeper',
                                        'Working',
                                        'Professional',
                                        'Retired',
                                        'House wife',
                                        'Student',
                                        'Social service'
                                      ].map(
                                        (val) {
                                          return DropdownMenuItem<String>(
                                            value: val,
                                            child: Text(val),
                                          );
                                        },
                                      ).toList(),
                                      onChanged: (val) {
                                        print(_dropDownValue);
                                        setState(
                                          () {
                                            _dropDownValue = val.toString();
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                ])),
                            Container(
                              padding: EdgeInsets.fromLTRB(5, 5, 5, 0),
                              child: TextFormField(
                                obscureText: false,
                                autofocus: false,
                                // showCursor: false,
                                focusNode: myFocusNode9,
                                controller: passwordController,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  counterText: "",
                                  labelText: 'Password',
                                  labelStyle: TextStyle(
                                      fontSize: 16,
                                      color: myFocusNode9.hasFocus
                                          ? Colors.black54
                                          : Colors.black54),
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
                                height: 55,
                                width: MediaQuery.of(context).size.width,
                                padding: EdgeInsets.fromLTRB(25, 15, 25, 0),
                                child: RaisedButton(
                                  textColor: Colors.white,
                                  color: Palette.SecondaryColor,
                                  child: Text('Save',
                                      style: TextStyle(
                                        fontFamily: 'Montserrat',
                                      )),
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        new BorderRadius.circular(8.0),
                                  ),
                                  onPressed: () {
                                    Navigator.pushNamed(
                                        context, Routes.DASHBOARD_SCREEN);
                                  },
                                )),
                          ])),
                    ),
                  ],
                ))));
  }
}
