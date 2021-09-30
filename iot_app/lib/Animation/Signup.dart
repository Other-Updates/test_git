import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:iot_app/Animation/LoginScreen.dart';
import 'package:iot_app/screens/home_screen.dart';

class Signup extends StatefulWidget {
  const Signup({Key? key}) : super(key: key);

  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final _formKey = GlobalKey<FormState>();
  late String name, email, password, phoneNumber, confirmPassword;
  bool isLoading = false;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  var reg = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

  TextEditingController _nameController = new TextEditingController();
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();
  TextEditingController _phoneController = new TextEditingController();
  TextEditingController _confirmController = new TextEditingController();

  get GoogleFonts => null;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        body: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Stack(
              children: <Widget>[
                Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: new BoxDecoration(
                      color: const Color(0xff000000),
                      image: new DecorationImage(
                        fit: BoxFit.cover,
                        colorFilter: new ColorFilter.mode(
                            Colors.black.withOpacity(0.4), BlendMode.dstATop),
                        image: AssetImage('assets/images/kitchen.jpg'),
                      )),
                ),
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        height: 30,
                      ),
                      Text("IOT App",
                          style: TextStyle(
                              fontSize: 27,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 1)),
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        "Sign Up",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          letterSpacing: 1,
                          fontSize: 23,
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "Learn new Technologies",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white70,
                              letterSpacing: 1,
                              fontSize: 17,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Form(
                        key: _formKey,
                        child: Container(
                          margin: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 25),
                          child: Column(
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.fromLTRB(20, 5, 20, 0),
                                alignment: Alignment.topCenter,
                                child: GestureDetector(
                                    child: Align(
                                  child: Stack(children: <Widget>[
                                    CircleAvatar(
                                        radius: 45,
                                        backgroundColor: Colors.white,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(45),
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
                                            borderRadius:
                                                BorderRadius.circular(35.0),
                                            color: Color(0xffEFCC00),
                                          ),
                                          child: IconButton(
                                            alignment: Alignment.center,
                                            icon: Icon(Icons.camera_alt,
                                                size: 19.0,
                                                color: Colors.white),
                                            onPressed: () {
                                              _optionsDialogBox();
                                            },
                                          )),
                                    ),
                                  ]),
                                )),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 15.0),
                                child: TextFormField(
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                  controller: _nameController,
                                  decoration: InputDecoration(
                                    contentPadding:
                                        EdgeInsets.fromLTRB(15, 15, 5, 0),
                                    border: InputBorder.none,
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(50.0)),
                                      borderSide: BorderSide(
                                          color: Colors.white, width: 0.8),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(50.0)),
                                      borderSide: BorderSide(
                                          color: Colors.white, width: 0.8),
                                    ),
                                    hintText: "Name",
                                    hintStyle: TextStyle(
                                        color: Colors.white70, fontSize: 15),
                                  ),
                                  onSaved: (val) {
                                    name = val!;
                                  },
                                ),
                              ),
                              SizedBox(
                                height: 12,
                              ),
                              TextFormField(
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                                controller: _emailController,
                                decoration: InputDecoration(
                                  contentPadding:
                                      EdgeInsets.fromLTRB(15, 15, 5, 0),
                                  border: InputBorder.none,
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(50.0)),
                                    borderSide: BorderSide(
                                        color: Colors.white, width: 0.8),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(50.0)),
                                    borderSide: BorderSide(
                                        color: Colors.white, width: 0.8),
                                  ),
                                  hintText: "Email",
                                  hintStyle: TextStyle(
                                      color: Colors.white70, fontSize: 15),
                                ),
                                onSaved: (val) {
                                  email = val!;
                                },
                              ),
                              SizedBox(
                                height: 12,
                              ),
                              TextFormField(
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                                controller: _phoneController,
                                decoration: InputDecoration(
                                  contentPadding:
                                      EdgeInsets.fromLTRB(15, 15, 5, 0),
                                  border: InputBorder.none,
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(50.0)),
                                    borderSide: BorderSide(
                                        color: Colors.white, width: 0.8),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(50.0)),
                                    borderSide: BorderSide(
                                        color: Colors.white, width: 0.8),
                                  ),
                                  hintText: "Phone number",
                                  hintStyle: TextStyle(
                                      color: Colors.white70, fontSize: 15),
                                ),
                                onSaved: (val) {
                                  phoneNumber = val!;
                                },
                              ),
                              SizedBox(
                                height: 12,
                              ),
                              TextFormField(
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                                controller: _phoneController,
                                decoration: InputDecoration(
                                  contentPadding:
                                      EdgeInsets.fromLTRB(15, 15, 5, 0),
                                  border: InputBorder.none,
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(50.0)),
                                    borderSide: BorderSide(
                                        color: Colors.white, width: 0.8),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(50.0)),
                                    borderSide: BorderSide(
                                        color: Colors.white, width: 0.8),
                                  ),
                                  hintText: "Password",
                                  hintStyle: TextStyle(
                                      color: Colors.white70, fontSize: 15),
                                ),
                                onSaved: (val) {
                                  password = val!;
                                },
                              ),
                              SizedBox(
                                height: 12,
                              ),
                              TextFormField(
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                                controller: _confirmController,
                                decoration: InputDecoration(
                                  contentPadding:
                                      EdgeInsets.fromLTRB(15, 15, 5, 0),
                                  border: InputBorder.none,
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(50.0)),
                                    borderSide: BorderSide(
                                        color: Colors.white, width: 0.8),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(50.0)),
                                    borderSide: BorderSide(
                                        color: Colors.white, width: 0.8),
                                  ),
                                  hintText: "Confirm password",
                                  hintStyle: TextStyle(
                                      color: Colors.white70, fontSize: 15),
                                ),
                                onSaved: (val) {
                                  confirmPassword = val!;
                                },
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
                                      onTap: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder:
                                                    (BuildContext context) =>
                                                        HomeScreen()));

                                        /*         if(isLoading)
                                        {
                                          return;
                                        }
                                        if(_nameController.text.isEmpty)
                                        {
                                          _scaffoldKey.currentState.showSnackBar(SnackBar(content:Text("Please Enter Name")));
                                          return;
                                        }
                                        if(!reg.hasMatch(_emailController.text))
                                        {
                                          _scaffoldKey.currentState.showSnackBar(SnackBar(content:Text("Enter Valid Email")));
                                          return;
                                        }
                                        if(_passwordController.text.isEmpty||_passwordController.text.length<6)
                                        {
                                          _scaffoldKey.currentState.showSnackBar(SnackBar(content:Text("Password should be min 6 characters")));
                                          return;
                                        }
                                        signup(_nameController.text,_emailController.text,_passwordController.text);*/
                                      },
                                      child: Text("CREATE ACCOUNT",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                              letterSpacing: 1)),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  LoginScreen()));
                        },
                        child: Text("Already have an account? Back to login",
                            style: TextStyle(
                                color: Colors.white70,
                                fontSize: 16,
                                decoration: TextDecoration.underline,
                                letterSpacing: 0.5)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
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
