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
import 'package:service_app/screens/EmployeProfile.dart';
import 'package:service_app/screens/LoginScreen.dart';
import 'package:service_app/screens/TodayTask.dart';
import 'package:service_app/screens/mobilelogin.dart';

class EmpDash extends StatefulWidget {
  @override
  _EmpDashState createState() => _EmpDashState();
}

class _EmpDashState extends State<EmpDash> {
  var _scaffoldKey = new GlobalKey<ScaffoldState>();
  var profile;
  TextEditingController emailController = TextEditingController();
  TextEditingController phonenumberController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  int _selectedIndex = 0;

  proofilepic() async {
    var data = json.encode({"emp_id": mobile_test5, "admin_image": _image});
    final response = await http.post(BASE_URL + 'api_employee_image_upload',
        headers: {'authorization': basicAuth}, body: data);
    print(data);
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      print(jsonResponse);
      if (jsonResponse['status'] == "success") {
        setState(() {
          profile = jsonResponse['data'];
          print(profile);
        });
      } else if (jsonResponse['status'] == 'Error') {
        Navigator.pop(context);
      }
    } else {
      Navigator.pop(context);
    }
  }

  updateprofile() async {
    var data = json.encode({
      "emp_id": mobile_test5,
      "username": usernameController.text,
      "email_id": emailController.text,
      "mobile_no": phonenumberController.text,
      "password": passwordController.text
    });
    final response = await http.post(BASE_URL + 'update_employee_profile',
        headers: {'authorization': basicAuth}, body: data);
    print(data);
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      print(jsonResponse);
      if (jsonResponse['status'] == "success") {
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
      } else if (jsonResponse['status'] == 'Error') {
        Navigator.pop(context);
      }
    } else {
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
      String data2 = await StorageUtil.getItem("login_employee_created_date");
      String data3 = await StorageUtil.getItem("login_employee_email_id");
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
        print("ytryjuur====" + mobile_test3);
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
              child: Text(
                'No',
                style: TextStyle(color: Color(0xff004080)),
              ),
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss the Dialog
              },
            ),
            FlatButton(
              child: Text(
                'Yes',
                style: TextStyle(color: Color(0xff004080)),
              ),
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
    final response = await http.post(BASE_URL + 'customer_log_out',
        headers: {'authorization': basicAuth}, body: data);
    print(data);
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      print(jsonResponse);
      if (jsonResponse['status'] == "true") {
        StorageUtil.remove('login_customer_id');
        await Future.delayed(Duration(seconds: 1));
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (BuildContext context) => LoginPage()),
            (Route<dynamic> route) => false);
      } else if (jsonResponse['status'] == 'Error') {
        Navigator.pop(context);
        // _showMessageInScaffold(jsonResponse['message']);
      }
      //   sharedPreferences.setString("token", jsonResponse['token']);
    } else {
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
      emailController.text = mobile_test3;
      phonenumberController.text = mobile_test1;
      usernameController.text = mobile_test;
      passwordController.text = mobile_test4;
    });
  }

  var _image;
  Future<void> _optionsDialogBox() {
    return showDialog(
        context: context,
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
            // appBar: AppBar(
            //   leadingWidth: 110,
            //   centerTitle: true,
            //   backgroundColor: new Color(0xff004080),
            //   leading: Image.asset(
            //     'assets/images/service_logo.png',
            //   ),
            //   title: Text('Profile'),
            //   //   centerTitle: true,
            //   automaticallyImplyLeading: false,
            //   actions: <Widget>[
            //     IconButton(
            //         icon: Icon(
            //           Icons.power_settings_new_rounded,
            //           color: Colors.white,
            //         ),
            //         onPressed: () {
            //           _showMyDialog();
            //         }),
            //   ],
            // ),
            key: _scaffoldKey,
            resizeToAvoidBottomInset: false,
            body: Container(
                width: double.infinity,
                height: double.infinity,
                //  color: Color(0xffff7000),
                child: Stack(
                  children: [
                    Container(
                        width: double.infinity,
                        height: double.infinity,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                          image: AssetImage('assets/images/profileIot.jpg'),
                          fit: BoxFit.fill,
                          // colorFilter: new ColorFilter.mode(
                          //     Colors.black.withOpacity(0.5), BlendMode.dstATop),
                        )),
                        child: Column(children: [
                          // Container(
                          //   height: 100,
                          //   child: Image.asset('assets/images/profileIot.jpg'),
                          // ),
                          SizedBox(
                            height: 130,
                          ),
                          Stack(children: [
                            Container(
                                child: Card(
                                    margin: EdgeInsets.only(top: 50),
                                    color: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(40.0),
                                          topRight: Radius.circular(40.0)),
                                    ),
                                    child: Column(children: [
                                      Container(
                                        alignment: Alignment.centerLeft,
                                        padding:
                                            EdgeInsets.fromLTRB(30, 60, 30, 5),
                                        child: Text(
                                          'Name',
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                            fontSize: 17,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding:
                                            EdgeInsets.fromLTRB(30, 0, 30, 0),
                                        child: TextField(
                                          controller: usernameController,
                                          decoration: InputDecoration(
                                            contentPadding: EdgeInsets.fromLTRB(
                                                20.0, 10.0, 20.0, 10.0),
                                            border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        32.0)),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(32.0)),
                                              borderSide: BorderSide(
                                                  color: Color(0xff004080),
                                                  width: 2),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        alignment: Alignment.centerLeft,
                                        padding:
                                            EdgeInsets.fromLTRB(30, 10, 30, 10),
                                        child: Text(
                                          'Email',
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                            fontSize: 17,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding:
                                            EdgeInsets.fromLTRB(30, 0, 30, 0),
                                        child: TextField(
                                          controller: emailController,
                                          decoration: InputDecoration(
                                            contentPadding: EdgeInsets.fromLTRB(
                                                20.0, 10.0, 20.0, 10.0),
                                            border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        32.0)),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(32.0)),
                                              borderSide: BorderSide(
                                                  color: Color(0xff004080),
                                                  width: 2),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        alignment: Alignment.centerLeft,
                                        padding:
                                            EdgeInsets.fromLTRB(30, 10, 30, 10),
                                        child: Text(
                                          'Mobile',
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                            fontSize: 17,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding:
                                            EdgeInsets.fromLTRB(30, 0, 30, 0),
                                        child: TextField(
                                          controller: phonenumberController,
                                          maxLength: 10,
                                          keyboardType: TextInputType.phone,
                                          decoration: InputDecoration(
                                            counterText: "",
                                            contentPadding: EdgeInsets.fromLTRB(
                                                20.0, 10.0, 20.0, 10.0),
                                            border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        32.0)),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(32.0)),
                                              borderSide: BorderSide(
                                                  color: Color(0xff004080),
                                                  width: 2),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        alignment: Alignment.centerLeft,
                                        padding:
                                            EdgeInsets.fromLTRB(30, 10, 30, 10),
                                        child: Text(
                                          'Password',
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                            fontSize: 17,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding:
                                            EdgeInsets.fromLTRB(30, 0, 30, 0),
                                        child: TextField(
                                          controller: passwordController,
                                          obscureText: true,
                                          decoration: InputDecoration(
                                            contentPadding: EdgeInsets.fromLTRB(
                                                20.0, 10.0, 20.0, 10.0),
                                            border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        32.0)),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(32.0)),
                                              borderSide: BorderSide(
                                                  color: Color(0xff004080),
                                                  width: 2),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                          height: 90,
                                          padding:
                                              EdgeInsets.fromLTRB(30, 0, 30, 0),
                                          child: RaisedButton(
                                            onPressed: () => {
                                              if (usernameController.text == "")
                                                {
                                                  _showMessageInScaffold(
                                                      "please enter name"),
                                                },
                                              if (emailController.text == "")
                                                {
                                                  _showMessageInScaffold(
                                                      "please enter email"),
                                                },
                                              if (emailController.text.length <
                                                  10)
                                                {
                                                  _showMessageInScaffold(
                                                      "please enter valid email id"),
                                                },
                                              if (phonenumberController.text ==
                                                  "")
                                                {
                                                  _showMessageInScaffold(
                                                      "please enter mobile number"),
                                                },
                                              if (phonenumberController
                                                      .text.length <
                                                  10)
                                                {
                                                  _showMessageInScaffold(
                                                      "please enter valid mobile number"),
                                                },
                                              if (passwordController.text == "")
                                                {
                                                  _showMessageInScaffold(
                                                      "please enter password"),
                                                },
                                              proofilepic(),
                                              updateprofile(),
                                            },
                                            textColor: Colors.white,
                                            color: Color(0xffff7000),
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        (32.0))),
                                            child: Text(
                                              'SAVE',
                                              style: TextStyle(fontSize: 20),
                                            ),
                                          )),
                                    ]))),
                            Align(
                              alignment: Alignment.topCenter,
                              child: Stack(children: <Widget>[
                                CircleAvatar(
                                    radius: 55,
                                    backgroundColor: Colors.white,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(55),
                                      child: _image != null
                                          ? Image.file(
                                              _image,
                                              width: double.infinity,
                                              height: double.infinity,
                                              fit: BoxFit.cover,
                                            )
                                          : Image.asset(
                                              "assets/images/profileIot.jpg",
                                              width: double.infinity,
                                              height: double.infinity,
                                              fit: BoxFit.cover,
                                            ),
                                    )),
                                // profile['profile_image']'
                                Positioned(
                                  right: 2.0,
                                  bottom: 0.0,
                                  child: Container(
                                      height: 35,
                                      width: 35,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(35.0),
                                        color: Color(0xffff7000),
                                      ),
                                      child: IconButton(
                                        alignment: Alignment.center,
                                        icon: Icon(Icons.camera_alt,
                                            size: 19.0, color: Colors.white),
                                        onPressed: () {
                                          _optionsDialogBox();
                                        },
                                      )),
                                ),
                              ]),
                            ),
                          ])
                        ])),
                    Container(
                        alignment: Alignment.bottomCenter,
                        child:
                            Column(mainAxisSize: MainAxisSize.min, children: [
                          Container(
                            height: 30,
                            // padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                            child: TextAds(),
                          ),
                          Container(
                            // padding: EdgeInsets.fromLTRB(3, 10, 3, 10),
                            width: double.infinity,
                            color: Colors.white,
                            child: Row(
                              children: [
                                Expanded(
                                    child: Column(children: [
                                      IconButton(
                                          onPressed: () {
                                            Navigator.of(context).pushReplacement(
                                                MaterialPageRoute(
                                                    builder: (BuildContext
                                                            context) =>
                                                        EmpServiceFragment()));
                                          },
                                          icon: Icon(
                                            Icons.home_repair_service_outlined,
                                            color: Color(0xff004080),
                                          )),
                                      Text(
                                        'Services',
                                        style: TextStyle(
                                          color: Color(0xff004080),
                                        ),
                                      ),
                                    ]),
                                    flex: 5),
                                Expanded(
                                    child: Column(children: [
                                      IconButton(
                                          onPressed: () {
                                            Navigator.of(context)
                                                .pushReplacement(
                                                    MaterialPageRoute(
                                                        builder: (BuildContext
                                                                context) =>
                                                            TodayTask()));
                                          },
                                          icon: Icon(
                                            Icons.sticky_note_2_outlined,
                                            color: Color(0xff004080),
                                          )),
                                      Text(
                                        'Today Task',
                                        style: TextStyle(
                                          color: Color(0xff004080),
                                        ),
                                      ),
                                    ]),
                                    flex: 5),
                                Expanded(
                                    child: Column(children: [
                                      IconButton(
                                          onPressed: () {
                                            Navigator.of(context)
                                                .pushReplacement(
                                                    MaterialPageRoute(
                                                        builder: (BuildContext
                                                                context) =>
                                                            EmphomeFragment()));
                                          },
                                          icon: Icon(
                                            Icons.home_outlined,
                                            color: Color(0xff004080),
                                          )),
                                      Text(
                                        'Home',
                                        style: TextStyle(
                                          color: Color(0xff004080),
                                        ),
                                      ),
                                    ]),
                                    flex: 5),
                                Expanded(
                                    child: Column(children: [
                                      IconButton(
                                          onPressed: () {
                                            Navigator.of(context).pushReplacement(
                                                MaterialPageRoute(
                                                    builder: (BuildContext
                                                            context) =>
                                                        EmpProfileFragment()));
                                          },
                                          icon: Icon(Icons.person_outline,
                                              color: Color(0xffff7000))),
                                      Text(
                                        'Profile',
                                        style: TextStyle(
                                          color: Color(0xffff7000),
                                        ),
                                      ),
                                    ]),
                                    flex: 5),
                              ],
                            ),
                          )
                        ])),
                  ],
                ))));
  }

  void opencamera() async {
    var image = await ImagePicker.pickImage(
        source: ImageSource.camera, imageQuality: 50);
    setState(() {
      _image = image;
    });
  }

  void opengallery() async {
    var image = await ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 50);
    setState(() {
      _image = image;
    });
  }
}

