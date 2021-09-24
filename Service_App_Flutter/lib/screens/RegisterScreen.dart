// ignore: file_names
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:service_app/Utils/Constants.dart';
import 'package:service_app/Utils/storageUtil.dart';
import 'package:service_app/components/Textads.dart';
import 'package:service_app/screens/CusHomeFragment.dart';
import 'package:service_app/screens/CustomerDashboardScreen.dart';
import 'package:http/http.dart' as http;

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  String selected_category = "";

  bool EmailId = true;
  bool PhoneNumber = true;
  bool UserName = true;
  bool Password = true;
  bool Signup = true;

  FocusNode myFocusNode1 = new FocusNode();
  FocusNode myFocusNode2 = new FocusNode();
  FocusNode myFocusNode3 = new FocusNode();
  FocusNode myFocusNode4 = new FocusNode();

  TextEditingController emailController = TextEditingController();
  TextEditingController phonenumberController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  var _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  register() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    if (usernameController.text == "") {
      _showMessageInScaffold("Please enter your name");
    } else if (passwordController.text == "") {
      _showMessageInScaffold("Please enter password");
    } else if (phonenumberController.text == "") {
      _showMessageInScaffold("Please enter mobile number");
    } else if (emailController.text == "") {
      _showMessageInScaffold("Please enter Email Id");
    }
    /*showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context)
        {
          return Scprogressdialog("Please wait while Registering...");
        }

    );*/
    String basicAuth = "Basic YWRtaW46MTIzNA==";
    //   SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var data = json.encode({
      "name": usernameController.text,
      "mobile_number": phonenumberController.text,
      "email_id": emailController.text,
      "password": passwordController.text
    });
    final response = await http.post(BASE_URL + 'customer_register',
        headers: {'authorization': basicAuth}, body: data);

    print(data);
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      print(jsonResponse);
      if (jsonResponse['status'] == "Success") {
        var customer_details = jsonResponse['data'][0];
        setState(() {
          StorageUtil.setItem("login_customer_id", customer_details['id']);
          StorageUtil.setItem("login_customer_name", customer_details['name']);
          StorageUtil.setItem(
              "login_customer_mobil_number", customer_details['mobil_number']);
          StorageUtil.setItem(
              "login_customer_email_id", customer_details['email_id']);
          StorageUtil.setItem(
              "login_customer_created_date", customer_details['created_date']);
          StorageUtil.setItem(
              "login_customer_type", customer_details['password']);
          StorageUtil.setItem("login_customer_profile_image",
              customer_details['profile_image']);
        });
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (BuildContext context) => CusHomeFragment()),
            (Route<dynamic> route) => false);
      } else if (jsonResponse['status'] == 'false') {
        // Navigator.pop(context);
        _showMessageInScaffold(jsonResponse['message']);
      }
      //   sharedPreferences.setString("token", jsonResponse['token']);
    } else {
      Navigator.pop(context);
      _showMessageInScaffold('Contact Admin!!');
    }
  }

  void _showMessageInScaffold(String message) {
    _scaffoldKey.currentState!.showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
          softWrap: true,
        ),
        duration: Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        key: _scaffoldKey,
        body: Center(
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/bg_image.png'),
                    fit: BoxFit.cover)),
            child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
              Container(
                  padding: EdgeInsets.fromLTRB(20, 80, 20, 0),
                  child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Container(
                              padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                              child: Image.asset("assets/images/logo.png")),
                          Container(
                              alignment: Alignment.center,
                              child: Text('Register')),
                          Form(
                              key: _formKey,
                              child: Column(children: [
                                Visibility(
                                    maintainSize: false,
                                    maintainAnimation: true,
                                    maintainState: true,
                                    visible: EmailId,
                                    child: Container(
                                      //  height: 70,
                                      padding:
                                          EdgeInsets.fromLTRB(20, 15, 20, 0),

                                      child: TextFormField(
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return 'Please enter email ID';
                                          } else if (value.length < 10) {
                                            return "Enter valid email ID";
                                          }
                                          return null;
                                        },
                                        obscureText: false,
                                        focusNode: myFocusNode1,
                                        //   maxLength: 10,
                                        controller: emailController,
                                        decoration: InputDecoration(
                                          labelText: 'Email ID',
                                          labelStyle: TextStyle(
                                              color: myFocusNode1.hasFocus
                                                  ? Color(0xff004080)
                                                  : Colors.grey),
                                          contentPadding: EdgeInsets.fromLTRB(
                                              20.0, 15.0, 20.0, 15.0),
                                          hintStyle:
                                              TextStyle(color: Colors.grey),
                                          fillColor: Colors.white,
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(32.0)),
                                          alignLabelWithHint: true,
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(32.0)),
                                            borderSide: BorderSide(
                                                color: Color(0xff004080),
                                                width: 2),
                                          ),
                                        ),
                                      ),
                                    )),
                                Visibility(
                                    maintainSize: false,
                                    maintainAnimation: true,
                                    maintainState: true,
                                    visible: PhoneNumber,
                                    child: Container(
                                      //height: 70,
                                      padding:
                                          EdgeInsets.fromLTRB(20, 15, 20, 0),
                                      child: TextFormField(
                                        obscureText: false,
                                        focusNode: myFocusNode2,
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return 'Please enter mobile number';
                                          } else if (value.length < 10) {
                                            return "Enter valid mobile number";
                                          }
                                          return null;
                                        },
                                        keyboardType: TextInputType.number,
                                        inputFormatters: <TextInputFormatter>[
                                          FilteringTextInputFormatter.digitsOnly
                                        ],
                                        maxLength: 10,
                                        controller: phonenumberController,
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          counterText: "",
                                          labelText: 'Phone No',
                                          labelStyle: TextStyle(
                                              color: myFocusNode2.hasFocus
                                                  ? Color(0xff004080)
                                                  : Colors.grey),
                                          contentPadding: EdgeInsets.fromLTRB(
                                              20.0, 15.0, 20.0, 15.0),
                                          //  hintStyle: TextStyle(color:Colors.grey),
                                          fillColor: Colors.white,
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(32.0)),
                                            borderSide: BorderSide(
                                                color: Color(0xff004080),
                                                width: 2),
                                          ),
                                          alignLabelWithHint: true,
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(32.0)),
                                            borderSide: BorderSide(
                                                color: Color(0xff004080),
                                                width: 2),
                                          ),
                                          errorBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(32.0)),
                                            borderSide: BorderSide(
                                                color: Colors.red, width: 2),
                                          ),
                                          focusedErrorBorder:
                                              OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(32.0)),
                                            borderSide: BorderSide(
                                                color: Colors.red, width: 2),
                                          ),
                                        ),
                                      ),
                                    )),
                                Visibility(
                                    maintainSize: false,
                                    maintainAnimation: true,
                                    maintainState: true,
                                    visible: UserName,
                                    child: Container(
                                      //  height: 70,
                                      padding:
                                          EdgeInsets.fromLTRB(20, 15, 20, 0),

                                      child: TextFormField(
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return 'Please enter username';
                                          }
                                          return null;
                                        },
                                        obscureText: false,
                                        focusNode: myFocusNode3,
                                        //   maxLength: 10,
                                        controller: usernameController,
                                        decoration: InputDecoration(
                                          labelText: 'User Name',
                                          labelStyle: TextStyle(
                                              color: myFocusNode3.hasFocus
                                                  ? Color(0xff004080)
                                                  : Colors.grey),
                                          contentPadding: EdgeInsets.fromLTRB(
                                              20.0, 15.0, 20.0, 15.0),
                                          hintStyle:
                                              TextStyle(color: Colors.grey),
                                          fillColor: Colors.white,
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(32.0)),
                                          alignLabelWithHint: true,
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(32.0)),
                                            borderSide: BorderSide(
                                                color: Color(0xff004080),
                                                width: 2),
                                          ),
                                        ),
                                      ),
                                    )),
                                Visibility(
                                    maintainSize: false,
                                    maintainAnimation: true,
                                    maintainState: true,
                                    visible: Password,
                                    child: Container(
                                      //   height: 70,
                                      padding:
                                          EdgeInsets.fromLTRB(20, 15, 20, 0),

                                      child: TextFormField(
                                        obscureText: true,
                                        focusNode: myFocusNode4,
                                        autofocus: false,
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return 'Please enter password';
                                          }
                                          return null;
                                        },
                                        //   maxLength: 10,
                                        controller: passwordController,
                                        decoration: InputDecoration(
                                          labelText: 'Password',
                                          labelStyle: TextStyle(
                                              color: myFocusNode4.hasFocus
                                                  ? Color(0xff004080)
                                                  : Colors.grey),
                                          contentPadding: EdgeInsets.fromLTRB(
                                              20.0, 15.0, 20.0, 15.0),
                                          hintStyle:
                                              TextStyle(color: Colors.grey),
                                          fillColor: Colors.white,
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(32.0)),
                                          alignLabelWithHint: true,
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(32.0)),
                                            borderSide: BorderSide(
                                                color: Color(0xff004080),
                                                width: 2),
                                          ),
                                        ),
                                      ),
                                    )),
                              ])),
                          Visibility(
                              maintainSize: false,
                              maintainAnimation: true,
                              maintainState: true,
                              visible: Signup,
                              child: Container(
                                child: FloatingActionButton(
                                    child: new Icon(Icons.arrow_forward),
                                    elevation: 0.0,
                                    backgroundColor: new Color(0xff004080),
                                    onPressed: () {
                                      register();
                                    }),
                                padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                              )),
                        ],
                      ))),
            ]),
          ),
          /*Container(
            //alignment: Alignment.bottomCenter,
            padding: EdgeInsets.only(top:10.0),
            height: 30 ,
            child:TextAds(),
          ),*/
        ));
  }
}
