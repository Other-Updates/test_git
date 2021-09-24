// ignore: file_names
// ignore: file_names
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:service_app/Utils/Constants.dart';
import 'package:service_app/Utils/storageUtil.dart';
import 'package:service_app/components/Textads.dart';
import 'package:service_app/components/adsimages.dart';
import 'package:service_app/screens/AddLeadsScreen.dart';
import 'package:http/http.dart' as http;
import 'package:service_app/screens/CusHomeFragment.dart';
import 'package:service_app/screens/CusProfileFragment.dart';
import 'package:service_app/screens/CusServiceFragment.dart';
import 'package:service_app/screens/CusYoutubeFragment.dart';
import 'package:service_app/screens/EditLeadsScreen.dart';
import 'package:service_app/screens/LoginScreen.dart';
class CusLeadsFragment extends StatefulWidget {
  @override
  _CusLeadsFragmentState createState() => _CusLeadsFragmentState();
}

class _CusLeadsFragmentState extends State<CusLeadsFragment> {
  List leads_list = [];
  int _selectedIndex = 0;
  var leadslisted,id = '', customer_id = '', status = '-', inv_no = '',attendant='-',created_date='',work_performed='',description='',customer_image_upload='';
/*  List<String> Names = [
    'Abhishek',
    'John',
    'Robert',
    'Shyam',
    'Sita',
    'Gita',
    'Nitish'
  ];*/
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
  customer() async {
    await getTextFromFile();
    var data = json.encode({"customer_id":mobile_test6 });
    final response = await http.post(BASE_URL + 'leads_list', headers: {'authorization': basicAuth}, body: data);
    print(data);
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      print(jsonResponse);
      if(jsonResponse['status'] == "success"){

        setState(() {
         leads_list = jsonResponse['data'];

         /*leadslisted =leads_list;
          status =leads_list['status'];*/
          print(leads_list);
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
    customer();
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
    return new
    WillPopScope(
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
    },child:Scaffold(
      appBar: AppBar(
        leadingWidth: 110,
        centerTitle: true,
        backgroundColor: new Color(0xff004080),
        leading: Image.asset('assets/images/service_logo.png'),
        title: Text('Leads'),
        automaticallyImplyLeading: false,
        actions: <Widget>[
          IconButton(icon: Icon(Icons.power_settings_new_rounded, color: Colors.white,), onPressed: () {_showMyDialog();}),
        ],
      ),

      body: Container(
        child:Column(
          mainAxisAlignment:MainAxisAlignment.start,
            children: <Widget>[
          Container(
            height: 100,
            width: MediaQuery.of(context).size.width,
            child:AdsImages(),
          ),
              Expanded(

            child:(leads_list.length > 0)? ListView.builder(
               reverse: false,
                itemCount:leads_list.length,
                itemBuilder: (context, index) =>
                    EachList(leads_list[index]),
              ):Center(child:  Image.asset('assets/images/loader.gif'),
            )   ),
          Container(
            alignment: Alignment.bottomRight,
            padding: EdgeInsets.only(right:10.0,bottom: 5.0),
            child: FloatingActionButton(
              child: Icon(Icons.add),
              backgroundColor: new Color(0xff004080),

              onPressed: () {  Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => AddLeadsScreen())); },

            ),),
          Container(
            alignment: Alignment.bottomCenter,
            height: 30,
            child:TextAds(),
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
                              }, icon: Icon(Icons.perm_phone_msg_outlined, color:  Color(0xffff7000))),
                              Text('Leads',   style: TextStyle(
                                color:  Color(0xffff7000),
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
                                color:Color(0xff004080),
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
                              }, icon: Icon(Icons.home_outlined,  color: Color(0xff004080),)),
                              Text('Home',   style: TextStyle(
                                color: Color(0xff004080),


                              ),),]),
                        flex:5),
                    Expanded(
                        child:Column(
                            children: [
                              IconButton(onPressed: (){
                                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => CusProfileFragment()));
                              }, icon: Icon(Icons.person_outline,                                color: Color(0xff004080),
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
/*      Container(
        alignment: Alignment.bottomRight,
     child: FloatingActionButton(
       child: Icon(Icons.add),
       backgroundColor: new Color(0xff004080),

       onPressed: () {  Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => AddServiceScreen())); },

     ),),*/
        ]),),
/*        body: Padding(
          padding: const EdgeInsets.only(bottom:80.0),
          child: Container(
            child:(leads_list.length > 0)? ListView.builder(
              itemCount:leads_list.length,
              itemBuilder: (context, index) =>
                  EachList(leads_list[index]),
            ):Center(child:  Image.asset('assets/images/loader.gif')
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(

          child: Icon(Icons.add),
          backgroundColor: new Color(0xff004080),

          onPressed: () {  Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => AddLeadsScreen())); },

        )*/
    ));

  }

  Widget EachList(leads_list) {
    return GestureDetector(
        onTap: (){
      setState(() {
        id = leads_list ['id'];
      });
      Navigator.of(context).push(
          MaterialPageRoute(
              builder: (BuildContext context) =>EditLeadsScreen(leads_list)
          )
      );
    },


   child:   Card(
     margin: EdgeInsets.all(5),
     shadowColor: Color(0xff004080),
elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        color: Colors.white,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                //padding: EdgeInsets.only(left: 10),
                  child: new Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment:
                      MainAxisAlignment.start,
                      children: <Widget>[
                        Stack(
                          children: [
                            SizedBox(width:20.0),
                            Container(
                          alignment: Alignment.topLeft,
                          decoration: new BoxDecoration(
                              color: (leads_list['status'].toString()== "leads"||leads_list['status'].toString()== "leads_follow_up"||leads_list['status'].toString()=="quotation_follow_up"||leads_list['status'].toString()=="quotation")? Colors.orange:(leads_list['status'].toString() == "order_conform")?Colors.green:Colors.red,


                              borderRadius: new BorderRadius.only(
                                topLeft: const Radius.circular(3),
                                bottomLeft: const Radius.circular(5)
                            ) ),

                       ///height: double.infinity,
                         width: 5,
                          height: 80,
                  )]
                        ),


                        Flexible(
                          child:Container(

                              padding:EdgeInsets.only(left: 10),
                              alignment: Alignment.topLeft,
                              child:   CircleAvatar(radius: 37,backgroundColor: Colors.blue,backgroundImage: NetworkImage('${leads_list['category_image']}'),
                              )),

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
                                        padding: EdgeInsets.all(5.0),

                                        alignment: Alignment.topLeft,
                                        child:  Text(
                                          '${leads_list['enquiry_no']}',
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                            color: Color(0xff004080),
                                          ),
                                        ) ),
                                    Container(
                                        padding: EdgeInsets.all(5.0),
                                        alignment: Alignment.bottomLeft,
                                        child:  Text(

                                          '${leads_list['enquiry_about']}',
                                          maxLines: 1,
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                            color: Colors.black54,
                                          ),
                                        ) ),

                                  ]),),
                            flex: 4),
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
                                          convertDateTimeDisplay('${leads_list['created_date']}'),
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                            color: Colors.black54,
                                          ),
                                        ) ),
                                    Container(
                                        padding: EdgeInsets.all(5.0),
                                        alignment: Alignment.bottomRight,
                                        child:  Text(
                                         '${ (leads_list['status'].toString()== "leads")? "leads":(leads_list['status'].toString() == "order_conform")?"Order Confirm":(leads_list['status'].toString()=="leads_follow_up")?"Leads Follow Up":(leads_list['status'].toString()=="quotation")?"Quotation":(leads_list['status'].toString()=="quotation_follow_up")?"Quotation Follow Up":(leads_list['status'].toString()=="leads_rejected")?"Leads Rejected":(leads_list['status'].toString()=="quotation_rejected")?"Quotation Rejected":"--"}',
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                            color: (leads_list['status'].toString()== "leads"||leads_list['status'].toString()== "leads_follow_up"||leads_list['status'].toString()=="quotation_follow_up"||leads_list['status'].toString()=="quotation")? Colors.orange:(leads_list['status'].toString() == "order_conform")?Colors.green:Colors.red,
                                          ),
                                        ) ),

                                  ]),),
                            flex: 4),

                      ])),
            ]),
   )  );
  }

}






