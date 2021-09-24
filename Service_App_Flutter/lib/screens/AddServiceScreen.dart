import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:service_app/Utils/Constants.dart';
import 'package:http/http.dart' as http;
import 'package:service_app/Utils/storageUtil.dart';
import 'package:service_app/components/Textads.dart';
import 'package:service_app/screens/CusHomeFragment.dart';
import 'package:service_app/screens/CusLeadsFragment.dart';
import 'package:service_app/screens/CusProfileFragment.dart';
import 'package:service_app/screens/CusServiceFragment.dart';
import 'package:service_app/screens/CusYoutubeFragment.dart';
import 'package:service_app/screens/LoginScreen.dart';
import 'package:flutter/foundation.dart';
// import 'package:path/path.dart';

class AddServiceScreen extends StatefulWidget {
//  bool get wantKeepAlive => true;
  @override
  _AddServiceScreenState createState() => _AddServiceScreenState();
}

class _AddServiceScreenState extends State<AddServiceScreen> {
  TextEditingController descriptioncontroller = TextEditingController();
  List imageupload = [];
  var _image;
  int _selectedIndex = 0;
  Future<void> _optionsDialogBox() {
    return showDialog(
        context: context,
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

  var currentDate = DateFormat('dd/MM/yyyy').format(DateTime.now());
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

  serviceadd() async {
    await getTextFromFile();

    var request = http.MultipartRequest(
      'POST',
      Uri.parse(BASE_URL + 'add_service'),
    );
    Map<String, String> headers = {
      "Authorization": basicAuth,
      "Content-type": "multipart/form-data"
    };
    request.files.add(
      http.MultipartFile(
          'name[]', _image.readAsBytes().asStream(), _image.lengthSync(),
          filename: _image.path),
    );
    print(request.files.add);
    request.headers.addAll(headers);
    request.fields.addAll({
      "customer_id": mobile_test6,
      "description": descriptioncontroller.text,
      "service_type": "warranty",
      "created_date": currentDate,
    });

    var res = await request.send();

    var response = await http.Response.fromStream(res);
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      print(jsonResponse);
      if (jsonResponse['status'] == "success") {
        Navigator.of(context).push(
          MaterialPageRoute(
              builder: (BuildContext context) => CusServiceFragment()),
        );
      } else if (jsonResponse['status'] == 'Error') {
        Navigator.pop(context);
      }
      //   sharedPreferences.setString("token", jsonResponse['token']);
    } else {
      Navigator.pop(context);
    }
  }

  customerlogout() async {
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
            MaterialPageRoute(builder: (BuildContext context) => LoginScreen()),
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getTextFromFile();
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
        child: Scaffold(
            appBar: AppBar(
              leadingWidth: 110,
              centerTitle: true,
              backgroundColor: new Color(0xff004080),
              /*   leading: new IconButton(
            alignment: Alignment.topLeft,
            icon: new Icon(Icons.arrow_back),
            onPressed: (){Navigator.pop(context,true);}
        ),*/
              leading: Image.asset('assets/images/service_logo.png'),
              title: Text('Add Service'),
              automaticallyImplyLeading: false,
              actions: <Widget>[
                //   centerTitle: true,
                IconButton(
                    icon: Icon(
                      Icons.power_settings_new_rounded,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      _showMyDialog();
                    }), //  automaticallyImplyLeading: false,
              ],
            ),
            resizeToAvoidBottomInset: false,
            body: Container(
                child: Stack(children: [
              Container(
                  alignment: Alignment.topCenter,
                  child: ListView(children: [
                    Container(
                      padding:
                          EdgeInsets.only(top: 5.0, right: 10.0, bottom: 10.0),
                      alignment: Alignment.centerRight,
                      child: Text(currentDate),
                    ),
                    Container(
                        alignment: Alignment.center,
                        child: Row(
                            //  mainAxisSize: MainAxisSize.max,
                            children: [
                              Flexible(
                                  child: Text(
                                    'Invoice No (Optional)',
                                    style: TextStyle(
                                      fontSize: 17,
                                      color: Colors.black,
                                    ),
                                  ),
                                  flex: 2),
                              Flexible(
                                  child: Container(
                                      padding: EdgeInsets.only(
                                        left: 20.0,
                                      ),
                                      // alignment: Alignment.centerRight,
                                      child: TextField(
                                        decoration: InputDecoration(
                                          contentPadding: EdgeInsets.fromLTRB(
                                              20.0, 10.0, 0.0, 10.0),
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10.0)),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10.0)),
                                            borderSide: BorderSide(
                                                color: Color(0xff004080),
                                                width: 2),
                                          ),
                                        ),
                                      )),
                                  flex: 2),
                            ])
                        /*  Expanded(child:

            imageSlider(context),flex: 2,),*/

                        ),
                    Container(
                      padding: EdgeInsets.only(bottom: 10.0, right: 5.0),
                      alignment: Alignment.topLeft,
                      child: Text(
                        'About issue :',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 17,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Container(
                        padding: EdgeInsets.only(
                            left: 2.0, right: 2.0, bottom: 10.0),
                        child: TextFormField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter about issue ';
                            }
                            return null;
                          },
                          maxLines: 2,
                          controller: descriptioncontroller,
                          decoration: InputDecoration(
                            contentPadding:
                                EdgeInsets.fromLTRB(4.0, 10.0, 20.0, 10.0),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0)),
                            focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                              borderSide: BorderSide(
                                  color: Color(0xff004080), width: 2),
                            ),
                          ),
                        )),
                    Container(
                      padding: EdgeInsets.only(bottom: 10.0),
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Image Uploaded :',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 17,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Container(
                        height: 80.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          border:
                              Border.all(color: Color(0xff004080), width: 2.0),
                        ),
                        child: Row(children: [
                          Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30.0),
                                color: Color(0xff004080),
                              ),
                              child: IconButton(
                                alignment: Alignment.centerLeft,
                                icon:
                                    Icon(Icons.camera_alt, color: Colors.white),
                                color: Color(0xff004080),
                                onPressed: () {
                                  _optionsDialogBox();
                                },
                              )),
                          Container(
                            child: (imageupload.length > 0)
                                ? ListView.builder(
                                    itemCount: imageupload.length,
                                    itemBuilder: (context, index) =>
                                        (imageupload[index]),
                                  )
                                : Center(),
                          ),
                          CircleAvatar(
                              radius: 30,
                              backgroundColor: Colors.transparent,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(55),
                                child: _image != null
                                    ? Image.file(
                                        _image,
                                        width: double.infinity,
                                        height: double.infinity,
                                        fit: BoxFit.cover,
                                      )
                                    : Container(),
                              )),
                        ])),

                    /*   Container(
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Stack(
                        children:<Widget> [

                          CircleAvatar(

                              radius: 55,
                              backgroundColor: Colors.white,
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

                        ]),),),*/
                    Container(
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                          Container(
                              alignment: Alignment.centerRight,
                              child: FlatButton(
                                onPressed: () => {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          CusServiceFragment()))
                                },
                                child: Text('CANCEL',
                                    style: TextStyle(
                                        color: Colors.red, fontSize: 20.0)),
                                textColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                        color: Colors.red,
                                        style: BorderStyle.solid),
                                    borderRadius: BorderRadius.circular(32.0)),
                              )),
                          Container(
                            padding: EdgeInsets.only(left: 20.0),
                            alignment: Alignment.centerRight,
                            child: RaisedButton(
                              onPressed: () => {
                                //profilepic(),
                                serviceadd(),
                              },
                              textColor: Colors.white,
                              color: Colors.green,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular((32.0))),
                              child: Text(
                                'SUBMIT',
                                style: TextStyle(fontSize: 20),
                              ),
                            ),
                          ),
                        ]))
                  ])),
              Container(
                  alignment: Alignment.bottomCenter,
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    Container(
                      alignment: Alignment.bottomCenter,
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
                                                  CusLeadsFragment()));
                                    },
                                    icon: Icon(
                                      Icons.perm_phone_msg_outlined,
                                      color: Color(0xff004080),
                                    )),
                                Text(
                                  'Leads',
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
                                                CusServiceFragment()));
                                  },
                                  icon: ImageIcon(
                                      AssetImage(
                                          'assets/images/paidservice.png'),
                                      // color: Color(0xFF3A5A98),
                                      color: Color(0xffff7000)),
                                ),
                                Text(
                                  'Services',
                                  style: TextStyle(color: Color(0xffff7000)),
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
                                                  CusHomeFragment()));
                                    },
                                    icon: Icon(
                                      Icons.home_outlined,
                                      color: Color(0xff004080),
                                    )),
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
                                                  CusProfileFragment()));
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
                          Expanded(
                              child: Column(children: [
                                IconButton(
                                  onPressed: () {
                                    Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                CusYoutubeFragment()));
                                  },
                                  icon: ImageIcon(
                                    AssetImage(
                                        'assets/images/youtube_logo.png'),
                                    //  color: Color(0xFF3A5A98),
                                    color: Color(0xff004080),
                                  ),
                                ),
                                Text(
                                  'Youtube',
                                  style: TextStyle(
                                    color: Color(0xff004080),
                                  ),
                                ),
                              ]),
                              flex: 5),
                        ],
                      ),
                    )
                  ]))
            ]))));
  }

  var image;
  void opencamera() async {
    image = await ImagePicker.pickImage(
        source: ImageSource.camera, imageQuality: 50);

    setState(() {
      _image = image;
      print(image);
    });
  }

  void opengallery() async {
    image = await ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 50);

    setState(() {
      _image = image;
    });
  }
}
