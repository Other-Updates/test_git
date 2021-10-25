// ignore: file_names
// ignore: file_names
// ignore_for_file: file_names

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:service_app/Utils/Constants.dart';
import 'package:http/http.dart' as http;
import 'package:service_app/Utils/storageUtil.dart';
import 'package:service_app/components/Textads.dart';
import 'package:service_app/screens/CusHomeFragment.dart';
import 'package:service_app/screens/CusLeadsFragment.dart';
import 'package:service_app/screens/CusProfileFragment.dart';
import 'package:service_app/screens/CusServiceFragment.dart';
import 'package:service_app/screens/CusYoutubeFragment.dart';
import 'package:service_app/screens/CustomerProfile.dart';
import 'package:service_app/screens/LoginScreen.dart';
import 'package:service_app/screens/mobilelogin.dart';

class EditServiceScreen extends StatefulWidget {
  @override
  final leads_list;
  EditServiceScreen(this.leads_list);

  _EditServiceScreenState createState() =>
      _EditServiceScreenState(this.leads_list);
}

class _EditServiceScreenState extends State<EditServiceScreen> {
  final leads_list;
  _EditServiceScreenState(this.leads_list);
  List category_list = [];
  String mobile_test6 = '';
  int _selectedIndex = 0;
  getTextFromFile() async {
    try {
      String data = await StorageUtil.getItem("login_customer_id");
      setState(() {
        mobile_test6 = data;
      });
    } catch (ex) {
      print(ex);
    }
  }

