import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:marquee/marquee.dart';
import 'package:service_app/Utils/Constants.dart';
import 'package:service_app/Utils/storageUtil.dart';
import 'package:service_app/components/Textads.dart';
import 'package:service_app/components/adsimages.dart';
import 'package:http/http.dart' as http;
import 'package:service_app/screens/CusHomeFragment.dart';
import 'package:service_app/screens/CusLeadsFragment.dart';
import 'package:service_app/screens/CusServiceFragment.dart';
import 'package:service_app/screens/CusYoutubeFragment.dart';
import 'package:service_app/screens/EmpEditServiceScreen.dart';
import 'package:service_app/screens/EmpProfileFragment.dart';
import 'package:service_app/screens/EmpServiceFragment.dart';
import 'package:service_app/screens/EmpTodaytaskFragment.dart';
import 'package:service_app/screens/EmphomeFragment.dart';
import 'package:service_app/screens/EmployeProfile.dart';
import 'package:service_app/screens/EmployeeEditService.dart';
import 'package:service_app/screens/LoginScreen.dart';
import 'package:flutter_string_encryption/flutter_string_encryption.dart';
import 'package:encrypt/encrypt.dart';
import 'package:crypto/crypto.dart';
import 'package:service_app/screens/mobilelogin.dart';

class TodayTask extends StatefulWidget {
  @override
  _TodayTaskState createState() => _TodayTaskState();
}

class _TodayTaskState extends State<TodayTask> {
  int _selectedIndex = 0;
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
  void showWidget() {
    setState(() {
      date1 = true;
      date2 = true;
      search = false;
    });
  }

  void hideWidget() {
    setState(() {
      date1 = false;
      date2 = false;
      search = true;
    });
  }

  void showall() {
    setState(() {
      date1 = true;
      date2 = true;
      search = true;
    });
  }

  var notfound = '';
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

