import 'dart:convert';

import 'package:coolincool/Utils/Colors.dart';
import 'package:coolincool/Utils/Routes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';


class HomeMenuDrawer extends StatefulWidget {
  _HomeMenuDrawerState createState() => _HomeMenuDrawerState();
}

class _HomeMenuDrawerState extends State<HomeMenuDrawer> {
  @override
  void initState() {

    super.initState();

  }

  String mobile_test1 = '';
  String mobile_test2 = '';
  String mobile_test5 = '';




  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        // padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.black,
              image: DecorationImage(
                image: AssetImage("assets/images/app_background.jpg"),
                  colorFilter: new ColorFilter.mode(
                      Colors.white.withOpacity(0.4),
                      BlendMode.dstATop),
                fit: BoxFit.cover
              ),

            ),
            child: Container(
                width: double.infinity,
                height: double.infinity,

                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [


                      Padding(
                        padding:
                            EdgeInsets.only(left: 8.0, bottom: 5.0, top: 7.0),

                              child: Image.asset(
                                "assets/images/logo.png",
                                width: 110,
                                height: 70,
                                fit: BoxFit.cover,
                              ),

                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 8.0, bottom: 2.0),
                        child: Text(
                          'CoolinCool Distributor',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 22.0,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 8.0, bottom: 2.0),
                        child: Text(
                          'coolincoolorganicfoods@gmail.com',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.0,
                          ),
                        ),
                      ),

                      //    ]),
                      //   ),
                    ])),
          ),
          ListTile(
            leading:Image(
    width: 26,height: 26,color:Palette.PrimaryColor,
 image:   AssetImage("assets/images/profile.png"),),
            title: Text('Profile'),
            onTap: () =>
                {Navigator.pushNamed(context, Routes.PROFILESCREEN)},
          ),
          ListTile(
            leading: Image(
    width: 26,height: 26,color:Palette.PrimaryColor,
    image:   AssetImage("assets/images/dashboard.png"),),
            title: Text('Dashboard'),
            onTap: () => {Navigator.pushNamed(context, Routes.DASHBOARDSCREEN)},
          ),
          ListTile(
            leading:Image(
              width: 26,height: 26,color:Palette.PrimaryColor,
              image:   AssetImage("assets/images/distributor.png"),),
            title: Text('Distributor'),
            onTap: () {
              Navigator.pushNamed(context, Routes.DISTRIBUTORSCREEN);
            },
          ),
          ListTile(
            leading:Image(
              width: 26,height: 26,color:Palette.PrimaryColor,
              image:   AssetImage("assets/images/salesorder.png"),),
            title: Text('Sales Order'),
            onTap: () =>
                {Navigator.pushNamed(context, Routes.SALESORDERSCREEN)},
          ),


          ListTile(
            leading: Icon(
              Icons.logout,
              color: Palette.PrimaryColor,
            ),
            title: Text('Logout'),
            onTap: () => {
              _optionsDialogBox(context),
            },
          ),
        ],
      ),
    );
  }
  Future<void> _optionsDialogBox(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (context, setState) {
                return AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  backgroundColor: Colors.white,
                  content: new SingleChildScrollView(
                    child: new ListBody(
                      children: <Widget>[
                        SizedBox(
                          height: 10,
                        ),
                        Image(image: AssetImage("assets/images/logout.png",),width: 100,height: 100,),
                        SizedBox(
                          height: 10,
                        ),
                        Text('Are you sure.You want to logout?'),
                        SizedBox(
                          height: 10,
                        ),
                        Row(mainAxisSize: MainAxisSize.min, children: [
                          Expanded(
                              child: InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  height: 50,
                                  width: 100,
                                  padding: EdgeInsets.only(top:15),
                                  decoration: BoxDecoration(
                                    color: Palette.SecondaryColor,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    "No",
                                    style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              flex: 2),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                              child: InkWell(
                                onTap: () {
                                  Navigator.pushNamed(context, Routes.LOGIN_SCREEN);
                                },
                                child: Container(
                                  height: 50,
                                  width: 100,
                                  padding: EdgeInsets.only(top:15),
                                  decoration: BoxDecoration(
                                    color: Palette.PrimaryColor,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    "YES",
                                    style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              flex: 2),
                        ]),
                      ],
                    ),
                  ),
                );
              });
        });
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
