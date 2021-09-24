// ignore: file_names
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:service_app/Utils/Constants.dart';
import 'package:service_app/Utils/storageUtil.dart';
import 'package:service_app/components/Textads.dart';
import 'package:service_app/components/adsimages.dart';
import 'package:service_app/screens/EmpEditServiceScreen.dart';
import 'package:http/http.dart' as http;
import 'package:service_app/screens/EmpProfileFragment.dart';
import 'package:service_app/screens/EmpServiceFragment.dart';
import 'package:service_app/screens/EmphomeFragment.dart';
import 'package:service_app/screens/LoginScreen.dart';


class EmpTodaytaskFragment extends StatefulWidget {
  @override
  _EmpTodaytaskFragmentState createState() => _EmpTodaytaskFragmentState();
}

class _EmpTodaytaskFragmentState extends State<EmpTodaytaskFragment> {
  int _selectedIndex = 0;
  List service_list = [];
  var id = '', customer_id = '', status = '', inv_no = '',attendant='',created_date='',work_performed='',description='',img_path=' ';
  TextEditingController fromController = TextEditingController();
  TextEditingController toController = TextEditingController();
  TextEditingController searchController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool date1 = true;
  bool date2 = true;
  bool search = true;
  bool refresh = true;
  FocusNode myFocusNode1 = new FocusNode();
  FocusNode myFocusNode2 = new FocusNode();
  FocusNode myFocusNode3 = new FocusNode();
  FocusNode myFocusNode4 = new FocusNode();
  FocusNode myFocusNode5 = new FocusNode();
  void showWidget(){
    setState(() {
      date1 = true;
      date2 = true;
      search = false;
    });
  }
  void hideWidget(){
    setState(() {
      date1 = false;
      date2 = false;
      search = true;

    });
  }
  void showall(){
    setState(() {
      date1 = true;
      date2 = true;
      search = true;
    });
  }
var notfound='';
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

    var data = json.encode({"emp_id":mobile_test6, "service_type":"employee","from_date":fromController.text,"to_date":toController.text});
    final response = await http.post(BASE_URL + 'get_service_list', headers: {'authorization': basicAuth}, body: data);
    print(data);
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      print(jsonResponse);
      if(jsonResponse['status'] == "success"){
        setState(() {
          service_list = jsonResponse['data'];

          print(service_list);
        });
      }else if(jsonResponse['status'] == "false"){
        setState(() {
          service_list =jsonResponse['message'] ;
        });
      }
      //   sharedPreferences.setString("token", jsonResponse['token']);
    }else {

    }
  }


