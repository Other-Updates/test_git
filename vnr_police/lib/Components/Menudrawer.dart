import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vnr_police/Components/Colors.dart';
import 'package:vnr_police/Utils/Routes.dart';

class HomeMenuDrawer extends StatefulWidget {
  _HomeMenuDrawerState createState() => _HomeMenuDrawerState();
}

class _HomeMenuDrawerState extends State<HomeMenuDrawer> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        // padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Palette.SecondaryColor,
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
                            radius: 40,
                            backgroundColor: Colors.white,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(40),
                              child: Image.asset(
                                "assets/images/loginLogin.png",
                                width: double.infinity,
                                height: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            )),
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 15.0, bottom: 2.0),
                        child: Text(
                          'VNR POLICE',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 22.0,
                              fontWeight: FontWeight.bold),
                        ),
                      ),

                      //    ]),
                      //   ),
                    ])),
          ),
          ListTile(
            leading: Icon(
              Icons.home,
              color: Palette.PrimaryColor,
            ),
            title: Text('Home'),
            onTap: () =>
                {Navigator.pushNamed(context, Routes.DASHBOARD_SCREEN)},
          ),
          ListTile(
            leading: Icon(
              Icons.person,
              color: Palette.PrimaryColor,
            ),
            title: Text('Profile'),
            onTap: () => {Navigator.pushNamed(context, Routes.PROFILE_SCREEN)},
          ),
          ListTile(
            leading: Icon(
              Icons.verified_user,
              color: Palette.PrimaryColor,
            ),
            title: Text('Police Officers'),
            onTap: () {
              Navigator.pushNamed(context, Routes.POLICEOFFICERS_SCREEN);
            },
          ),
          ListTile(
            leading: Icon(
              Icons.phone,
              color: Palette.PrimaryColor,
            ),
            title: Text('Emergency Contact'),
            onTap: () =>
                {Navigator.pushNamed(context, Routes.EMERGENCYCONTACT_SCREEN)},
          ),
          ListTile(
              leading: Icon(
                Icons.notifications,
                color: Palette.PrimaryColor,
              ),
              title: Text('Notifications'),
              onTap: () {
                Navigator.pushNamed(context, Routes.NOTIFICATION_SCREEN);
              }),
          ListTile(
            leading: Icon(
              Icons.indeterminate_check_box_sharp,
              color: Palette.PrimaryColor,
            ),
            title: Text('Terms & Conditions'),
            onTap: () => {Navigator.pushNamed(context, Routes.TERMS_SCREEN)},
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
