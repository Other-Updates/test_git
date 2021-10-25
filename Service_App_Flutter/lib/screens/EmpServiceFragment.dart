import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:service_app/Utils/Constants.dart';
import 'package:service_app/Utils/storageUtil.dart';
import 'package:service_app/components/Textads.dart';
import 'package:service_app/components/adsimages.dart';
import 'package:http/http.dart' as http;
import 'package:service_app/screens/EmpEditServiceScreen.dart';
import 'package:service_app/screens/EmpProfileFragment.dart';
import 'package:service_app/screens/EmpTodaytaskFragment.dart';
import 'package:service_app/screens/EmphomeFragment.dart';
import 'package:service_app/screens/EmployeProfile.dart';
import 'package:service_app/screens/LoginScreen.dart';
import 'package:service_app/screens/EmployeeEditService.dart';
import 'package:service_app/screens/TodayTask.dart';
import 'package:service_app/screens/mobilelogin.dart';

class EmpServiceFragment extends StatefulWidget {
  @override
  _EmpServiceFragmentState createState() => _EmpServiceFragmentState();
}

class _EmpServiceFragmentState extends State<EmpServiceFragment> {
  List service_list = [];
  var id = '',
      customer_id = '',
      status = '',
      inv_no = '',
      attendant = '',
      created_date = '',
      work_performed = '',
      description = '',
      img_path = ' ';
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

  customer() async {
    await getTextFromFile();
    var data =
        json.encode({"emp_id": mobile_test6, "service_type": "employee"});
    final response = await http.post(BASE_URL + 'get_service_list',
        headers: {'authorization': basicAuth}, body: data);
    print(data);
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      print(jsonResponse);
      if (jsonResponse['status'] == "success") {
        setState(() {
          service_list = jsonResponse['data'];
          print(service_list);
        });
      } else if (jsonResponse['status'] == 'Error') {
        Navigator.pop(context);
      }
      //   sharedPreferences.setString("token", jsonResponse['token']);
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
          actions: <Widget>[
            FlatButton(
              child: Text(
                'No',
                style: TextStyle(color: Color(0xffff7000)),
              ),
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss the Dialog
              },
            ),
            FlatButton(
              child: Text(
                'Yes',
                style: TextStyle(color: Color(0xffff7000)),
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
    customer();
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
                      TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text('No')),
                      ElevatedButton(
                          onPressed: () {
                            willLeave = false;
                            SystemNavigator.pop();
                          },
                          child: Text('Yes')),
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
              'Services',
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
          body: Container(
            child: Column(children: <Widget>[
              SizedBox(
                height: 8.0,
              ),
              Container(
                height: 130,
                width: MediaQuery.of(context).size.width,
                child: AdsImages(),
              ),
              SizedBox(
                height: 8.0,
              ),
              Expanded(
                  child: Container(
                    margin: EdgeInsets.only(left: 5.0, right: 5.0),
                    child: (service_list.length > 0)
                        ? ListView.builder(
                            //reverse: true,
                            itemCount: service_list.length,
                            itemBuilder: (context, index) =>
                                EachList(service_list[index]),
                          )
                        : Center(
                            child: Image.asset('assets/images/loader.gif'),
                          ),
                  ),
                  flex: 4),
              Container(
                alignment: Alignment.bottomCenter,
                height: 30,
                child: TextAds(),
              ),
              Container(
                color: Colors.white,
                //    alignment:Alignment.bottomCenter,
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
                              icon: Icon(Icons.home_repair_service_outlined,
                                  color: Color(0xffff7000))),
                          Text(
                            'Services',
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

/*      Container(
        alignment: Alignment.bottomRight,
     child: FloatingActionButton(
       child: Icon(Icons.add),
       backgroundColor: new Color(0xff004080),

       onPressed: () {  Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => AddServiceScreen())); },

     ),),*/
            ]),
          ),
          /* body: Padding(
          padding: const EdgeInsets.only(bottom:80.0),
          child: Container(

child:(service_list.length > 0)? ListView.builder(

            itemCount:service_list.length,
            itemBuilder: (context, index) =>
                EachList(service_list[index]),
          ):Center(child:Image.asset('assets/images/loader.gif')),
              ),
        ),*/
        ));
  }

