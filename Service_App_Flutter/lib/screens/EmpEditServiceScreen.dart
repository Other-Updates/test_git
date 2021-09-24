// ignore: file_names
// ignore: file_names
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:service_app/Utils/Constants.dart';
import 'package:http/http.dart' as http;
import 'package:service_app/Utils/storageUtil.dart';
import 'package:service_app/components/EmployeeBottomNavigation.dart';
import 'package:service_app/components/Textads.dart';
import 'package:service_app/screens/CustomerDashboardScreen.dart';
import 'package:service_app/screens/EmpProfileFragment.dart';
import 'package:service_app/screens/EmpServiceFragment.dart';
import 'package:service_app/screens/EmpTodaytaskFragment.dart';
import 'package:service_app/screens/EmphomeFragment.dart';
import 'package:service_app/screens/EmployeeDashboardScreen.dart';
import 'package:service_app/screens/LoginScreen.dart';

class EmpEditServiceScreen extends StatefulWidget {
  @override
  final leads_list;
  EmpEditServiceScreen(this.leads_list);

  _EmpEditServiceScreenState createState() => _EmpEditServiceScreenState(this.leads_list);
}
class _EmpEditServiceScreenState extends State<EmpEditServiceScreen> {
  int _selectedIndex = 0;
  TextEditingController workperformed= TextEditingController();
  var _scaffoldKey = new GlobalKey<ScaffoldState>();
  String _dropDownValue ='';

  Future<void> _optionsDialogBox() {
    return showDialog(context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Add Photo!'),
            content: new SingleChildScrollView(
              child: new ListBody(
                children: <Widget>[

                  GestureDetector(
                      child: new Text('Take Photo'),
                      onTap: () {
                        opencamera();
                        Navigator.of(context).pop();
                      }),

                  Padding(
                    padding: EdgeInsets.all(8.0),
                  ),
                  GestureDetector(
                      child: new Text('Choose from Gallery'),
                      onTap: () {
                        opengallery();
                        Navigator.of(context).pop();
                      }),

                  Padding(
                    padding: EdgeInsets.all(8.0),
                  ),
                  GestureDetector(
                      child: new Text('Cancel'),
                      onTap: () {
                        Navigator.of(context).pop();
                      }
                    //   onTap: openCamera,
                  ),
                ],
              ),
            ),
          );
        });
  }
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
  List imageupload = [];
  var _image;
  final leads_list;
  _EmpEditServiceScreenState(this.leads_list);
  List category_list = [];
  customer() async {
    await getTextFromFile();

    var data = json.encode({"customer_id":leads_list['customer_id'], "service_id":leads_list['id'],"service_type":"service","emp_id":mobile_test6});
    final response = await http.post(BASE_URL + 'get_service_history', headers: {'authorization': basicAuth}, body: data);
    print(data);
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      print(jsonResponse);
      if(jsonResponse['status'] == "success"){
        setState(() {
          category_list = jsonResponse['data'];

          print(category_list);
        });
      }else if(jsonResponse['status'] == 'Error'){
        Navigator.pop(context);

      }
      //   sharedPreferences.setString("token", jsonResponse['token']);
    }else {
      Navigator.pop(context);

    }
  }
