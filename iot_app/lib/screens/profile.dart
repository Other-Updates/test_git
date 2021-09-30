import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:iot_app/screens/EditprofileScreen.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatefulWidget {
  @override
  ProfileScreenState createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  bool _status = true;
  final FocusNode myFocusNode = FocusNode();

  TextEditingController emailController =
      TextEditingController(text: 'james@gmail.com');
  TextEditingController phonenumberController =
      TextEditingController(text: '9859658985');
  TextEditingController usernameController =
      TextEditingController(text: 'James');
  TextEditingController passwordController =
      TextEditingController(text: '* * *');
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
//    getTextFromFile();
    //  getLanguage();
    //   profile();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back,
                color: Color(0xffEFCC00) // add custom icons also
                ),
          ),
          title: Text(
            'Profile',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
                fontFamily: 'Montserrat',
                color: Colors.black54),
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0.0,
        ),
        body: new Container(
          margin: EdgeInsets.symmetric(vertical: 10, horizontal: 25),
          color: Colors.white,
          child: new ListView(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.fromLTRB(20, 5, 20, 0),
                    alignment: Alignment.topCenter,
                    child: GestureDetector(
                        child: Align(
                      child: Stack(children: <Widget>[
                        CircleAvatar(
                            radius: 55,
                            backgroundColor: Colors.white,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(55),
                              child: Image.asset(
                                "assets/images/profileIot.jpg",
                                width: double.infinity,
                                height: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            )),
                        Positioned(
                          right: 2.0,
                          bottom: 0.0,
                          child: Container(
                              height: 35,
                              width: 35,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(35.0),
                                color: Color(0xffEFCC00),
                              ),
                              child: IconButton(
                                alignment: Alignment.center,
                                icon: Icon(Icons.edit,
                                    size: 19.0, color: Colors.white),
                                onPressed: () {
                                  _optionsDialogBox();
                                },
                              )),
                        ),
                      ]),
                    )),
                  ),
                  new Container(
                    child: new Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                            padding: EdgeInsets.only(
                                left: 8.0, top: 8.0, bottom: 10.0),
                            child: new Text(
                              'Name',
                              // '${mobile_test}',
                              style: TextStyle(
                                fontSize: 18.0,
                                fontFamily: 'Montserrat',
                                color: Colors.grey,
                                //    fontWeight: FontWeight.bold
                              ),
                            )),
                        Padding(
                          padding: EdgeInsets.only(
                              left: 8.0, top: 5.0, bottom: 10.0),
                          child: new TextFormField(
                            controller: usernameController,
                            decoration: InputDecoration(
                              border: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.grey, width: 2),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.grey, width: 2),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                            padding: EdgeInsets.only(
                                left: 8.0, top: 5.0, bottom: 10.0),
                            child: new Text(
                              'Phone number',
                              // '${mobile_test}',
                              style: TextStyle(
                                fontSize: 18.0,
                                fontFamily: 'Montserrat',
                                color: Colors.grey,
                                //    fontWeight: FontWeight.bold
                              ),
                            )),
                        Padding(
                          padding: EdgeInsets.only(
                              left: 8.0, top: 5.0, bottom: 10.0),
                          child: new TextFormField(
                            controller: phonenumberController,
                            decoration: InputDecoration(
                              border: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.grey, width: 2),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.grey, width: 2),
                              ),
                            ),
                          ),
                        ),

                        Padding(
                            padding: EdgeInsets.only(
                                left: 8.0, top: 5.0, bottom: 10.0),
                            child: new Text(
                              'Email ID',
                              // '${mobile_test}',
                              style: TextStyle(
                                fontSize: 18.0,
                                fontFamily: 'Montserrat',
                                color: Colors.grey,
                                //    fontWeight: FontWeight.bold
                              ),
                            )),
                        Padding(
                          padding: EdgeInsets.only(
                              left: 8.0, top: 5.0, bottom: 10.0),
                          child: new TextFormField(
                            controller: emailController,
                            decoration: InputDecoration(
                              border: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.grey, width: 2),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.grey, width: 2),
                              ),
                            ),
                          ),
                        ),

                        Padding(
                            padding: EdgeInsets.only(
                                left: 8.0, top: 5.0, bottom: 10.0),
                            child: new Text(
                              'Password',
                              style: TextStyle(
                                fontSize: 18.0,
                                fontFamily: 'Montserrat',
                                color: Colors.grey,
                                //    fontWeight: FontWeight.bold
                              ),
                            )),
                        Padding(
                          padding: EdgeInsets.only(
                              left: 8.0, top: 5.0, bottom: 10.0),
                          child: new TextFormField(
                            controller: passwordController,
                            decoration: InputDecoration(
                              border: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.grey, width: 2),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.grey, width: 2),
                              ),
                            ),
                          ),
                        ),

                        SizedBox(
                          height: 25,
                        ),
                        Stack(
                          children: [
                            Container(
                              alignment: Alignment.center,
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 0),
                              height: 50,
                              decoration: BoxDecoration(
                                color: Color(0xffEFCC00),
                                border: Border.all(color: Colors.white),
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: InkWell(
                                onTap: () {},
                                child: Text("Save",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        letterSpacing: 1)),
                              ),
                            ),
                          ],
                        )
                        // Container(
                        //     alignment: Alignment.bottomRight,
                        //     padding: EdgeInsets.only(
                        //         top: 70.0, right: 25.0, bottom: 10.0),
                        //     child: new Row(
                        //       mainAxisAlignment: MainAxisAlignment.end,
                        //       mainAxisSize: MainAxisSize.max,
                        //       children: <Widget>[
                        //         _status ? _getEditIcon() : new Container(),
                        //       ],
                        //     )),

                        //  !_status ? _getActionButtons() : new Container(),
                      ],
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
        backgroundColor: Color(0xffEFCC00),
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
        Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) => EditProfileScreen()));
      },
    );
  }

  var _image;

  Future<void> _optionsDialogBox() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              side: BorderSide(color: Colors.transparent, width: 2),
              borderRadius: BorderRadius.circular(15.0),
            ),
            title: Text(
              'Add Photo!',
            ),
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
