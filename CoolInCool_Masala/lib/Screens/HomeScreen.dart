import 'package:coolincool/Screens/DashboardScreen.dart';
import 'package:coolincool/Screens/DistributorScreen.dart';
import 'package:coolincool/Screens/ProfileScreen.dart';
import 'package:coolincool/Screens/SalesOrderScreen.dart';
import 'package:coolincool/Utils/Colors.dart';
import 'package:coolincool/Utils/Menudrawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class HomeScreen extends StatefulWidget {

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  GlobalKey<ScaffoldState> _key = new GlobalKey<ScaffoldState>();

  int _currentIndex =0;
  _getDrawerItemWidget(int pos) {
    switch (pos) {
      case 0:
        return new DashboardScreen();
      case 1:
        return new DistributorScreen();
      case 2:
        return new SalesOrderScreen();
      case 3:
        return new ProfileScreen();
      default:
        return new Text("Error");
    }
  }

  List<String> titleList = ["Dashboard", "Distributor", "Sales Order","Profile"];
  @override
  Widget build(BuildContext context) {


    return Scaffold(
      key: _key,
      resizeToAvoidBottomInset: true,
      drawer: Drawer(
        child: HomeMenuDrawer(),
      ),

      body:  _getDrawerItemWidget(_currentIndex),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Palette.PrimaryColor,
        unselectedItemColor: Colors.white54,
        backgroundColor: Palette.BottomMenu,

        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,

        onTap: (value) {
          setState(() {
            _currentIndex = value;
          });
        },
        // this will be set when a new tab is tapped
        items: [
          BottomNavigationBarItem(
            icon: Image.asset("assets/images/dashboard.png",width: 32,height: 32,color:(_currentIndex == 0)?Palette.PrimaryColor: Colors.white54),
            title: new Text('Dashboard'),
          ),
          BottomNavigationBarItem(
            icon: Image.asset("assets/images/distributor.png",width: 32,height: 32,color:(_currentIndex == 1)?Palette.PrimaryColor: Colors.white54),
            title: new Text('Distributor'),
          ),
          BottomNavigationBarItem(
              icon: Image.asset("assets/images/salesorder.png",width: 32,height: 32,color:(_currentIndex == 2)?Palette.PrimaryColor: Colors.white54),
              title: Text('Sales Order')
          ),
          BottomNavigationBarItem(
              icon: Image.asset("assets/images/profile.png",width: 32,height: 32,color:(_currentIndex == 3)?Palette.PrimaryColor: Colors.white54),
              title: Text('Profile')
          )
        ],
      ),
    );
  }




}
