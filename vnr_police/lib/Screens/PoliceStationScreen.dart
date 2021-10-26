import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vnr_police/Components/Colors.dart';
import 'package:vnr_police/Screens/notes.dart';
import 'package:vnr_police/Screens/photo_capture.dart';
import 'package:vnr_police/Utils/Routes.dart';
import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';

class PoliceStationScreen extends StatefulWidget {
  @override
  _PoliceStationScreenState createState() => _PoliceStationScreenState();
}

class _PoliceStationScreenState extends State<PoliceStationScreen> {
  GlobalKey bottomNavigationKey = GlobalKey();

  List PoliceStation = [
    {"police_officer": "Virudhunagar police station"},
    {"police_officer": "Virudhunagar police station"},
    {"police_officer": "Virudhunagar police station"},
    {"police_officer": "Virudhunagar police station"},
    {"police_officer": "Virudhunagar police station"},
    {"police_officer": "Virudhunagar police station"},
    {"police_officer": "Virudhunagar police station"},
    {"police_officer": "Virudhunagar police station"},
    {"police_officer": "Virudhunagar police station"},
    {"police_officer": "Virudhunagar police station"},
    {"police_officer": "Virudhunagar police station"},
  ];
  List womanPolice = [
    {"police_officer": "Virudhunagar Woman's Police Station"},
    {"police_officer": "Virudhunagar Woman's Police Station"},
    {"police_officer": "Virudhunagar Woman's Police Station"},
    {"police_officer": "Virudhunagar Woman's Police Station"},
    {"police_officer": "Virudhunagar Woman's Police Station"},
  ];
  List Divisions = [
    {"police_officer": "ALGSC"},
    {"police_officer": "PSW"},
    {"police_officer": "CAS"},
    {"police_officer": "DCRB"},
    {"police_officer": "EOW"},
  ];
  List traffic = [
    {"police_officer": "Traffic virudhunagar"},
    {"police_officer": "Traffic virudhunagar"},
    {"police_officer": "Traffic virudhunagar"},
    {"police_officer": "Traffic virudhunagar"},
    {"police_officer": "Traffic virudhunagar"},
    {"police_officer": "Traffic virudhunagar"},
  ];
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 4,
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: Palette.SecondaryColor,
              leading: new IconButton(
                icon: Icon(Icons.arrow_back_ios_sharp),
                color: Colors.white,
                onPressed: () {
                  Navigator.pushNamed(context, Routes.DASHBOARD_SCREEN);
                },
              ),
              title: Text(
                'Police Station',
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              ),
              centerTitle: true,
              elevation: 0,
              bottom: TabBar(
                  unselectedLabelColor: Colors.white,
                  labelColor: Colors.white,
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicatorColor: Palette.SecondaryColor,
                  // indicator: BoxDecoration(
                  //     gradient: LinearGradient(
                  //         colors: [Color(0xff004080), Colors.orangeAccent]),
                  //     borderRadius: BorderRadius.circular(50),
                  //     color: Colors.orangeAccent),
                  tabs: [
                    Tab(
                      child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Padding(
                            padding: EdgeInsets.only(bottom: 10),
                            // IconButton(
                            //     // Use the FaIcon Widget + FontAwesomeIcons class for the IconData
                            //     icon: FaIcon(FontAwesomeIcons.playstation),
                            //     onPressed: () {
                            //       print("Pressed");
                            //     }),
                            child: Icon(Icons.account_balance),
                          )),
                    ),
                    Tab(
                      child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Padding(
                            padding: EdgeInsets.only(bottom: 10),
                            child: Icon(Icons.person_pin_outlined),
                          )),
                    ),
                    Tab(
                      child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Padding(
                            padding: EdgeInsets.only(bottom: 10),
                            child: Icon(Icons.hardware_outlined),
                          )),
                    ),
                    Tab(
                      child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Padding(
                            padding: EdgeInsets.only(bottom: 10),
                            //child: Column(children: [
                            child: Icon(Icons.traffic),
                            // ])
                          )),
                    ),
                  ]),
            ),
            body: Container(
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
            //  color: Colors.black12,
              child: TabBarView(children: [
                PoliceDetails(),
                WomanStation(),
                PoliceDivisions(),
                TrafficInspectors(),
              ]),
            ),
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
                  //  Navigator.pushNamed(context, PhotoCapture.route);
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

        ));
  }

  Widget PoliceDetails() {
    return Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(children: [
          Column(children: [
            SizedBox(
              height: 10.0,
            ),
            Text(
              "Police Station",
              style: TextStyle(
                  color: Colors.black54,
                  fontWeight: FontWeight.bold,
                  fontSize: 18),
            ),
            SizedBox(
              height: 10.0,
            ),
            Divider(),
            Expanded(
                child: Padding(
              padding: EdgeInsets.only(left: 10.0, right: 10.0),
              child: (PoliceStation.length > 0)
                  ? ListView.builder(
                      // addAutomaticKeepAlives: false,
                      itemCount: PoliceStation.length,
                      itemBuilder: (context, index) =>
                          EachList(PoliceStation[index]),
                    )
                  : Center(child: Image.asset('assets/images/favicon.png')),
            )),
          ]),
        ]));
  }

  Widget WomanStation() {
    return Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(children: [
          Column(children: [
            SizedBox(
              height: 10.0,
            ),
            Text(
              "Woman's Police Station",
              style: TextStyle(
                  color: Colors.black54,
                  fontWeight: FontWeight.bold,
                  fontSize: 18),
            ),
            SizedBox(
              height: 10.0,
            ),
            Divider(),
            Expanded(
                child: Padding(
              padding: EdgeInsets.only(left: 10.0, right: 10.0),
              child: (womanPolice.length > 0)
                  ? ListView.builder(
                      // addAutomaticKeepAlives: false,
                      itemCount: womanPolice.length,
                      itemBuilder: (context, index) =>
                          EachList1(womanPolice[index]),
                    )
                  : Center(child: Image.asset('assets/images/favicon.png')),
            )),
          ]),
        ]));
  }

  Widget PoliceDivisions() {
    return Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(children: [
          Column(children: [
            SizedBox(
              height: 10.0,
            ),
            Text(
              "Police Divisions",
              style: TextStyle(
                  color: Colors.black54,
                  fontWeight: FontWeight.bold,
                  fontSize: 18),
            ),
            SizedBox(
              height: 10.0,
            ),
            Divider(),
            Expanded(
                child: Padding(
              padding: EdgeInsets.only(left: 10.0, right: 10.0),
              child: (Divisions.length > 0)
                  ? ListView.builder(
                      // addAutomaticKeepAlives: false,
                      itemCount: Divisions.length,
                      itemBuilder: (context, index) =>
                          EachList2(Divisions[index]),
                    )
                  : Center(child: Image.asset('assets/images/favicon.png')),
            )),
          ]),
        ]));
  }

  Widget TrafficInspectors() {
    return Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(children: [
          Column(children: [
            SizedBox(
              height: 10.0,
            ),
            Text(
              "Traffic Inspector",
              style: TextStyle(
                  color: Colors.black54,
                  fontWeight: FontWeight.bold,
                  fontSize: 18),
            ),
            SizedBox(
              height: 10.0,
            ),
            Divider(),
            Expanded(
                child: Padding(
              padding: EdgeInsets.only(left: 10.0, right: 10.0),
              child: (traffic.length > 0)
                  ? ListView.builder(
                      // addAutomaticKeepAlives: false,
                      itemCount: traffic.length,
                      itemBuilder: (context, index) =>
                          EachList3(traffic[index]),
                    )
                  : Center(child: Image.asset('assets/images/favicon.png')),
            )),
          ]),
        ]));
  }

  Widget EachList(cardList) {
    return GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, Routes.FINDPOLICESTATION);
        },
        child: new Card(
            color: Colors.white,
            shape: new RoundedRectangleBorder(
                //  side: new BorderSide(color: Color(0xffADDFDE), width: 2.0),
                borderRadius: BorderRadius.circular(12.0)),
            child: Container(
                height: 50.0,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                padding: EdgeInsets.only(left: 10.0, right: 10.0),
                child: Row(children: [
                  Icon(Icons.local_police_rounded,  color: Palette.PrimaryColor,),
                  SizedBox(
                    width: 20,
                  ),
                  Expanded(
                      child: Padding(
                          padding: EdgeInsets.only(left: 10.0, right: 10.0),
                          child: Text(
                            cardList['police_officer'],
                            maxLines: 3,style: TextStyle(
                              color: Palette.PrimaryColor,
                              fontWeight: FontWeight.bold),
                          )),
                      flex: 2)
                ]))));
  }

  Widget EachList1(cardList) {
    return GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, Routes.FINDPOLICESTATION);
        },
        child: new Card(
            color: Colors.white,
            shape: new RoundedRectangleBorder(
                //  side: new BorderSide(color: Color(0xffADDFDE), width: 2.0),
                borderRadius: BorderRadius.circular(12.0)),
            child: Container(
                height: 50.0,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                padding: EdgeInsets.only(left: 10.0, right: 10.0),
                child: Row(children: [
                  Icon(Icons.local_police_rounded,  color: Palette.PrimaryColor,),
                  SizedBox(
                    width: 20,
                  ),
                  Expanded(
                      child: Padding(
                          padding: EdgeInsets.only(left: 10.0, right: 10.0),
                          child: Text(
                            cardList['police_officer'],
                            maxLines: 3, style: TextStyle(
                              color: Palette.PrimaryColor,
                              fontWeight: FontWeight.bold),
                          )),
                      flex: 2)
                ]))));
  }

  Widget EachList2(cardList) {
    return GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, Routes.FINDPOLICESTATION);
        },
        child: new Card(
            color: Colors.white,
            shape: new RoundedRectangleBorder(
                //  side: new BorderSide(color: Color(0xffADDFDE), width: 2.0),
                borderRadius: BorderRadius.circular(12.0)),
            child: Container(
                height: 50.0,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                padding: EdgeInsets.only(left: 10.0, right: 10.0),
                child: Row(children: [
                  Icon(Icons.local_police_rounded,  color: Palette.PrimaryColor,),
                  SizedBox(
                    width: 20,
                  ),
                  Expanded(
                      child: Padding(
                          padding: EdgeInsets.only(left: 10.0, right: 10.0),
                          child: Text(
                            cardList['police_officer'],
                            maxLines: 3,style: TextStyle(
                              color: Palette.PrimaryColor,
                              fontWeight: FontWeight.bold),
                          )),
                      flex: 2)
                ]))));
  }

  Widget EachList3(cardList) {
    return GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, Routes.FINDPOLICESTATION);
        },
        child: new Card(
            color: Colors.white,
            shape: new RoundedRectangleBorder(
                //  side: new BorderSide(color: Color(0xffADDFDE), width: 2.0),
                borderRadius: BorderRadius.circular(12.0)),
            child: Container(
                height: 50.0,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                padding: EdgeInsets.only(left: 10.0, right: 10.0),
                child: Row(children: [
                  Icon(Icons.local_police_rounded,  color: Palette.PrimaryColor,),
                  SizedBox(
                    width: 20,
                  ),
                  Expanded(
                      child: Padding(
                          padding: EdgeInsets.only(left: 10.0, right: 10.0),
                          child: Text(
                            cardList['police_officer'],
                            maxLines: 3,style: TextStyle(
                              color: Palette.PrimaryColor,
                              fontWeight: FontWeight.bold),
                          )),
                      flex: 2)
                ]))));
  }
}