  TodayService() async {
    await getTextFromFile();

    var data = json.encode({
      "emp_id": mobile_test6,
      "service_type": "employee",
      "from_date": currentDate,
      "to_date": currentDate
    });
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
      } else if (jsonResponse['status'] == "false") {
        setState(() {
          service_list = jsonResponse['message'];
        });
      }
      //   sharedPreferences.setString("token", jsonResponse['token']);
    } else {}
  }

  List search_list = [];
  SearchService() async {
    await getTextFromFile();

    var data = json.encode({
      "emp_id": mobile_test6,
      "service_type": "employee",
      "from_date": searchController.text,
      "to_date": searchController.text
    });
    final response = await http.post(BASE_URL + 'get_service_list',
        headers: {'authorization': basicAuth}, body: data);
    print(data);
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      print(jsonResponse);
      if (jsonResponse['status'] == "success") {
        setState(() {
          search_list = jsonResponse['data'];
          print(search_list);
        });
      } else if (jsonResponse['status'] == "false") {
        setState(() {
          search_list = jsonResponse['message'];
        });
      }
      //   sharedPreferences.setString("token", jsonResponse['token']);
    } else {}
  }

  List pending_leads_list = [];
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

  @override
  void initState() {
    super.initState();
    getTextFromFile();
    TodayService();
    empservice();
    // SearchService();
  }

  // DateTime selectedDate = DateTime.now();
  // DateFormat dateFormat = DateFormat("yyyy-MM-dd");
  // Future<void> _selectDate(BuildContext context) async {
  //   final DateTime? picked = await showDatePicker(
  //     context: context,
  //     initialDate: selectedDate,
  //     firstDate: DateTime(1900),
  //     lastDate: DateTime.now(),
  //   );
  //   if (picked != null && picked != selectedDate)
  //     setState(() {
  //       selectedDate = picked;
  //       fromController.text = selectedDate.toString().substring(0, 10);
  //       print(selectedDate);
  //       TodayService();
  //       //  toController.text = selectedDate.toString().substring(0, 10);
  //       // searchController.text = selectedDate.toString().substring(0, 10);
  //     });
  // }
  //
  // DateTime selectedDate1 = DateTime.now();
  // DateFormat dateFormat1 = DateFormat("yyyy-MM-dd");
  // Future<void> _selectDate1(BuildContext context) async {
  //   final DateTime? picked = await showDatePicker(
  //     context: context,
  //     initialDate: selectedDate1,
  //     firstDate: DateTime(1900),
  //     lastDate: DateTime.now(),
  //   );
  //   if (picked != null && picked != selectedDate1)
  //     setState(() {
  //       selectedDate1 = picked;
  //       print(selectedDate1);
  //       toController.text = selectedDate1.toString().substring(0, 10);
  //       TodayService();
  //       // searchController.text = selectedDate.toString().substring(0, 10);
  //     });
  // }

  DateTime selectedDate2 = DateTime.now();
  DateFormat dateFormat2 = DateFormat("yyyy-MM-dd");
  Future<void> _selectDate2(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate2,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != selectedDate2)
      setState(() {
        selectedDate2 = picked;
        print(selectedDate2);
        searchController.text = selectedDate2.toString().substring(0, 10);
        // fromController.text = searchController.text;
        // toController.text = searchController.text;
        SearchService();
        // searchController.text = selectedDate.toString().substring(0, 10);
      });
  }

  var currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
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
        child: DefaultTabController(
            length: 3,
            child: Scaffold(
              appBar: AppBar(
                backgroundColor: Color(0xffff7000),
                title: Text(
                  'Today Task',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                automaticallyImplyLeading: false,
                actions: <Widget>[
                  IconButton(
                      icon: Icon(
                        Icons.power_settings_new_rounded,
                        color: Colors.white,
                      ),
                      onPressed: () {}),
                ],
                elevation: 0,
                bottom: TabBar(
                    unselectedLabelColor: Colors.white,
                    labelColor: Color(0xff004080),
                    indicatorSize: TabBarIndicatorSize.tab,
                    indicatorColor: Color(0xff004080),
                    // indicator: BoxDecoration(
                    //     gradient: LinearGradient(
                    //         colors: [Color(0xff004080), Colors.orangeAccent]),
                    //     borderRadius: BorderRadius.circular(50),
                    //     color: Colors.orangeAccent),
                    tabs: [
                      Tab(
                        child: Align(
                            alignment: Alignment.center,
                            child: Column(children: [
                              Icon(Icons.task_rounded),
                              SizedBox(
                                height: 8.0,
                              ),
                              Text(
                                "Today Task",
                                style: TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.bold),
                                maxLines: 1,
                              ),
                            ])),
                      ),
                      Tab(
                        child: Align(
                            alignment: Alignment.center,
                            child: Column(children: [
                              Icon(Icons.pending_actions),
                              SizedBox(
                                height: 8.0,
                              ),
                              Text(
                                "Pending Task",
                                maxLines: 1,
                                style: TextStyle(
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.bold),
                              ),
                            ])),
                      ),
                      Tab(
                        child: Align(
                            alignment: Alignment.center,
                            child: Column(children: [
                              Icon(Icons.search),
                              SizedBox(
                                height: 8.0,
                              ),
                              Text(
                                "Search Task",
                                maxLines: 1,
                                style: TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.bold),
                              ),
                            ])),
                      ),
                    ]),
              ),
              body: TabBarView(children: [
                TodayTask(),
                PendingTask(),
                SearchTask(),
              ]),
            )));
  }

  Widget TodayTask() {
    return Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            color: Colors.white,
            image: DecorationImage(
                image: AssetImage('assets/images/bolt7.jpg'),
                colorFilter: new ColorFilter.mode(
                    Colors.black.withOpacity(0.1), BlendMode.dstATop),
                fit: BoxFit.fill)),
        child: Stack(children: [
          Column(children: [
            SizedBox(
              height: 10.0,
            ),
            Container(
              alignment: Alignment.center,
              child: Text(
                'Today Task ',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
                child: Align(
              alignment: Alignment.center,
              //  margin: EdgeInsets.only(left: 8.0, right: 8.0, bottom: 10.0),
              child: (service_list.length > 0)
                  ? ListView.builder(
                      // addAutomaticKeepAlives: false,
                      itemCount: service_list.length,
                      itemBuilder: (context, index) =>
                          PendingList(service_list[index]),
                    )
                  : Center(child: Text('Service list not found')),
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
                                color: Color(0xffff7000),
                              )),
                          Text(
                            'Today Task',
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
                                            EmphomeFragment()));
                              },
                              icon: Icon(Icons.home_outlined,
                                  color: Color(0xff004080))),
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
            ]),
          )
        ]));
  }

  Widget PendingTask() {
    return Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(children: [
          Column(children: [
            SizedBox(
              height: 15.0,
            ),
            Expanded(
                child: Padding(
              padding: EdgeInsets.only(left: 12, right: 12),
              child: (pending_leads_list.length > 0)
                  ? ListView.builder(
                      reverse: false,
                      itemCount: pending_leads_list.length,
                      itemBuilder: (context, index) =>
                          PendingList(pending_leads_list[index]),
                    )
                  : Center(
                      child: Image.asset('assets/images/loader.gif'),
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
                                color: Color(0xffff7000),
                              )),
                          Text(
                            'Today Task',
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
                                            EmphomeFragment()));
                              },
                              icon: Icon(Icons.home_outlined,
                                  color: Color(0xff004080))),
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
            ]),
          )
        ]));
  }

  Widget SearchTask() {
    return Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            color: Colors.white,
            image: DecorationImage(
                image: AssetImage('assets/images/bolt7.jpg'),
                colorFilter: new ColorFilter.mode(
                    Colors.black.withOpacity(0.1), BlendMode.dstATop),
                fit: BoxFit.fill)),
        child: Stack(children: [
          Column(children: [
            SizedBox(
              height: 10.0,
            ),
            Container(
              margin: EdgeInsets.only(left: 15, right: 15),
              child: TextFormField(
                  readOnly: true,
                  showCursor: false,
                  cursorColor: Colors.transparent,
                  controller: searchController,
                  onTap: () => {
                        //   hideWidget(),
                        _selectDate2(context),
                      },
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.fromLTRB(10, 15, 10, 0),
                    prefixIcon:
                        Icon(Icons.search, color: Color(0xffff7000), size: 25),
                    hintText: 'Search',
                    hintStyle:
                        TextStyle(color: Color(0xff747474), fontSize: 15.0),
                    filled: true,
                    fillColor: Colors.white,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide:
                          BorderSide(color: Color(0xffff7000), width: 0.8),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide:
                          BorderSide(color: Color(0xffff7000), width: 0.8),
                    ),
                  )),
            ),
            SizedBox(
              height: 12.0,
            ),
            Expanded(
                child: Padding(
                    padding: EdgeInsets.only(left: 7, right: 7),
                    child: Container(
                      margin: EdgeInsets.only(left: 5.0, right: 5.0),
                      child: (search_list.length > 0)
                          ? ListView.builder(
                              itemCount: search_list.length,
                              itemBuilder: (context, index) =>
                                  PendingList(search_list[index]),
                            )
                          : Center(),
                    )),
                flex: 4),
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
                                color: Color(0xffff7000),
                              )),
                          Text(
                            'Today Task',
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
                                            EmphomeFragment()));
                              },
                              icon: Icon(Icons.home_outlined,
                                  color: Color(0xff004080))),
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
            ]),
          )
        ]));
  }

  Widget PendingList(service_list) {
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