/*  todaytask() async {
    var data = json.encode({"emp_id":"11", "service_type":"employee","warranty_from": "req_from_date","warranty_to":"req_to_date" });
    final response = await http.post(BASE_URL + 'get_service_list', headers: {'authorization': basicAuth}, body: data);
    print(data);
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      print(jsonResponse);
      if(jsonResponse['status'] == "success"){
        var i = 0;
        var currentDate = DateFormat('dd/MM/yyyy').format(DateTime.now());
        print(currentDate);

        setState(() {
          for (i; i < jsonResponse['data'].length; i++) {
            var datestr = jsonResponse['data'][i]['created_date'];
            print(datestr);
            if (datestr == currentDate) {

              service_list.add(jsonResponse['data'][i]) ;

              print(service_list);
            }
          }
        });
      }else if(jsonResponse['status'] == 'Error'){
        Navigator.pop(context);

      }
      //   sharedPreferences.setString("token", jsonResponse['token']);
    }else {
      Navigator.pop(context);

    }
  }*/

  DateTime selectedDate = DateTime.now();
  DateFormat dateFormat = DateFormat("yyyy-MM-dd");
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1900),
        lastDate: DateTime.now(),);
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        fromController.text = selectedDate.toString().substring(0, 10);
        print(selectedDate);
        customer();
      //  toController.text = selectedDate.toString().substring(0, 10);
       // searchController.text = selectedDate.toString().substring(0, 10);
      });
  }
  DateTime selectedDate1 = DateTime.now();
  DateFormat dateFormat1 = DateFormat("yyyy-MM-dd");
  Future<void> _selectDate1(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate1,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),);
    if (picked != null && picked != selectedDate1)
      setState(() {
        selectedDate1 = picked;
        print(selectedDate1);
          toController.text = selectedDate1.toString().substring(0, 10);
        customer();
        // searchController.text = selectedDate.toString().substring(0, 10);
      });
  }

  DateTime selectedDate2 = DateTime.now();
  DateFormat dateFormat2 = DateFormat("yyyy-MM-dd");
  Future<void> _selectDate2(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate2,
      firstDate: DateTime(1900),
      lastDate:DateTime.now(),);
    if (picked != null && picked != selectedDate2)
      setState(() {
        selectedDate2 = picked;
        print(selectedDate2);
        searchController.text = selectedDate2.toString().substring(0, 10);
        fromController.text =searchController.text;
        toController.text =searchController.text;
        customer();
        // searchController.text = selectedDate.toString().substring(0, 10);
      });
  }

  var currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
  customerlogout() async {
    await getTextFromFile();
    var data = json.encode({"user_id": mobile_test6, "user_type": "2"});
    final response = await http.post(BASE_URL + 'customer_log_out', headers: {'authorization': basicAuth}, body: data);
    print(data);
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      print(jsonResponse);
      if(jsonResponse['status'] == "true"){
        StorageUtil.remove('login_customer_id');
        await Future.delayed(Duration(seconds: 1));
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => LoginScreen()), (Route<dynamic> route) => false);
      }else if(jsonResponse['status'] == 'Error'){
        Navigator.pop(context);
        // _showMessageInScaffold(jsonResponse['message']);
      }
      //   sharedPreferences.setString("token", jsonResponse['token']);
    }else {
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
              child: Text('No',style: TextStyle(color:Color(0xff004080)),),
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss the Dialog
              },
            ),
            FlatButton(
              child: Text('Yes',style: TextStyle(color:Color(0xff004080)),),
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
    setState(() {
      fromController.text=currentDate;
      toController.text=currentDate;
      customer();
    });
   // customer();
  }


  @override
  Widget build(BuildContext context) {
    return  WillPopScope(
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
    child:  Scaffold(
      appBar: AppBar(
        leadingWidth: 110,
        centerTitle: true,
        backgroundColor: new Color(0xff004080),
        leading: Image.asset('assets/images/service_logo.png',
        ),
        title: Text('Today Task'),
        automaticallyImplyLeading: false,
        actions: <Widget>[
          IconButton(icon: Icon(Icons.power_settings_new_rounded, color: Colors.white,), onPressed: () {_showMyDialog();}),
        ],
        //   centerTitle: true,
        //  automaticallyImplyLeading: false,
      ),
      body: Center(
            child: Container(
                child: Column(
                  children: <Widget>[
                    Container(
                      height: 90,
                      width: MediaQuery.of(context).size.width,
                      child:AdsImages(),
                    ),

                    Container(
                      //   height: 65,
                        padding: EdgeInsets.fromLTRB(5, 8, 5, 0),
                        child: new Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Expanded(
                              //   alignment: Alignment.center,
                              //   padding: EdgeInsets.only(top: 5.0),
                                child: new Row(
                                  mainAxisSize: MainAxisSize.min,
                                //    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Flexible(
                                        child:     Text('TASK LIST',
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: Colors.black,
                                          ),
                                        ),flex:2,),
                Flexible(
                    child: Padding(
                      padding: EdgeInsets.only(right: 5.0,left: 5.0),
                      child:      Visibility(
                        maintainSize: false,
                        maintainAnimation: true,
                        maintainState: true,
                        visible: date1,
                        child: TextFormField(
                            readOnly: true,
                            showCursor: false,
                            cursorColor: Colors.transparent,
                              controller: fromController,
                            onTap: () => {
                             // showWidget(),
                              showall(),
                                _selectDate(context),
                            },
                            decoration: InputDecoration(
                                 isDense: true,
                              contentPadding: EdgeInsets.fromLTRB(5, 15, 5, 0),                             /*   prefixIcon: Icon(Icons.date_range,
                                color: Color(0xff004080), size: 20),*/
                      hintStyle:
                      TextStyle(color:Color(0xff747474),fontSize: 15.0),
                      filled: true,
                      fillColor: Colors.white,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                            Radius.circular(32.0)),
                        borderSide: BorderSide(
                            color: Color(0xff004080),
                            width: 0.8),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                            Radius.circular(32.0)),
                        borderSide: BorderSide(
                            color: Color(0xff004080),
                            width: 0.8),
                      ),
                    ))),
      ),   flex: 6,
    ),
                                      Flexible(

                                        child: Padding(
                                            padding: EdgeInsets.only(right: 5.0,left: 5.0),
                                            child:   Visibility(
                                                maintainSize: false,
                                                maintainAnimation: true,
                                                maintainState: true,
                                                visible: date2,

                                                child: TextFormField(
                                                    readOnly: true,
                                                    showCursor: false,
                                                    cursorColor: Colors.transparent,
                                                      controller: toController,
                                                    onTap: () => {
                                                         _selectDate1(context),
                                                     // showWidget(),
                                                      showall(),
                                                    },
                                                    decoration: InputDecoration(
                                                      isDense: true,
                                                      contentPadding: EdgeInsets.fromLTRB(5, 15, 5, 0),                                                    /*  prefixIcon: Icon(Icons.date_range,
                                                          color: Color(0xff004080), size: 20),*/
                                                      hintStyle:
                                                      TextStyle(color:Color(0xff747474),fontSize: 15.0),
                                                      filled: true,
                                                      fillColor: Colors.white,
                                                      enabledBorder: OutlineInputBorder(
                                                        borderRadius: BorderRadius.all(
                                                            Radius.circular(32.0)),
                                                        borderSide: BorderSide(
                                                            color: Color(0xff004080),
                                                            width: 0.8),
                                                      ),
                                                      focusedBorder: OutlineInputBorder(
                                                        borderRadius: BorderRadius.all(
                                                            Radius.circular(32.0)),
                                                        borderSide: BorderSide(
                                                            color: Color(0xff004080),
                                                            width: 0.8),
                                                      ),
                                                    )  ))),
                                        flex: 6,
                                      ),
                                      Flexible(
                                        child: Padding(
                                            padding: EdgeInsets.only(right:5.0),
                                            child:    Visibility(
                                                maintainSize: false,
                                                maintainAnimation: true,
                                                maintainState: true,
                                                visible: search,

                                                child: TextFormField(
                                                    readOnly: true,
                                                    showCursor: false,
                                                    cursorColor: Colors.transparent,
                                                      controller: searchController,
                                                    onTap: () => {
                                                   //   hideWidget(),
                                                      showall(),
                                                         _selectDate2(context),
                                                    },
                                                    decoration: InputDecoration(
                                                      isDense: true,
                                                       contentPadding: EdgeInsets.fromLTRB(10, 15, 10, 0),
                                                   /*   prefixIcon: Icon(Icons.search,
                                                          color: Color(0xff004080), size: 20),*/
                                                      hintText: 'Search',
                                                      hintStyle:
                                                      TextStyle(color:Color(0xff747474),fontSize: 15.0),
                                                      filled: true,
                                                      fillColor: Colors.white,
                                                      enabledBorder: OutlineInputBorder(
                                                        borderRadius: BorderRadius.all(
                                                            Radius.circular(32.0)),
                                                        borderSide: BorderSide(
                                                            color: Color(0xff004080),
                                                            width: 0.8),
                                                      ),
                                                      focusedBorder: OutlineInputBorder(
                                                        borderRadius: BorderRadius.all(
                                                            Radius.circular(32.0)),
                                                        borderSide: BorderSide(
                                                            color: Color(0xff004080),
                                                            width: 0.8),
                                                      ),
                                                    )  ))),
                                        flex: 6,
                                      ),
                                      Flexible(
                                        child:
                                        GestureDetector(
                                          onTap: () {
                                            searchController.text = "";
                                            fromController.text =currentDate;
                                            toController.text =currentDate;
                                            customer();
                                            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => EmpTodaytaskFragment()));
                                           // showall();
                                          },

                                          child: Icon(
                                            Icons.refresh_outlined,
                                            color: Colors.black54,// add custom icons also
                                          ),
                                        ) ,flex: 1,),
                                    ])),
                          ],
                        )),
                    Expanded(
                        child:(service_list.length > 0)? ListView.builder(
                          itemCount:service_list.length,
                          itemBuilder: (context, index) =>
                              EachList(service_list[index]),
                        ):Center(child: Text('Service List Not Found')
                        ),flex:4
                    ),
                    Container(
                      height: 30,
                      child:TextAds(),
                    ),
                    Container(
                      alignment:Alignment.bottomCenter,
                      width: double.infinity,
                      child: Row(
                        children: [
                          Expanded(
                              child:Column(
                                  children: [
                                    IconButton(onPressed: (){
                                      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => EmpServiceFragment()));
                                    }, icon: Icon(Icons.home_repair_service_outlined,   color:  Color(0xff004080),)),
                                    Text('Services',   style: TextStyle(
                                      color:Color(0xff004080),

                                    ),),]),
                              flex:5),
                          Expanded(
                              child:Column(
                                  children: [
                                    IconButton(onPressed: (){
                                      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => EmpTodaytaskFragment()));
                                    }, icon: Icon(Icons.sticky_note_2_outlined,        color:Color(0xffff7000),)),
                                    Text('Today Task',   style: TextStyle(
                                      color:Color(0xffff7000),

                                    ),),]),
                              flex:5),
                          Expanded(
                              child:Column(
                                  children: [
                                    IconButton(onPressed: (){
                                      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => EmphomeFragment()));
                                    }, icon: Icon(Icons.home_outlined,    color:Color(0xff004080),)),
                                    Text('Home',   style: TextStyle(
                                      color:Color(0xff004080),

                                    ),),]),
                              flex:5),
                          Expanded(
                              child:Column(
                                  children: [
                                    IconButton(onPressed: (){
                                      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => EmpProfileFragment()));
                                    }, icon: Icon(Icons.person_outline,    color:Color(0xff004080),)),
                                    Text('Profile',   style: TextStyle(
                                      color:Color(0xff004080),

                                    ),),]),
                              flex:5),

                        ],
                      ),
                    )

                  ],
                ),),

        ),));
  }
  Widget EachList(service_list) {
    return GestureDetector(
        onTap: (){
          setState(() {
            id = service_list ['id'];
          });
          Navigator.of(context).push(
              MaterialPageRoute(
                  builder: (BuildContext context) =>EmpEditServiceScreen(service_list)
              )
          );
        },
        child: Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
            color: Colors.white,
            child: Column(
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
                            /*Container(
                              alignment: Alignment.topLeft,
                              decoration: new BoxDecoration(
                                color: Colors.redAccent,


                                *//* borderRadius: new BorderRadius.only(
                                topLeft: const Radius.circular(3),
                                bottomLeft: const Radius.circular(5)
                            )*//* ),
                              width: 5,
                              height: 80,

                            ),*/
                            Flexible(
                              child:Container(

                                  padding:EdgeInsets.only(left: 10),
                                  alignment: Alignment.topLeft,
                                  child:   CircleAvatar(radius: 37,backgroundImage:AssetImage("assets/images/favicon.png"),backgroundColor: Colors.white,
                                  )
                              ),

                              flex: 3,),
                            Flexible(
                                child:Container(
                                  alignment: Alignment.center,
                                  child: new Column(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                      MainAxisAlignment.start,
                                      children: <Widget>[
                                        Container(
                                            padding: EdgeInsets.all(4.0),
                                            child: new Row(
                                                children: <Widget>[
                                                  Text('Current Status:', style: TextStyle(fontSize: 10,
                                                    color: Colors.black54,
                                                  )  ),
                                                  Container(
                                                      padding: EdgeInsets.all(2.0),
                                                      alignment: Alignment.topLeft,
                                                      child:  Text(
                                                        '${(service_list['status'].toString()== "0")?"In-Progress":(service_list['status'].toString() == "1")?"Complete":"Pending"}',
                                                        textAlign: TextAlign.start,
                                                        style: TextStyle(fontSize: 10,fontWeight: FontWeight.bold,
                                                          color: (service_list['status'].toString()== "0")? Colors.deepOrangeAccent:(service_list['status'].toString() == "1")?Colors.green:Colors.red,
                                                        ),
                                                      )  )
                                                ] ) ),

                                        /* Container(
                                        padding: EdgeInsets.all(5.0),
                                        alignment: Alignment.topLeft,
                                        child:  Text('Current Status:', style: TextStyle(fontSize: 12,
                                          color: Colors.black54,
                                        ))),
                                          Container(
                                              padding: EdgeInsets.all(5.0),
                                              alignment: Alignment.topLeft,
                                              child:  Text(
                                          '${(service_list['status'].toString()== "0")?"In-Progress":(service_list['status'].toString() == "1")?"Complete":"Pending"}',
                                          textAlign: TextAlign.start,
                                          style: TextStyle(fontSize: 10,
                                            color: (service_list['status'].toString()== "0")? Colors.deepOrangeAccent:(service_list['status'].toString() == "1")?Colors.green:Colors.red,
                                          ),
                                              )  ) ,*/
                                        Container(
                                            padding: EdgeInsets.all(5.0),
                                            alignment: Alignment.bottomLeft,
                                            child:  Text(
                                              '${service_list['description']}',
                                              maxLines: 1,
                                              textAlign: TextAlign.start,
                                              style: TextStyle(fontSize: 12,
                                                color: Colors.black54,
                                              ),
                                            ) ),
                                        Container(
                                            padding: EdgeInsets.all(5.0),
                                            alignment: Alignment.bottomLeft,
                                            child:  Text(
                                              '${service_list['ticket_no']??"--"}',
                                              maxLines: 1,
                                              textAlign: TextAlign.start,
                                              style: TextStyle(fontSize: 10,
                                                color: Colors.black,
                                              ),
                                            ) ),

                                      ]),),
                                flex: 5),
                            Flexible(
                                child:Container(
                                  alignment: Alignment.center,
                                  child: new Column(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                      MainAxisAlignment.start,
                                      children: <Widget>[

                                        Container(
                                            padding: EdgeInsets.all(5.0),

                                            alignment: Alignment.topRight,
                                            child:  Text(
                                              '${service_list['created_date']}',
                                              textAlign: TextAlign.start,
                                              style: TextStyle(
                                                color: Colors.black54,
                                              ),
                                            ) ),
                                        Container(
                                            padding: EdgeInsets.all(5.0),
                                            alignment: Alignment.bottomRight,
                                            child:  Text(
                                              ' ',
                                              textAlign: TextAlign.start,
                                              style: TextStyle(
                                                color: Colors.black54,
                                              ),
                                            ) ),
                                        Container(
                                            padding: EdgeInsets.all(5.0),

                                            alignment: Alignment.topLeft,
                                            child:  Text(
                                              ' ',
                                              textAlign: TextAlign.start,
                                              style: TextStyle(
                                                color: Colors.black54,
                                              ),
                                            ) ),

                                      ]),),
                                flex: 4),

                          ])),
                ])));
  }
}
