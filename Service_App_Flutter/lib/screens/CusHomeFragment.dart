// ignore: file_names
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:marquee/marquee.dart';
import 'package:service_app/Utils/Constants.dart';
import 'package:service_app/Utils/storageUtil.dart';
import 'package:service_app/components/Textads.dart';
import 'package:service_app/components/adsimages.dart';
import 'package:http/http.dart' as http;
import 'package:service_app/screens/CusLeadsFragment.dart';
import 'package:service_app/screens/CusProfileFragment.dart';
import 'package:service_app/screens/CusServiceFragment.dart';
import 'package:service_app/screens/CusYoutubeFragment.dart';
import 'package:service_app/screens/LoginScreen.dart';
import 'globals.dart' as globals;
void main() {
  globals.isLoggedIn = true;
}
class CusHomeFragment extends StatefulWidget {
  @override
  _CusHomeFragmentState createState() => _CusHomeFragmentState();
}

class _CusHomeFragmentState extends State<CusHomeFragment> with AutomaticKeepAliveClientMixin {

  List pending_leads_list = [];
  int _selectedIndex = 0;
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
      String data = await StorageUtil.getItem("login_customer_id");
      setState(() {
        mobile_test6 = data;
      });
    } catch (ex) {
      print(ex);
    }
  }

  leadspending() async {
    await getTextFromFile();
    var data = json.encode({"customer_id":mobile_test6});
    final response = await http.post(
        BASE_URL + 'pending_leads', headers: {'authorization': basicAuth},
        body: data);
    print(data);
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      print(jsonResponse);
      if (jsonResponse['status'] == "success") {
        setState(() {
          pending_leads_list = jsonResponse['data'];
          print(pending_leads_list);
        });
      } else if (jsonResponse['status'] == 'Error') {
        Navigator.pop(context);
      }
    } else {
      Navigator.pop(context);
    }
  }

  List pending_service_list = [];

  servicepending() async {
    await getTextFromFile();
    var data = json.encode({"customer_id": mobile_test6, "service_type": "customer"});
    final response = await http.post(BASE_URL + 'get_pending_service_list',
        headers: {'authorization': basicAuth}, body: data);
    print(data);
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      print(jsonResponse);
      if (jsonResponse['status'] == "success") {
        setState(() {
          pending_service_list = jsonResponse['data'];
          print(pending_service_list);
        });
      } else if (jsonResponse['status'] == 'Error') {
        Navigator.pop(context);
      }
    } else {
      Navigator.pop(context);
    }
  }
  customerlogout() async {
    var data = json.encode({"user_id": 'customer_id', "user_type": "2"});
    final response = await http.post(
        BASE_URL + 'customer_log_out', headers: {'authorization': basicAuth},
        body: data);
    print(data);
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      print(jsonResponse);
      if (jsonResponse['status'] == "true") {
        StorageUtil.remove('login_customer_id');
        await Future.delayed(Duration(seconds: 1));
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(
            builder: (BuildContext context) => LoginScreen()), (
            Route<dynamic> route) => false);
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
              child: Text('No', style: TextStyle(color: Color(0xff004080)),),
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss the Dialog
              },
            ),
            FlatButton(
              child: Text('Yes', style: TextStyle(color: Color(0xff004080)),),
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
    leadspending();
    servicepending();
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
                SystemNavigator.pop();              },
              child: Text('Yes')),
          TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('No'))
        ],
      ));
    return willLeave;
    },
    child:Scaffold(
        appBar: AppBar(
          leadingWidth: 110,
          centerTitle: true,
          backgroundColor: new Color(0xff004080),
          leading: Image.asset('assets/images/service_logo.png'),
          title: Text('Home'),
          automaticallyImplyLeading: false,
          actions: <Widget>[
            IconButton(icon: Icon(Icons.power_settings_new_rounded, color: Colors.white,), onPressed: () {_showMyDialog();}),
          ],
        ),
        resizeToAvoidBottomInset: false,
        body: new Column(
            children: <Widget>[
              Container(
                child: Row(
                  children: [
                    Expanded(
                      child:Column(
                  children:[
                             GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(
                                      MaterialPageRoute(builder: (
                                          BuildContext context) =>
                                          CusLeadsFragment()));
                                },
                                child: Image.asset("assets/images/leads.png")

                            )]), flex: 2),
                    Expanded(
                        child:Column(
                            children:[
                              GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(builder: (
                                            BuildContext context) =>
                                            CusServiceFragment()));
                                  },
                                  child: Image.asset("assets/images/service_text.png")

                              )]), flex: 2),
              /*      Expanded(
                        child: Container(
                            child: GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(
                                      MaterialPageRoute(builder: (
                                          BuildContext context) =>
                                          CusServiceFragment()));
                                },

                                child: Image.asset(
                                    "assets/images/service_text.png"))),
                        flex: 2)*/
                  ],
                ),
              ),
              Container(
                height: 80,
                width: MediaQuery
                    .of(context)
                    .size
                    .width,
                child: AdsImages(),
              ),
              Expanded(
                  child: Column(
                      children: <Widget>[
                        //alignment: Alignment.topLeft,
                        Container(
                            alignment: Alignment.topLeft,
                            child: Text('Leads', style: TextStyle(
                                color: Color(0xff004080),
                                fontSize: 20,
                                fontWeight: FontWeight.bold))),
                        Expanded(
                          child: (pending_leads_list.length > 0) ? ListView
                              .builder(
                            itemCount: pending_leads_list.length,
                            itemBuilder: (context, index) =>
                                LeadsList(pending_leads_list[index]),
                          ) : Center(
                            child: Image.asset('assets/images/loader.gif'),),

                        ),


                      ]),
                  flex: 2),
              Expanded(
                  child: Container(
                      child: Column(
                          children: <Widget>[
                            //alignment: Alignment.topLeft,
                            Container(
                                alignment: Alignment.topLeft,
                                child: Text('Services', style: TextStyle(
                                    color: Color(0xff004080),
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold))),
                            Expanded(
                              child: (pending_service_list.length > 0)
                                  ? ListView.builder(
                                reverse: false,
                                itemCount: pending_service_list.length,
                                itemBuilder: (context, index) =>
                                    ServiceList(pending_service_list[index]),
                              )
                                  : Center(),

                            ),

                          ])),
                  flex: 2),
