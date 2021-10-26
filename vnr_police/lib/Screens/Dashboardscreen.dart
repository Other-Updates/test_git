import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vnr_police/Components/Colors.dart';
import 'package:vnr_police/Components/Menudrawer.dart';
import 'package:vnr_police/Components/adsimages.dart';
import 'package:vnr_police/Screens/notes.dart';
import 'package:vnr_police/Screens/photo_capture.dart';
import 'package:vnr_police/Utils/Routes.dart';
import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  GlobalKey bottomNavigationKey = GlobalKey();
  GlobalKey<ScaffoldState> _key = new GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      resizeToAvoidBottomInset: true,
      drawer: Drawer(
        child: HomeMenuDrawer(),
      ),
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Palette.SecondaryColor,
        leading: IconButton(
            icon: Icon(
              Icons.menu,
              color: Colors.white,
            ),
            onPressed: () {
              _key.currentState!.openDrawer();
            }),
        title: Text(
          'Dashboard',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        automaticallyImplyLeading: false,
        actions: <Widget>[
          IconButton(
              icon: Icon(
                Icons.power_settings_new_rounded,
                color: Colors.white,
              ),
              onPressed: () {
                openAlertBox();
              }),
        ],
      ),
      body: Center(
          child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height >= 775.0
                  ? MediaQuery.of(context).size.height
                  : 775.0,
              decoration: BoxDecoration(color: bg
                  // begin: const FractionalOffset(0.0, 0.0),
                  // end: const FractionalOffset(1.0, 1.0),
                  // stops: [0.0, 1.0],
                  // tileMode: TileMode.clamp),
                  ),
              child: ListView(
                //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  SizedBox(
                    height: 20.0,
                  ),
                  Container(
                    height: 160,
                    width: MediaQuery.of(context).size.width,
                    child: AdsImages(),
                  ),
                  SizedBox(
                    height: 30.0,
                  ),
                  Container(
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 140,
                        width: 160,
                        child: GestureDetector(
                          onTap: () {
                            //   Navigator.pushNamed(
                            //       context, Routes.LOCKEDHOMESCREEN);
                            // },
                            Navigator.pushNamed(context, Routes.LOCKEDNEW);
                          },
                          child: Card(
                              shadowColor: Palette.PrimaryColor,
                              elevation: 4,
                              //color: Palette.PrimaryColor,
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Container(
                                      height: 70,
                                      width: 70,
                                      child: Image.asset(
                                          "assets/images/locked-house.png"),
                                    ),
                                    Text(
                                      'Locked Home',
                                      style: TextStyle(
                                          color: Palette.PrimaryColor,
                                          fontWeight: FontWeight.bold),
                                    )
                                  ])),
                        ),
                      ),
                      // Container(
                      //     height: 140,
                      //     width: 160,
                      //     child: GestureDetector(
                      //         onTap: () {},
                      //         child: Card(
                      //             shadowColor: Palette.PrimaryColor,
                      //             elevation: 4,
                      //             //color: Palette.PrimaryColor,
                      //             color: Colors.white,
                      //             shape: RoundedRectangleBorder(
                      //               borderRadius: BorderRadius.circular(10),
                      //             ),
                      //             child: Column(
                      //                 mainAxisAlignment:
                      //                     MainAxisAlignment.center,
                      //                 children: [
                      //                   Icon(
                      //                     Icons.drive_file_move_outline,
                      //                     color: Palette.PrimaryColor,
                      //                     size: 60,
                      //                   ),
                      //                   Text(
                      //                     'File Complaint',
                      //                     style: TextStyle(
                      //                         color: Palette.PrimaryColor,
                      //                         fontWeight: FontWeight.bold),
                      //                   )
                      //                 ])))),
                      Container(
                        height: 140,
                        width: 160,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(
                                context, Routes.POLICESTATION_SCREEN);
                          },
                          child: Card(
                              shadowColor: Palette.PrimaryColor,
                              elevation: 4,
                              //color: Palette.PrimaryColor,
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      height: 70,
                                      width: 70,
                                      child: Image.asset(
                                          "assets/images/police-station.png"),
                                    ),
                                    Text(
                                      'Police Station',
                                      style: TextStyle(
                                          color: Palette.PrimaryColor,
                                          fontWeight: FontWeight.bold),
                                    )
                                  ])),
                        ),
                      ),
                    ],
                  )),
                  SizedBox(
                    height: 20.0,
                  ),
                  // Container(
                  //     child: Row(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: [
                  //     Container(
                  //       height: 140,
                  //       width: 160,
                  //       child: GestureDetector(
                  //         onTap: () {
                  //           Navigator.pushNamed(
                  //               context, Routes.POLICESTATION_SCREEN);
                  //         },
                  //         child: Card(
                  //             shadowColor: Palette.PrimaryColor,
                  //             elevation: 4,
                  //             //color: Palette.PrimaryColor,
                  //             color: Colors.white,
                  //             shape: RoundedRectangleBorder(
                  //               borderRadius: BorderRadius.circular(10),
                  //             ),
                  //             child: Column(
                  //                 mainAxisAlignment: MainAxisAlignment.center,
                  //                 children: [
                  //                   Icon(
                  //                     Icons.business,
                  //                     color: Palette.PrimaryColor,
                  //                     size: 60,
                  //                   ),
                  //                   Text(
                  //                     'Police Station',
                  //                     style: TextStyle(
                  //                         color: Palette.PrimaryColor,
                  //                         fontWeight: FontWeight.bold),
                  //                   )
                  //                 ])),
                  //       ),
                  //     ),
                  //     // Container(
                  //     //     height: 140,
                  //     //     width: 160,
                  //     //     child: GestureDetector(
                  //     //         onTap: () {},
                  //     //         child: Card(
                  //     //             shadowColor: Palette.PrimaryColor,
                  //     //             elevation: 4,
                  //     //             //color: Palette.PrimaryColor,
                  //     //             color: Colors.white,
                  //     //             shape: RoundedRectangleBorder(
                  //     //               borderRadius: BorderRadius.circular(10),
                  //     //             ),
                  //     //             child: Column(
                  //     //                 mainAxisAlignment:
                  //     //                     MainAxisAlignment.center,
                  //     //                 children: [
                  //     //                   Icon(
                  //     //                     Icons.timeline_sharp,
                  //     //                     color: Palette.PrimaryColor,
                  //     //                     size: 60,
                  //     //                   ),
                  //     //                   Text(
                  //     //                     'IMEI',
                  //     //                     style: TextStyle(
                  //     //                         color: Palette.PrimaryColor,
                  //     //                         fontWeight: FontWeight.bold),
                  //     //                   )
                  //     //                 ])))),
                  //   ],
                  // )),
                  // SizedBox(
                  //   height: 13.0,
                  // ),
                  Container(
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Container(
                      //   height: 140,
                      //   width: 160,
                      //   child: GestureDetector(
                      //     onTap: () {},
                      //     child: Card(
                      //         shadowColor: Palette.PrimaryColor,
                      //         elevation: 4,
                      //         //color: Palette.PrimaryColor,
                      //         color: Colors.white,
                      //         shape: RoundedRectangleBorder(
                      //           borderRadius: BorderRadius.circular(10),
                      //         ),
                      //         child: Column(
                      //             mainAxisAlignment: MainAxisAlignment.center,
                      //             children: [
                      //               Icon(
                      //                 Icons.directions_bus,
                      //                 color: Palette.PrimaryColor,
                      //                 size: 60,
                      //               ),
                      //               Text(
                      //                 'Vehicles',
                      //                 style: TextStyle(
                      //                     color: Palette.PrimaryColor,
                      //                     fontWeight: FontWeight.bold),
                      //               )
                      //             ])),
                      //   ),
                      // ),
                      Container(
                          height: 140,
                          width: 160,
                          child: GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, Routes.NEWSSCREEN);
                              },
                              child: Card(
                                  shadowColor: Palette.PrimaryColor,
                                  elevation: 4,
                                  //color: Palette.PrimaryColor,
                                  color: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          height: 70,
                                          width: 70,
                                          child: Image.asset(
                                              "assets/images/covid-19.png"),
                                        ),
                                        // Icon(
                                        //   Icons.insert_drive_file,
                                        //   color: Palette.SecondaryColor,
                                        //   size: 60,
                                        // ),
                                        Text(
                                          'Covid-19 News',
                                          style: TextStyle(
                                              color: Palette.PrimaryColor,
                                              fontWeight: FontWeight.bold),
                                        )
                                      ]))))
                    ],
                  ))
                ],
              ))),
      bottomNavigationBar: FancyBottomNavigation(
        //activeIconColor:Color(0xffb72334) ,
        inactiveIconColor: Color(0xffb72334),
        barBackgroundColor: Colors.white70,
        circleColor: Color(0xffb72334),
        tabs: [
          TabData(
              iconData: Icons.lock_outline,
              title: 'Locked home',
              onclick: () {
                final State<StatefulWidget>? fState =
                    bottomNavigationKey.currentState;
                // fState.setPage(2);
                //Navigator.pushNamed(context, PhotoCapture.route);
              }),
          TabData(
            iconData: Icons.local_police_outlined,
            title: 'Police station',
            //  onclick: () => Navigator.pushNamed(context, SpeechScreen.route),
          ),
          TabData(
            iconData: Icons.new_releases_outlined,
            title: 'News',
            // onclick: () => Navigator.pushNamed(context, NearbyPlaces.route),
          ),
          TabData(
            iconData: Icons.dashboard,
            title: 'Dashboard',
            // onclick: () => Navigator.pushNamed(context, NearbyPlaces.route),
          ),
        ],
        initialSelection: 1,
        key: bottomNavigationKey,
        onTabChangedListener: (position) {
          setState(() {
            // currentPage = position;
          });
        },
      ),
    );
  }

  openAlertBox() {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(32.0))),
            contentPadding: EdgeInsets.only(top: 10.0),
            content: Container(
              // width: 300.0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  SizedBox(
                    height: 5.0,
                  ),
                  Padding(
                      padding: EdgeInsets.all(15),
                      child: Text('Are you sure ? you want to logout')),
                  Row(mainAxisSize: MainAxisSize.min, children: [
                    Expanded(
                        child: InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                            decoration: BoxDecoration(
                              color: Palette.PrimaryColor,
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(32.0),
                              ),
                            ),
                            child: Text(
                              "No",
                              style: TextStyle(color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        flex: 2),
                    Expanded(
                        child: InkWell(
                          onTap: () {
                            Navigator.pushNamed(context, Routes.LOGIN_SCREEN);
                          },
                          child: Container(
                            padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                            decoration: BoxDecoration(
                              color: Palette.SecondaryColor,
                              borderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(32.0)),
                            ),
                            child: Text(
                              "YES",
                              style: TextStyle(color: Colors.white),
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
  }
}
