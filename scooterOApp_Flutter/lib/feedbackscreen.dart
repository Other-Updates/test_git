import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:scotto/acknowledgementscreen.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'constants.dart';
import 'package:scotto/home_screen.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:scotto/utils/StorageUtil.dart';



import 'package:shared_preferences/shared_preferences.dart';
import 'package:scotto/utils/Language.dart';
import 'dart:async';



class FeedbackScreen extends StatefulWidget {
  @override
  final trip_details;
  FeedbackScreen(this.trip_details);
  _FeedbackScreenState createState() => _FeedbackScreenState(this.trip_details);
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final trip_details;
  _FeedbackScreenState(this.trip_details);
  var _GENERIC_HOW_ENJOY_RIDE = ' ',_GENERIC_PROVIDE_FEEDBACK = '', _GENERIC_ENTER_FEEDBACK ='',_GENERIC_SUBMIT = ' ',_GENERIC_WONT_START = '', _GENERIC_JERKY ='',_GENERIC_SLOW = '', _GENERIC_DEMAGED ='' ;

  var _scaffoldKey = new GlobalKey<ScaffoldState>();
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  SharedPreferences _sharedPreferences;

  getLanguage() async {
    _sharedPreferences = await _prefs;
    // print(Language.getLocalLanguage(_sharedPreferences,'GENERIC_LOGIN'));
    setState(() {
      _GENERIC_HOW_ENJOY_RIDE = Language.getLocalLanguage(_sharedPreferences, 'GENERIC_HOW_ENJOY_RIDE');
      _GENERIC_PROVIDE_FEEDBACK = Language.getLocalLanguage(_sharedPreferences, "GENERIC_PROVIDE_FEEDBACK");
      _GENERIC_ENTER_FEEDBACK = Language.getLocalLanguage(_sharedPreferences, "GENERIC_ENTER_FEEDBACK");
      _GENERIC_SUBMIT = Language.getLocalLanguage(_sharedPreferences, 'GENERIC_SUBMIT');
      _GENERIC_WONT_START = Language.getLocalLanguage(_sharedPreferences, "GENERIC_WONT_START");
      _GENERIC_JERKY = Language.getLocalLanguage(_sharedPreferences, "GENERIC_JERKY");
      _GENERIC_SLOW = Language.getLocalLanguage(_sharedPreferences, "GENERIC_SLOW");
      _GENERIC_DEMAGED = Language.getLocalLanguage(_sharedPreferences, "GENERIC_DEMAGED");



    });

  }
  TextEditingController feedbackController = TextEditingController();
  TextEditingController ratingController = TextEditingController();

  var  _rating;
  int _currentRating = 0;


  String customer_id = '';


  getTextFromFile() async {
    try {

      String data = await StorageUtil.getItem("login_customer_detail_id");

      setState(() {
        customer_id = data;

      });
    } catch (ex) {
      print(ex);
    }
  }


  feedback() async {
  await getTextFromFile();
    String basicAuth = "Basic YWRtaW46MTIzNA==";
    //   SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var data =json.encode( {"id":customer_id,"scootoro_id":"108","trip_id":"27","feedback":feedbackController.text,"ratings": _rating });
    print(data);
    final response = await http.post(baseurl + 'api_ride_feedback', headers: {'authorization': basicAuth}, body: data);
    if (response.statusCode == 200) {
      var  jsonResponse = json.decode(response.body);
      print(jsonResponse);
      if(jsonResponse['status'] == "Success"){

        Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => AcknowledgementScreen()));
      }else if(jsonResponse['status'] == 'Error'){
        print(jsonResponse['message']);
        //   _showMessageInScaffold(jsonResponse['message']);
      }
      //   sharedPreferences.setString("token", jsonResponse['token']);
    }else {
      //   _showMessageInScaffold('Contact Admin!!');
    }
  }

  void _showMessageInScaffold(String message) {
    _scaffoldKey.currentState.showSnackBar(
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


  @override
  void initState() {
    super.initState();
    getLanguage();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
        body: Center(
            child: Container(

                color: Color(0xffE6FFE6),
                child: ListView(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    GestureDetector(
                    child:Container(
                      padding: EdgeInsets.only(left:15,top: 20),
                      alignment: Alignment.topLeft,
                      child: new Icon(
                        Icons.close,
                        color: Colors.black54,
                        size: 23.0,
                      ),),
            onTap: (){
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => HomeScreen()));}),
                    Container(
                        padding: EdgeInsets.only(top: 30.0,bottom: 10,left: 10.0),
                        alignment: Alignment.center,
                        child: Text(_GENERIC_HOW_ENJOY_RIDE, style: TextStyle(color: Color(0xff676767), fontWeight: FontWeight.bold, fontFamily: 'Montserrat', fontSize: 22),)
                    ),
          Container(

              padding: EdgeInsets.only(top: 30.0,bottom: 10,left: 10.0),
              alignment: Alignment.center,
              child: RatingBar.builder(

              initialRating: 0,
              minRating:1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) => Icon(
                Icons.star,
                color:Color(0xff00DD00),
              ),
              onRatingUpdate: (rating) {
               // print(rating);
                setState(() {
                  _rating = rating;
                  print("rating changed: rating = $_rating");
                });

              },
              ) ),
                    Container(
                      padding: EdgeInsets.only(left: 18,top: 20,bottom: 15),
                      child: Text(
                        _GENERIC_PROVIDE_FEEDBACK,style: TextStyle(color: Colors.black45,fontSize: 16,fontFamily: 'Montserrat'),
                      ),
                    ),
                    Container(

                      padding: EdgeInsets.fromLTRB(15, 10, 15, 15),

                      child: TextFormField(

                        textAlign: TextAlign.start,
                        controller: feedbackController,
                        keyboardType: TextInputType.multiline,
                        maxLength: null,
                        maxLines: 5,
                        decoration: InputDecoration(
                          hintText: _GENERIC_ENTER_FEEDBACK ,
                          hintStyle: TextStyle(color: Colors.grey,fontFamily: 'Montserrat'),
                          filled: true,
                          fillColor: Colors.white,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8.0)),
                            borderSide: BorderSide(color: Color(0xff00DD00), width: 0.8),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8.0)),
                            borderSide: BorderSide(color: Color(0xff00DD00), width: 0.8),
                          ),
                          //  labelText: 'Password',
                        ),
                      ),
                    ),
                    Container(
                        height: 55,
                        padding: EdgeInsets.fromLTRB(15,8, 15, 0),
                        child: RaisedButton(
                          textColor: Colors.white,
                          color: Color(0xff00DD00),
                          child: Text(_GENERIC_SUBMIT,style:TextStyle(fontFamily: 'Montserrat',fontWeight: FontWeight.bold)),
                          shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(8.0),),
                          onPressed:() {
                            feedback();
                          },
                        )
                    ),







                  ],
                ) )) );
  }
}


