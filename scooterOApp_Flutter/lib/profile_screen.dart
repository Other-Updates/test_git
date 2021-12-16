import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:scotto/constants.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:scotto/editprofilescreen.dart';
import 'package:scotto/utils/Language.dart';
import 'package:scotto/utils/StorageUtil.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  @override
  ProfileScreenState createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> with SingleTickerProviderStateMixin {
  bool _status = true;
  final FocusNode myFocusNode = FocusNode();

  var _GENERIC_NAME = ' ', _GENERIC_MOBILE_NUMBER = '',_GENERIC_DOB ='', _GENERIC_GENDER ='', _GENERIC_EMAIL_ID ='', _GENERIC_PROFILE = '' ;

  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  SharedPreferences _sharedPreferences;

  getLanguage() async {
    _sharedPreferences = await _prefs;
    setState(() {
      _GENERIC_PROFILE = Language.getLocalLanguage(_sharedPreferences, "GENERIC_PROFILE");
      _GENERIC_NAME = Language.getLocalLanguage(_sharedPreferences, 'GENERIC_NAME');
      _GENERIC_DOB = Language.getLocalLanguage(_sharedPreferences, "GENERIC_DOB");
      _GENERIC_GENDER = Language.getLocalLanguage(_sharedPreferences, "GENERIC_GENDER");
      _GENERIC_MOBILE_NUMBER = Language.getLocalLanguage(_sharedPreferences, "GENERIC_MOBILE_NUMBER");
      _GENERIC_EMAIL_ID = Language.getLocalLanguage(_sharedPreferences, "GENERIC_EMAIL_ID");

    });
  }

  String mobile_test='',mobile_test1='',mobile_test2='',mobile_test3='',mobile_test4='',mobile_test6='';

  void getTextFromFile() async {
    try {
      String data = await StorageUtil.getItem("login_customer_detail_name");
      String data1 = await StorageUtil.getItem("login_customer_detail_dob");
      String data2 = await StorageUtil.getItem("login_customer_detail_mobile_gender");
      String data3 = await StorageUtil.getItem("login_customer_detail_mobile_number");
      String data4 = await StorageUtil.getItem("login_customer_detail_email");
      String data6 = await StorageUtil.getItem("login_customer_detail_id");
      setState(() {
        mobile_test = data;
        mobile_test1 = data1;
        mobile_test2 = data2;
        mobile_test3 = data3;
        mobile_test4 = data4;
        mobile_test6 = data6;
        print(mobile_test6);
      });
    } catch (ex) {
      print(ex);
    }
  }

  var customerProfiledetails,id,name=' ',mobile_number=' ',dob=' ',email=' ',gender=' ';

  profile() async {
    await getTextFromFile();

    String basicAuth = "Basic YWRtaW46MTIzNA==";
    //   SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var data = json.encode({"id": mobile_test6});
    print("dsfsget" +data);
    final response = await http.post(baseurl + 'api_profile_details',
        headers: {'authorization': basicAuth}, body: data);
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      print(jsonResponse);
      if (jsonResponse['status'] == "Success") {
        var profileDetails = jsonResponse['data'];
        setState(() {
          customerProfiledetails = profileDetails;
          id = profileDetails['id'];
          name = profileDetails['name'];
          mobile_number = profileDetails['mobile_number'];
          dob = profileDetails['dob'];
          email = profileDetails['email'];
          gender = profileDetails['gender'];

        });
      } else if (jsonResponse['status'] == 'Error') {
        print(jsonResponse['message']);
      }
      //   sharedPreferences.setString("token", jsonResponse['token']);
    } else {
      //   _showMessageInScaffold('Contact Admin!!');
    }
  }



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getTextFromFile();
    getLanguage();
    profile();
  }



  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back_ios_rounded,
              color: Colors.white,// add custom icons also
            ),
          ),
          title: Text( _GENERIC_PROFILE ,style: TextStyle(fontWeight: FontWeight.bold,
              fontSize: 20.0,
              fontFamily: 'Montserrat',
              color: Colors.white),),
          centerTitle: true,
          backgroundColor:Color(0xff00DD00),

        ),

        body: new Container(
          color: Color(0xffE6FFE6),
          child: new ListView(
            children: <Widget>[
              Column(
                children: <Widget>[
                  new Container(
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 25.0),
                      child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 10.0, top: 15.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Column(

                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      new Icon(
                                        Icons.person_outline,
                                        color: Color(0xff00DD00),
                                        size: 25.0,
                                      ),
                                    ],

                                  ),
                                  new Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Container(
                                        padding: EdgeInsets.only(
                                            left: 10.0),
                                   child:   new Text(
                                        _GENERIC_NAME ,
                                        // '${mobile_test}',
                                        style: TextStyle(
                                          fontSize: 18.0,
                                          fontFamily: 'Montserrat',
                                          color:Color(0xff747474),
                                          //    fontWeight: FontWeight.bold
                                        ),
                                   ),  ),
                                    ],
                                  ),

                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 45.0, top: 8.0,bottom: 5.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[

                                  new Text(
                                    '${name}',
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      color:Color(0xff3D3D3D),
                                      fontFamily: 'Montserrat',
                                    ),
                                  ),


                                ],
                              )),
                         Divider(
                            color: Colors.grey,
                            thickness: 0.5,
                            indent: 10,
                            endIndent:10,
                          ),

                          Padding(
                              padding: EdgeInsets.only(
                                  left: 10.0, top: 5.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      new Icon(
                                        Icons.date_range_outlined,
                                        color: Color(0xff00DD00),
                                        size: 25.0,
                                      ),
                                    ],

                                  ),
                                  new Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Container(
                                        padding: EdgeInsets.only(
                                            left: 10.0),
                                        child:   new Text(
                                        _GENERIC_DOB ,
                                        style: TextStyle(
                                          fontSize: 18.0,
                                          color:Color(0xff747474),
                                          fontFamily: 'Montserrat',
                                          //    fontWeight: FontWeight.bold
                                        ),
                                        )    ),
                                    ],
                                  ),

                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 45.0, top: 8.0,bottom: 5.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Text(
                                    '${dob}',
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      color:Color(0xff3D3D3D),
                                      fontFamily: 'Montserrat',

                                    ),
                                  ),
                                ],
                              )),
                          Divider(
                            color: Colors.grey,
                            thickness: 0.5,
                            indent: 10,
                            endIndent:10,
                          ),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 10.0, top:5.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Column(
                                    //backgroundColor: Colors.green,
                                    //   radius: 15.0,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      new Icon(
                                        Icons.female,
                                        color: Color(0xff00DD00),
                                        size: 25.0,
                                      ),
                                    ],

                                  ),

                                  new Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Container(
                                        padding: EdgeInsets.only(
                                            left: 10.0),
                                        child:   new Text(
                                        _GENERIC_GENDER ,
                                        style: TextStyle(
                                          fontSize: 18.0,
                                          color:Color(0xff747474),
                                          fontFamily: 'Montserrat',
                                          //    fontWeight: FontWeight.bold
                                        ),
                                        )   ),
                                    ],
                                  ),

                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 45.0, top: 8.0,bottom: 5.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Text(
                                    '${(gender == "1")?"Male":"Female"}',
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      color:Color(0xff3D3D3D),
                                      fontFamily: 'Montserrat',
                                    ),
                                  ),
                                ],
                              )),
                          Divider(
                            color: Colors.grey,
                            thickness: 0.5,
                            indent: 10,
                            endIndent:10,
                          ),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 10.0, top: 5.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Column(
                                    //backgroundColor: Colors.green,
                                    //   radius: 15.0,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      new Icon(
                                        Icons.phone_outlined,
                                        color: Color(0xff00DD00),
                                        size: 25.0,
                                      ),
                                    ],

                                  ),
                                  new Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Container(
                                        padding: EdgeInsets.only(
                                            left: 10.0),
                                        child:   new Text(
                                        _GENERIC_MOBILE_NUMBER ,
                                        style: TextStyle(
                                          fontSize: 18.0,
                                          color:Color(0xff747474),
                                          fontFamily: 'Montserrat',
                                          //    fontWeight: FontWeight.bold
                                        ),
                                        ) ),
                                    ],
                                  ),

                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 45.0, top: 8.0,bottom: 5.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Text(

                                    '${mobile_number}',
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      color:Color(0xff3D3D3D),
                                      fontFamily: 'Montserrat',

                                    ),
                                  ),
                                ],
                              )),
                          Divider(
                            color: Colors.grey,
                            thickness: 0.5,
                            indent: 10,
                            endIndent:10,
                          ),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 10.0, top: 5.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Column(
                                    //backgroundColor: Colors.green,
                                    //   radius: 15.0,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      new Icon(
                                        Icons.email_outlined,
                                        color: Color(0xff00DD00),
                                        size: 25.0,
                                      ),
                                    ],

                                  ),
                                  new Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Container(
                                        padding: EdgeInsets.only(
                                            left: 10.0),
                                        child:   new Text(
                                        _GENERIC_EMAIL_ID ,
                                        style: TextStyle(
                                          fontSize: 18.0,
                                          color:Color(0xff747474),
                                          fontFamily: 'Montserrat',
                                          //    fontWeight: FontWeight.bold
                                        ),
                                        )  ),
                                    ],
                                  ),

                                ],
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                  left: 45.0, top: 8.0,bottom: 5.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  new Text(

                                    '${email}',
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      color:Color(0xff3D3D3D),
                                      fontFamily: 'Montserrat',

                                    ),
                                  ),
                                ],
                              )),
                          Divider(
                            color: Colors.grey,
                            thickness: 0.5,
                            indent: 10,
                            endIndent:10,
                          ),


                          Container(
                              alignment: Alignment.bottomRight,

                              padding: EdgeInsets.only(top: 100.0,
                                  right: 25.0, bottom: 10.0),
                              child: new Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                mainAxisSize: MainAxisSize.max,
                                children: <Widget>[
                                  _status ? _getEditIcon() : new Container(),
                                ],
                              )

                          ),

                          //  !_status ? _getActionButtons() : new Container(),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ));
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    myFocusNode.dispose();
    super.dispose();
  }


  Widget _getEditIcon() {
    return new GestureDetector(
      child: new CircleAvatar(
        backgroundColor: Color(0xff00DD00),
        radius: 30.0,

        child: new Icon(
          Icons.edit,
          color: Colors.white,
          size: 23.0,
        ),
      ),
      onTap: () {
        /*setState(() {
          _status = false;
        });*/
        Navigator.of(context).push(
            MaterialPageRoute(
                builder: (BuildContext context) => EditProfileScreen()
            )
        );
      },
    );
  }
}