import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:service_app/Utils/Constants.dart';
import 'package:service_app/screens/EmpProfileFragment.dart';
import 'package:service_app/screens/EmpServiceFragment.dart';
import 'package:service_app/screens/EmpTodaytaskFragment.dart';
import 'package:service_app/screens/EmphomeFragment.dart';
import 'package:http/http.dart' as http;
import 'package:service_app/screens/EmployeProfile.dart';
import 'package:service_app/screens/TodayTask.dart';

class EmployeeBottomNavigation extends StatefulWidget {
  @override
  _EmployeeBottomNavigationState createState() =>
      _EmployeeBottomNavigationState();
}

class _EmployeeBottomNavigationState extends State<EmployeeBottomNavigation> {
  //PageController _pageController = PageController(initialPage: 2);
  List<Widget> _Screens = [
    EmpServiceFragment(),
    TodayTask(),
    EmphomeFragment(),
    EmpProfileFragment(),
  ];
  int _selectedIndex = 0;
  void _onPageChanged(int index) {
    setState(() {
      _selectedIndex = index;
      _selectedIndex = index;
    });
  }

  List _pages = [
    Text("Services"),
    Text("Today Task"),
    Text("Dashboard"),
    Text("Profile"),
  ];

  /* void onItemTapped(int selectedIndex){
    _pageController.jumpToPage(selectedIndex);



  }*/
  int _currentIndex = 0;

  List images = [];

  customerlogout() async {
    var data = json.encode({"user_id": 'emp_id', "user_type": "1"});
    final response = await http.post(BASE_URL + 'user_log_out',
        headers: {'authorization': basicAuth}, body: data);
    print(data);
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      print(jsonResponse);
      if (jsonResponse['status'] == "success") {
        var customer_details = jsonResponse['data'];
        //  print("customeraavo"+customer_details['id']);
        setState(() {});

        //  Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => CustomerDashboardScreen()), (Route<dynamic> route) => false);
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
                //   SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                Navigator.of(context).pop(); // Navigate to login
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    //_pageController;
    customerlogout();
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      //  onTap: onItemTapped,
      //_currentIndex = _currentIndex;

      //  onTap: ,
      // currentIndex: _currentIndex,
      type: BottomNavigationBarType.fixed,
      // this will be set when a new tab is tapped
      items: [
        BottomNavigationBarItem(
          backgroundColor: new Color(0xff004080),
          icon: new Icon(
            Icons.perm_phone_msg_outlined,
            color: _selectedIndex == 0 ? Color(0xffff7000) : Color(0xff004080),
          ),
          title: new Text(
            'Services',
            style: TextStyle(
              color:
                  _selectedIndex == 0 ? Color(0xffff7000) : Color(0xff004080),
            ),
          ),
        ),
        BottomNavigationBarItem(
          icon: ImageIcon(
            AssetImage('assets/images/paidservice.png'),
            // color: Color(0xFF3A5A98),

            color: _selectedIndex == 1 ? Color(0xffff7000) : Color(0xff004080),
          ),
          title: new Text(
            'Today Task',
            style: TextStyle(
              color:
                  _selectedIndex == 1 ? Color(0xffff7000) : Color(0xff004080),
            ),
          ),
        ),
        BottomNavigationBarItem(
          icon: new Icon(
            Icons.home_outlined,
            color: _selectedIndex == 2 ? Color(0xffff7000) : Color(0xff004080),
          ),
          title: new Text(
            'Home',
            style: TextStyle(
              color:
                  _selectedIndex == 2 ? Color(0xffff7000) : Color(0xff004080),
            ),
          ),
        ),
        BottomNavigationBarItem(
          icon: new Icon(
            Icons.person_outline,
            color: _selectedIndex == 3 ? Color(0xffff7000) : Color(0xff004080),
          ),
          title: new Text(
            'Profile',
            style: TextStyle(
              color:
                  _selectedIndex == 3 ? Color(0xffff7000) : Color(0xff004080),
            ),
          ),
        ),
      ],
    );
  }
}
