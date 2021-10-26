import 'package:flutter/material.dart';
import 'package:vnr_police/Screens/Dashboardscreen.dart';
import 'package:vnr_police/Screens/EmergencyContact.dart';
import 'package:vnr_police/Screens/FindPoliceDivisions.dart';
import 'package:vnr_police/Screens/FindTrafficInspectors.dart';
import 'package:vnr_police/Screens/FindWomanPoliceStation.dart';
import 'package:vnr_police/Screens/FindpolicestationScreen.dart';
import 'package:vnr_police/Screens/LockedNew.dart';
import 'package:vnr_police/Screens/LockedhomeScreen.dart';
import 'package:vnr_police/Screens/LoginPage.dart';
import 'package:vnr_police/Screens/LoginScreen.dart';
import 'package:vnr_police/Screens/NewsScreen.dart';
import 'package:vnr_police/Screens/Notifications.dart';
import 'package:vnr_police/Screens/PoliceDivisionDetails.dart';
import 'package:vnr_police/Screens/PoliceOFficers.dart';
import 'package:vnr_police/Screens/PoliceStationScreen.dart';
import 'package:vnr_police/Screens/PoliceofficerScreen.dart';
import 'package:vnr_police/Screens/ProfileScreen.dart';
import 'package:vnr_police/Screens/RegisterScreen.dart';
import 'package:vnr_police/Screens/SplashScreen.dart';
import 'package:oktoast/oktoast.dart';
import 'package:vnr_police/Screens/Terms&Conditions.dart';
import 'package:vnr_police/Screens/TrafficInspectorsDetails.dart';
import 'package:vnr_police/Screens/WomanStationDetails.dart';
import 'package:vnr_police/Screens/nearby_places.dart';
import 'package:vnr_police/Screens/preview_screen.dart';
import 'package:vnr_police/Utils/Routes.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return OKToast(
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(primarySwatch: Colors.blue),
          initialRoute: Routes.SPLASH_SCREEN,
          routes: {
            Routes.SPLASH_SCREEN: (context) => SplashScreen(),
            Routes.LOGIN_SCREEN: (context) => LoginPage(),
            Routes.REGISTER_SCREEN: (context) => RegisterScreen(),
            Routes.DASHBOARD_SCREEN: (context) => DashboardScreen(),
            Routes.PROFILE_SCREEN: (context) => ProfileScreen(),
            Routes.TERMS_SCREEN: (context) => TermsConditions(),
            Routes.NOTIFICATION_SCREEN: (context) => NotificationScreen(),
            Routes.POLICEOFFICERS_SCREEN: (context) => PoliceOfficers(),
            Routes.EMERGENCYCONTACT_SCREEN: (context) => EmergencyContact(),
            Routes.POLICESTATION_SCREEN: (context) => PoliceStationScreen(),
            Routes.WOMANSTATION_DETAILS: (context) => WomanStationDetails(),
            Routes.FINDPOLICESTATION: (context) => FindPoliceStationScreen(),
            Routes.FINDPOLICEDIVISIONS: (context) => FindPoliceDivisions(),
            Routes.FINDTRAFFICINSPECTORS: (context) => FindTrafficInspectors(),
            Routes.LOCKEDNEW: (context) => LockedNew(),

            Routes.FINDWOMANPOLICESTATION: (context) =>
                FindWomanPoliceStation(),
            Routes.POLICEOFFICERSDETAILSSCREEN: (context) =>
                PoliceOfficerDetailsScreen(),
            Routes.LOCKEDHOMESCREEN: (context) => LockedHomeScreen(),
            Routes.NEWSSCREEN: (context) => NewsScreen(),
            Routes.PREVIEWSCREEN: (context) => PreviewImageScreen(imagePath: '',),
            Routes.DIVISIONSTATION_DETAILS: (context) =>
                PoliceDivisionDetails(),
            Routes.TRAFFICSTATION_DETAILS: (context) =>
                TrafficInspectorDetails(),
          }),
    );
  }
}
