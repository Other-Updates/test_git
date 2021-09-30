import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iot_app/Animation/LoginScreen.dart';
import 'package:iot_app/screens/FeedbackScreen.dart';
import 'package:iot_app/screens/Settings%20screen.dart';
import 'package:iot_app/screens/profile.dart';

class HomeMenuDrawer extends StatefulWidget {
  _HomeMenuDrawerState createState() => _HomeMenuDrawerState();
}

class _HomeMenuDrawerState extends State<HomeMenuDrawer> {
  // static const platform = const MethodChannel('Hyperpay.demo.fultter/channel');
  bool _status = true;
  var _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //   getLanguage();
    //  endride();
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
                LoginScreen();
                // customerlogout();
                SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                // Navigate to login
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        // padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Color(0xffEFCC00),
            ),
            child: Container(
                width: double.infinity,
                height: double.infinity,

                //  color: Color(0xffEFCC00),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Padding(
                      //   padding: EdgeInsets.only(left: 15.0),
                      //   child: Row(
                      //       mainAxisAlignment: MainAxisAlignment.start,
                      //       children: [

                      Padding(
                        padding:
                            EdgeInsets.only(left: 15.0, bottom: 5.0, top: 10.0),
                        child: CircleAvatar(
                            radius: 35,
                            backgroundColor: Colors.white,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(35),
                              child: Image.asset(
                                "assets/images/profileIot.jpg",
                                width: double.infinity,
                                height: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            )),
                      ),

                      Padding(
                        padding: EdgeInsets.only(left: 15.0, bottom: 5.0),
                        child: Text(
                          'James',
                          style:
                              TextStyle(color: Colors.black54, fontSize: 20.0),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 15.0, bottom: 5.0),
                        child: Text(
                          'james@gmail.com',
                          style:
                              TextStyle(color: Colors.black54, fontSize: 16.0),
                        ),
                      ),

                      //    ]),
                      //   ),
                    ])),
          ),
          ListTile(
            leading: Icon(
              Icons.home,
              color: Color(0xffEFCC00),
            ),
            title: Text('Dashboard'),
            onTap: () => {Navigator.of(context).pop()},
          ),
          ListTile(
            leading: Icon(
              Icons.verified_user,
              color: Color(0xffEFCC00),
            ),
            title: Text('Profile'),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ProfileScreen()));
            },
          ),
          ListTile(
            leading: Icon(
              Icons.settings,
              color: Color(0xffEFCC00),
            ),
            title: Text('Settings'),
            onTap: () => {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SettingsScreen()))
            },
          ),
          ListTile(
              leading: Icon(
                Icons.border_color,
                color: Color(0xffEFCC00),
              ),
              title: Text('Feedback'),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => FeedbackScreen()));
              }),
          ListTile(
            leading: Icon(
              Icons.exit_to_app,
              color: Color(0xffEFCC00),
            ),
            title: Text('Logout'),
            onTap: () => {_showMyDialog()},
          ),
        ],
      ),
    );
  }
}

Widget linkMenuDrawer(String title, Function onPressed) {
  return InkWell(
    // onTap: onPressed,
    splashColor: Colors.black,
    child: Container(
      padding: EdgeInsets.symmetric(vertical: 13, horizontal: 15),
      width: double.infinity,
      child: Text(
        title,
        style: TextStyle(fontSize: 15.0),
      ),
    ),
  );
}