  customer() async {
    await getTextFromFile();
    var data = json.encode({
      "customer_id": mobile_test6,
      "service_id": leads_list['id'],
      "service_type": "customer",
      "emp_id": mobile_test6
    });
    final response = await http.post(BASE_URL + 'get_service_history',
        headers: {'authorization': basicAuth}, body: data);
    print(data);
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      print(jsonResponse);
      if (jsonResponse['status'] == "success") {
        setState(() {
          category_list = jsonResponse['data'];
          print(category_list);
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
    var data = json.encode({"user_id": 'customer_id', "user_type": "2"});
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
    // TODO: implement initState
    super.initState();
    getTextFromFile();
    customer();
  }

  String convertDateTimeDisplay(String date) {
    final DateFormat displayFormater = DateFormat('dd/MM/yyyy');
    //final DateFormat serverFormater = DateFormat('dd/MM/yyyy');
    final DateTime displayDate = displayFormater.parse(date);
    final String formatted = displayFormater.format(displayDate);
    return formatted;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
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
              title: Text('Edit Service'),
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
            body: Container(
              child: Stack(children: [
                Container(
                    alignment: Alignment.center,
                    child: ListView(children: [
                      Container(
                          margin: EdgeInsets.only(
                              left: 8.0, right: 8.0, top: 10.0, bottom: 10.0),
                          child: Row(children: [
                            Expanded(
                                child: Text(
                                  leads_list['ticket_no'] ?? "--",
                                  style: TextStyle(
                                      fontSize: 17,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                                flex: 4),
                            Expanded(
                                child: Container(
                                  padding: EdgeInsets.only(
                                      top: 5.0, right: 10.0, bottom: 10.0),
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    '${leads_list['created_date']}',
                                    style: TextStyle(
                                        color: Color(0xffff7000),
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                flex: 4),
                          ])),
                      Container(
                          margin: EdgeInsets.only(
                              left: 8.0, right: 8.0, bottom: 10.0, top: 10.0),
                          alignment: Alignment.center,
                          child: Row(mainAxisSize: MainAxisSize.max, children: [
                            Padding(
                              padding: EdgeInsets.only(right: 12.0),
                              child: Text(
                                'About Issue',
                                style: TextStyle(
                                    fontSize: 17,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Expanded(
                              child: TextField(
                                maxLines: 3,
                                showCursor: false,
                                readOnly: true,
                                decoration: InputDecoration(
                                  hintText: leads_list['description'] ?? " ",
                                  contentPadding: EdgeInsets.fromLTRB(
                                      20.0, 15.0, 20.0, 15.0),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide: BorderSide(
                                        color: Colors.grey, width: 2),
                                  ),
                                ),
                              ),
                            )
                          ])),
                      Container(
                          margin: EdgeInsets.only(
                            left: 8.0,
                            right: 8.0,
                            bottom: 10.0,
                          ),
                          alignment: Alignment.center,
                          child: Row(mainAxisSize: MainAxisSize.max, children: [
                            Expanded(
                                child: Text(
                                  'Attender                     :',
                                  style: TextStyle(
                                      fontSize: 17,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                                flex: 2),
                            Expanded(
                                child: Text(
                                  leads_list['attendant'] ?? "--",
                                  style: TextStyle(
                                    fontSize: 17,
                                    color: Colors.black,
                                  ),
                                ),
                                flex: 2),
                          ])),
                      Container(
                          margin: EdgeInsets.only(
                              left: 8.0, right: 8.0, bottom: 10.0, top: 5.0),
                          alignment: Alignment.center,
                          child: Row(mainAxisSize: MainAxisSize.max, children: [
                            Expanded(
                                child: Text(
                                  'Mobile number         :  ${leads_list['attendant_mobile_no'] ?? "--"}',
                                  style: TextStyle(
                                      fontSize: 17,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                                flex: 2),
                          ])
                          /*  Expanded(child:

            imageSlider(context),flex: 2,),*/

                          ),
                      Container(
                        margin: EdgeInsets.only(
                            left: 8.0, right: 8.0, bottom: 10.0, top: 5.0),
                        alignment: Alignment.topLeft,
                        child: Text(
                          'Work Performed      :',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontSize: 17,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                          margin: EdgeInsets.only(
                              left: 5.0, right: 5.0, bottom: 10.0, top: 5.0),
                          height: 300.0,
                          child: ListView.builder(
                            itemCount: category_list.length,
                            itemBuilder: (context, index) =>
                                EachList(category_list[index]),
                          ))
                    ])),
                Container(
                    //  color:Colors.white,
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
                                                builder:
                                                    (BuildContext context) =>
                                                        CusLeadsFragment()));
                                      },
                                      icon: Icon(
                                        Icons.perm_phone_msg_outlined,
                                        color: Color(0xff004080),
                                      )),
                                  Text(
                                    'Leads',
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
                                                  CusServiceFragment()));
                                    },
                                    icon: ImageIcon(
                                        AssetImage(
                                            'assets/images/paidservice.png'),
                                        // color: Color(0xFF3A5A98),
                                        color: Color(0xffff7000)),
                                  ),
                                  Text(
                                    'Services',
                                    style: TextStyle(color: Color(0xffff7000)),
                                  ),
                                ]),
                                flex: 5),
                            Expanded(
                                child: Column(children: [
                                  IconButton(
                                      onPressed: () {
                                        Navigator.of(context).pushReplacement(
                                            MaterialPageRoute(
                                                builder:
                                                    (BuildContext context) =>
                                                        CusHomeFragment()));
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
                                                builder:
                                                    (BuildContext context) =>
                                                        CusProfileFragment()));
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
                            Expanded(
                                child: Column(children: [
                                  IconButton(
                                    onPressed: () {
                                      Navigator.of(context).pushReplacement(
                                          MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  CusYoutubeFragment()));
                                    },
                                    icon: ImageIcon(
                                      AssetImage(
                                          'assets/images/youtube_logo.png'),
                                      //  color: Color(0xFF3A5A98),
                                      color: Color(0xff004080),
                                    ),
                                  ),
                                  Text(
                                    'Youtube',
                                    style: TextStyle(
                                      color: Color(0xff004080),
                                    ),
                                  ),
                                ]),
                                flex: 5),
                          ],
                        ),
                      )
                    ]))
              ]),
            )));
  }

  Widget EachList(category_list) {
    return GestureDetector(
        child: Card(
            shadowColor: Color(0x802196F3),
            elevation: 4.0,
            color: Colors.white,
            shape: new RoundedRectangleBorder(
                //  side: new BorderSide(color: Color(0xffADDFDE), width: 2.0),
                borderRadius: BorderRadius.circular(12.0)),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                      //padding: EdgeInsets.only(left: 10),
                      child: new Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                        Flexible(
                          child: Container(
                              padding: EdgeInsets.only(left: 10),
                              alignment: Alignment.topLeft,
                              child: (category_list["emp_image"] != null &&
                                      category_list["emp_image"].length > 0)
                                  ? CircleAvatar(
                                      radius: 37,
                                      backgroundColor: Colors.blue,
                                      backgroundImage: NetworkImage(
                                          '${category_list["emp_image"]}'))
                                  : CircleAvatar(
                                      radius: 37,
                                      backgroundImage: AssetImage(
                                          "assets/images/favicon.png"),
                                      backgroundColor: Colors.white,
                                    )),
                          flex: 3,
                        ),
                        Flexible(
                            child: Container(
                              alignment: Alignment.center,
                              child: new Column(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                        child: new Row(children: [
                                      Container(
                                          padding: EdgeInsets.all(5.0),
                                          alignment: Alignment.topLeft,
                                          child: Text(
                                            'Date                          :',
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                              color: Colors.black54,
                                            ),
                                          )),
                                      Container(
                                          padding: EdgeInsets.all(5.0),
                                          alignment: Alignment.topLeft,
                                          child: Text(
                                            convertDateTimeDisplay(
                                                '${category_list['created_date'] ?? " "}'),
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                              color: Colors.black54,
                                            ),
                                          )),
                                    ])),
                                    Container(
                                        padding: EdgeInsets.all(5.0),
                                        alignment: Alignment.bottomLeft,
                                        child: Text(
                                          'Status                       :   ${category_list['work_status'] ?? "--"}',
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                            color: Colors.black54,
                                          ),
                                        )),
                                    Container(
                                        padding: EdgeInsets.all(5.0),
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                          'Work Performed     :  ${category_list['work_performed'] ?? "--"}',
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                            color: Colors.black54,
                                          ),
                                        )),
                                    Container(
                                        padding: EdgeInsets.all(5.0),
                                        alignment: Alignment.bottomLeft,
                                        child: Text(
                                          'Attender                   :  ${category_list['name'] ?? " "}',
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                            color: Colors.black54,
                                          ),
                                        )),
                                    Container(
                                        padding: EdgeInsets.all(5.0),
                                        alignment: Alignment.bottomLeft,
                                        child: Text(
                                          'Mobile number       :  ${category_list['mobile_no'] ?? "--"}',
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                            color: Colors.black54,
                                          ),
                                        )),
                                  ]),
                            ),
                            flex: 8),
                      ])),
                ])));
  }
}
