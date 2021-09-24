// ignore: file_names
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import 'package:service_app/Utils/Constants.dart';
import 'package:http/http.dart' as http;

class TextAds extends StatefulWidget {
  @override
  _TextAdsState createState() => _TextAdsState();
}

class _TextAdsState extends State<TextAds> {



var images=' ';

  adsapi() async {

    String basicAuth = "Basic YWRtaW46MTIzNA==";
    //   SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    //var data = json.encode({"name":usernameController.text,"mobile_number":phonenumberController.text,"email_id":emailController.text,"password":passwordController.text});
    final response = await http.get(BASE_URL+'get_adverstisment_details', headers: {'authorization': basicAuth});
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      print(jsonResponse);
      if(jsonResponse['status'] == "success"){


     setState(() {
       images =jsonResponse['data'][0]['ads_details'][0]['ads_data'];

          });


        //  Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => CustomerDashboardScreen()), (Route<dynamic> route) => false);
      }
      //   sharedPreferences.setString("token", jsonResponse['token']);
    }

  }


  @override
  void initState() {
    super.initState();
    adsapi();
  }
  @override
  Widget build(BuildContext context) {
  return Scaffold(
    body: Align(
        alignment: Alignment.bottomCenter,
        child:  Container(
          color: Color(0xff004080),
          height: 30,
          child: new Marquee(text: ('${images}'),style: TextStyle(color: Colors.white),
              scrollAxis: Axis.horizontal,
            startAfter:Duration(seconds: 2),
            blankSpace: 15.0,
          //  pauseAfterRound: Duration(seconds: 1),
             // startPadding: 3.0

            )), ),

  );
}}

