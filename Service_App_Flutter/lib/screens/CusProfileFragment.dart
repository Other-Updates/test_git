// ignore: file_names
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
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
import 'package:service_app/screens/CustomerProfile.dart';
import 'package:service_app/screens/LoginScreen.dart';
import 'package:flutter_string_encryption/flutter_string_encryption.dart';
import 'package:encrypt/encrypt.dart';
import 'package:crypto/crypto.dart';
import 'package:service_app/screens/mobilelogin.dart';

class CusProfile extends StatefulWidget {
  @override
  _CusProfileState createState() => _CusProfileState();
}

class _CusProfileState extends State<CusProfile> {
  var _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  var selectedImage;
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

  final cryptor = new PlatformStringCryptor();
  // final String salt = await cryptor.generateSalt();
  // final String key = await cryptor.generateKeyFromPassword(password, salt);
  // final String encrypted =
  //     await cryptor.encrypt("Password that you want to encrypt", key);
  // final key = Key.fromUtf8('put32charactershereeeeeeeeeeeee!'); //32 chars
  // final iv = IV.fromUtf8('put16characters!');
  // String decryptMyData(String text) {
  //   final e = Encrypter(AES(key, mode: AESMode.cbc));
  //   final decrypted_data = e.decrypt(Encrypted.fromBase64(text), iv: iv);
  //   return decrypted_data;
  // }

  FocusNode myFocusNode1 = new FocusNode();
  FocusNode myFocusNode2 = new FocusNode();
  FocusNode myFocusNode3 = new FocusNode();
  FocusNode myFocusNode4 = new FocusNode();

  var profile;
  var profile1;