/*  editservice() async {
    var data = json.encode({"name":_image,"work_performed":workperformed.text,"status": '${(_dropDownValue == "Inprogress")?"0":(_dropDownValue == "Complete")?"1":"2"}',"service_id":leads_list['id']});
    final response = await http.post(BASE_URL + 'edit_service', headers: {'authorization': basicAuth}, body: data);
    print(data);
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      print(jsonResponse);
      if(jsonResponse['status'] == "success"){
        setState(() {
          category_list = jsonResponse['data'];
          print(category_list);
        });
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => EmpServiceFragment()), (Route<dynamic> route) => false);
      }else if(jsonResponse['status'] == 'Error'){
        Navigator.pop(context);

      }
      //   sharedPreferences.setString("token", jsonResponse['token']);
    }else {
      Navigator.pop(context);
    }
  }*/
  editservice() async {
    await getTextFromFile();
    var request = http.MultipartRequest(
      'POST', Uri.parse(BASE_URL + 'edit_service'),
    );
    Map<String, String> headers = {
      "Authorization": basicAuth,
      "Content-type": "multipart/form-data"
    };
    request.files.add(
      http.MultipartFile(
          'name[]',
          _image.readAsBytes().asStream(),
          _image.lengthSync(),
          filename: _image.path),
    );
    request.headers.addAll(headers);
    request.fields.addAll({"work_performed":workperformed.text,"status": '${(_dropDownValue == "Inprogress")?"0":(_dropDownValue == "Complete")?"1":"2"}',"service_id":leads_list['id']});

    var res = await request.send();

    var response = await http.Response.fromStream(res);
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      print(jsonResponse);
      if(jsonResponse['status'] == "success"){
        setState(() {
          category_list = jsonResponse['data'];
          print(category_list);
        });
        Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => EmpServiceFragment()), );

      }else if(jsonResponse['status'] == 'Error'){
        Navigator.pop(context);
      }
      //   sharedPreferences.setString("token", jsonResponse['token']);
    }else {
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
    // TODO: implement initState
    super.initState();
    getTextFromFile();
    customer();
  }
  String convertDateTimeDisplay(String date) {
    // print(date+" date ");
    var date = leads_list['created_date'];
      final DateFormat displayFormater = new DateFormat("dd/MM/yyyy");
      final DateFormat serverFormater = new DateFormat("dd/MM/yyyy");
      final DateTime displayDate = displayFormater.parse(date.toString());
      final String formatted = serverFormater.format(displayDate);
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
      key:_scaffoldKey,
      appBar: AppBar(
        leadingWidth: 110,
        centerTitle: true,
        backgroundColor: new Color(0xff004080),
        leading: Image.asset('assets/images/service_logo.png',
        ),
        title: Text('Edit Services'),
        automaticallyImplyLeading: false,
        actions: <Widget>[
          IconButton(icon: Icon(Icons.power_settings_new_rounded, color: Colors.white,), onPressed: () {_showMyDialog();}),
        ],
        //   centerTitle: true,
        //  automaticallyImplyLeading: false,
      ),
      resizeToAvoidBottomInset: false,
      body: Container(
        child: Stack(
          children: [
            Container(
              alignment: Alignment.center,
              child:ListView(
                  children:[
                    Container(
              padding: EdgeInsets.only(bottom: 10.0, right: 5.0),
              alignment: Alignment.topLeft,
              child:
              Text('About Issue',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 17,
                  color: Colors.black,
                ),
              ),),
            Container(
              height: 50,
                padding: EdgeInsets.only(left: 2.0, right: 2.0, bottom: 10.0),
                child: TextField(
                  maxLines: 2,
                  decoration: InputDecoration(
                    hintText: leads_list['description']??" ",
                    contentPadding: EdgeInsets.fromLTRB(
                        20.0, 15.0, 20.0, 15.0),

                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0)

                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide: BorderSide(
                          color: Color(0xff004080), width: 2),

                    ),
                  ),
                )),
            Container(
              padding: EdgeInsets.only(bottom: 10.0),
              alignment: Alignment.topLeft,
              child: Text('Attachments',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 17,
                  color: Colors.black,
                ),
              ), ),
            Container(
                padding: EdgeInsets.only(bottom: 10.0, right: 5.0),

                height: 50.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  border:Border.all(color: Color(0xff004080),width: 2.0),

                ),
                child:Row(
                    children: [
                      Container(
                          height: 30,
                          width: 30,
                        /*  decoration: BoxDecoration(

                            borderRadius: BorderRadius.circular(30.0),
                            color: Color(0xff004080),
                          ),
                          child:IconButton(
                            alignment: Alignment.centerLeft,
                            icon: Icon(Icons
                                .camera_alt, color: Colors.white),

                            color: Color(0xff004080), onPressed: () {   },
                          )*/   ),
                      Container(
                        padding: EdgeInsets.only(bottom: 10.0),
                        child:(imageupload.length > 0)? ListView.builder(
                          itemCount:imageupload.length,
                          itemBuilder: (context, index) =>
                          (imageupload[index]),
                        ):Center(),
                      ),
                /*      CircleAvatar(

                          radius: 30,
                          backgroundColor: Colors.transparent,
                          child:
                          ClipRRect(
                            borderRadius: BorderRadius.circular(55),
                            child:_image != null ?Image.file(
                              _image,
                              width: double.infinity,
                              height: double.infinity,
                              fit: BoxFit.cover,

                            ):Container() ,
                          ) ),*/
                    ])),

            Container(
              padding: EdgeInsets.only(bottom: 10.0),
              alignment: Alignment.topLeft,
              child:
              Text('Service History',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 17,
                  color: Colors.black,
                ),
              ),),
            Container(
              height: 100.0,
              child: (category_list.length > 0) ? ListView.builder(
               // addAutomaticKeepAlives: false,
                itemCount: category_list.length,
                itemBuilder: (context, index) =>
                    EachList(category_list[index]),
              ) : Center(child:Image.asset('assets/images/favicon.png')),
            ),
             /* Container(
                alignment: Alignment.center,
                child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                          child:
                          Text('ticket no  :',
                            style: TextStyle(
                              fontSize: 17,
                              color: Colors.black,
                            ),
                          ), flex: 2),
                      Expanded(
                          child: Text(leads_list['ticket_no']??" ",

                            style: TextStyle(
                              fontSize: 17,
                              color: Colors.black,
                            ),
                          ), flex: 2),
                    ])
     *//*           Expanded(child:

            imageSlider(context),flex: 2,),*//*

            ),*/
            Container(
                alignment: Alignment.center,
                child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                          child:
                          Text('Ticket no :  ${leads_list['ticket_no']??" "}',
                            style: TextStyle(
                              fontSize: 17,
                              color: Colors.black,
                            ),
                          ), flex: 2),

                    ]),
              /*           Expanded(child:

            imageSlider(context),flex: 2,),*/

            ),

            Container(
                alignment: Alignment.center,
                child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                          Text('Date         :  ${leads_list['created_date']??" "}',
                            style: TextStyle(
                              fontSize: 17,
                              color: Colors.black,
                            ),
                          ),


          Expanded  ( child:  DropdownButtonFormField(
              decoration: InputDecoration(
                hintText: 'Select status',
                              contentPadding: EdgeInsets.fromLTRB(
                                  20.0, 1.0, 20.0, 1.0),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(34.0)
                              ),
                             /* focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(34.0)),
                                borderSide: BorderSide(
                                    color: Color(0xff004080), width: 1,),
                              ),*/
                            ),
                            hint: _dropDownValue == null
                                ? Text('Dropdown')
                                : Text(
                              _dropDownValue,
                              style: TextStyle(color: Colors.black),
                            ),
                            isExpanded: true,
                            iconSize: 30.0,
                            style: TextStyle(color: Colors.black),
                            items: ['Select Status', 'Inprogress', 'Complete','pending'].map(
                                  (val) {
                                return DropdownMenuItem<String>(
                                  value: val,
                                  child: Text(val),
                                );
                              },
                            ).toList(),
                            onChanged: (val) {
                              print(_dropDownValue);
                              setState(
                                    () {
                                      _dropDownValue=val.toString();
                                },
                              );
                            },
          )   )

                    ])
     /*           Expanded(child:

            imageSlider(context),flex: 2,),*/

            ),
         Container(
            //    padding: EdgeInsets.only(bottom: 20.0, right: 10.0),
                alignment: Alignment.center,
                child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                          child:
                          Text('Work Performed ',
                            style: TextStyle(
                              fontSize: 17,
                              color: Colors.black,
                            ),
                          ), flex: 2),
                    ])
        /*        Expanded(child:

            imageSlider(context),flex: 2,),*/

            ),
            Container(
            //  height: 50,
                padding: EdgeInsets.only(left: 2.0, right: 2.0, bottom: 10.0),
                child: TextField(
                  maxLines: 2,
                  controller: workperformed,
                  decoration: InputDecoration(
                  //  hintText: leads_list['description']??" ",
                    contentPadding: EdgeInsets.fromLTRB(
                        4.0, 5.0, 20.0, 5.0),

                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0)

                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide: BorderSide(
                          color: Color(0xff004080), width: 2),

                    ),
                  ),
                )),
            Container(
              padding: EdgeInsets.only(bottom: 10.0),
              alignment: Alignment.topLeft,
              child: Text('Uploaded Image:',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 17,
                  color: Colors.black,
                ),
              ), ),
            Container(
                height: 60.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  border:Border.all(color: Color(0xff004080),width: 2.0),
                ),
                child:Row(
                    children: [
                      Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(

                            borderRadius: BorderRadius.circular(30.0),
                            color: Color(0xff004080),
                          ),
                          child:IconButton(
                            alignment: Alignment.centerLeft,
                            icon: Icon(Icons
                                .camera_alt, color: Colors.white),

                            color: Color(0xff004080), onPressed: () {   _optionsDialogBox(); },
                          )   ),
                      Container(

                        child:(imageupload.length > 0)? ListView.builder(

                          itemCount:imageupload.length,
                          itemBuilder: (context, index) =>
                          (imageupload[index]),
                        ):Center(),
                      ),
                      CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.transparent,
                          child:
                          ClipRRect(
                            borderRadius: BorderRadius.circular(55),
                            child:_image != null ?Image.file(
                              _image,
                              width: double.infinity,
                              height: double.infinity,
                              fit: BoxFit.cover,

                            ):Container() ,
                          ) ),
                    ]) ),
            Container(
                child:Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children:[
                      Container(
                          alignment: Alignment.centerRight,
                          child:
                          FlatButton(
                            onPressed: () => {
                              Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => EmpServiceFragment()))
                            },
                            child: Text('CANCEL', style: TextStyle(
                                color: Colors.red, fontSize: 20.0
                            )
                            ),
                            textColor: Colors.white,
                            shape: RoundedRectangleBorder(side: BorderSide(
                                color: Colors.red,
                                style: BorderStyle.solid
                            ), borderRadius: BorderRadius.circular(32.0)),
                          )),
                      Container(
                        padding: EdgeInsets.only(left: 20.0),
                        alignment: Alignment.centerRight,
                        child:          RaisedButton(
                          onPressed: () => {
                            if(workperformed.text == ""){
                              _showMessageInScaffold("please enter workperformed"),
                            },
                            if(_dropDownValue == ""){
                              _showMessageInScaffold("please select status"),
                            },
                            editservice(),
                          },
                          textColor: Colors.white,
                          color: Colors.green,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular((32.0))),
                          child: Text('SUBMIT', style: TextStyle(fontSize: 20),),
                        ),),
                    ]))]),
              /*  Expanded(child:

            imageSlider(context),flex: 2,),*/

            ),
    Container(
    alignment: Alignment.bottomCenter,
    child:Column(
    mainAxisSize: MainAxisSize.min,
    children:[
            Container(
              height: 30,
              child:TextAds(),
            ),
            Container(
              color:Colors.white,
             // alignment:Alignment.bottomCenter,
              width: double.infinity,
              child: Row(
                children: [
                  Expanded(
                      child:Column(
                          children: [
                            IconButton(onPressed: (){
                              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => EmpServiceFragment()));
                            }, icon: Icon(Icons.home_repair_service_outlined, color:   _selectedIndex == 0 ? Color(0xffff7000):Color(0xff004080),)),
                            Text('Services',   style: TextStyle(
                              color: _selectedIndex == 0 ? Color(0xffff7000):Color(0xff004080),
                            ),),]),
                      flex:5),
                  Expanded(
                      child:Column(
                          children: [
                            IconButton(onPressed: (){
                              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => EmpTodaytaskFragment()));
                            }, icon: Icon(Icons.sticky_note_2_outlined, color:   _selectedIndex == 1 ? Color(0xffff7000):Color(0xff004080),)),
                            Text('Today Task',   style: TextStyle(
                              color: _selectedIndex == 1 ? Color(0xffff7000):Color(0xff004080),

                            ),),]),
                      flex:5),
                  Expanded(
                      child:Column(
                          children: [
                            IconButton(onPressed: (){
                              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => EmphomeFragment()));
                            }, icon: Icon(Icons.home_outlined, color:   _selectedIndex == 2 ? Color(0xffff7000):Color(0xff004080),)),
                            Text('Home',   style: TextStyle(
                              color: _selectedIndex == 2 ? Color(0xffff7000):Color(0xff004080),

                            ),),]),
                      flex:5),
                  Expanded(
                      child:Column(
                          children: [
                            IconButton(onPressed: (){
                              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => EmpProfileFragment()));
                            }, icon: Icon(Icons.person_outline, color:   _selectedIndex == 3 ? Color(0xffff7000):Color(0xff004080),)),
                            Text('Profile',   style: TextStyle(
                              color: _selectedIndex == 3 ? Color(0xffff7000):Color(0xff004080),
                            ),),]),
                      flex:5),
                ],
              ),
            )
          ]  ),
      ) ])) ));
  }
  Widget EachList(category_list) {
    return GestureDetector(
        child: Card(
elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
            color: Colors.white,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment:
                MainAxisAlignment.start,
                children: [
                  Container(
                    //padding: EdgeInsets.only(left: 10),
                      child: new Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                           /* Container(
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
                                  child:    ( category_list["emp_image"] != null && category_list["emp_image"].length > 0)? CircleAvatar(radius: 37,backgroundColor: Colors.blue,backgroundImage: NetworkImage('${category_list["emp_image"]}')
                                  ):CircleAvatar(radius: 37,backgroundImage:AssetImage("assets/images/favicon.png"),backgroundColor: Colors.white,
                                  ) ),

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
                                            child:new Row(
                                                children:[
                                                  Container(
                                                      padding: EdgeInsets.all(5.0),

                                                      alignment: Alignment.topLeft,
                                                      child:  Text(
                                                        convertDateTimeDisplay('${category_list['created_date']?? " "}'),
                                                        textAlign: TextAlign.start,
                                                        style: TextStyle(
                                                          color: Colors.black54,
                                                        ),
                                                      ) ),
                                                  Container(
                                                      padding: EdgeInsets.all(5.0),
                                                      alignment: Alignment.bottomLeft,
                                                      child:  Text(
                                                        'Status :  ${category_list['work_status']}',
                                                        textAlign: TextAlign.start,
                                                        style: TextStyle(
                                                          color: Colors.black54,
                                                        ),
                                                      ) ),
                                                ] )),
                                        Container(
                                            padding: EdgeInsets.all(5.0),

                                            alignment: Alignment.topLeft,
                                            child:  Text(
                                              'Work Performed     :  ${category_list['work_performed']??" "}',
                                              textAlign: TextAlign.start,
                                              style: TextStyle(
                                                color: Colors.black54,
                                              ),
                                            ) ),
                                        Container(
                                            padding: EdgeInsets.all(5.0),
                                            alignment: Alignment.bottomLeft,
                                            child:  Text(
                                              'Attender                   :  ${category_list['name']??" "}',

                                              textAlign: TextAlign.start,
                                              style: TextStyle(
                                                color: Colors.black54,
                                              ),
                                            ) ),
                                        Container(
                                            padding: EdgeInsets.all(5.0),
                                            alignment: Alignment.bottomLeft,
                                            child:  Text(
                                              'Mobile number       :  ${category_list['mobile_no']??" "}',
                                              textAlign: TextAlign.start,
                                              style: TextStyle(
                                                color: Colors.black54,
                                              ),
                                            ) ),

                                      ]),),
                                flex: 8),
                          ])),
                ])));
  }
  void opencamera() async {
    var image = await ImagePicker.pickImage(
        source: ImageSource.camera, imageQuality: 50
    );
    setState(() {
      _image = image;
    });
  }
  void opengallery()async  {
    var image = await  ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 50
    );
    setState(() {
      _image = image;
    });
  }
}

