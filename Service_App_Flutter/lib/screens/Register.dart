import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:service_app/Utils/Constants.dart';
import 'package:service_app/Utils/storageUtil.dart';
import 'package:service_app/screens/CusHomeFragment.dart';
import 'package:service_app/screens/mobilelogin.dart';
import 'package:http/http.dart' as http;

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
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
  bool ispassshow = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,

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
                fit: BoxFit.fill
            )
        ),
        // padding: EdgeInsets.fromLTRB(0,5, 0, 20),


        child: Stack(
            children:<Widget> [
              Align(
                  alignment:Alignment.topLeft,
                  //   child:Column(
                  //   children:[
                  child: Container(
                      padding: EdgeInsets.only(top: 190),
                      child:Column(
                          mainAxisSize: MainAxisSize.min,
                          children:[

                            Container(
                              height: 40,
                              width: 80,
                              padding: EdgeInsets.only(right: 8),
                              child:GestureDetector(
                                onTap: (){
                                  Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => LoginPage()) );
                                },
                                child:    new Icon(Icons.arrow_back,color: Colors.white70),),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color:Color(0xffff7000) ,
                                  borderRadius: BorderRadius.only(bottomRight: Radius.circular(22.0),topRight: Radius.circular(22.0))
                              )
                            ),
                            SizedBox(
                              height: 10,
                            ),
                          ]))

              ),
              Align(
                  alignment: Alignment.centerRight,
                  child: Form(
                      key: _formKey,
                      child: Container(
                          height:500,
                          width: 270,
                          // padding: EdgeInsets.fromLTRB(50,120, 80, 200),
                          decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.circular(20.0),
                              //   borderRadius: BorderRadius.only(topLeft: Radius.circular(250.0),bottomRight:Radius.circular(250.0)),
                              gradient: LinearGradient(
                                //begin: Alignment.topLeft,
                                  end: Alignment.bottomLeft,

                                  colors: [Color(0xff282a5c),  Color(0xffa83e57)])

                          ),
                          child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children:<Widget> [

                                Container(
                                    padding: EdgeInsets.only(top: 60.0),
                                    alignment: Alignment.topCenter,
                                    child:Text('REGISTER',style: TextStyle(fontSize: 20,fontWeight:FontWeight.bold,color: Colors.white),)
                                ),


                                Expanded(
                                    child: Container(
                                      //color: Colors.grey[200],
                                      child: Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Material(
                                              elevation: 6.0,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(40)),
                                              child: TextFormField(
                                               /* validator: (value) {
                                                  if (value!.isEmpty) {
                                                    return 'Please enter email ID';
                                                  } else if (value.length < 10) {
                                                    return "Enter valid email ID";
                                                  }
                                                  return null;
                                                },*/
                                                obscureText: false,
                                               // focusNode: myFocusNode1,
                                                //   maxLength: 10,
                                                controller: emailController,
                                                keyboardType: TextInputType.emailAddress,
                                                textInputAction: TextInputAction.next,
                                                onEditingComplete: () =>
                                                    FocusScope.of(context).nextFocus(),
                                                style: TextStyle(fontSize: 18, color: Colors.grey),
                                                decoration: InputDecoration(
                                                  contentPadding: EdgeInsets.only(top: 14),
                                                  prefixIcon: Icon(Icons.email_outlined),
                                                  border: InputBorder.none,
                                                  hintText: "Email ID",
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 20,
                                            ),
                                            Material(
                                              elevation: 6.0,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(40)),
                                              child: TextFormField(
                                               /* validator: (value) {
                                                  if (value!.isEmpty) {
                                                    return 'Please enter mobile number';
                                                  } else if (value.length < 10) {
                                                    return "Enter valid mobile number";
                                                  }
                                                  return null;
                                                },*/
                                                obscureText: false,
                                                autofocus: false,
                                               // focusNode: myFocusNode1,
                                                keyboardType: TextInputType.number,
                                                inputFormatters: <TextInputFormatter>[
                                                  FilteringTextInputFormatter.digitsOnly
                                                ],
                                               // obscureText: !ispassshow,
                                                onEditingComplete: () =>
                                                    FocusScope.of(context).unfocus(),
                                                style: TextStyle(fontSize: 18, color: Colors.grey),
                                                decoration: InputDecoration(
                                                  contentPadding: EdgeInsets.only(top: 14),
                                                  prefixIcon: Icon(Icons.phone_outlined),
                                                  border: InputBorder.none,

                                                  hintText: "Phone No",
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 20,
                                            ),
                                            Material(
                                              elevation: 6.0,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(40)),
                                              child: TextFormField(
                                               /* validator: (value) {
                                                  if (value!.isEmpty) {
                                                    return 'Please enter username';
                                                  }
                                                  return null;
                                                },*/
                                                // obscureText: !ispassshow,
                                                keyboardType: TextInputType.text,
                                                textInputAction: TextInputAction.done,
                                                onEditingComplete: () =>
                                                    FocusScope.of(context).unfocus(),
                                                style: TextStyle(fontSize: 18, color: Colors.grey),
                                                decoration: InputDecoration(
                                                  contentPadding: EdgeInsets.only(top: 14),
                                                  prefixIcon: Icon(Icons.person_outline),
                                                  border: InputBorder.none,

                                                  hintText: "User Name",
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 20,
                                            ),
                                            Material(
                                              elevation: 6.0,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(40)),
                                              child: TextFormField(
                                               /* validator: (value) {
                                                  if (value!.isEmpty) {
                                                    return 'Please enter password';
                                                  }
                                                  return null;
                                                },*/
                                                obscureText: !ispassshow,
                                                keyboardType: TextInputType.text,
                                                textInputAction: TextInputAction.done,
                                                onEditingComplete: () =>
                                                    FocusScope.of(context).unfocus(),
                                                style: TextStyle(fontSize: 18, color: Colors.grey),
                                                decoration: InputDecoration(
                                                  contentPadding: EdgeInsets.only(top: 14),
                                                  prefixIcon: Icon(Icons.lock_outlined),
                                                  border: InputBorder.none,
                                                  hintText: "Password",
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 20,
                                            ),
                                            gradientbutton(),
                                            SizedBox(
                                              height: 10,
                                            ),
                                          ],
                                        ),
                                      ),
                                    )),

                              ])
                      ) ) ) ]))
    )));
  }
  Widget gradientbutton() {
    return InkWell(
      splashColor: Colors.white,
      onTap: () {
        register();
        },
      child: Material(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
        elevation: 6.0,
        child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: <Color>[Colors.orange, Colors.red]),
              borderRadius: BorderRadius.circular(40)),
          height: 50,
          width: MediaQuery.of(context).size.width * 0.75,
          child: Center(
              child: Text(
                'Register',
                style: TextStyle(
                    color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
              )),
        ),
      ),
    );
  }
}