  TextEditingController emailController = TextEditingController();
  TextEditingController phonenumberController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  profilepic() async {
    await getTextFromFile();
    var request = http.MultipartRequest(
      'POST',
      Uri.parse(BASE_URL + 'api_customer_image_upload'),
    );
    Map<String, String> headers = {
      "Authorization": basicAuth,
      "Content-type": "multipart/form-data"
    };
    request.files.add(
      http.MultipartFile(
          'profile_image', _image.readAsBytes().asStream(), _image.lengthSync(),
          filename: _image.path),
    );

    request.headers.addAll(headers);
    request.fields.addAll({'customer_id': mobile_test1});
    print("request: " + request.toString());
    var res = await request.send();

    var response = await http.Response.fromStream(res);
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      print(jsonResponse);
      if (jsonResponse['status'] == "success") {
        print(jsonResponse['data']);
        if (response.statusCode == 200) {
          var jsonResponse = json.decode(response.body);
          print(jsonResponse);
          if (jsonResponse['status'] == "success") {
            setState(() {
              profile1 = jsonResponse['data'];

              StorageUtil.setItem("login_customer_profile_image",
                  JsonEncoder().convert(profile1['profile_image']));
            });
          } else if (jsonResponse['status'] == 'Error') {
            Navigator.pop(context);
          }
        }
      }
    }
  }

  String mobile_test1 = '';
  String mobile_test2 = '';
  String mobile_test3 = '';
  String mobile_test4 = '';
  String mobile_test5 = '';
  String mobile_test6 = '';
  String mobile_test7 = '';

  getTextFromFile() async {
    try {
      String data1 = await StorageUtil.getItem("login_customer_id");
      String data2 = await StorageUtil.getItem("login_customer_name");
      String data3 = await StorageUtil.getItem("login_customer_mobil_number");
      String data4 = await StorageUtil.getItem("login_customer_email_id");
      String data5 = await StorageUtil.getItem("login_customer_type");
      String data6 = await StorageUtil.getItem("login_customer_password");
      String data7 = await StorageUtil.getItem("login_customer_profile_image");
      setState(() {
        mobile_test1 = data1;
        mobile_test2 = data2;
        mobile_test3 = data3;
        mobile_test4 = data4;
        mobile_test5 = data5;
        mobile_test6 = data6;
        mobile_test7 = data7;
        print("udhuh" + (mobile_test6));
      });
    } catch (ex) {
      print(ex);
    }
  }

  String generateMd5(String input) {
    return md5.convert(utf8.encode(mobile_test6)).toString();
  }

  updateprofile() async {
    var data = json.encode({
      "customer_id": mobile_test1,
      "name": usernameController.text,
      "email_id": emailController.text,
      "mobile_number": phonenumberController.text,
      "password": passwordController.text
    });
    final response = await http.post(BASE_URL + 'update_customer_profile',
        headers: {'authorization': basicAuth}, body: data);
    print(data);
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      print(jsonResponse);
      if (jsonResponse['status'] == "success") {
        setState(() {
          profile = jsonResponse['data'];
          setState(() {
            StorageUtil.setItem("login_customer_id", profile['id']);
            StorageUtil.setItem("login_customer_name", profile['name']);
            StorageUtil.setItem(
                "login_customer_mobil_number", profile['mobil_number']);
            StorageUtil.setItem("login_customer_email_id", profile['email_id']);
            StorageUtil.setItem(
                "login_customer_created_date", profile['created_date']);
            StorageUtil.setItem("login_customer_password",
                JsonEncoder().convert(profile['password']));
            print("hjhgghg" + JsonEncoder().convert(profile['password']));
          });
          emailController.text = profile['email_id'];
          phonenumberController.text = profile['mobil_number'];
          usernameController.text = profile['name'];
          passwordController.text = profile['password'];
        });
      } else if (jsonResponse['status'] == 'Error') {
        Navigator.pop(context);
      }
    } else {
      Navigator.pop(context);
    }
  }

  bool username = true;
  bool email = true;
  bool mobileno = true;
  bool password = true;
  bool save = true;
  void showWidget() {
    setState(() {
      username = true;
      email = true;
      mobileno = true;
      save = false;
    });
  }

  void hideWidget() {
    setState(() {
      username = false;
      email = false;
      mobileno = false;
      save = true;
    });
  }

  late Image imageFromPreferences;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getTextFromFile().then((result) {
      setState(() {
        emailController.text = mobile_test4;
        phonenumberController.text = mobile_test3;
        usernameController.text = mobile_test2;
        passwordController.text = generateMd5(mobile_test6);
        //_image = Image.network(mobile_test7);
        print("huhaiuh" + mobile_test7);
      });
    });
  }

  var _image;

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

  customerlogout() async {
    var data = json.encode({"user_id": mobile_test1, "user_type": "2"});
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
            leading: Image.asset('assets/images/service_logo.png'),
            title: Text('Profile'),
            automaticallyImplyLeading: false,
            actions: <Widget>[
              IconButton(
                  icon: Icon(
                    Icons.power_settings_new_rounded,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    _showMyDialog();
                  }),
            ],
          ),
          key: _scaffoldKey,
          resizeToAvoidBottomInset: false,
          body: Container(
              child: Stack(
            children: [
              Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/images/serviceBolt.jpg'),
                          fit: BoxFit.cover)),
                  child: ListView(children: [
                    // Container(
                    //   padding: EdgeInsets.fromLTRB(20, 30, 20, 0),
                    //   alignment: Alignment.topCenter,
                    //   child: GestureDetector(
                    //       child: Align(
                    //     child: Stack(children: <Widget>[
                    //       CircleAvatar(
                    //           radius: 75,
                    //           backgroundColor: Colors.white,
                    //           child: ClipRRect(
                    //             borderRadius: BorderRadius.circular(75),
                    //
                    //             /*mobile_test7 != null
                    //                   ? Image.network(
                    //                       _image,
                    //                       width: double.infinity,
                    //                       height: double.infinity,
                    //                       fit: BoxFit.cover,
                    //                     )
                    //                   : */
                    //             child: _image != null
                    //                 ? Image.file(
                    //                     _image,
                    //                     width: double.infinity,
                    //                     height: double.infinity,
                    //                     fit: BoxFit.cover,
                    //                   )
                    //                 : (mobile_test7 != null)
                    //                     ? Image.network(
                    //                         mobile_test7,
                    //                         width: double.infinity,
                    //                         height: double.infinity,
                    //                         fit: BoxFit.cover,
                    //                       )
                    //                     : Image.asset(
                    //                         "assets/images/favicon.png",
                    //                         width: double.infinity,
                    //                         height: double.infinity,
                    //                         fit: BoxFit.cover,
                    //                       ),
                    //           )),
                    //
                    //       // profile['profile_image']
                    //       Positioned(
                    //         right: 2.0,
                    //         bottom: 0.0,
                    //         child: Container(
                    //             height: 35,
                    //             width: 35,
                    //             decoration: BoxDecoration(
                    //               borderRadius: BorderRadius.circular(30.0),
                    //               color: Color(0xffff7000),
                    //             ),
                    //             child: IconButton(
                    //               alignment: Alignment.center,
                    //               icon: Icon(Icons.camera_alt,
                    //                   size: 19.0, color: Colors.white),
                    //               color: Color(0xff004080),
                    //               onPressed: () {
                    //                 _optionsDialogBox();
                    //               },
                    //             )),
                    //       ),
                    //     ]),
                    //   )),
                    // ),
                    SizedBox(
                      height: 80.0,
                    ),
                    Stack(children: [
                      Container(
                        margin: EdgeInsets.only(top: 48),
                        height: 500,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                      ),
                      Align(
                          alignment: Alignment.topCenter,
                          child: SizedBox(
                            child: Stack(children: <Widget>[
                              CircleAvatar(
                                  radius: 55,
                                  backgroundColor: Colors.white,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(55),
                                    child: _image != null
                                        ? Image.file(
                                            _image,
                                            width: double.infinity,
                                            height: double.infinity,
                                            fit: BoxFit.cover,
                                          )
                                        : (mobile_test7 != null)
                                            ? Image.network(
                                                mobile_test7,
                                                width: double.infinity,
                                                height: double.infinity,
                                                fit: BoxFit.cover,
                                              )
                                            : Image.asset(
                                                "assets/images/profileIot.png",
                                                width: double.infinity,
                                                height: double.infinity,
                                                fit: BoxFit.cover,
                                              ),
                                  )),

                              // profile['profile_image']
                              Positioned(
                                right: 2.0,
                                bottom: 0.0,
                                child: Container(
                                    height: 35,
                                    width: 35,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30.0),
                                      color: Color(0xffff7000),
                                    ),
                                    child: IconButton(
                                      alignment: Alignment.center,
                                      icon: Icon(Icons.camera_alt,
                                          size: 19.0, color: Colors.white),
                                      color: Color(0xff004080),
                                      onPressed: () {
                                        _optionsDialogBox();
                                      },
                                    )),
                              ),
                            ]),
                          )),
                    ]),
                    //       Form(
                    //           key: _formKey,
                    //           child: Column(mainAxisSize: MainAxisSize.min,
                    //               //  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //               children: [
                    //                 Align(
                    //                   alignment: Alignment.centerLeft,
                    //                   child: Padding(
                    //                       padding:
                    //                           EdgeInsets.only(left: 25.0, top: 8.0),
                    //                       child: new Text(
                    //                         'Name',
                    //                         // '${mobile_test}',
                    //                         style: TextStyle(
                    //                           fontSize: 18.0,
                    //                           fontFamily: 'Montserrat',
                    //                           color: Colors.black,
                    //                           //    fontWeight: FontWeight.bold
                    //                         ),
                    //                       )),
                    //                 ),
                    //                 Padding(
                    //                   padding: EdgeInsets.only(
                    //                       left: 25.0, right: 25, bottom: 5.0),
                    //                   child: new TextFormField(
                    //                     controller: usernameController,
                    //                     obscureText: false,
                    //                     autofocus: false,
                    //                     focusNode: myFocusNode1,
                    //                     validator: (value) {
                    //                       if (value!.isEmpty) {
                    //                         return 'Please enter name';
                    //                       }
                    //                       return null;
                    //                     },
                    //                     decoration: InputDecoration(
                    //                       border: UnderlineInputBorder(
                    //                         borderSide: BorderSide(
                    //                             color: Colors.black26, width: 1),
                    //                       ),
                    //                       focusedBorder: UnderlineInputBorder(
                    //                         borderSide: BorderSide(
                    //                             color: Colors.black26, width: 1),
                    //                       ),
                    //                       errorBorder: UnderlineInputBorder(
                    //                         borderSide: BorderSide(
                    //                             color: Colors.red, width: 1),
                    //                       ),
                    //                       focusedErrorBorder: UnderlineInputBorder(
                    //                         borderSide: BorderSide(
                    //                             color: Colors.black26, width: 1),
                    //                       ),
                    //                     ),
                    //                   ),
                    //                 ),
                    //
                    //                 // Container(
                    //                 //   //height: 70,
                    //                 //   padding: EdgeInsets.fromLTRB(20, 30, 20, 0),
                    //                 //   child: TextFormField(
                    //                 //     obscureText: false,
                    //                 //     focusNode: myFocusNode1,
                    //                 //     validator: (value) {
                    //                 //       if (value!.isEmpty) {
                    //                 //         return 'Please enter name';
                    //                 //       }
                    //                 //       return null;
                    //                 //     },
                    //                 //     maxLength: 10,
                    //                 //     controller: usernameController,
                    //                 //     decoration: InputDecoration(
                    //                 //       border: InputBorder.none,
                    //                 //       counterText: "",
                    //                 //       labelText: 'Name',
                    //                 //       labelStyle: TextStyle(
                    //                 //           color: myFocusNode1.hasFocus
                    //                 //               ? Color(0xff004080)
                    //                 //               : Colors.grey),
                    //                 //       contentPadding: EdgeInsets.fromLTRB(
                    //                 //           20.0, 15.0, 20.0, 15.0),
                    //                 //       //  hintStyle: TextStyle(color:Colors.grey),
                    //                 //       fillColor: Colors.white,
                    //                 //       enabledBorder: OutlineInputBorder(
                    //                 //         borderRadius: BorderRadius.all(
                    //                 //             Radius.circular(32.0)),
                    //                 //         borderSide: BorderSide(
                    //                 //             color: Colors.grey, width: 2),
                    //                 //       ),
                    //                 //       alignLabelWithHint: true,
                    //                 //       focusedBorder: OutlineInputBorder(
                    //                 //         borderRadius: BorderRadius.all(
                    //                 //             Radius.circular(32.0)),
                    //                 //         borderSide: BorderSide(
                    //                 //             color: Colors.grey, width: 2),
                    //                 //       ),
                    //                 //       errorBorder: OutlineInputBorder(
                    //                 //         borderRadius: BorderRadius.all(
                    //                 //             Radius.circular(32.0)),
                    //                 //         borderSide: BorderSide(
                    //                 //             color: Colors.red, width: 2),
                    //                 //       ),
                    //                 //       focusedErrorBorder: OutlineInputBorder(
                    //                 //         borderRadius: BorderRadius.all(
                    //                 //             Radius.circular(32.0)),
                    //                 //         borderSide: BorderSide(
                    //                 //             color: Colors.grey, width: 2),
                    //                 //       ),
                    //                 //     ),
                    //                 //   ),
                    //                 // ),
                    //                 Align(
                    //                   alignment: Alignment.centerLeft,
                    //                   child: Padding(
                    //                       padding:
                    //                           EdgeInsets.only(left: 25.0, top: 8.0),
                    //                       child: new Text(
                    //                         'Email ID',
                    //                         // '${mobile_test}',
                    //                         style: TextStyle(
                    //                           fontSize: 18.0,
                    //                           fontFamily: 'Montserrat',
                    //                           color: Colors.black,
                    //                           //    fontWeight: FontWeight.bold
                    //                         ),
                    //                       )),
                    //                 ),
                    //                 Padding(
                    //                   padding: EdgeInsets.only(
                    //                       left: 25.0, right: 25, bottom: 5.0),
                    //                   child: new TextFormField(
                    //                     validator: (value) {
                    //                       if (value!.isEmpty) {
                    //                         return 'Please enter email';
                    //                       }
                    //                       return null;
                    //                     },
                    //                     obscureText: false,
                    //                     focusNode: myFocusNode2,
                    //                     autofocus: false,
                    //                     controller: emailController,
                    //                     decoration: InputDecoration(
                    //                       //  labelText: 'Email ID',
                    //                       border: UnderlineInputBorder(
                    //                         borderSide: BorderSide(
                    //                             color: Colors.black26, width: 1),
                    //                       ),
                    //                       focusedBorder: UnderlineInputBorder(
                    //                         borderSide: BorderSide(
                    //                             color: Colors.black26, width: 1),
                    //                       ),
                    //                       errorBorder: UnderlineInputBorder(
                    //                         borderSide: BorderSide(
                    //                             color: Colors.red, width: 1),
                    //                       ),
                    //                       focusedErrorBorder: UnderlineInputBorder(
                    //                         borderSide: BorderSide(
                    //                             color: Colors.black26, width: 1),
                    //                       ),
                    //                     ),
                    //                   ),
                    //                 ),
                    //                 //
                    //                 // Container(
                    //                 //   //  height: 70,
                    //                 //   padding: EdgeInsets.fromLTRB(20, 15, 20, 0),
                    //                 //   child: TextFormField(
                    //                 //     validator: (value) {
                    //                 //       if (value!.isEmpty) {
                    //                 //         return 'Please enter email';
                    //                 //       }
                    //                 //       return null;
                    //                 //     },
                    //                 //     obscureText: false,
                    //                 //     focusNode: myFocusNode2,
                    //                 //     controller: emailController,
                    //                 //     decoration: InputDecoration(
                    //                 //       labelText: 'Email ID',
                    //                 //       labelStyle: TextStyle(
                    //                 //           color: myFocusNode2.hasFocus
                    //                 //               ? Color(0xff004080)
                    //                 //               : Colors.grey),
                    //                 //       contentPadding: EdgeInsets.fromLTRB(
                    //                 //           20.0, 15.0, 20.0, 15.0),
                    //                 //       fillColor: Colors.white,
                    //                 //       border: OutlineInputBorder(
                    //                 //           borderRadius:
                    //                 //               BorderRadius.circular(32.0)),
                    //                 //       focusedBorder: OutlineInputBorder(
                    //                 //         borderRadius: BorderRadius.all(
                    //                 //             Radius.circular(32.0)),
                    //                 //         borderSide: BorderSide(
                    //                 //             color: Colors.grey, width: 2),
                    //                 //       ),
                    //                 //       errorBorder: OutlineInputBorder(
                    //                 //         borderRadius: BorderRadius.all(
                    //                 //             Radius.circular(32.0)),
                    //                 //         borderSide: BorderSide(
                    //                 //             color: Colors.red, width: 2),
                    //                 //       ),
                    //                 //       focusedErrorBorder: OutlineInputBorder(
                    //                 //         borderRadius: BorderRadius.all(
                    //                 //             Radius.circular(32.0)),
                    //                 //         borderSide: BorderSide(
                    //                 //             color: Colors.grey, width: 2),
                    //                 //       ),
                    //                 //     ),
                    //                 //   ),
                    //                 // ),
                    //                 Align(
                    //                   alignment: Alignment.centerLeft,
                    //                   child: Padding(
                    //                       padding:
                    //                           EdgeInsets.only(left: 25.0, top: 8.0),
                    //                       child: new Text(
                    //                         'Phone number',
                    //                         // '${mobile_test}',
                    //                         style: TextStyle(
                    //                           fontSize: 18.0,
                    //                           fontFamily: 'Montserrat',
                    //                           color: Colors.black,
                    //                           //    fontWeight: FontWeight.bold
                    //                         ),
                    //                       )),
                    //                 ),
                    //                 Padding(
                    //                   padding: EdgeInsets.only(
                    //                       left: 25.0, right: 25, bottom: 5.0),
                    //                   child: new TextFormField(
                    //                     obscureText: false,
                    //                     focusNode: myFocusNode3,
                    //                     keyboardType: TextInputType.number,
                    //                     inputFormatters: <TextInputFormatter>[
                    //                       FilteringTextInputFormatter.digitsOnly
                    //                     ],
                    //                     validator: (value) {
                    //                       if (value!.isEmpty) {
                    //                         return 'Please enter mobile number';
                    //                       } else if (value.length < 10) {
                    //                         return "Enter valid mobile number";
                    //                       }
                    //                       return null;
                    //                     },
                    //                     maxLength: 10,
                    //                     autofocus: false,
                    //                     controller: phonenumberController,
                    //                     decoration: InputDecoration(
                    //                       counterText: "",
                    //                       border: UnderlineInputBorder(
                    //                         borderSide: BorderSide(
                    //                             color: Colors.black26, width: 1),
                    //                       ),
                    //                       focusedBorder: UnderlineInputBorder(
                    //                         borderSide: BorderSide(
                    //                             color: Colors.black26, width: 1),
                    //                       ),
                    //                       errorBorder: UnderlineInputBorder(
                    //                         borderSide: BorderSide(
                    //                             color: Colors.red, width: 1),
                    //                       ),
                    //                       focusedErrorBorder: UnderlineInputBorder(
                    //                         borderSide: BorderSide(
                    //                             color: Colors.black26, width: 1),
                    //                       ),
                    //                     ),
                    //                   ),
                    //                 ),
                    //                 // Container(
                    //                 //   //height: 70,
                    //                 //   padding: EdgeInsets.fromLTRB(20, 15, 20, 0),
                    //                 //   child: TextFormField(
                    //                 //     obscureText: false,
                    //                 //     focusNode: myFocusNode3,
                    //                 //     keyboardType: TextInputType.number,
                    //                 //     inputFormatters: <TextInputFormatter>[
                    //                 //       FilteringTextInputFormatter.digitsOnly
                    //                 //     ],
                    //                 //     validator: (value) {
                    //                 //       if (value!.isEmpty) {
                    //                 //         return 'Please enter mobile number';
                    //                 //       } else if (value.length < 10) {
                    //                 //         return "Enter valid mobile number";
                    //                 //       }
                    //                 //       return null;
                    //                 //     },
                    //                 //     maxLength: 10,
                    //                 //     controller: phonenumberController,
                    //                 //     decoration: InputDecoration(
                    //                 //       border: InputBorder.none,
                    //                 //       counterText: "",
                    //                 //       labelText: 'Phone No',
                    //                 //
                    //                 //       labelStyle: TextStyle(
                    //                 //           color: myFocusNode3.hasFocus
                    //                 //               ? Color(0xff004080)
                    //                 //               : Colors.grey),
                    //                 //       contentPadding: EdgeInsets.fromLTRB(
                    //                 //           20.0, 15.0, 20.0, 15.0),
                    //                 //       //  hintStyle: TextStyle(color:Colors.grey),
                    //                 //       fillColor: Colors.white,
                    //                 //       enabledBorder: OutlineInputBorder(
                    //                 //         borderRadius: BorderRadius.all(
                    //                 //             Radius.circular(32.0)),
                    //                 //         borderSide: BorderSide(
                    //                 //             color: Colors.grey, width: 2),
                    //                 //       ),
                    //                 //       alignLabelWithHint: true,
                    //                 //       focusedBorder: OutlineInputBorder(
                    //                 //         borderRadius: BorderRadius.all(
                    //                 //             Radius.circular(32.0)),
                    //                 //         borderSide: BorderSide(
                    //                 //             color: Colors.grey, width: 2),
                    //                 //       ),
                    //                 //       errorBorder: OutlineInputBorder(
                    //                 //         borderRadius: BorderRadius.all(
                    //                 //             Radius.circular(32.0)),
                    //                 //         borderSide: BorderSide(
                    //                 //             color: Colors.red, width: 2),
                    //                 //       ),
                    //                 //       focusedErrorBorder: OutlineInputBorder(
                    //                 //         borderRadius: BorderRadius.all(
                    //                 //             Radius.circular(32.0)),
                    //                 //         borderSide: BorderSide(
                    //                 //             color: Colors.grey, width: 2),
                    //                 //       ),
                    //                 //     ),
                    //                 //   ),
                    //                 // ),
                    //                 Align(
                    //                   alignment: Alignment.centerLeft,
                    //                   child: Padding(
                    //                       padding:
                    //                           EdgeInsets.only(left: 25.0, top: 8.0),
                    //                       child: new Text(
                    //                         'Password',
                    //                         style: TextStyle(
                    //                           fontSize: 18.0,
                    //                           fontFamily: 'Montserrat',
                    //                           color: Colors.black,
                    //                           //    fontWeight: FontWeight.bold
                    //                         ),
                    //                       )),
                    //                 ),
                    //                 Padding(
                    //                   padding: EdgeInsets.only(
                    //                       left: 25.0, right: 25, bottom: 5.0),
                    //                   child: new TextFormField(
                    //                     validator: (value) {
                    //                       if (value!.isEmpty) {
                    //                         return 'Please enter password';
                    //                       }
                    //                       return null;
                    //                     },
                    //                     obscureText: true,
                    //                     focusNode: myFocusNode4,
                    //                     controller: passwordController,
                    //                     autofocus: false,
                    //                     decoration: InputDecoration(
                    //                       counterText: "",
                    //                       border: UnderlineInputBorder(
                    //                         borderSide: BorderSide(
                    //                             color: Colors.black26, width: 1),
                    //                       ),
                    //                       focusedBorder: UnderlineInputBorder(
                    //                         borderSide: BorderSide(
                    //                             color: Colors.black26, width: 1),
                    //                       ),
                    //                       errorBorder: UnderlineInputBorder(
                    //                         borderSide: BorderSide(
                    //                             color: Colors.red, width: 1),
                    //                       ),
                    //                       focusedErrorBorder: UnderlineInputBorder(
                    //                         borderSide: BorderSide(
                    //                             color: Colors.black26, width: 1),
                    //                       ),
                    //                     ),
                    //                   ),
                    //                 ),
                    //                 // Container(
                    //                 //   //    height: 70,
                    //                 //   padding: EdgeInsets.fromLTRB(20, 15, 20, 0),
                    //                 //   child: TextFormField(
                    //                 //     validator: (value) {
                    //                 //       if (value!.isEmpty) {
                    //                 //         return 'Please enter password';
                    //                 //       }
                    //                 //       return null;
                    //                 //     },
                    //                 //     obscureText: true,
                    //                 //     focusNode: myFocusNode4,
                    //                 //     controller: passwordController,
                    //                 //     decoration: InputDecoration(
                    //                 //       labelText: 'Password',
                    //                 //       labelStyle: TextStyle(
                    //                 //           color: myFocusNode4.hasFocus
                    //                 //               ? Color(0xff004080)
                    //                 //               : Colors.grey),
                    //                 //       contentPadding: EdgeInsets.fromLTRB(
                    //                 //           20.0, 15.0, 20.0, 15.0),
                    //                 //       fillColor: Colors.white,
                    //                 //       border: OutlineInputBorder(
                    //                 //           borderRadius:
                    //                 //               BorderRadius.circular(32.0)),
                    //                 //       focusedBorder: OutlineInputBorder(
                    //                 //         borderRadius: BorderRadius.all(
                    //                 //             Radius.circular(32.0)),
                    //                 //         borderSide: BorderSide(
                    //                 //             color: Colors.grey, width: 2),
                    //                 //       ),
                    //                 //       errorBorder: OutlineInputBorder(
                    //                 //         borderRadius: BorderRadius.all(
                    //                 //             Radius.circular(32.0)),
                    //                 //         borderSide: BorderSide(
                    //                 //             color: Colors.red, width: 2),
                    //                 //       ),
                    //                 //       focusedErrorBorder: OutlineInputBorder(
                    //                 //         borderRadius: BorderRadius.all(
                    //                 //             Radius.circular(32.0)),
                    //                 //         borderSide: BorderSide(
                    //                 //             color: Colors.grey, width: 2),
                    //                 //       ),
                    //                 //     ),
                    //                 //   ),
                    //                 // ),
                    //
                    //                 /*           Container(
                    //   padding: EdgeInsets.fromLTRB(30, 10, 30, 10),
                    //   child:  Text('Email',
                    //     textAlign: TextAlign.left,
                    //     style: TextStyle(
                    //       fontSize: 17,
                    //       color: Colors.grey,
                    //     ),
                    //   ),),
                    // Container(
                    //   padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
                    //   child:  TextFormField(
                    //     validator: (value) {
                    //       if (value!.isEmpty ) {
                    //         return 'Please enter email Id';
                    //       }
                    //       return null;
                    //     },
                    //     controller: emailController,
                    //     decoration: InputDecoration(
                    //       contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                    //       border: OutlineInputBorder(
                    //           borderRadius: BorderRadius.circular(32.0)
                    //       ),
                    //       focusedBorder: OutlineInputBorder(
                    //         borderRadius: BorderRadius.all(Radius.circular(32.0)),
                    //         borderSide: BorderSide(color: Color(0xff004080), width: 2),
                    //
                    //       ),
                    //     ),
                    //   ),),*/
                    //                 /*  Container(
                    //   padding: EdgeInsets.fromLTRB(30, 10, 30, 10),
                    //   child:  Text('Mobile',
                    //     textAlign: TextAlign.left,
                    //     style: TextStyle(
                    //       fontSize: 17,
                    //       color: Colors.grey,
                    //     ),
                    //   ),),
                    // Container(
                    //   padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
                    //   child:  TextFormField(
                    //     controller: phonenumberController,
                    //     maxLength: 10,
                    //     keyboardType: TextInputType.number,
                    //     inputFormatters: <TextInputFormatter>[
                    //       FilteringTextInputFormatter.digitsOnly
                    //     ],
                    //     validator: (value) {
                    //       if (value!.isEmpty ) {
                    //         return 'Please enter mobile number';
                    //       } else if (value.length < 10){
                    //         return "Enter valid mobile number";
                    //       }
                    //       return null;
                    //     },
                    //     decoration: InputDecoration(
                    //       counterText: "",
                    //       contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                    //
                    //       border: OutlineInputBorder(
                    //           borderRadius: BorderRadius.circular(32.0)
                    //
                    //       ),
                    //       focusedBorder: OutlineInputBorder(
                    //         borderRadius: BorderRadius.all(Radius.circular(32.0)),
                    //         borderSide: BorderSide(color: Color(0xff004080), width: 2),
                    //
                    //       ),
                    //     ),
                    //   ),),
                    // Container(
                    //   padding: EdgeInsets.fromLTRB(30, 10, 30, 10),
                    //   child: Text('Password',
                    //     textAlign: TextAlign.left,
                    //     style: TextStyle(
                    //       fontSize: 17,
                    //       color: Colors.grey,
                    //     ),
                    //   ),),
                    // Container(
                    //   padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
                    //   child: TextFormField(
                    //     validator: (value) {
                    //       if (value!.isEmpty ) {
                    //         return 'Please enter password';
                    //       }
                    //       return null;
                    //     },
                    //     controller: passwordController,
                    //     obscureText: true,
                    //     decoration: InputDecoration(
                    //       contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                    //
                    //       border: OutlineInputBorder(
                    //           borderRadius: BorderRadius.circular(32.0)
                    //       ),
                    //       focusedBorder: OutlineInputBorder(
                    //         borderRadius: BorderRadius.all(Radius.circular(32.0)),
                    //         borderSide: BorderSide(color: Color(0xff004080), width: 2),
                    //
                    //       ),
                    //     ),
                    //
                    //   ),)*/
                    //               ])),
                    //       Container(
                    //           height: 90,
                    //           padding: EdgeInsets.fromLTRB(30, 20, 30, 20),
                    //           child: RaisedButton(
                    //             onPressed: () => {
                    //               /*        if(usernameController.text == ""){
                    //           _showMessageInScaffold("please enter name"),
                    //         },
                    //         if(emailController.text == ""){
                    //           _showMessageInScaffold("please enter email"),
                    //         },if (emailController.text.length < 10){
                    //           _showMessageInScaffold("please enter valid email id"),
                    //         },
                    //         if(phonenumberController.text== ""){
                    //           _showMessageInScaffold  ("please enter mobile number"),
                    //         },
                    //         if(phonenumberController.text.length < 10){
                    //           _showMessageInScaffold  ("please enter valid mobile number"),
                    //         },
                    //         if(passwordController.text== ""){
                    //           _showMessageInScaffold("please enter password"),
                    //         },*/
                    //               profilepic(),
                    //               updateprofile(),
                    //             },
                    //             textColor: Colors.white,
                    //             color: Color(0xffff7000),
                    //             shape: RoundedRectangleBorder(
                    //                 borderRadius: BorderRadius.circular((32.0))),
                    //             child: Text(
                    //               'SAVE',
                    //               style: TextStyle(fontSize: 20),
                    //             ),
                    //           )),
                  ])),
              Container(
                  alignment: Alignment.bottomCenter,
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    Container(
                      height: 30,
                      // padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                      child: TextAds(),
                    ),
                    Container(
                      color: Colors.white,
                      //    alignment:Alignment.bottomCenter,
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
                                    AssetImage('assets/images/paidservice.png'),
                                    // color: Color(0xFF3A5A98),
                                    color: Color(0xff004080),
                                  ),
                                ),
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
                                      color: Color(0xffff7000),
                                    )),
                                Text(
                                  'Profile',
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
                  ])),
              /*   Container(
                alignment: Alignment.bottomCenter,
                height: 30,
                child:TextAds(),
              ),*/
            ],
          )),
        ));
  }

  /* Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);

    setState(() {
      _image = image;
    });
    //return image;
  }
  Future<void> _getImage(BuildContext context) async {
    if (_image != null) {
      var imageFile = _image;
    }
  }*/
  var image;
  void opencamera() async {
    image = await ImagePicker.pickImage(
        source: ImageSource.camera, imageQuality: 50);

    setState(() {
      _image = image;
      profilepic();
      print(image);
    });
  }

  void opengallery() async {
    image = await ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 50);

    setState(() {
      _image = image;
      profilepic();
    });
  }
}
