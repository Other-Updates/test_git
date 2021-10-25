// ignore: file_names
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:service_app/Utils/Constants.dart';
import 'package:http/http.dart' as http;
import 'package:service_app/Utils/storageUtil.dart';
import 'package:service_app/components/Textads.dart';
import 'package:service_app/components/adsimages.dart';
import 'package:service_app/screens/EmpProfileFragment.dart';
import 'package:service_app/screens/EmpServiceFragment.dart';
import 'package:service_app/screens/EmpTodaytaskFragment.dart';
import 'package:service_app/screens/EmployeProfile.dart';
import 'package:service_app/screens/LoginScreen.dart';
import 'package:service_app/screens/TodayTask.dart';
import 'package:service_app/screens/mobilelogin.dart';

class EmphomeFragment extends StatefulWidget {
  @override
  _EmphomeFragmentState createState() => _EmphomeFragmentState();
}

class _EmphomeFragmentState extends State<EmphomeFragment> {
  List pending_leads_list = [];
  int _selectedIndex = 0;
  void _onPageChanged(int index) {
    setState(() {
      _selectedIndex = index;
      _selectedIndex = index;
    });
  }

  List<String> Names = [
    'Abhishek',
    'John',
    'Robert',
    'Shyam',
    'Sita',
    'Gita',
    'Nitish'
  ];
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

