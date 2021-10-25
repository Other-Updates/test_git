import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:service_app/Utils/Constants.dart';
import 'package:service_app/Utils/storageUtil.dart';
import 'package:service_app/screens/CusHomeFragment.dart';
import 'package:service_app/screens/EmphomeFragment.dart';
import 'package:service_app/screens/Register.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  // const MyHomePage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKey1 = GlobalKey<FormState>();

  int id = 1;
  bool isSignupScreen = true;
  String radioButtonItem = 'ONE';
  bool customerphoneno = true;
  bool customerpassword = true;
  bool empname = true;
  bool emppassword = true;
  bool emplocation = true;
  bool customerlogin = true;
  bool emplogin = true;
  bool signup = true;

  FocusNode myFocusNode1 = new FocusNode();
  FocusNode myFocusNode2 = new FocusNode();
  FocusNode myFocusNode3 = new FocusNode();
  FocusNode myFocusNode4 = new FocusNode();
  FocusNode myFocusNode5 = new FocusNode();

  TextEditingController phonenumberController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController EmpnameController = TextEditingController();
  TextEditingController EmppasswordController = TextEditingController();
  TextEditingController EmpLocationController = TextEditingController();

  bool ispassshow = false;
  bool _rememberme = false;

  bool SelectedLogin = false;
  bool CustomerLogin = false;
  bool EmployeeLogin = false;

  void showWidget() {
    setState(() {
      CustomerLogin = false;
      EmployeeLogin = true;
    });
  }

  void hideWidget() {
    setState(() {
      CustomerLogin = true;
      EmployeeLogin = false;
    });
  }

  customer() async {
    final isValid = _formKey.currentState!.validate();
    // if (!isValid) {
    //   return;
    // }
    // if(phonenumberController.text == ""){
    //   _showMessageInScaffold("Please enter mobile number");
    //
    // }
    // else if(passwordController.text == ""){
    //   _showMessageInScaffold("Please enter password");
    // }
    var data = json.encode({
      "mobile_number": phonenumberController.text,
      "password": passwordController.text
    });
    final response = await http.post(
        'https://demo.f2fsolutions.co.in/serviceAPP/api/cust_login',
        headers: {'authorization': basicAuth},
        body: data);
    print(data);
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      print(jsonResponse);
      if (jsonResponse['status'] == "Success") {
        var customer_details = jsonResponse['data'][0];
        print("customeraavo" + customer_details['id']);
        setState(() {
          StorageUtil.setItem("login_customer_id", customer_details['id']);
          StorageUtil.setItem("login_customer_name", customer_details['name']);
          StorageUtil.setItem(
              "login_customer_mobil_number", customer_details['mobil_number']);
          StorageUtil.setItem(
              "login_customer_email_id", customer_details['email_id']);
          StorageUtil.setItem(
              "login_customer_created_date", customer_details['created_date']);
          StorageUtil.setItem("login_customer_type", customer_details['type']);
          StorageUtil.setItem("login_customer_profile_image",
              customer_details['profile_image']);
          print(customer_details['profile_image']);
          StorageUtil.setItem("login_customer_password",
              JsonEncoder().convert(customer_details['password']));
          print(
              "hjhgghg" + JsonEncoder().convert(customer_details['password']));
        });

        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (BuildContext context) => CusHomeFragment()),
            (Route<dynamic> route) => false);
      } else if (jsonResponse['status'] == 'error') {
        // Navigator.pop(context);
        _showMessageInScaffold(jsonResponse['message']);
      }
      //   sharedPreferences.setString("token", jsonResponse['token']);
    } else {
      Navigator.pop(context);
      _showMessageInScaffold('Contact Admin!!');
    }
  }

  // emp_login
  Employee() async {
    final isValid = _formKey1.currentState!.validate();
    /* if (!isValid) {
      return;
    }
    if(EmpnameController.text == ""){
      _showMessageInScaffold("Please enter employee name");

    }
    else if(EmppasswordController.text == ""){
      _showMessageInScaffold("Please enter password");
    }
    else if(EmpLocationController.text == ""){
      _showMessageInScaffold("Please enter location");
    }*/

    var data = json.encode({
      "username": EmpnameController.text,
      "password": EmppasswordController.text,
      "login_location": EmpLocationController.text
    });
    final response = await http.post(BASE_URL + 'emp_login',
        headers: {'authorization': basicAuth}, body: data);
    print(data);
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      print(jsonResponse);
      if (jsonResponse['status'] == "Success") {
        var Employee_details = jsonResponse['data'][0];
        print(Employee_details);
        StorageUtil.setItem("login_employee_id", Employee_details['id']);
        StorageUtil.setItem(
            "login_employee_name", Employee_details['username']);
        StorageUtil.setItem(
            "login_employee_mobil_number", Employee_details['mobile_no']);
        StorageUtil.setItem(
            "login_employee_email_id", Employee_details['email_id']);
        StorageUtil.setItem(
            "login_employee_created_date", Employee_details['created_date']);
        StorageUtil.setItem("login_employee_type", Employee_details['type']);
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (BuildContext context) => EmphomeFragment()),
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
  void initState() {
    // TODO: implement initState
    super.initState();
    hideWidget();
  }

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
        onWillPop: () async {
          bool willLeave = false;
          // show the confirm dialog
          await showDialog(
              context: context,
              builder: (_) => AlertDialog(
                    title: Text('Are you sure want to leave?'),
                    actions: [
                      ElevatedButton(
                          onPressed: () {
                            willLeave = false;
                            SystemNavigator.pop();
                          },
                          child: Text('Yes')),
                      TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text('No'))
                    ],
                  ));
          return willLeave;
        },
        child: Scaffold(
            key: _scaffoldKey,
            // backgroundColor: Colors.grey[200],
            body: GestureDetector(
                onTap: () {
                  FocusScope.of(context).unfocus();
                },
                child: SingleChildScrollView(
                    child: Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  //  crossAxisAlignment: CrossAxisAlignment.stretch,

                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/images/login_bg_image.jpg'),
                          fit: BoxFit.fill)),
                  // padding: EdgeInsets.fromLTRB(0,5, 0, 20),

                  child: Stack(children: <Widget>[
                    Align(
                        alignment: Alignment.topLeft,
                        //   child:Column(
                        //   children:[
                        child: Container(
                            padding: EdgeInsets.only(top: 190),
                            child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    height: 40,
                                    width: 80,
                                    padding: EdgeInsets.only(right: 8),
                                    child: GestureDetector(
                                      onTap: () {
                                        hideWidget();
                                        //   SelectedLogin = true;
                                      },
                                      child: Text(
                                        'Customer',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                    alignment: Alignment.center,
                                    decoration: (CustomerLogin == true)
                                        ? BoxDecoration(
                                            color: (CustomerLogin == true)
                                                ? Color(0xffff7000)
                                                : Colors.grey,
                                            borderRadius: BorderRadius.only(
                                                bottomRight:
                                                    Radius.circular(22.0),
                                                topRight:
                                                    Radius.circular(22.0)))
                                        : BoxDecoration(),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                      height: 40,
                                      width: 80,
                                      padding: EdgeInsets.only(right: 8),
                                      child: GestureDetector(
                                        onTap: () {
                                          showWidget();
                                          //   SelectedLogin = true;
                                        },
                                        child: Text(
                                          'Employee',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                      alignment: Alignment.center,
                                      decoration: (EmployeeLogin == true)
                                          ? BoxDecoration(
                                              color: (EmployeeLogin == true)
                                                  ? Color(0xffff7000)
                                                  : Colors.grey,
                                              borderRadius: BorderRadius.only(
                                                  bottomRight:
                                                      Radius.circular(22.0),
                                                  topRight:
                                                      Radius.circular(22.0)))
                                          : BoxDecoration())
                                ]))),
                    Align(
                        alignment: Alignment.centerRight,
                        child: Form(
                            key: _formKey1,
                            child: Visibility(
                                maintainSize: false,
                                maintainAnimation: true,
                                maintainState: true,
                                visible: EmployeeLogin,
                                child: Container(
                                    height: 500,
                                    width: 270,
                                    // padding: EdgeInsets.fromLTRB(50,120, 80, 200),
                                    decoration: BoxDecoration(
                                        shape: BoxShape.rectangle,
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                        //   borderRadius: BorderRadius.only(topLeft: Radius.circular(250.0),bottomRight:Radius.circular(250.0)),
                                        gradient: LinearGradient(
                                            //begin: Alignment.topLeft,
                                            end: Alignment.bottomLeft,
                                            colors: [
                                              Color(0xff282a5c),
                                              Color(0xffa83e57)
                                            ])),
                                    child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          Container(
                                              padding:
                                                  EdgeInsets.only(top: 60.0),
                                              alignment: Alignment.topCenter,
                                              child: Text(
                                                'EMPLOYEE',
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white),
                                              )),
                                          Expanded(
                                              child: Container(
                                            //color: Colors.grey[200],
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(5.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Material(
                                                    elevation: 6.0,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        40)),
                                                    child: TextFormField(
                                                      validator: (value) {
                                                        if (value!.isEmpty) {
                                                          return 'Please enter employee name';
                                                        }
                                                        return null;
                                                      },
                                                      focusNode: myFocusNode3,
                                                      controller:
                                                          EmpnameController,
                                                      keyboardType:
                                                          TextInputType
                                                              .emailAddress,
                                                      textInputAction:
                                                          TextInputAction.next,
                                                      onEditingComplete: () =>
                                                          FocusScope.of(context)
                                                              .nextFocus(),
                                                      style: TextStyle(
                                                          fontSize: 18,
                                                          color: Colors.grey),
                                                      decoration:
                                                          InputDecoration(
                                                        contentPadding:
                                                            EdgeInsets.only(
                                                                top: 14),
                                                        prefixIcon: Icon(Icons
                                                            .person_outline),
                                                        border:
                                                            InputBorder.none,
                                                        hintText:
                                                            "Employee Name ",
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 20,
                                                  ),
                                                  Material(
                                                    elevation: 6.0,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        40)),
                                                    child: TextFormField(
                                                      validator: (value) {
                                                        if (value!.isEmpty) {
                                                          return 'Please enter password';
                                                        }
                                                        return null;
                                                      },
                                                      focusNode: myFocusNode4,
                                                      controller:
                                                          EmppasswordController,
                                                      obscureText: !ispassshow,
                                                      keyboardType:
                                                          TextInputType.text,
                                                      textInputAction:
                                                          TextInputAction.done,
                                                      onEditingComplete: () =>
                                                          FocusScope.of(context)
                                                              .unfocus(),
                                                      style: TextStyle(
                                                          fontSize: 18,
                                                          color: Colors.grey),
                                                      decoration:
                                                          InputDecoration(
                                                        contentPadding:
                                                            EdgeInsets.only(
                                                                top: 14),
                                                        prefixIcon: Icon(Icons
                                                            .lock_outlined),
                                                        border:
                                                            InputBorder.none,
                                                        hintText: "Password",
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 20,
                                                  ),
                                                  Material(
                                                    elevation: 6.0,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        40)),
                                                    child: TextFormField(
                                                      validator: (value) {
                                                        if (value!.isEmpty) {
                                                          return 'Please enter location';
                                                        }
                                                        return null;
                                                      },
                                                      obscureText: false,
                                                      focusNode: myFocusNode5,
                                                      controller:
                                                          EmpLocationController,
                                                      // obscureText: !ispassshow,
                                                      keyboardType:
                                                          TextInputType.text,
                                                      textInputAction:
                                                          TextInputAction.done,
                                                      onEditingComplete: () =>
                                                          FocusScope.of(context)
                                                              .unfocus(),
                                                      style: TextStyle(
                                                          fontSize: 18,
                                                          color: Colors.grey),
                                                      decoration:
                                                          InputDecoration(
                                                        contentPadding:
                                                            EdgeInsets.only(
                                                                top: 14),
                                                        prefixIcon: Icon(Icons
                                                            .location_city_outlined),
                                                        border:
                                                            InputBorder.none,
                                                        hintText: "Location",
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 20,
                                                  ),
                                                  gradientbutton(),
                                                  SizedBox(
                                                    height: 30,
                                                  ),
                                                  /*          Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Don\'t have and account ?",
                                  style: TextStyle(color: Colors.blue[700]),
                                ),
                                SizedBox(width: 10,),

                                  GestureDetector(
                                    child: Text('  Signup here' ,  style: new TextStyle(
                                      fontSize: 15.0,color: Colors.white,
                                    ),),
                                    onTap: () {
                                      Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => Register()) );

                                    },
                                )
                              ],
                            )*/
                                                ],
                                              ),
                                            ),
                                          )),
                                        ]))))),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Form(
                          key: _formKey,
                          child: Visibility(
                              maintainSize: false,
                              maintainAnimation: true,
                              maintainState: true,
                              visible: CustomerLogin,
                              child: Container(
                                  height: 500,
                                  width: 270,
                                  // padding: EdgeInsets.fromLTRB(50,120, 80, 200),
                                  decoration: BoxDecoration(
                                      shape: BoxShape.rectangle,
                                      borderRadius: BorderRadius.circular(20.0),
                                      //   borderRadius: BorderRadius.only(topLeft: Radius.circular(250.0),bottomRight:Radius.circular(250.0)),
                                      gradient: LinearGradient(
                                          //begin: Alignment.topLeft,
                                          end: Alignment.bottomLeft,
                                          colors: [
                                            Color(0xff282a5c),
                                            Color(0xffa83e57)
                                          ])),
                                  child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Container(
                                            padding: EdgeInsets.only(top: 60.0),
                                            alignment: Alignment.topCenter,
                                            child: Text(
                                              'CUSTOMER',
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white),
                                            )),
                                        Expanded(
                                            child: Container(
                                          //color: Colors.grey[200],
                                          child: Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Material(
                                                  elevation: 6.0,
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              40)),
                                                  child: TextFormField(
                                                    validator: (value) {
                                                      if (value!.isEmpty) {
                                                        return 'Please enter mobile number';
                                                      } else if (value.length <
                                                          10) {
                                                        return "Enter valid mobile number";
                                                      }
                                                      return null;
                                                    },
                                                    controller:
                                                        phonenumberController,
                                                    obscureText: false,
                                                    autofocus: false,
                                                    // focusNode: myFocusNode1,
                                                    keyboardType:
                                                        TextInputType.number,
                                                    inputFormatters: <
                                                        TextInputFormatter>[
                                                      FilteringTextInputFormatter
                                                          .digitsOnly
                                                    ],
                                                    textInputAction:
                                                        TextInputAction.next,
                                                    onEditingComplete: () =>
                                                        FocusScope.of(context)
                                                            .nextFocus(),
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        color: Colors.grey),
                                                    decoration: InputDecoration(
                                                      contentPadding:
                                                          EdgeInsets.only(
                                                              top: 14),
                                                      prefixIcon: Icon(
                                                          Icons.phone_outlined),
                                                      border: InputBorder.none,
                                                      hintText: "Phone No ",
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 20,
                                                ),
                                                Material(
                                                  elevation: 6.0,
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              40)),
                                                  child: TextFormField(
                                                    validator: (value) {
                                                      if (value!.isEmpty) {
                                                        return 'Please enter password';
                                                      }
                                                      return null;
                                                    },
                                                    controller:
                                                        passwordController,
                                                    obscureText: !ispassshow,
                                                    keyboardType:
                                                        TextInputType.text,
                                                    textInputAction:
                                                        TextInputAction.done,
                                                    onEditingComplete: () =>
                                                        FocusScope.of(context)
                                                            .unfocus(),
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        color: Colors.grey),
                                                    decoration: InputDecoration(
                                                      contentPadding:
                                                          EdgeInsets.only(
                                                              top: 14),
                                                      prefixIcon: Icon(
                                                          Icons.lock_outlined),
                                                      border: InputBorder.none,
                                                      hintText: "Password",
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 20,
                                                ),
                                                gradientbutton1(),
                                                SizedBox(
                                                  height: 80,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      "Don\'t have and account ?",
                                                      style: TextStyle(
                                                          color:
                                                              Colors.white70),
                                                    ),
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                    GestureDetector(
                                                      child: Text(
                                                        'Signup here',
                                                        style: new TextStyle(
                                                            fontSize: 16.0,
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      onTap: () {
                                                        Navigator.of(context).push(
                                                            MaterialPageRoute(
                                                                builder: (BuildContext
                                                                        context) =>
                                                                    Register()));
                                                      },
                                                    )
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        )),
                                      ])))),
                    ),
                    Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 10.0),
                          child: Text('version 1.0.0',
                              textAlign: TextAlign.center),
                        ))
                  ]),
                )))));
  }

  Widget gradientbutton() {
    return InkWell(
      splashColor: Colors.white,
      onTap: () {
        Employee();
      },
      child: Material(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
        elevation: 6.0,
        child: Container(
          decoration: BoxDecoration(
              gradient:
                  LinearGradient(colors: <Color>[Colors.orange, Colors.red]),
              borderRadius: BorderRadius.circular(40)),
          height: 50,
          width: MediaQuery.of(context).size.width * 0.75,
          child: Center(
              child: Text(
            'Login',
            style: TextStyle(
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          )),
        ),
      ),
    );
  }

  Widget gradientbutton1() {
    return InkWell(
      splashColor: Colors.white,
      onTap: () {
        customer();
      },
      child: Material(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
        elevation: 6.0,
        child: Container(
          decoration: BoxDecoration(
              gradient:
                  LinearGradient(colors: <Color>[Colors.orange, Colors.red]),
              borderRadius: BorderRadius.circular(40)),
          height: 50,
          width: MediaQuery.of(context).size.width * 0.75,
          child: Center(
              child: Text(
            'Login',
            style: TextStyle(
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          )),
        ),
      ),
    );
  }
}
