// ignore: file_names
import 'dart:convert';

import 'package:flutter/cupertino.dart';
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

class CusEditLeads extends StatefulWidget {
  @override
  final leads_list;
  CusEditLeads(this.leads_list);
  _CusEditLeadsState createState() => _CusEditLeadsState(this.leads_list);
}

class _CusEditLeadsState extends State<CusEditLeads> {
  final leads_list;
  _CusEditLeadsState(this.leads_list);
  int _selectedIndex = 0;
  var _scaffoldKey = new GlobalKey<ScaffoldState>();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController contact1controller = TextEditingController();
  TextEditingController contact2controller = TextEditingController();
  TextEditingController descriptioncontroller = TextEditingController();

  String imagename = '';
  String mobile_test6 = '';
  String selected_category = "";

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

  category() async {
    final response = await http.get(BASE_URL + 'get_all_checked_categories',
        headers: {'authorization': basicAuth});

    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      print(jsonResponse);
      if (jsonResponse['status'] == "success") {
        setState(() {
          category_list = jsonResponse['category'];
          // category_image
          //  print(category_list);
        });
      } else if (jsonResponse['status'] == 'Error') {
        Navigator.pop(context);
      }
      //   sharedPreferences.setString("token", jsonResponse['token']);
    } else {
      Navigator.pop(context);
    }
  }

  void _showMessageInScaffold(String message) {
    _scaffoldKey.currentState!.showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
          softWrap: true,
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  List category_list = [];

  String convertDateTimeDisplay(String date) {
    final DateFormat displayFormater = DateFormat('yyyy-MM-dd');
    final DateFormat serverFormater = DateFormat('dd/MM/yyyy');
    final DateTime displayDate = displayFormater.parse(date);
    final String formatted = serverFormater.format(displayDate);
    return formatted;
  }

  customerlogout() async {
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

  leadsUpdate() async {
    await getTextFromFile();
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    if (contact1controller.text == "") {
      _showMessageInScaffold("Please enter mobile number");
    } else if (descriptioncontroller.text == "") {
      _showMessageInScaffold("Please enter description");
    }

    var currentDate = DateFormat('dd/MM/yyyy').format(DateTime.now());

    var data = json.encode({
      "customer_id": mobile_test6,
      "cat_id": selected_category,
      "contact_1": contact1controller.text,
      "contact_2": contact2controller.text,
      "description": descriptioncontroller.text,
      "followup_date": currentDate,
      "leads_id": leads_list['id']
    });

    final response = await http.post(BASE_URL + 'edit_leads',
        headers: {'authorization': basicAuth}, body: data);
    print("shfyab" + data);
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      print(jsonResponse);
      if (jsonResponse['status'] == "success") {
        Navigator.of(context).push(
          MaterialPageRoute(
              builder: (BuildContext context) => CusLeadsFragment()),
        );
      } else if (jsonResponse['status'] == 'Error') {
        _showMessageInScaffold(jsonResponse['message']);
      }
    } else {
      // Navigator.pop(context);
      _showMessageInScaffold('Contact Admin!!');
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
    category();
    setState(() {
      contact1controller.text = leads_list['contact_number'];
      contact2controller.text = leads_list['contact_number_2'];
      descriptioncontroller.text = leads_list['enquiry_about'];
      selected_category = leads_list['cat_id'];
    });
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
          backgroundColor: Color(0xff004080),
          body: Stack(
            children: <Widget>[
              Column(children: [
                Container(
                  padding: EdgeInsets.only(top: 10.0),
                  child: Stack(
                    //mainAxisSize: MainAxisSize.max,
                    //mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                          padding: EdgeInsets.only(top: 10.0, left: 15),
                          width: 100,
                          height: 30,
                          alignment: Alignment.centerLeft,
                          child: Image.asset('assets/images/service_logo.png')),
                      Container(
                        height: 30,
                        padding: EdgeInsets.only(top: 10.0),
                        alignment: Alignment.center,
                        child: Text(
                          'Edit Leads',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                          height: 30,
                          alignment: Alignment.centerRight,
                          child: IconButton(
                            icon: Icon(Icons.power_settings_new_rounded),
                            color: Colors.white,
                            onPressed: () {
                              _showMyDialog();
                            },
                          ))
                    ],
                  ),
                ),
                SizedBox(height: 20.0),
                Padding(
                  padding: EdgeInsets.only(left: 1.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Text(leads_list['enquiry_no'],
                          style: TextStyle(
                              fontFamily: 'Montserrat',
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 15.0)),
                      SizedBox(width: 10.0),
                      Text(
                          convertDateTimeDisplay(
                              '${leads_list['created_date']}'),
                          style: TextStyle(
                              fontFamily: 'Montserrat',
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 15.0))
                    ],
                  ),
                ),
                SizedBox(height: 20.0),
                Expanded(
                    child: Container(
                  height: MediaQuery.of(context).size.height - 90.0,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(50.0),
                        topRight: Radius.circular(50.0)),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    //  primary: false,
                    //   padding: EdgeInsets.only(left: 25.0, right: 20.0),
                    children: <Widget>[
                      Padding(
                          padding: EdgeInsets.only(top: 30.0),
                          child: Container(
                              // height:
                              //     MediaQuery.of(context).size.height - 300.0,
                              child: Column(children: [
                            Container(
                                padding: EdgeInsets.all(10.0),
                                alignment: Alignment.center,
                                child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Text(
                                        'What we do',
                                        style: TextStyle(
                                            fontSize: 17,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        '*',
                                        style: TextStyle(
                                          fontSize: 17,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ])),
                            Container(
                              height: 120.0,
                              margin: EdgeInsets.only(left: 10, right: 10),
                              child: (category_list.length > 0)
                                  ? ListView.builder(
                                      itemCount: category_list.length,
                                      itemBuilder: (context, index) =>
                                          EachList(category_list[index]),
                                      scrollDirection: Axis.horizontal,
                                    )
                                  : Center(),
                            ),
                            Container(
                                padding: EdgeInsets.all(10.0),
                                alignment: Alignment.center,
                                child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Expanded(
                                          child: Row(children: [
                                        Text(
                                          'Contact No1',
                                          style: TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                        Text(
                                          '*',
                                          style: TextStyle(
                                            fontSize: 17,
                                            color: Colors.red,
                                          ),
                                        )
                                      ])),
                                      Expanded(
                                          child: Text(
                                        'Contact No2',
                                        style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      )),
                                    ])),
                            Form(
                                key: _formKey,
                                child: Column(children: [
                                  Container(
                                      padding: EdgeInsets.all(10.0),
                                      child: Row(
                                          //  mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Expanded(
                                                child: Container(
                                                    padding: EdgeInsets.only(
                                                      right: 10.0,
                                                    ),
                                                    // alignment: Alignment.centerRight,
                                                    child: TextFormField(
                                                      controller:
                                                          contact1controller,
                                                      validator: (value) {
                                                        if (value!.isEmpty) {
                                                          return 'Please enter mobile number';
                                                        } else if (value
                                                                .length <
                                                            10) {
                                                          return "Enter valid mobile number";
                                                        }
                                                        return null;
                                                      },
                                                      // keyboardType: TextInputType.phone,
                                                      keyboardType:
                                                          TextInputType.number,
                                                      inputFormatters: <
                                                          TextInputFormatter>[
                                                        FilteringTextInputFormatter
                                                            .digitsOnly
                                                      ],
                                                      maxLength: 10,
                                                      decoration:
                                                          InputDecoration(
                                                        counterText: "",
                                                        //hintText: leads_list['contact_number'],
                                                        contentPadding:
                                                            EdgeInsets.fromLTRB(
                                                                20.0,
                                                                10.0,
                                                                0.0,
                                                                10.0),

                                                        border: OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10.0)),
                                                        focusedBorder:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          10.0)),
                                                          borderSide: BorderSide(
                                                              color: Color(
                                                                  0xff004080),
                                                              width: 2),
                                                        ),
                                                      ),
                                                    )),
                                                flex: 2),
                                            Expanded(
                                                child: Container(
                                                    padding: EdgeInsets.only(
                                                      left: 10.0,
                                                    ),
                                                    // alignment: Alignment.centerRight,
                                                    child: TextFormField(
                                                      controller:
                                                          contact2controller,
                                                      keyboardType:
                                                          TextInputType.number,
                                                      inputFormatters: <
                                                          TextInputFormatter>[
                                                        FilteringTextInputFormatter
                                                            .digitsOnly
                                                      ],
                                                      maxLength: 10,
                                                      decoration:
                                                          InputDecoration(
                                                        counterText: "",
                                                        // hintText: leads_list['contact_number_2'],
                                                        contentPadding:
                                                            EdgeInsets.fromLTRB(
                                                                20.0,
                                                                10.0,
                                                                0.0,
                                                                10.0),

                                                        border: OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10.0)),
                                                        focusedBorder:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          10.0)),
                                                          borderSide: BorderSide(
                                                              color: Color(
                                                                  0xff004080),
                                                              width: 2),
                                                        ),
                                                      ),
                                                    )),
                                                flex: 2),
                                          ])
                                      /*  Expanded(child:

            imageSlider(context),flex: 2,),*/

                                      ),
                                  Container(
                                      padding: EdgeInsets.all(10.0),
                                      alignment: Alignment.center,
                                      child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Text(
                                              'Description',
                                              style: TextStyle(
                                                  fontSize: 17,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              '*',
                                              style: TextStyle(
                                                fontSize: 17,
                                                color: Colors.red,
                                              ),
                                            ),
                                          ])),
                                  Container(
                                      padding: EdgeInsets.only(
                                          left: 8.0, right: 8.0, bottom: 5.0),
                                      child: TextFormField(
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return 'Please enter description ';
                                          }
                                          return null;
                                        },
                                        textAlign: TextAlign.start,
                                        //  style: TextStyle(fontSize: 20.0,color: Colors.black38),
                                        keyboardType: TextInputType.multiline,
                                        maxLength: null,
                                        controller: descriptioncontroller,
                                        maxLines: 5,
                                        decoration: InputDecoration(
                                          // hintText: leads_list['enquiry_about'],
                                          contentPadding: EdgeInsets.fromLTRB(
                                              10.0, 8.0, 10.0, 8.0),
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10.0)),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10.0)),
                                            borderSide: BorderSide(
                                                color: Color(0xff004080),
                                                width: 2),
                                          ),
                                        ),
                                      )),
                                ])),
                            Container(
                                padding: EdgeInsets.all(8.0),
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        padding: EdgeInsets.only(
                                            bottom: 5.0, right: 5.0),
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                          'Status :',
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(left: 20.0),
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                            '${(leads_list['status'].toString() == "leads") ? "Leads" : (leads_list['status'].toString() == "order_conform") ? "Order Confirm" : (leads_list['status'].toString() == "leads_follow_up") ? "Leads Follow Up" : (leads_list['status'].toString() == "quotation") ? "Quotation" : (leads_list['status'].toString() == "quotation_follow_up") ? "Quotation Follow Up" : (leads_list['status'].toString() == "leads_rejected") ? "Leads Rejected" : (leads_list['status'].toString() == "quotation_rejected") ? "Quotation Rejected" : "--"}',
                                            style: TextStyle(
                                                color: (leads_list['status']
                                                                .toString() ==
                                                            "leads" ||
                                                        leads_list['status']
                                                                .toString() ==
                                                            "leads_follow_up" ||
                                                        leads_list['status']
                                                                .toString() ==
                                                            "quotation_follow_up" ||
                                                        leads_list['status']
                                                                .toString() ==
                                                            "quotation")
                                                    ? Colors.orange
                                                    : (leads_list['status']
                                                                .toString() ==
                                                            "order_conform")
                                                        ? Colors.green
                                                        : Colors.red,
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold)),
                                      ),
                                    ])),
                          ]))),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                                alignment: Alignment.centerRight,
                                child: FlatButton(
                                  onPressed: () => {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                CusLeadsFragment()))
                                  },
                                  child: Text('CANCEL',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.bold)),
                                  textColor: Colors.white,
                                  color: Colors.red,
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(32.0)),
                                )),
                            Container(
                              padding: EdgeInsets.only(left: 20.0),
                              alignment: Alignment.centerRight,
                              child: RaisedButton(
                                onPressed: () => {
                                  leadsUpdate(),
                                  if (selected_category == "")
                                    {
                                      _showMessageInScaffold(
                                          "please select category"),
                                    }
                                },
                                textColor: Colors.white,
                                color: Colors.green,
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular((32.0))),
                                child: Text(
                                  'UPDATE',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ]),
                      /*  Expanded(child:

            imageSlider(context),flex: 2,),*/

                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      //   children: <Widget>[
                      //     Container(
                      //       height: 65.0,
                      //       width: 60.0,
                      //       decoration: BoxDecoration(
                      //         border: Border.all(
                      //             color: Colors.grey,
                      //             style: BorderStyle.solid,
                      //             width: 1.0),
                      //         borderRadius: BorderRadius.circular(10.0),
                      //       ),
                      //       child: Center(
                      //         child: Icon(Icons.search, color: Colors.black),
                      //       ),
                      //     ),
                      //     Container(
                      //       height: 65.0,
                      //       width: 60.0,
                      //       decoration: BoxDecoration(
                      //         border: Border.all(
                      //             color: Colors.grey,
                      //             style: BorderStyle.solid,
                      //             width: 1.0),
                      //         borderRadius: BorderRadius.circular(10.0),
                      //       ),
                      //       child: Center(
                      //         child: Icon(Icons.shopping_basket,
                      //             color: Colors.black),
                      //       ),
                      //     ),
                      //     Container(
                      //       height: 65.0,
                      //       width: 120.0,
                      //       decoration: BoxDecoration(
                      //           border: Border.all(
                      //               color: Colors.grey,
                      //               style: BorderStyle.solid,
                      //               width: 1.0),
                      //           borderRadius: BorderRadius.circular(10.0),
                      //           color: Color(0xFF1C1428)),
                      //       child: Center(
                      //           child: Text('Checkout',
                      //               style: TextStyle(
                      //                   fontFamily: 'Montserrat',
                      //                   color: Colors.white,
                      //                   fontSize: 15.0))),
                      //     )
                      //   ],
                      // )
                    ],
                  ),
                )),
              ]),
              Container(
                alignment: Alignment.bottomCenter,
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  Container(
                    height: 30,
                    child: TextAds(),
                  ),
                  Container(
                    color: Colors.white,
                    //      alignment:Alignment.bottomCenter,
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
                                                CusLeadsFragment()));
                                  },
                                  icon: Icon(
                                    Icons.perm_phone_msg_outlined,
                                    color: _selectedIndex == 0
                                        ? Color(0xffff7000)
                                        : Color(0xff004080),
                                  )),
                              Text(
                                'Leads',
                                style: TextStyle(
                                  color: _selectedIndex == 0
                                      ? Color(0xffff7000)
                                      : Color(0xff004080),
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
                                  AssetImage('assets/images/paidservice.png'),
                                  // color: Color(0xFF3A5A98),
                                  color: _selectedIndex == 1
                                      ? Color(0xffff7000)
                                      : Color(0xff004080),
                                ),
                              ),
                              Text(
                                'Services',
                                style: TextStyle(
                                  color: _selectedIndex == 1
                                      ? Color(0xffff7000)
                                      : Color(0xff004080),
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
                                                CusHomeFragment()));
                                  },
                                  icon: Icon(
                                    Icons.home_outlined,
                                    color: _selectedIndex == 2
                                        ? Color(0xffff7000)
                                        : Color(0xff004080),
                                  )),
                              Text(
                                'Home',
                                style: TextStyle(
                                  color: _selectedIndex == 2
                                      ? Color(0xffff7000)
                                      : Color(0xff004080),
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
                                                CusProfileFragment()));
                                  },
                                  icon: Icon(
                                    Icons.person_outline,
                                    color: _selectedIndex == 3
                                        ? Color(0xffff7000)
                                        : Color(0xff004080),
                                  )),
                              Text(
                                'Profile',
                                style: TextStyle(
                                  color: _selectedIndex == 3
                                      ? Color(0xffff7000)
                                      : Color(0xff004080),
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
                                  AssetImage('assets/images/youtube_logo.png'),
                                  //  color: Color(0xFF3A5A98),
                                  color: _selectedIndex == 4
                                      ? Color(0xffff7000)
                                      : Color(0xff004080),
                                ),
                              ),
                              Text(
                                'Youtube',
                                style: TextStyle(
                                  color: _selectedIndex == 4
                                      ? Color(0xffff7000)
                                      : Color(0xff004080),
                                ),
                              ),
                            ]),
                            flex: 5),
                      ],
                    ),
                  )
                ]),
              )
            ],
          ),
        ));
  }

  void showWidget() {
    setState(() {
      tickselected = true;
    });
  }

  void hideWidget() {
    setState(() {
      tickselected = false;
    });
  }

  bool tickselected = false;
  Widget EachList(category_list) {
    print(category_list);
    return Container(
      padding: EdgeInsets.only(left: 20.0),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        GestureDetector(
          onTap: () {
            print(selected_category);
            setState(() {
              selected_category = category_list['cat_id'];
            });
          },
          child: Container(
            child: Align(
              alignment: Alignment.topCenter,
              child: Stack(children: <Widget>[
                // CircleAvatar(
                //     radius: 37,
                //     backgroundColor: Colors.transparent,
                //     backgroundImage:
                //         NetworkImage('${category_list['category_image']}')),
                Container(
                  height: 98,
                  width: 85,
                  decoration: (category_list['category_image'] != null)
                      ? BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          image: DecorationImage(
                              image: NetworkImage(
                                  '${category_list['category_image']}'),
                              colorFilter: new ColorFilter.mode(
                                  Colors.black.withOpacity(0.8),
                                  BlendMode.dstATop),
                              fit: BoxFit.fill))
                      : BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          image: DecorationImage(
                              image: AssetImage('assets/images/favicon.png'),
                              colorFilter: new ColorFilter.mode(
                                  Colors.black.withOpacity(0.8),
                                  BlendMode.dstATop),
                              fit: BoxFit.fill)),
                  // child: Image.network(
                  //   '${category_list['category_image']}',
                  //   width: double.infinity,
                  //   height: double.infinity,
                  //   fit: BoxFit.fill,
                  // ),
                ),
                Visibility(
                  maintainSize: false,
                  maintainAnimation: true,
                  maintainState: true,
                  visible: (selected_category == category_list['cat_id'])
                      ? true
                      : false,
                  child: Positioned(
                      right: -1.0,
                      bottom: 0.0,
                      child: Container(
                        alignment: Alignment.bottomRight,
                        //  height: 35,
                        //    width:35,

                        child: Icon(
                          Icons.check_circle,
                          color: Color(0xff004080),
                          size: 20.0,
                        ),
                      )),
                ),
              ]),
            ),
          ),
        ),
        Container(
            width: 75.0,
            padding: EdgeInsets.only(
              top: 5.0,
            ),
            child: Text('${category_list['categoryName']}',
                maxLines: 1, textAlign: TextAlign.center)),
      ]),
    );
  }

  Widget Tickmarker() {
    return Positioned(
        right: -1.0,
        bottom: 0.0,
        child: Container(
          alignment: Alignment.bottomRight,
          //  height: 35,
          //    width:35,

          child: Icon(
            Icons.check_circle,
            color: Color(0xff004080),
            size: 20.0,
          ),
        ));
  }
}