  empservice() async {
    await getTextFromFile();
    var data =
        json.encode({"emp_id": mobile_test6, "service_type": "employee"});
    final response = await http.post(BASE_URL + 'get_service_pending_list',
        headers: {'authorization': basicAuth}, body: data);
    print(data);
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      print(jsonResponse);
      if (jsonResponse['status'] == "success") {
        setState(() {
          pending_leads_list = jsonResponse['data'];
          print(pending_leads_list);
        });
      } else if (jsonResponse['status'] == 'Error') {}
    }
  }

  List todaytasklist = [];
  String serviceDate = ' ',
      status = ' ',
      description = ' ',
      todaytasklist1 = ' ';
  todayTask() async {
    await getTextFromFile();

    var data =
        json.encode({"emp_id": mobile_test6, "service_type": "employee"});
    final response = await http.post(BASE_URL + 'get_service_pending_list',
        headers: {'authorization': basicAuth}, body: data);
    print(data);
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      print(jsonResponse);
      if (jsonResponse['status'] == "success") {
        var i = 0;
        var currentDate = DateFormat('dd/MM/yyyy').format(DateTime.now());
        print(currentDate);

        setState(() {
          for (i; i < jsonResponse['data'].length; i++) {
            var datestr = jsonResponse['data'][i]['created_date'];
            print(datestr);
            if (datestr == currentDate) {
              todaytasklist.add(jsonResponse['data'][i]);

              print(todaytasklist);
            }
          }
        });
      } else if (jsonResponse['status'] == 'Error') {
        Navigator.pop(context);
      }
    } else {
      Navigator.pop(context);
    }
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

  @override
  void initState() {
    super.initState();
    getTextFromFile();
    empservice();
    todayTask();
  }

  String convertDateTimeDisplay(String date) {
    final DateFormat displayFormater = DateFormat('yyyy-MM-dd');
    final DateFormat serverFormater = DateFormat('dd/MM/yyyy');
    final DateTime displayDate = displayFormater.parse(date);
    final String formatted = serverFormater.format(displayDate);
    return formatted;
  }

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
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
            appBar: AppBar(
              leadingWidth: 110,
              centerTitle: true,
              backgroundColor: new Color(0xff004080),
              leading: Image.asset(
                'assets/images/service_logo.png',
              ),
              title: Text(
                'Home',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              automaticallyImplyLeading: false,
              actions: <Widget>[
                IconButton(
                    icon: Icon(
                      Icons.power_settings_new_rounded,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      _showMyDialog();
                    }),
              ],
              //   centerTitle: true,
              //  automaticallyImplyLeading: false,
            ),
            resizeToAvoidBottomInset: false,
            body: new Column(children: <Widget>[
              Container(
                margin: EdgeInsets.all(5.0),
                child: Row(
                  children: [
                    Expanded(
                        child: Column(children: [
                          Container(
                              child: GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                EmpServiceFragment()));
                                  },
                                  child:
                                      Image.asset("assets/images/service.png")))
                        ]),
                        flex: 2),
                    Expanded(
                        child: Column(children: [
                          Container(
                              child: GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                TodayTask()));
                                  },
                                  child: Image.asset(
                                      "assets/images/today_task.png")))
                        ]),
                        flex: 2),
                  ],
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              Container(
                height: 140,
                width: MediaQuery.of(context).size.width,
                child: AdsImages(),
              ),
              SizedBox(
                height: 20.0,
              ),
              Container(
                child: _tabSection(context),
              ),
              // Expanded(
              //     child: Container(
              //       margin: EdgeInsets.all(5.0),
              //       child: Column(children: <Widget>[
              //         //alignment: Alignment.topLeft,
              //         Container(
              //             padding: EdgeInsets.only(top: 10.0, left: 5.0),
              //             alignment: Alignment.topLeft,
              //             child: Text('Services',
              //                 style: TextStyle(
              //                     color: Color(0xff004080),
              //                     fontSize: 20,
              //                     fontWeight: FontWeight.bold))),
              //         Expanded(
              //           child: (pending_leads_list.length > 0)
              //               ? ListView.builder(
              //                   reverse: false,
              //                   itemCount: pending_leads_list.length,
              //                   itemBuilder: (context, index) =>
              //                       ServiceList(pending_leads_list[index]),
              //                 )
              //               : Center(
              //                   child: Image.asset('assets/images/loader.gif'),
              //                 ),
              //         ),
              //       ]),
              //     ),
              //     flex: 2),
              // Expanded(
              //     child: Container(
              //         margin: EdgeInsets.all(5.0),
              //         child: Column(children: <Widget>[
              //           //alignment: Alignment.topLeft,
              //           Container(
              //               alignment: Alignment.topLeft,
              //               child: Text('Today Task',
              //                   style: TextStyle(
              //                       color: Color(0xff004080),
              //                       fontSize: 20,
              //                       fontWeight: FontWeight.bold))),
              //           Expanded(
              //             child: (todaytasklist.length > 0)
              //                 ? ListView.builder(
              //                     reverse: false,
              //                     itemCount: todaytasklist.length,
              //                     itemBuilder: (context, index) =>
              //                         TodayTaskList(todaytasklist[index]),
              //                   )
              //                 : Center(),
              //           ),
              //         ])),
              //     flex: 2),
              Container(
                alignment: Alignment.bottomCenter,
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  Container(
                    height: 30,
                    child: TextAds(),
                  ),
                  Container(
                    color: Colors.white,
                    alignment: Alignment.bottomCenter,
                    width: double.infinity,
                    child: Row(
                      children: [
                        Expanded(
                            child: Column(children: [
                              IconButton(
                                  onPressed: () {
                                    Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                            builder: (BuildContext context) =>
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
                                    Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                            builder: (BuildContext context) =>
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
                                    Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                EmphomeFragment()));
                                  },
                                  icon: Icon(Icons.home_outlined,
                                      color: Color(0xffff7000))),
                              Text(
                                'Home',
                                style: TextStyle(
                                  color: Color(0xffff7000),
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
                                            builder: (BuildContext context) =>
                                                EmpProfileFragment()));
                                  },
                                  icon: Icon(
                                    Icons.person_outline,
                                    color: Color(0xff004080),
                                  )),
                              Text(
                                'Profile',
                                style: TextStyle(
                                  color: Color(0xff004080),
                                ),
                              ),
                            ]),
                            flex: 5),
                      ],
                    ),
                  )
                ]),
              )
            ])));
  }

  Widget TodayTaskList(todaytasklist) {
    return Card(
        shadowColor: Color(0x802196F3),
        elevation: 4.0,
        color: Colors.white,
        shape: new RoundedRectangleBorder(
            side: new BorderSide(
                color: (todaytasklist['status'].toString() == "0")
                    ? Colors.deepOrangeAccent
                    : (todaytasklist['status'].toString() == "1")
                        ? Colors.green
                        : Colors.red,
                width: 1.0),
            borderRadius: BorderRadius.circular(5.0)),
        child: new Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                  //padding: EdgeInsets.only(left: 10),
                  child: new Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                    Container(
                      alignment: Alignment.topLeft,
                      decoration: new BoxDecoration(
                        borderRadius: new BorderRadius.only(
                            topLeft: const Radius.circular(5),
                            bottomLeft: const Radius.circular(5)),
                        color: (todaytasklist['status'].toString() == "0")
                            ? Colors.deepOrangeAccent
                            : (todaytasklist['status'].toString() == "1")
                                ? Colors.green
                                : Colors.red,
                      ),
                      width: 5,
                      height: 45,
                    ),
                    Flexible(
                        child: Container(
                          alignment: Alignment.center,
                          child: new Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Flexible(
                                    child: Container(
                                        padding: EdgeInsets.only(left: 10.0),
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                            '${todaytasklist['description']}')),
                                    flex: 3),
                                Flexible(
                                    child: Container(
                                        padding: EdgeInsets.only(right: 10.0),
                                        alignment: Alignment.centerRight,
                                        child: Text(
                                          '${todaytasklist['created_date']}',
                                          maxLines: 1,
                                        )),
                                    flex: 3),
                              ]),
                        ),
                        flex: 2),
                  ])),
            ]));
  }

  Widget ServiceList(pending_leads_list1) {
    return Card(
        shadowColor: Color(0x802196F3),
        elevation: 4.0,
        color: Colors.white,
        shape: new RoundedRectangleBorder(
            side: new BorderSide(
                color: (pending_leads_list1['status'].toString() == "0")
                    ? Colors.deepOrangeAccent
                    : (pending_leads_list1['status'].toString() == "1")
                        ? Colors.green
                        : Colors.red,
                width: 1.0),
            borderRadius: BorderRadius.circular(5.0)),
        child: new Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                  //padding: EdgeInsets.only(left: 10),
                  child: new Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                    Container(
                      alignment: Alignment.topLeft,
                      decoration: new BoxDecoration(
                        borderRadius: new BorderRadius.only(
                            topLeft: const Radius.circular(5),
                            bottomLeft: const Radius.circular(5)),
                        color: (pending_leads_list1['status'].toString() == "0")
                            ? Colors.deepOrangeAccent
                            : (pending_leads_list1['status'].toString() == "1")
                                ? Colors.green
                                : Colors.red,
                      ),
                      width: 5,
                      height: 45,
                    ),
                    Flexible(
                        child: Container(
                          alignment: Alignment.center,
                          child: new Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Flexible(
                                    child: Container(
                                        padding: EdgeInsets.only(left: 10.0),
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                            '${pending_leads_list1['description']}')),
                                    flex: 3),
                                Flexible(
                                    child: Container(
                                        padding: EdgeInsets.only(right: 10.0),
                                        alignment: Alignment.centerRight,
                                        child: Text(
                                          '${pending_leads_list1['created_date']}',
                                          maxLines: 1,
                                        )),
                                    flex: 3),
                              ]),
                        ),
                        flex: 2),
                  ])),
            ]));
  }

  Widget _tabSection(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(left: 20, right: 20),
            child: TabBar(
                unselectedLabelColor: Color(0xff004080),
                labelColor: Colors.white,
                indicatorSize: TabBarIndicatorSize.tab,
                indicatorColor: Color(0xffff7000),
                indicator: BoxDecoration(
                    //  gradient: LinearGradient(
                    //   color: Color(0xff004080), Colors.orangeAccent]),
                    borderRadius: BorderRadius.circular(50),
                    color: Color(0xff004080)),
                tabs: [
                  Tab(
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        "Services",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Tab(
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        "Today Task",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ]),
          ),
          SizedBox(
            height: 15,
          ),
          Container(
            //Add this to give height
            height: 280,
            child: TabBarView(children: [
              Expanded(
                child: (pending_leads_list.length > 0)
                    ? ListView.builder(
                        reverse: false,
                        itemCount: pending_leads_list.length,
                        itemBuilder: (context, index) =>
                            ServiceList(pending_leads_list[index]),
                      )
                    : Center(
                        child: Image.asset('assets/images/loader.gif'),
                      ),
              ),
              Expanded(
                  child: Padding(
                padding: EdgeInsets.only(left: 7, right: 7),
                child: (todaytasklist.length > 0)
                    ? ListView.builder(
                        reverse: false,
                        itemCount: todaytasklist.length,
                        itemBuilder: (context, index) =>
                            TodayTaskList(todaytasklist[index]),
                      )
                    : Center(),
              )),
              //  ])),
              //   ),
              // ),
            ]),
          ),
        ],
      ),
    );
  }
}
