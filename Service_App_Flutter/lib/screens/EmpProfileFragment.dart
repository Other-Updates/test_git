// ignore: file_names
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:service_app/Utils/Constants.dart';
import 'package:service_app/Utils/storageUtil.dart';
import 'package:http/http.dart' as http;
import 'package:service_app/components/Textads.dart';
import 'package:service_app/screens/EmpServiceFragment.dart';
import 'package:service_app/screens/EmpTodaytaskFragment.dart';
import 'package:service_app/screens/EmphomeFragment.dart';
import 'package:service_app/screens/LoginScreen.dart';


class EmpProfileFragment extends StatefulWidget {
  @override
  _EmpProfileFragmentState createState() => _EmpProfileFragmentState();
}

class _EmpProfileFragmentState extends State<EmpProfileFragment> {
  var _scaffoldKey = new GlobalKey<ScaffoldState>();
  var profile;
  TextEditingController emailController= TextEditingController();
  TextEditingController phonenumberController= TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  int _selectedIndex = 0;
  String saveprofile="";
  proofilepic() async {
    var data = json.encode({"emp_id": mobile_test5,"admin_image":_image});
    final response = await http.post(BASE_URL + 'api_employee_image_upload', headers: {'authorization': basicAuth}, body: data);
    print(data);
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      print(jsonResponse);
      if(jsonResponse['status'] == "success"){
        setState(() {
          profile = jsonResponse['data'];
          print(profile);
        });
      }else if(jsonResponse['status'] == 'Error'){
        Navigator.pop(context);

      }

    }else {
      Navigator.pop(context);
    }
  }
  updateprofile() async {
    var data = json.encode({"emp_id":"11","username":usernameController.text,"email_id":emailController.text,"mobile_no":phonenumberController.text,"password":passwordController.text});
    final response = await http.post(BASE_URL + 'update_employee_profile', headers: {'authorization': basicAuth}, body: data);
    print(data);
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      print(jsonResponse);
      if(jsonResponse['status'] == "success"){
        setState(() {
          profile = jsonResponse['data'];
          /*  emailController.text=profile['email_id'];
          phonenumberController.text=profile['mobile_no'];
          usernameController.text=profile['name'];
          passwordController.text=profile['pass'];*/
          /* StorageUtil.setItem("login_customer_id", profile['id']);
          StorageUtil.setItem("login_customer_name", profile['name']);
          StorageUtil.setItem("login_customer_mobil_number", profile['mobil_number']);
          StorageUtil.setItem("login_customer_email_id", profile['email_id']);
          StorageUtil.setItem("login_customer_created_date", profile['created_date']);
          StorageUtil.setItem("login_customer_type", profile['type']);
          StorageUtil.setItem("login_customer_password", profile['password']);*/
          print(profile);
        });
      }else if(jsonResponse['status'] == 'Error'){
        Navigator.pop(context);

      }

    }else {
      Navigator.pop(context);

    }
  }
  String mobile_test = '';
  String mobile_test1 = '';
  String mobile_test2 = '';
  String mobile_test3 = '';
  String mobile_test4 = '';
  String mobile_test5 = '';
  void getEditableText() async {
    try {
      String data = await StorageUtil.getItem("login_employee_name");
      String data1 = await StorageUtil.getItem("login_employee_mobil_number");
      String data2 =
      await StorageUtil.getItem("login_employee_created_date");
      String data3 =
      await StorageUtil.getItem("login_employee_email_id");
      String data4 = await StorageUtil.getItem("login_employee_password");
      String data5 = await StorageUtil.getItem("login_employee_id");


      setState(() {
        mobile_test = data;
        print(mobile_test);
        mobile_test1 = data1;
        mobile_test2 = data2;
        mobile_test3 = data3;
        mobile_test4 = data4;
        mobile_test5 = data5;
        print("ytryjuur===="+mobile_test3);
      });
    } catch (ex) {
      print(ex);
    }
  }
  String mobile_test6 = '';

  getTextFromFile() async {
    try {
      String data = await StorageUtil.getItem("login_employee_id");
      setState(() {
        mobile_test6 = data;
      });
    } catch (ex) {
      print(ex);
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
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Are you sure want to logout?'),
          /*       content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('We will be redirected to login page.'),
              ],
            ),
          ),*/
          actions: <Widget>[
            FlatButton(
              child: Text('No',style: TextStyle(color:Color(0xff004080)),),
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss the Dialog
              },
            ),
            FlatButton(
              child: Text('Yes',style: TextStyle(color:Color(0xff004080)),),
              onPressed: () {
                customerlogout();
                //   SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                // Navigate to login
              },
            ),
          ],
        );
      },
    );
  }
  customerlogout() async {
    await getTextFromFile();
    var data = json.encode({"user_id": mobile_test6, "user_type": "2"});
    final response = await http.post(BASE_URL + 'customer_log_out', headers: {'authorization': basicAuth}, body: data);
    print(data);
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      print(jsonResponse);
      if(jsonResponse['status'] == "true"){
        StorageUtil.remove('login_customer_id');
        await Future.delayed(Duration(seconds: 1));
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => LoginScreen()), (Route<dynamic> route) => false);
      }else if(jsonResponse['status'] == 'Error'){
        Navigator.pop(context);
        // _showMessageInScaffold(jsonResponse['message']);
      }
      //   sharedPreferences.setString("token", jsonResponse['token']);
    }else {
      Navigator.pop(context);
      //    _showMessageInScaffold('Contact Admin!!');
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getEditableText();
    setState(() {
      emailController.text=mobile_test3;
      phonenumberController.text=mobile_test1;
      usernameController.text=mobile_test;
      passwordController.text=mobile_test4;
    });
  }
  var _image ;
  Future<void> _optionsDialogBox() {
    return showDialog(context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Add Photo!'),
            content: new SingleChildScrollView(
              child: new ListBody(
                children: <Widget>[
                  GestureDetector(
                      child: new Text('Take Photo'),
                      onTap: () {
                        opencamera();
                        Navigator.of(context).pop();
                      }),

                  Padding(
                    padding: EdgeInsets.all(8.0),
                  ),
                  GestureDetector(
                      child: new Text('Choose from Gallery'),
                      onTap: () {
                        opengallery();
                        Navigator.of(context).pop();
                      }),

                  Padding(
                    padding: EdgeInsets.all(8.0),
                  ),
                  GestureDetector(
                      child: new Text('Cancel'),
                      onTap: () {
                        Navigator.of(context).pop();
                      }
                    //   onTap: openCamera,
                  ),
                ],
              ),
            ),
          );
        });
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
        title: Text('Are you sure want to leave?'),
        actions: [
          ElevatedButton(
              onPressed: () {
                willLeave = false;
                SystemNavigator.pop();              },
              child: Text('Yes')),
          TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('No'))
        ],
      ));
    return willLeave;
    },
     child: Scaffold(
      appBar: AppBar(
        leadingWidth: 110,
        centerTitle: true,
        backgroundColor: new Color(0xff004080),
         leading: Image.asset('assets/images/service_logo.png',
        ),
 /*       leading: new IconButton(
            alignment: Alignment.topLeft,
            icon: new Icon(Icons.arrow_back),
            onPressed: (){Navigator.pop(context,true);}
        ),*/
        title: Text('Profile'),
        //   centerTitle: true,
          automaticallyImplyLeading: false,
        actions: <Widget>[
          IconButton(icon: Icon(Icons.power_settings_new_rounded, color: Colors.white,), onPressed: () {_showMyDialog();}),
        ],

      ),
      key:_scaffoldKey,
      resizeToAvoidBottomInset: false,
      body: Container(
      child:Stack(
    children: [
    Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/images/bg_profile.png'),
                  fit: BoxFit.cover
              )
          ),
          child: ListView(
            children: [
              Container(
                alignment: Alignment.topCenter,
                child: Align(
                  child: Stack(
                      children:<Widget> [
                        CircleAvatar(
                            radius: 55,
                            backgroundColor: Colors.white,
                            child:
                            ClipRRect(
                              borderRadius: BorderRadius.circular(55),
                              child:_image != null ?Image.file(
                                _image ,
                                width: double.infinity,
                                height: double.infinity,
                                fit: BoxFit.cover,
                              ):Container() ,
                            ) ),
                        // profile['profile_image']
                        Positioned(
                          right: 5.0,
                          bottom: 0.0,
                          child:Container(
                              height: 35,
                              width:35,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30.0),
                                color: Color(0xff004080),
                              ),
                              child:IconButton(
                                alignment: Alignment.center,
                                icon: Icon(Icons
                                    .camera_alt, color: Colors.white),

                                color: Color(0xff004080), onPressed: () {   _optionsDialogBox(); },
                              )   ),
                        ),
                      ]),),),
Container(
  padding: EdgeInsets.fromLTRB(30, 10, 30, 5),
            child:  Text('Name',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 17,
                  color: Colors.grey,
                ),
              ),),
              Container(
                padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
                child: TextField(
                controller: usernameController,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(32.0)

                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(32.0)),
                    borderSide: BorderSide(color: Color(0xff004080), width: 2),

                  ),
                ),
              ),),
              Container(
                padding: EdgeInsets.fromLTRB(30, 10, 30, 10),
                child:  Text('Email',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 17,
                  color: Colors.grey,
                ),
              ),),
              Container(
                padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
                child:  TextField(
                controller: emailController,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(32.0)
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(32.0)),
                    borderSide: BorderSide(color: Color(0xff004080), width: 2),

                  ),
                ),
              ),),
              Container(
                padding: EdgeInsets.fromLTRB(30, 10, 30, 10),
                child:  Text('Mobile',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 17,
                  color: Colors.grey,
                ),
              ),),
              Container(
                padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
                child:  TextField(
                controller: phonenumberController,
                maxLength: 10,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  counterText: "",
                  contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),

                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(32.0)

                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(32.0)),
                    borderSide: BorderSide(color: Color(0xff004080), width: 2),

                  ),
                ),
              ),),
              Container(
                padding: EdgeInsets.fromLTRB(30, 10, 30, 10),
               child: Text('Password',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 17,
                  color: Colors.grey,
                ),
              ),),
              Container(
                padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
                child: TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),

                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(32.0)
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(32.0)),
                    borderSide: BorderSide(color: Color(0xff004080), width: 2),

                  ),
                ),

              ),),
              Container(
                  height: 90,
                  padding: EdgeInsets.fromLTRB(30, 20, 30, 20),
                  child:
                  RaisedButton(
                    onPressed: () => {
                      if(usernameController.text == ""){
                        _showMessageInScaffold("please enter name"),
                      },
                    if(emailController.text == ""){
                    _showMessageInScaffold("please enter email"),
                        },if (emailController.text.length < 10){
                      _showMessageInScaffold("please enter valid email id"),
              },
                   if(phonenumberController.text== ""){
                     _showMessageInScaffold  ("please enter mobile number"),
                         },
                      if(phonenumberController.text.length < 10){
                        _showMessageInScaffold  ("please enter valid mobile number"),
                      },
                        if(passwordController.text== ""){
                          _showMessageInScaffold("please enter password"),
                              },
                      proofilepic(),
                      updateprofile(),
                             },
                    textColor: Colors.white,
                    color: Color(0xff004080),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular((32.0))),
                    child: Text('SAVE', style: TextStyle(fontSize: 20),
                    ),
                  )
              ),])),
      Container(
          alignment:Alignment.bottomCenter,
          child:Column(
              mainAxisSize: MainAxisSize.min,
              children:[
              Container(
                height: 30,
              // padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                child:TextAds(),
              ),
              Container(
              // padding: EdgeInsets.fromLTRB(3, 10, 3, 10),
                width: double.infinity,
                child: Row(
                  children: [
                    Expanded(
                        child:Column(
                            children: [
                              IconButton(onPressed: (){
                                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => EmpServiceFragment()));
                              }, icon: Icon(Icons.home_repair_service_outlined,    color:Color(0xff004080),)),
                              Text('Services',   style: TextStyle(
                                color:Color(0xff004080),

                              ),),]),
                        flex:5),
                    Expanded(
                        child:Column(
                            children: [
                              IconButton(onPressed: (){
                                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => EmpTodaytaskFragment()));
                              }, icon: Icon(Icons.sticky_note_2_outlined,   color:Color(0xff004080),)),
                              Text('Today Task',   style: TextStyle(
                                color:Color(0xff004080),

                              ),),]),
                        flex:5),
                    Expanded(
                        child:Column(
                            children: [
                              IconButton(onPressed: (){
                                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => EmphomeFragment()));
                              }, icon: Icon(Icons.home_outlined,   color:Color(0xff004080),)),
                              Text('Home',   style: TextStyle(
                                color:Color(0xff004080),

                              ),),]),
                        flex:5),
                    Expanded(
                        child:Column(
                            children: [
                              IconButton(onPressed: (){
                                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => EmpProfileFragment()));
                              }, icon: Icon(Icons.person_outline,   color:   Color(0xffff7000))),
                              Text('Profile',   style: TextStyle(
                                color:  Color(0xffff7000),

                              ),),]),
                        flex:5),
                  ],
                ),
              )])),
              /*   Container(
                alignment: Alignment.bottomCenter,
                height: 30,
                child:TextAds(),
              ),*/
            ],
          )
      ),
    ));
  }
  void opencamera() async {
    var image = await ImagePicker.pickImage(
        source: ImageSource.camera, imageQuality: 50
    );
    setState(() {
      _image = image;
    });
  }
  void opengallery()async  {
    var image = await  ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 50
    );
    setState(() {
      _image = image;
    });

  }
}