Container(
    child:Column(
    children:[
              Container(
                height: 30,
                child: TextAds(),
              ),
              Container(
                color:Colors.white,
                alignment:Alignment.bottomCenter,
                width: double.infinity,
                child: Row(
                  children: [
                    Expanded(
                        child:Column(
                            children: [
                              IconButton(onPressed: (){
                                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => CusLeadsFragment()));
                              }, icon: Icon(Icons.perm_phone_msg_outlined,                                 color: Color(0xff004080),
                              )),
                              Text('Leads',   style: TextStyle(
                                color: Color(0xff004080),
                              ),),]),
                        flex:5),
                    Expanded(
                        child:Column(
                            children: [
                              IconButton(onPressed: (){
                                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => CusServiceFragment()));
                              }, icon: ImageIcon(
                                AssetImage('assets/images/paidservice.png'),
                                // color: Color(0xFF3A5A98),
                                color: Color(0xff004080),
                              ),),
                              Text('Services',   style: TextStyle(
                                color: Color(0xff004080),

                              ),),]),
                        flex:5),
                    Expanded(
                        child:Column(
                            children: [
                              IconButton(onPressed: (){
                                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => CusHomeFragment()));
                              }, icon: Icon(Icons.home_outlined, color: Color(0xffff7000))),
                              Text('Home',   style: TextStyle(
                                color:  Color(0xffff7000)

                              ),),]),
                        flex:5),
                    Expanded(
                        child:Column(
                            children: [
                              IconButton(onPressed: (){
                                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => CusProfileFragment()));
                              }, icon: Icon(Icons.person_outline,                                 color: Color(0xff004080),
                              )),
                              Text('Profile',   style: TextStyle(
                                color: Color(0xff004080),
                              ),),]),
                        flex:5),
                    Expanded(
                        child:Column(
                            children: [
                              IconButton(onPressed: (){
                                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => CusYoutubeFragment()));
                              }, icon: ImageIcon(
                                AssetImage('assets/images/youtube_logo.png'),
                                //  color: Color(0xFF3A5A98),
                                color: Color(0xff004080),
                              ),),
                              Text('Youtube',   style: TextStyle(
                                color: Color(0xff004080),

                              ),),]),
                        flex:5),

                  ],
                ),
              )
            ]))])));
  }

  Widget ServiceList(pending_service_list) {
    return Card(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
        color: Colors.white,
        child: new Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment:
            MainAxisAlignment.start,
            children: [
              Container(
                //padding: EdgeInsets.only(left: 10),
                  child: new Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment:
                      MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          alignment: Alignment.topLeft,
                          decoration: new BoxDecoration(
                            color: (pending_service_list['status'].toString() ==
                                "0")
                                ? Colors.orange
                                : (pending_service_list['status'].toString() ==
                                "1") ? Colors.green : Colors.red,

                          ),
                          width: 3,
                          height: 30,

                        ),

                        Flexible(
                            child: Container(
                              alignment: Alignment.center,
                              child: new Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                  MainAxisAlignment.start,
                                  children: <Widget>[

                                    Flexible(
                                        child: Container(
                                            padding: EdgeInsets.only(left: 5.0),
                                            alignment: Alignment.topLeft,
                                            child: Text(
                                                '${pending_service_list['description']}')),
                                        flex: 3),
                                    Flexible(
                                        child: Container(
                                            padding: EdgeInsets.only(
                                                right: 5.0),
                                            alignment: Alignment.topRight,
                                            child: Text(convertDateTimeDisplay(
                                                '${pending_service_list['created_date']}'))),
                                        flex: 3),
                                  ]),),
                            flex: 3),

                      ])),
            ]));
  }

  Widget LeadsList(pending_leads_list1) {
    return Card(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
        color: Colors.white,
        child: new Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment:
            MainAxisAlignment.start,
            children: [
              Container(
                //padding: EdgeInsets.only(left: 10),
                  child: new Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment:
                      MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          alignment: Alignment.topLeft,
                          decoration: new BoxDecoration(
                            color: (pending_leads_list1['status'].toString() ==
                                "leads" ||
                                pending_leads_list1['status'].toString() ==
                                    "leads_follow_up" ||
                                pending_leads_list1['status'].toString() ==
                                    "quotation_follow_up" ||
                                pending_leads_list1['status'].toString() ==
                                    "quotation")
                                ? Colors.orange
                                : (pending_leads_list1['status'].toString() ==
                                "order_conform") ? Colors.green : Colors.red,

                          ),
                          width: 3,
                          height: 30,

                        ),

                        Flexible(
                            child: Container(
                              alignment: Alignment.center,
                              child: new Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                  MainAxisAlignment.start,
                                  children: <Widget>[
                                    Flexible(
                                        child: Container(
                                            padding: EdgeInsets.only(left: 5.0),
                                            alignment: Alignment.topLeft,
                                            child: Text(
                                                '${pending_leads_list1['enquiry_no']}')),
                                        flex: 3),
                                    Flexible(
                                        child: Container(
                                            alignment: Alignment.center,
                                            child: Text(
                                              '${pending_leads_list1['enquiry_about']}',
                                              maxLines: 1,)), flex: 3),
                                    Flexible(
                                        child: Container(
                                            padding: EdgeInsets.only(
                                                right: 5.0),
                                            alignment: Alignment.topRight,
                                            child: Text(convertDateTimeDisplay(
                                                '${pending_leads_list1['created_date']}'))),
                                        flex: 3),
                                  ]),),
                            flex: 3),
                      ])),
            ]));
  }

  @override
  bool get wantKeepAlive => true;
}