import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:service_app/Utils/Constants.dart';
import 'package:service_app/Utils/basicsFunction.dart';
import 'package:http/http.dart' as http;
import 'package:service_app/Utils/storageUtil.dart';
import 'package:service_app/components/Textads.dart';
import 'package:service_app/components/adsimages.dart';
import 'package:service_app/screens/CusHomeFragment.dart';
import 'package:service_app/screens/CusLeadsFragment.dart';
import 'package:service_app/screens/CusProfileFragment.dart';
import 'package:service_app/screens/CusServiceFragment.dart';
import 'package:service_app/screens/LoginScreen.dart';
import 'package:url_launcher/url_launcher.dart';

class CusYoutubeFragment extends StatefulWidget {
  @override
  _CusYoutubeFragmentState createState() => _CusYoutubeFragmentState();
}

class _CusYoutubeFragmentState extends State<CusYoutubeFragment> {
/*YoutubePlayerController _controller;
void runyoutubePlayer(){
  _controller = YoutubePlayerController(

  )
}*/
  int _selectedIndex = 0;

  List youtubeList = [];
  var leadslisted,id = '', customer_id = '', status = '-', inv_no = '',attendant='-',created_date='',work_performed='',description='',customer_image_upload='';
  List<String> Names = [
    'Abhishek',
    'John',
    'Robert',
    'Shyam',
    'Sita',
    'Gita',
    'Nitish'
  ];

  youtube() async {
    String basicAuth = "Basic YWRtaW46MTIzNA==";
    //   SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    //var data = json.encode({"name":usernameController.text,"mobile_number":phonenumberController.text,"email_id":emailController.text,"password":passwordController.text});
    final response = await http.get(BASE_URL + 'get_link_details',
        headers: {'authorization': basicAuth});
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      print(jsonResponse);
      if (jsonResponse['status'] == "success") {
        setState(() {
          youtubeList = jsonResponse['data'][0]['link_datas'];
          print(youtubeList);
        });


        //  Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => CustomerDashboardScreen()), (Route<dynamic> route) => false);
      }
      //   sharedPreferences.setString("token", jsonResponse['token']);
    }
  }


/*  _launchURL() async {
     const url =  'https://www.youtube.com/watch?v=hePLDVbULZc';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  onTap: () {
  launchURL("https://www.google.com");
  },
  ..............*/
  /*launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }*/
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
    // TODO: implement initState
    super.initState();
    youtube();
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
   child: Scaffold(
      appBar: AppBar(
        leadingWidth: 110,
        centerTitle: true,
        backgroundColor: new Color(0xff004080),
        leading: Image.asset('assets/images/service_logo.png'),
        title: Text('Youtube'),
        automaticallyImplyLeading: false,
        actions: <Widget>[
          IconButton(icon: Icon(Icons.power_settings_new_rounded, color: Colors.white,), onPressed: () {_showMyDialog();}),
        ],
      ),
        body:new Column(children: <Widget>[
          Container(
          height: 80,
          width: MediaQuery.of(context).size.width,
          child:AdsImages(),
        ),
        Expanded(

            child:(youtubeList.length > 0)? ListView.builder(
              itemCount:youtubeList.length,
              itemBuilder: (context, index) =>
                  Youtube(youtubeList[index]),
            ):Center(child:  Image.asset('assets/images/loader.gif'),

            ),
    ),
          Container(
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
                          }, icon: Icon(Icons.home_outlined,                                 color: Color(0xff004080),
                          )),
                          Text('Home',   style: TextStyle(
                            color: Color(0xff004080),

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
                            color:  Color(0xffff7000)
                          ),),
                          Text('Youtube',   style: TextStyle(
                            color:  Color(0xffff7000)

                          ),),]),
                    flex:5),

              ],
            ),
          )
      ]),
    ));
  }

//youtubeList['link_data']

  @override
  Widget Youtube(youtubeList) {
    return  new Card(
                    color: Colors.white,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                  Flexible(
                      child:  Container(
                        color: Colors.black,
                         width: double.infinity,
                        height: 130,
                          child:GestureDetector(
                            onTap:()  async {
    String url = youtubeList['link_data'];
    if (await canLaunch(url)) {
    await launch(url);
    } else {
      throw 'Could not launch $url';
    }},
                          //  borderRadius: new BorderRadius.circular(24.0),
                            child: Image(
                            fit: BoxFit.fitWidth,

                              image: NetworkImage('https://i3.ytimg.com/vi/'+basicFunction.youtubevideo(youtubeList['link_data'])+'/maxresdefault.jpg'),
                              //  ZVO8Wt_PCgE/hqdefault
                            ) ),


                          ),

                 flex: 2, ),
                        Flexible(
                            child:Container(
                                padding: EdgeInsets.only(left:5.0,right: 5.0),
                                alignment: Alignment.topCenter,

                                child: Text('${youtubeList['description']}',  textAlign: TextAlign.center, overflow: TextOverflow.ellipsis,maxLines: 6,style: TextStyle(color:Color(0xff676767),fontSize: 15.0),),),flex:2),


                      ],),

    );
  }
  }