  Widget EachList(service_list) {
    return GestureDetector(
        onTap: () {
          setState(() {
            id = service_list['id'];
          });
          Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) =>
                  EmployeeEditService(service_list)));
          // EmpEditServiceScreen(service_list)
        },
        child: Stack(children: [
          Container(
            height: 80,
            child: Card(
                margin: EdgeInsets.only(left: 30, bottom: 8, right: 13),
                shadowColor: Color(0xff004080),
                elevation: 1.0,
                color: Colors.white,
                // color: (service_list['status'] == "0")
                //     ? Color(0xffFFB347)
                //     : (service_list['status'] == "1")
                //         ? Color(0xffABD5AB)
                //     : Color(0xffF28B88),
                shape: new RoundedRectangleBorder(
                    side: new BorderSide(
                        color: (service_list['status'] == "0")
                            ? Color(0xffFFB347)
                            : (service_list['status'] == "1")
                                ? Colors.green
                                : Color(0xffF28B88),
                        width: 2.0),
                    borderRadius: BorderRadius.circular(12.0)),
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                          child: new Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                            Flexible(
                                child: Container(
                                  alignment: Alignment.center,
                                  child: new Column(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        Container(
                                          padding: EdgeInsets.only(
                                              left: 40.0, top: 6),
                                          alignment: Alignment.bottomLeft,
                                          child: Text(
                                            '${service_list['ticket_no'] ?? "--"}',
                                            maxLines: 1,
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                        Container(
                                            padding: EdgeInsets.only(
                                                left: 40.0, top: 5),
                                            alignment: Alignment.bottomLeft,
                                            child: Text(
                                              '${service_list['description']}',
                                              maxLines: 1,
                                              textAlign: TextAlign.start,
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.black54,
                                              ),
                                            )),
                                        Container(
                                            padding: EdgeInsets.only(
                                                left: 40.0, top: 5),
                                            child: new Row(children: <Widget>[
                                              Text('Current Status:',
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black,
                                                  )),
                                              Container(
                                                  padding: EdgeInsets.only(
                                                      left: 2.0),
                                                  alignment: Alignment.topLeft,
                                                  child: Text(
                                                    '${(service_list['status'].toString() == "0") ? "In-Progress" : (service_list['status'].toString() == "1") ? "Complete" : "Pending"}',
                                                    textAlign: TextAlign.start,
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: (service_list[
                                                                      'status']
                                                                  .toString() ==
                                                              "0")
                                                          ? Colors
                                                              .deepOrangeAccent
                                                          : (service_list['status']
                                                                      .toString() ==
                                                                  "1")
                                                              ? Colors.green
                                                              : Colors.red,
                                                    ),
                                                  ))
                                            ])),
                                      ]),
                                ),
                                flex: 5),
                            Flexible(
                                child: Container(
                                  alignment: Alignment.center,
                                  child: new Column(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        Container(
                                            padding: EdgeInsets.only(
                                              right: 15.0,
                                            ),
                                            alignment: Alignment.topRight,
                                            child: Text(
                                              '${service_list['created_date']}',
                                              textAlign: TextAlign.start,
                                              style: TextStyle(
                                                  color: Colors.black54,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12.0),
                                            )),
                                        Container(
                                            //padding: EdgeInsets.all(5.0),
                                            alignment: Alignment.bottomRight,
                                            child: Text(
                                              ' ',
                                              textAlign: TextAlign.start,
                                              style: TextStyle(
                                                color: Colors.black54,
                                              ),
                                            )),
                                        Container(
                                            //  padding: EdgeInsets.all(5.0),
                                            alignment: Alignment.topLeft,
                                            child: Text(
                                              ' ',
                                              textAlign: TextAlign.start,
                                              style: TextStyle(
                                                color: Colors.black54,
                                              ),
                                            )),
                                      ]),
                                ),
                                flex: 2),
                          ])),
                    ])),
          ),
          Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(top: 8),
                child: SizedBox(
                    child: (service_list['customer_image_upload'].length > 0)
                        ? CircleAvatar(
                            radius: 28,
                            backgroundColor: Colors.blue,
                            backgroundImage: NetworkImage(
                                '${service_list['customer_image_upload'][0]["img_path"]}'))
                        : CircleAvatar(
                            radius: 28,
                            backgroundImage:
                                AssetImage("assets/images/favicon.png"),
                            backgroundColor: Colors.white,
                          )),
              )),
          Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: EdgeInsets.only(top: 27, bottom: 15),
                child: Container(
                  height: 25,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30.0)),
                  child: (service_list['status'] == "0")
                      ? Icon(
                          Icons.report_gmailerrorred_rounded,
                          color: Colors.orangeAccent,
                          size: 25.0,
                        )
                      : (service_list['status'] == "1")
                          ? Icon(
                              Icons.check_circle,
                              color: Colors.green,
                              size: 25.0,
                            )
                          : Icon(
                              Icons.pending,
                              color: Colors.red,
                              size: 25.0,
                            ),
                ),
              )),
        ]));
  }
}
