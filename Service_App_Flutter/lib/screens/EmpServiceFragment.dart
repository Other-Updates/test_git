import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:service_app/Utils/Constants.dart';
import 'package:service_app/Utils/storageUtil.dart';
import 'package:service_app/components/Textads.dart';
import 'package:service_app/components/adsimages.dart';
import 'package:service_app/screens/AddServiceScreen.dart';
import 'package:service_app/screens/CustomerDashboardScreen.dart';
import 'package:http/http.dart' as http;
import 'package:service_app/screens/EditServiceScreen.dart';
import 'package:service_app/screens/EmpEditServiceScreen.dart';
import 'package:service_app/screens/EmpProfileFragment.dart';
import 'package:service_app/screens/EmpTodaytaskFragment.dart';
import 'package:service_app/screens/EmphomeFragment.dart';
import 'package:service_app/screens/LoginScreen.dart';

class EmpServiceFragment extends StatefulWidget {
  @override
  _EmpServiceFragmentState createState() =>
      _EmpServiceFragmentState();
}

class _EmpServiceFragmentState extends State<EmpServiceFragment> {
  int _selectedIndex = 0;
  List service_list = [];
  var id = '', customer_id = '', status = '', inv_no = '',attendant='',created_date='',work_performed='',description='',img_path=' ';
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
    var data = json.encode({"emp_id":mobile_test6, "service_type":"employee" });
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
      }else if(jsonResponse['status'] == 'Error'){
        Navigator.pop(context);
      }
      //   sharedPreferences.setString("token", jsonResponse['token']);
    }else {
      Navigator.pop(context);
    }
  }
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
        leading: Image.asset('assets/images/service_logo.png',
        ),
        title: Text('Services'),
        automaticallyImplyLeading: false,
        actions: <Widget>[
          IconButton(icon: Icon(Icons.power_settings_new_rounded, color: Colors.white,), onPressed: () {_showMyDialog();}),
        ],
        //   centerTitle: true,
        //  automaticallyImplyLeading: false,
      ),
      body: Container(
        child:Column(children: <Widget>[
          Container(
            height: 100,
            width: MediaQuery.of(context).size.width,
            child:AdsImages(),
          ),
          Expanded(

              child:(service_list.length > 0)? ListView.builder(
                //reverse: true,
                itemCount:service_list.length,
                itemBuilder: (context, index) =>
                    EachList(service_list[index]),
              ):Center(child:  Image.asset('assets/images/loader.gif'),
              ),flex:4
          ),
      /*    Container(
            alignment: Alignment.bottomRight,
            padding: EdgeInsets.only(right:10.0,bottom: 5.0),
            child: FloatingActionButton(
              child: Icon(Icons.add),
              backgroundColor: new Color(0xff004080),

              onPressed: () {  Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => AddServiceScreen())); },

            ),),*/
          Container(
            alignment: Alignment.bottomCenter,
            height: 30,
            child:TextAds(),
          ),
          Container(
            color:Colors.white,
        //    alignment:Alignment.bottomCenter,
            width: double.infinity,
            child: Row(
              children: [
                Expanded(
                    child:Column(
                        children: [
                          IconButton(onPressed: (){
                            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => EmpServiceFragment()));
                          }, icon: Icon(Icons.home_repair_service_outlined,   color:   Color(0xffff7000))),
                          Text('Services',   style: TextStyle(
                            color: Color(0xffff7000),

                          ),),]),
                    flex:5),
                Expanded(
                    child:Column(
                        children: [
                          IconButton(onPressed: (){
                            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => EmpTodaytaskFragment()));
                          }, icon: Icon(Icons.sticky_note_2_outlined,    color:Color(0xff004080),)),
                          Text('Today Task',   style: TextStyle(
                            color:Color(0xff004080),

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
                          }, icon: Icon(Icons.person_outline,   color:Color(0xff004080),)),
                          Text('Profile',   style: TextStyle(
                            color:Color(0xff004080),
                          ),),]),
                    flex:5),

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
        ]),),
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
                                  child:   (service_list['customer_image_upload'].length >0)?CircleAvatar(radius: 37,backgroundColor: Colors.blue,backgroundImage: NetworkImage('${service_list['customer_image_upload'][0]["img_path"]}')
                                  ) :CircleAvatar(radius: 37,backgroundImage:AssetImage("assets/images/favicon.png"),backgroundColor: Colors.white,
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