const double _kCurveHeight = 20;

class ShapesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final p = Path();
    p.lineTo(0, size.height - _kCurveHeight);
    p.relativeQuadraticBezierTo(
        size.width / -2, -1 * _kCurveHeight, size.width, -5);
    p.lineTo(size.width, 0);
    p.close();

    canvas.drawPath(
      p,
      Paint()..color = Color(0xffff7000),
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
// import 'package:iot_app/screens/EditprofileScreen.dart';
// import 'package:image_picker/image_picker.dart';
//
// class ProfileScreen extends StatefulWidget {
//   @override
//   ProfileScreenState createState() => ProfileScreenState();
// }
//
// class ProfileScreenState extends State<ProfileScreen>
//     with SingleTickerProviderStateMixin {
//   bool _status = true;
//   final FocusNode myFocusNode = FocusNode();
//
//   TextEditingController emailController =
//   TextEditingController(text: 'james@gmail.com');
//   TextEditingController phonenumberController =
//   TextEditingController(text: '9859658985');
//   TextEditingController usernameController =
//   TextEditingController(text: 'James');
//   TextEditingController passwordController =
//   TextEditingController(text: '* * *');
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
// //    getTextFromFile();
//     //  getLanguage();
//     //   profile();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return new Scaffold(
//         appBar: AppBar(
//           leading: GestureDetector(
//             onTap: () {
//               Navigator.pop(context);
//             },
//             child: Icon(Icons.arrow_back,
//                 color: Color(0xffEFCC00) // add custom icons also
//             ),
//           ),
//           title: Text(
//             'Profile',
//             style: TextStyle(
//                 fontWeight: FontWeight.bold,
//                 fontSize: 20.0,
//                 fontFamily: 'Montserrat',
//                 color: Colors.black54),
//           ),
//           centerTitle: true,
//           backgroundColor: Colors.transparent,
//           elevation: 0.0,
//         ),
//         body: new Container(
//           margin: EdgeInsets.symmetric(vertical: 10, horizontal: 25),
//           color: Colors.white,
//           child: new ListView(
//             children: <Widget>[
//               Column(
//                 children: <Widget>[
//                   Container(
//                     padding: EdgeInsets.fromLTRB(20, 5, 20, 0),
//                     alignment: Alignment.topCenter,
//                     child: GestureDetector(
//                         child: Align(
//                           child: Stack(children: <Widget>[
//                             CircleAvatar(
//                                 radius: 55,
//                                 backgroundColor: Colors.white,
//                                 child: ClipRRect(
//                                   borderRadius: BorderRadius.circular(55),
//                                   child: Image.asset(
//                                     "assets/images/profileIot.jpg",
//                                     width: double.infinity,
//                                     height: double.infinity,
//                                     fit: BoxFit.cover,
//                                   ),
//                                 )),
//                             Positioned(
//                               right: 2.0,
//                               bottom: 0.0,
//                               child: Container(
//                                   height: 35,
//                                   width: 35,
//                                   decoration: BoxDecoration(
//                                     borderRadius: BorderRadius.circular(35.0),
//                                     color: Color(0xffEFCC00),
//                                   ),
//                                   child: IconButton(
//                                     alignment: Alignment.center,
//                                     icon: Icon(Icons.edit,
//                                         size: 19.0, color: Colors.white),
//                                     onPressed: () {
//                                       _optionsDialogBox();
//                                     },
//                                   )),
//                             ),
//                           ]),
//                         )),
//                   ),
//                   new Container(
//                     child: new Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       children: <Widget>[
//                         Padding(
//                             padding: EdgeInsets.only(
//                                 left: 8.0, top: 8.0, bottom: 10.0),
//                             child: new Text(
//                               'Name',
//                               // '${mobile_test}',
//                               style: TextStyle(
//                                 fontSize: 18.0,
//                                 fontFamily: 'Montserrat',
//                                 color: Colors.grey,
//                                 //    fontWeight: FontWeight.bold
//                               ),
//                             )),
//                         Padding(
//                           padding: EdgeInsets.only(
//                               left: 8.0, top: 5.0, bottom: 10.0),
//                           child: new TextFormField(
//                             controller: usernameController,
//                             decoration: InputDecoration(
//                               border: UnderlineInputBorder(
//                                 borderSide:
//                                 BorderSide(color: Colors.grey, width: 2),
//                               ),
//                               focusedBorder: UnderlineInputBorder(
//                                 borderSide:
//                                 BorderSide(color: Colors.grey, width: 2),
//                               ),
//                             ),
//                           ),
//                         ),
//                         Padding(
//                             padding: EdgeInsets.only(
//                                 left: 8.0, top: 5.0, bottom: 10.0),
//                             child: new Text(
//                               'Phone number',
//                               // '${mobile_test}',
//                               style: TextStyle(
//                                 fontSize: 18.0,
//                                 fontFamily: 'Montserrat',
//                                 color: Colors.grey,
//                                 //    fontWeight: FontWeight.bold
//                               ),
//                             )),
//                         Padding(
//                           padding: EdgeInsets.only(
//                               left: 8.0, top: 5.0, bottom: 10.0),
//                           child: new TextFormField(
//                             controller: phonenumberController,
//                             decoration: InputDecoration(
//                               border: UnderlineInputBorder(
//                                 borderSide:
//                                 BorderSide(color: Colors.grey, width: 2),
//                               ),
//                               focusedBorder: UnderlineInputBorder(
//                                 borderSide:
//                                 BorderSide(color: Colors.grey, width: 2),
//                               ),
//                             ),
//                           ),
//                         ),
//
//                         Padding(
//                             padding: EdgeInsets.only(
//                                 left: 8.0, top: 5.0, bottom: 10.0),
//                             child: new Text(
//                               'Email ID',
//                               // '${mobile_test}',
//                               style: TextStyle(
//                                 fontSize: 18.0,
//                                 fontFamily: 'Montserrat',
//                                 color: Colors.grey,
//                                 //    fontWeight: FontWeight.bold
//                               ),
//                             )),
//                         Padding(
//                           padding: EdgeInsets.only(
//                               left: 8.0, top: 5.0, bottom: 10.0),
//                           child: new TextFormField(
//                             controller: emailController,
//                             decoration: InputDecoration(
//                               border: UnderlineInputBorder(
//                                 borderSide:
//                                 BorderSide(color: Colors.grey, width: 2),
//                               ),
//                               focusedBorder: UnderlineInputBorder(
//                                 borderSide:
//                                 BorderSide(color: Colors.grey, width: 2),
//                               ),
//                             ),
//                           ),
//                         ),
//
//                         Padding(
//                             padding: EdgeInsets.only(
//                                 left: 8.0, top: 5.0, bottom: 10.0),
//                             child: new Text(
//                               'Password',
//                               style: TextStyle(
//                                 fontSize: 18.0,
//                                 fontFamily: 'Montserrat',
//                                 color: Colors.grey,
//                                 //    fontWeight: FontWeight.bold
//                               ),
//                             )),
//                         Padding(
//                           padding: EdgeInsets.only(
//                               left: 8.0, top: 5.0, bottom: 10.0),
//                           child: new TextFormField(
//                             controller: passwordController,
//                             decoration: InputDecoration(
//                               border: UnderlineInputBorder(
//                                 borderSide:
//                                 BorderSide(color: Colors.grey, width: 2),
//                               ),
//                               focusedBorder: UnderlineInputBorder(
//                                 borderSide:
//                                 BorderSide(color: Colors.grey, width: 2),
//                               ),
//                             ),
//                           ),
//                         ),
//
//                         SizedBox(
//                           height: 25,
//                         ),
//                         Stack(
//                           children: [
//                             Container(
//                               alignment: Alignment.center,
//                               width: double.infinity,
//                               padding: EdgeInsets.symmetric(
//                                   vertical: 10, horizontal: 0),
//                               height: 50,
//                               decoration: BoxDecoration(
//                                 color: Color(0xffEFCC00),
//                                 border: Border.all(color: Colors.white),
//                                 borderRadius: BorderRadius.circular(50),
//                               ),
//                               child: InkWell(
//                                 onTap: () {},
//                                 child: Text("Save",
//                                     textAlign: TextAlign.center,
//                                     style: TextStyle(
//                                         color: Colors.black,
//                                         fontWeight: FontWeight.bold,
//                                         fontSize: 18,
//                                         letterSpacing: 1)),
//                               ),
//                             ),
//                           ],
//                         )
//
//                       ],
//                     ),
//                   )
//                 ],
//               ),
//             ],
//           ),
//         ));
//   }
//
//   @override
//   void dispose() {
//     // Clean up the controller when the Widget is disposed
//     myFocusNode.dispose();
//     super.dispose();
//   }
//
//   Widget _getEditIcon() {
//     return new GestureDetector(
//       child: new CircleAvatar(
//         backgroundColor: Color(0xffEFCC00),
//         radius: 30.0,
//         child: new Icon(
//           Icons.edit,
//           color: Colors.white,
//           size: 23.0,
//         ),
//       ),
//       onTap: () {
//         /*setState(() {
//           _status = false;
//         });*/
//         Navigator.of(context).push(MaterialPageRoute(
//             builder: (BuildContext context) => EditProfileScreen()));
//       },
//     );
//   }
//
//   var _image;
//
//   Future<void> _optionsDialogBox() {
//     return showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           return AlertDialog(
//             shape: RoundedRectangleBorder(
//               side: BorderSide(color: Colors.transparent, width: 2),
//               borderRadius: BorderRadius.circular(15.0),
//             ),
//             title: Text(
//               'Add Photo!',
//             ),
//             content: new SingleChildScrollView(
//               child: new ListBody(
//                 children: <Widget>[
//                   GestureDetector(
//                       child: new Text('Take Photo'),
//                       onTap: () {
//                         opencamera();
//                         Navigator.of(context).pop();
//                       }),
//                   Padding(
//                     padding: EdgeInsets.all(8.0),
//                   ),
//                   GestureDetector(
//                       child: new Text('Choose from Gallery'),
//                       onTap: () {
//                         opengallery();
//                         Navigator.of(context).pop();
//                       }),
//                   Padding(
//                     padding: EdgeInsets.all(8.0),
//                   ),
//                   GestureDetector(
//                       child: new Text('Cancel'),
//                       onTap: () {
//                         Navigator.of(context).pop();
//                       }
//                     //   onTap: openCamera,
//                   ),
//                 ],
//               ),
//             ),
//           );
//         });
//   }
//
//   var image;
//   void opencamera() async {
//     image = await ImagePicker.pickImage(
//         source: ImageSource.camera, imageQuality: 50);
//
//     setState(() {
//       _image = image;
//       print(image);
//     });
//   }
//
//   void opengallery() async {
//     image = await ImagePicker.pickImage(
//         source: ImageSource.gallery, imageQuality: 50);
//
//     setState(() {
//       _image = image;
//     });
//   }
// }
//
