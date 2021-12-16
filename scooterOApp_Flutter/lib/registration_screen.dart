import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:scotto/Scprogressdialog.dart';
import 'package:scotto/login_screen.dart';
import 'package:scotto/constants.dart';
import 'package:scotto/registerotpverify.dart';
import 'package:scotto/utils/Language.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:scotto/choose_language.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class RegistrationScreen extends StatefulWidget {
  @override
  RegistrationScreenState createState() => RegistrationScreenState();
  }

  class RegistrationScreenState extends State<RegistrationScreen> {
  int selectedDropdown;
  String selectedText;
  var _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController mobilenoController = TextEditingController();
  final TextEditingController dateofbirthController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController genderController = TextEditingController();

  var _GENERIC_NAME = ' ',_GENERIC_NUMBER = '',_GENERIC_DOB ='',_GENERIC_PASSWORD ='',_GENERIC_GENDER ='',_GENERIC_EMAIL ='', _GENERIC_REGISTRATION_GOOGLE ='', _GENERIC_REGISTER ='', _GENERIC_ALREADY_HAVE_ACCOUNT ='', _GENERIC_REGISTRATION_REGISTER ='', _GENERIC_OR ='', _GENERIC_CHOOSE_LANGUGAE ='' ;



  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  SharedPreferences _sharedPreferences;

  getLanguage() async {
    _sharedPreferences = await _prefs;
    // print(Language.getLocalLanguage(_sharedPreferences,'GENERIC_LOGIN'));
    setState(() {
      _GENERIC_NAME = Language.getLocalLanguage(_sharedPreferences, 'GENERIC_NAME');
      _GENERIC_NUMBER = Language.getLocalLanguage(_sharedPreferences, "GENERIC_NUMBER");
      _GENERIC_DOB = Language.getLocalLanguage(_sharedPreferences, "GENERIC_DOB");
      _GENERIC_GENDER = Language.getLocalLanguage(_sharedPreferences, "GENERIC_GENDER");
      _GENERIC_EMAIL = Language.getLocalLanguage(_sharedPreferences, "GENERIC_EMAIL");
      _GENERIC_PASSWORD = Language.getLocalLanguage(_sharedPreferences, "GENERIC_PASSWORD");
      _GENERIC_REGISTER = Language.getLocalLanguage(_sharedPreferences, "GENERIC_REGISTER");
      _GENERIC_ALREADY_HAVE_ACCOUNT = Language.getLocalLanguage(_sharedPreferences, "GENERIC_ALREADY_HAVE_ACCOUNT");
      _GENERIC_REGISTRATION_REGISTER = Language.getLocalLanguage(_sharedPreferences, "GENERIC_REGISTRATION_REGISTER");
      _GENERIC_OR = Language.getLocalLanguage(_sharedPreferences, "GENERIC_OR");
      _GENERIC_REGISTRATION_GOOGLE = Language.getLocalLanguage(_sharedPreferences, "GENERIC_REGISTRATION_GOOGLE");
      _GENERIC_CHOOSE_LANGUGAE = Language.getLocalLanguage(_sharedPreferences, "GENERIC_CHOOSE_LANGUGAE");

    });

  }

  register() async {
    final isValid = _formKey.currentState.validate();
    if (!isValid) {
      return;
    }
    if(nameController.text == ""){
      _showMessageInScaffold("Please enter your name");
    }else if(passwordController.text == ""){
      _showMessageInScaffold("Please enter password");
    }else if(mobilenoController.text == ""){
      _showMessageInScaffold("Please enter mobile number");
    }else if(emailController.text == "") {
      _showMessageInScaffold("Please enter Email Id");
    }
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context)
        {
          return Scprogressdialog("Please wait while Registering...");
        }

    );
    String basicAuth = "Basic YWRtaW46MTIzNA==";
    //   SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var data = json.encode({"name":nameController.text,"mobile_number":mobilenoController.text,"dob":"","gender":"","email":emailController.text,"password":passwordController.text,"googleid":"","isGoogle":""});
    final response = await http.post(baseurl+'api_customer_registeration', headers: {'authorization': basicAuth}, body: data);

    if(response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      print(jsonResponse);
      if (jsonResponse ['status'] == 'Success') {
        var customer_id = jsonResponse['customer_id'];
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
            builder: (BuildContext context) => RegisterOtpVerification(customer_id)), (
            Route<dynamic> route) => false);

      } else if (jsonResponse['status'] == 'Error') {
        Navigator.pop(context);
        print(jsonResponse['message']);
        _showMessageInScaffold(jsonResponse['message']);
      }
      //   sharedPreferences.setString("token", jsonResponse['token']);
    }
    else {
      Navigator.pop(context);
      _showMessageInScaffold('Contact Admin!!');
    }
  }

  DateTime selectedDate = DateTime.now();
  DateFormat dateFormat = DateFormat("dd/MM/yyyy");
  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1900),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        //   dateofbirthController.value=TextEditingValue(text:selectedDate.toString());
        dateofbirthController.text = selectedDate.toString().substring(0,10);
      });
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
    getLanguage();
    selectedDropdown = 1;
    genderController.addListener(() => print(''));
  }

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        body: Center(

            child: Container(
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/images/background.png'),
                        colorFilter: ColorFilter.mode(Color(0xffF1FDF0).withOpacity(1.0), BlendMode.dstATop),

                        fit: BoxFit.cover)
                ),

                    child: ListView(

                      children: <Widget>[

                        Container(
                            padding: EdgeInsets.only(top: 70.0,bottom: 10,left: 10.0),
                            alignment: Alignment.centerLeft,

                            child: Text(
                              _GENERIC_REGISTER ,
                              style: TextStyle(
                                  color: Color(0xff676767),
                                  fontWeight: FontWeight.bold, fontFamily: 'Montserrat',
                                  fontSize: 20),
                            )),
                Container(
                    child:Form(
                      key: _formKey,
                      child: Column(
                        children: [
                        Container(

                          padding: EdgeInsets.fromLTRB(10, 8, 10, 0),
                          child: TextFormField(
                            controller: nameController,

                            validator: (value) {
                              String pattern = r'(^[a-zA-Z ]*$)';
                              RegExp regExp = new RegExp(pattern);
                              if (value.length == 0) {
                                return "Please enter your name";
                              } else if (!regExp.hasMatch(value)) {
                                return "Name must be a-z and A-Z";
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              isDense: true,
                              contentPadding: EdgeInsets.fromLTRB(5, 15, 5, 0),
                              hintText: _GENERIC_NAME ,
                              prefixIcon: Icon(Icons.person_outline,color: Color(0xff00DD00),size: 20),
                              hintStyle: TextStyle(color: Colors.grey,fontFamily: 'Montserrat',fontSize: 15),
                              filled: true,
                              fillColor: Colors.white,
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                borderSide: BorderSide(color: Color(0xff00DD00), width: 0.8),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                borderSide: BorderSide(color: Color(0xff00DD00), width: 0.8),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                borderSide: BorderSide(color: Color(0xff00DD00), width: 0.8),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                borderSide: BorderSide(color: Color(0xff00DD00), width: 0.8),
                              ),
                            ),
                          ),
                        ),
                        Container(

                          padding: EdgeInsets.fromLTRB(10, 8, 10, 0),
                          child: TextFormField(
                            validator: (value) {
                              if (value.isEmpty ) {
                                return 'Please enter mobile number';
                              }
                              else if (value.length < 10){
                                return "Your phone number must be in 10 digits";
                              }
                              return null;
                            },
                            keyboardType: TextInputType.phone,
                            controller: mobilenoController,
                            maxLength: 10,
                            decoration: InputDecoration(
                              isDense: true,
                              contentPadding: EdgeInsets.fromLTRB(5, 15, 5, 0),
                              border: InputBorder.none,
                              counterText: "",
                              hintText:  _GENERIC_NUMBER ,
                              prefixIcon: Icon(Icons.phone_outlined,color: Color(0xff00DD00),size: 20),
                              hintStyle: TextStyle(color: Colors.grey,fontFamily: 'Montserrat',fontSize: 15),
                              filled: true,
                              fillColor: Colors.white,
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                borderSide: BorderSide(color: Color(0xff00DD00), width: 0.8),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                borderSide: BorderSide(color: Color(0xff00DD00), width: 0.8),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                borderSide: BorderSide(color: Color(0xff00DD00), width: 0.8),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                borderSide: BorderSide(color: Color(0xff00DD00), width: 0.8),
                              ),
                            ),
                          ),
                        ),

                        Container(

                            padding: EdgeInsets.fromLTRB(10, 8, 15, 0),
                            child: new Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Flexible(
                                  child: Padding(
                                      padding: EdgeInsets.only(right: 10.0),

                                      child: Text(
                                          '${_GENERIC_DOB}(Optional)',
                                          style: TextStyle(color: Colors.grey,fontFamily: 'Montserrat',fontSize: 15)

                                          )   ),
                                  flex: 2,
                                ),
                                Flexible(
                                  child: Padding(
                                      padding: EdgeInsets.only(left: 20.0),

                                      child: Text(
                                          '${_GENERIC_GENDER}(Optional)',
                                           style: TextStyle(color:Colors.grey,fontFamily: 'Montserrat',fontSize: 15),

                                      )   ),
                                  flex: 2,
                                ),

                              ],
                            )),

                        Container(

                            padding: EdgeInsets.fromLTRB(10, 8, 10, 0),
                            child: new Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Flexible(
                                  child: Padding(
                                      padding: EdgeInsets.only(right: 10.0),

                                      child: TextFormField(
                                          /*validator: (value) {
                                            if (value.isEmpty ) {
                                              return 'Please enter date of birth';
                                            }
                                            return null;
                                          },*/

                                          readOnly: true,
                                          showCursor: false,
                                          controller: dateofbirthController,
                                          onTap: () =>{
                                            _selectDate(context),

                                          },

                                          decoration: InputDecoration(
                                            isDense: true,
                                            contentPadding: EdgeInsets.fromLTRB(5, 15, 5, 0),
                                            hintText: _GENERIC_DOB ,
                                            prefixIcon: Icon(Icons.date_range,color: Color(0xff00DD00),size: 20),
                                            hintStyle: TextStyle(color: Colors.grey,fontFamily: 'Montserrat',fontSize: 13),
                                            filled: true,
                                            fillColor: Colors.white,
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                              borderSide: BorderSide(color: Color(0xff00DD00), width: 0.8),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                              borderSide: BorderSide(color: Color(0xff00DD00), width: 0.8),
                                            ),
                                            errorBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                              borderSide: BorderSide(color: Color(0xff00DD00), width: 0.8),
                                            ),
                                            focusedErrorBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                              borderSide: BorderSide(color: Color(0xff00DD00), width: 0.8),
                                            ),

                                          ) )  ),
                                  flex: 2,
                                ),

                                Flexible(
                                  child: TextFormField(
                                      /*validator: (value) {
                                        if (value.isEmpty ) {
                                          return 'Please enter Gender';
                                        }
                                        return null;
                                      },*/

                                      readOnly: true,
                                      showCursor: false,
                                      cursorColor: Colors.transparent,
                                      controller: genderController,
                                      decoration:  InputDecoration(
                                        isDense: true,
                                        contentPadding: EdgeInsets.fromLTRB(5, 15, 5, 0),
                                        hintText: _GENERIC_GENDER ,
                                        prefixIcon: Icon(Icons.female_rounded,color: Color(0xff00DD00),size: 22),
                                        hintStyle: TextStyle(color: Colors.grey,fontFamily: 'Montserrat',fontSize: 15),
                                        filled: true,
                                        fillColor: Colors.white,
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                          borderSide: BorderSide(color: Color(0xff00DD00), width: 0.8),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                          borderSide: BorderSide(color: Color(0xff00DD00), width: 0.8),
                                        ),
                                      errorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                        borderSide: BorderSide(color: Color(0xff00DD00), width: 0.8),
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                        borderSide: BorderSide(color: Color(0xff00DD00), width: 0.8),
                                      ),  ),

                                      onTap: () {

                                        /*  FocusScopeNode currentFocus = FocusScope.of(context);
       if (!currentFocus.hasPrimaryFocus) {
         currentFocus.unfocus();
       }*/
                                        showModalBottomSheet(

                                          // isDismissible: VerticalDirection.down,
                                            enableDrag: true,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(25),
                                                  topRight: Radius.circular(25)),),
                                            isScrollControlled: true,
                                            context: context,
                                            builder: (BuildContext context) {

                                              return Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(18.0),
                                                  ),
                                                  height: 160.0,
                                                  child: new ListView(

                                                    children: [
                                                      Container(
                                                          padding: EdgeInsets.fromLTRB(12, 25, 12, 0),
                                                          child: Text(
                                                              _GENERIC_GENDER,
                                                              style: TextStyle(fontSize: 20,fontFamily: 'Montserrat',
                                                                  color: Colors.black54,
                                                                  fontWeight: FontWeight.bold)

                                                          )),
                                                      Container(
                                                        padding: EdgeInsets.fromLTRB(12, 10, 12, 0),
                                                        child:FlatButton(

                                                          child: Text(
                                                              'Male',
                                                              style: TextStyle(fontSize: 18,
                                                                  color: Colors.black54,fontFamily: 'Montserrat'
                                                              )
                                                          ),
                                                          onPressed: () {
                                                            genderController.text = "Male";
                                                            TextStyle(color: Colors.black54,fontFamily: 'Montserrat');
                                                            Navigator.of(context).pop();

                                                          },
                                                        ),

                                                      ),
                                                      Container(
                                                        child:FlatButton(
                                                          padding: EdgeInsets.fromLTRB(12, 10, 12, 0),
                                                          textColor: Colors.black38,
                                                          child: Text(
                                                              'Female',
                                                              style: TextStyle(fontSize: 18,
                                                                  color: Colors.black54,fontFamily: 'Montserrat'
                                                              )
                                                          ),
                                                          onPressed: () {
                                                            genderController.text = "Female";
                                                            TextStyle(color: Colors.black54,fontFamily: 'Montserrat');
                                                            Navigator.of(context).pop();

                                                          },
                                                        ),),
                                                    ],
                                                  ));

                                            }

                                        );

                                      }

                                  ),
                                  flex: 2,
                                ),
                              ],
                            )),





                        Container(

                          padding: EdgeInsets.fromLTRB(10, 8, 10, 0),
                          child: TextFormField(
                         /*   validator: (value) {
                              String pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                              RegExp regExp = new RegExp(pattern);
                              if (value.length == 0) {
                                return "Please enter Email Id";
                              } else if (!regExp.hasMatch(value)) {
                                return "Invalid Email";
                              } else {
                                return null;
                              }   },*/
                            validator: (value){
                              Pattern pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                              RegExp regex = new RegExp(pattern);
                              // Null check
                              if(value.isEmpty){
                                return 'please enter your email';
                              }
                              else if(!regex.hasMatch(value)){
                                return 'Enter valid email address';
                              }
                              // success condition

                              return null;
                            },
                            keyboardType: TextInputType.emailAddress,
                            controller: emailController,
                            decoration: InputDecoration(
                              isDense: true,
                              contentPadding: EdgeInsets.fromLTRB(5, 15, 5, 0),
                              hintText: _GENERIC_EMAIL ,
                              prefixIcon: Icon(Icons.email_outlined,color: Color(0xff00DD00),size: 20),
                              hintStyle: TextStyle(color: Colors.grey,fontFamily: 'Montserrat',fontSize: 15),
                              filled: true,
                              fillColor: Colors.white,
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                borderSide: BorderSide(color: Color(0xff00DD00), width: 0.8),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                borderSide: BorderSide(color: Color(0xff00DD00), width: 0.8),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                borderSide: BorderSide(color: Color(0xff00DD00), width: 0.8),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                borderSide: BorderSide(color: Color(0xff00DD00), width: 0.8),
                              ),


                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(10, 8, 10, 0),
                          child: TextField(
                            key: ValueKey('password'),
                            obscureText: true,
                          /*  validator: (value) {
                              if (value.isEmpty ) {
                                return 'Please enter password';
                              }
                              return null;
                            },*/
                            controller: passwordController,
                            decoration: InputDecoration(
                              isDense: true,
                              contentPadding: EdgeInsets.fromLTRB(5, 15, 5, 0),
                              hintText: _GENERIC_PASSWORD ,
                              prefixIcon: Icon(Icons.lock_outline_rounded,color: Color(0xff00DD00),size: 20),
                              hintStyle: TextStyle(color: Colors.grey,fontFamily: 'Montserrat',fontSize: 15),
                              filled: true,
                              fillColor: Colors.white,
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                borderSide: BorderSide(color: Color(0xff00DD00), width: 0.8),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                borderSide: BorderSide(color: Color(0xff00DD00), width: 0.8),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                borderSide: BorderSide(color: Color(0xff00DD00), width: 0.8),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(8.0)),
                                borderSide: BorderSide(color: Color(0xff00DD00), width: 0.8),
                              ),
                            ),
                          ),
                        ),]))),
                        Container(
                            height: 55,
                            margin:EdgeInsets.fromLTRB(10,8, 10, 0),

                            child: RaisedButton(

                              textColor: Colors.white,
                              color: Color(0xff00DD00),
                              child: Text( _GENERIC_REGISTER ,style:TextStyle(fontFamily: 'Montserrat',fontWeight: FontWeight.bold)),
                              shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(8.0),
                              ),

                              onPressed: /*phonenumberController.text == "" || passwordController.text == "" ? null :*/ () {

                                setState(() {
                                  _isLoading = true;
                                });
                                register();

                              },
                            )),
                        Container(
                            child: Row(
                              children: <Widget>[
                                FlatButton(
                                  textColor: Color(0xffB1B1B1),
                                  child: Text(
                                    _GENERIC_CHOOSE_LANGUGAE ,
                                    style: TextStyle(fontSize: 15,fontFamily: 'Montserrat'),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (BuildContext context) => ChooseLanguage()
                                        )
                                    );   //signup screen
                                  },
                                )
                              ],
                            )),

                        Container(
                            padding: EdgeInsets.only(top: 0.5,bottom: 0.5),
                            child: Row(
                              children: <Widget>[
                                FlatButton(
                                  textColor:  Color(0xff00DD00),
                                  child: Text(
                                    _GENERIC_OR ,
                                    style: TextStyle(fontSize: 15,fontFamily: 'Montserrat',color:Color(0xffB1B1B1) ),
                                  ),

                                )
                              ],
                              mainAxisAlignment: MainAxisAlignment.center,
                            )),


                        /*Container(
                          margin:EdgeInsets.fromLTRB(10,8, 10, 0),
                          height: 40,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              //  border: EdgeInsets.fromLTRB(10,8, 10, 0),

                              borderRadius: BorderRadius.circular(3.0),
                              boxShadow: [
                                BoxShadow(color: Colors.black38, offset: Offset(2.0, 2.0))
                              ]),


                          child: Row(
                            //   mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.fromLTRB(20,5, 80, 5),
                                // decoration: BoxDecoration(color: Colors.blue)
                                child: Image.asset(
                                  'assets/images/google.png',
                                  height: 18,
                                  width: 18,
                                ),
                              ),
                              *//*SizedBox(
                        width: 5.0,
                      ),*//*

                              *//* Text('Register in using Google',
            style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold,color: Colors.black54,),)
*//*
                              GestureDetector(
                                child: Text( _GENERIC_REGISTRATION_GOOGLE ,  style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold,color: Colors.black54,),),
                                onTap: () async {
                                  bool res = await AuthProvider().loginWithGoogle();
                                  if(!res)
                                    print("error logging in with google");
                                },
                              ),

                            ],
                          ),
                        ),
*/
                        Container(
                            child: Row(
                              children: <Widget>[
                                FlatButton(
                                  textColor:  Color(0xff00DD00),
                                  child: Text(
                                    _GENERIC_ALREADY_HAVE_ACCOUNT ,
                                    style: TextStyle(fontSize: 15,fontFamily: 'Montserrat'),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                            builder: (BuildContext context) => LoginScreen()
                                        )
                                    );   //signup screen
                                  },
                                )
                              ],
                              mainAxisAlignment: MainAxisAlignment.center,
                            ))
                      ],
                    )) ));
  }


}





