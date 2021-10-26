import 'dart:async';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:vnr_police/Components/Colors.dart';

// ignore: library_prefixes
import 'package:vnr_police/Screens/switcher.dart';
import 'package:vnr_police/Shared/bubble_indication_painter.dart';
import 'package:vnr_police/Utils/Routes.dart';

import 'notes.dart';

class LoginPage extends StatefulWidget {
  static final String route = '/loginPage';

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final FocusNode myFocusNodeEmailLogin = FocusNode();
  final FocusNode myFocusNodePasswordLogin = FocusNode();

  final FocusNode myFocusNodeName = FocusNode();
  final FocusNode myFocusNodeMobile = FocusNode();
  final FocusNode myFocusNodeAdhar = FocusNode();
  final FocusNode myFocusNodeDob = FocusNode();
  final FocusNode myFocusNodeAddress = FocusNode();
  final FocusNode myFocusNodePincode = FocusNode();
  final FocusNode myFocusNodeProfession = FocusNode();

  TextEditingController loginEmailController = TextEditingController();
  TextEditingController loginPasswordController = TextEditingController();

  bool _obscureTextLogin = true;
  bool _obscureTextSignup = true;
  bool _obscureTextSignupConfirm = true;

  TextEditingController signupNameController = TextEditingController();
  TextEditingController signupMobileController = TextEditingController();
  TextEditingController signupAdharController = TextEditingController();
  TextEditingController signupDobController = TextEditingController();
  TextEditingController signupAddressController = TextEditingController();
  TextEditingController signupPincodeController = TextEditingController();
  TextEditingController signupProfessionController = TextEditingController();

  late PageController _pageController;

  /* Future<void> signup() async {
    try {
      // ignore: unused_local_variable
      var userCredential =
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: signupEmailController.text,
        password: signupPasswordController.text,
      );
    } catch (e) {
      print(e);
    }
  }*/

  /* Future<void> signin(BuildContext context) async {
    try {
      // ignore: unused_local_variable
      var userCredential =
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: loginEmailController.text,
        password: loginPasswordController.text,
      );
    } catch (e) {
      print(e);
    }
    print('signin successfully!!');

    await Navigator.pushNamed(context, Switcher.route);
  }
*/
  Color left = Colors.black;
  Color right = Colors.white;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: NotificationListener<OverscrollIndicatorNotification>(
        // ignore: missing_return
        /* onNotification: (overscroll) {
          overscroll.disallowGlow();
        },*/
        child: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            // >= 775.0
            // ? MediaQuery.of(context).size.height
            // : 775.0,
            decoration: BoxDecoration(color: bg
                // begin: const FractionalOffset(0.0, 0.0),
                // end: const FractionalOffset(1.0, 1.0),
                // stops: [0.0, 1.0],
                // tileMode: TileMode.clamp),
                ),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 20.0),
                      child: AvatarGlow(
                        endRadius: 100.0,
                        glowColor: HexColor('#ea6a88'),
                        child: Container(
                          height: 120,
                          width: 120,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(1000)),
                          child: Image(
                              width: 180.0,
                              height: 180.0,
                              fit: BoxFit.fill,
                              image: AssetImage('assets/images/vnrpolice.png')),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                      child: ScaleAnimatedTextKit(
                          onTap: () {
                            print('Tap Event');
                          },
                          text: [
                            'VNR POLICE',
                          ],
                          textStyle: TextStyle(
                              fontSize: 30.0,
                              fontFamily: 'Canterbury',
                              // color: HexColor('#0b5394'),
                              color: Palette.SecondaryColor,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.start,
                          alignment: AlignmentDirectional
                              .topStart // or Alignment.topLeft
                          ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(top: 20.0),
                  child: _buildMenuBar(context),
                ),
                Expanded(
                  flex: 2,
                  child: PageView(
                    controller: _pageController,
                    onPageChanged: (i) {
                      if (i == 0) {
                        setState(() {
                          right = Colors.white;
                          left = Colors.black;
                        });
                      } else if (i == 1) {
                        setState(() {
                          right = Colors.black;
                          left = Colors.white;
                        });
                      }
                    },
                    children: <Widget>[
                      Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints.expand(),
                          child: _buildSignIn(context),
                        ),
                      ),
                      Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints.expand(),
                          child: _buildSignUp(context),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
//    myFocusNodePassword.dispose();
    // myFocusNodeEmail.dispose();
    myFocusNodeName.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    _pageController = PageController();
  }

  void showInSnackBar(String value) {
    FocusScope.of(context).requestFocus(FocusNode());
    // ignore: deprecated_member_use
    _scaffoldKey.currentState?.removeCurrentSnackBar();
    // ignore: deprecated_member_use
    _scaffoldKey.currentState!.showSnackBar(SnackBar(
      content: Text(
        value,
        textAlign: TextAlign.center,
        style: TextStyle(
            color: Colors.white,
            fontSize: 16.0,
            fontFamily: 'WorkSansSemiBold'),
      ),
      backgroundColor: Palette.PrimaryColor,
      duration: Duration(seconds: 3),
    ));
  }

  Widget _buildMenuBar(BuildContext context) {
    return Container(
      width: 300.0,
      height: 50.0,
      decoration: BoxDecoration(
        color: Color(0x552B2B2B),
        borderRadius: BorderRadius.all(Radius.circular(25.0)),
      ),
      child: CustomPaint(
        painter: TabIndicationPainter(pageController: _pageController),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Expanded(
              // ignore: deprecated_member_use
              child: FlatButton(
                splashColor: bg,
                highlightColor: Colors.red,
                onPressed: _onSignInButtonPress,
                child: Text(
                  'LOGIN',
                  style: TextStyle(
                      color: left,
                      fontSize: 16.0,
                      fontFamily: 'WorkSansSemiBold'),
                ),
              ),
            ),
            //Container(height: 33.0, width: 1.0, color: Colors.white),
            Expanded(
              // ignore: deprecated_member_use
              child: FlatButton(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onPressed: _onSignUpButtonPress,
                child: Text(
                  'SIGNUP',
                  style: TextStyle(
                      color: right,
                      fontSize: 16.0,
                      fontFamily: 'WorkSansSemiBold'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSignIn(BuildContext context) {
    return Container(
      //color: Colors.blue,
      child: ListView(
        children: <Widget>[
          Stack(
            alignment: Alignment.topCenter,
            // ignore: deprecated_member_use
            overflow: Overflow.visible,
            children: <Widget>[
              Card(
                elevation: 2.0,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Container(
                  width: 300.0,
                  height: 190.0,
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(
                            top: 20.0, bottom: 20.0, left: 25.0, right: 25.0),
                        child: TextField(
                          focusNode: myFocusNodeEmailLogin,
                          controller: loginEmailController,
                          keyboardType: TextInputType.emailAddress,
                          style: TextStyle(
                              fontFamily: 'WorkSansSemiBold',
                              fontSize: 16.0,
                              color: Colors.black),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            icon: Icon(
                              FontAwesomeIcons.mobileAlt,
                              color: Colors.black,
                              size: 22.0,
                            ),
                            hintText: 'Mobile Number',
                            hintStyle: TextStyle(
                                fontFamily: 'WorkSansSemiBold', fontSize: 17.0),
                          ),
                        ),
                      ),
                      Container(
                        width: 250.0,
                        height: 1.0,
                        color: Colors.grey[400],
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            top: 20.0, bottom: 20.0, left: 25.0, right: 25.0),
                        child: TextField(
                          focusNode: myFocusNodePasswordLogin,
                          controller: loginPasswordController,
                          obscureText: _obscureTextLogin,
                          style: TextStyle(
                              fontFamily: 'WorkSansSemiBold',
                              fontSize: 16.0,
                              color: Colors.black),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            icon: Icon(
                              Icons.lock_outline,
                              color: Colors.black,
                            ),
                            hintText: 'Password',
                            hintStyle: TextStyle(
                                fontFamily: 'WorkSansSemiBold', fontSize: 17.0),
                            suffixIcon: GestureDetector(
                              onTap: _toggleLogin,
                              child: Icon(
                                _obscureTextLogin
                                    ? FontAwesomeIcons.eye
                                    : FontAwesomeIcons.eyeSlash,
                                size: 15.0,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 170.0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                          // color: Theme.Colors.loginGradientStart,
                          // offset: Offset(1.0, 6.0),
                          // blurRadius: 20.0,
                          ),
                      BoxShadow(
                          //color: Theme.Colors.loginGradientEnd,
                          // offset: Offset(1.0, 7.0),
                          // blurRadius: 20.0,
                          ),
                    ],
                    color: Palette.SecondaryColor),
                child: MaterialButton(
                  highlightColor: Colors.transparent,
                  splashColor: Palette.SecondaryColor,
                  /*           onPressed: () {
                    if (loginEmailController.text != 'user') {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Dialog(
                                child: Text(
                                    "Authentication Details didn't match\nEmain didn't match!"),
                              )));
                    }
                    if (loginPasswordController.text != '123') {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Dialog(
                                child: Text(
                                    "Authentication Details didn't match\nPassword didn't match!"),
                              )));
                    }
                    if (loginEmailController.text == 'user' &&
                        loginPasswordController.text == '123') {
                      showInSnackBar('Signing In.. please wait');
                      Future.delayed(Duration(seconds: 1)).then((value) =>
                          Navigator.pushNamedAndRemoveUntil(
                              context, Switcher.route, (route) => false));
                    }
                  },
*/
                  //shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5.0))),
                  onPressed: () {
                    Navigator.pushNamed(context, Routes.DASHBOARD_SCREEN);
                  },
                  child: const Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 42.0),
                    child: Text(
                      'LOGIN',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 25.0,
                          fontFamily: 'WorkSansBold'),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: 5.0),
            // ignore: deprecated_member_use
            child: FlatButton(
                minWidth: 20.0,
                //color: Colors.black12,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100)),
                onPressed: () {
                  openAlertBox();
                },
                child: Text(
                  'Forgot Password?',
                  style: TextStyle(
                      //decoration: TextDecoration.underline,
                      color: Colors.brown,
                      fontSize: 16.0,
                      fontFamily: 'WorkSansMedium'),
                )),
          ),
          /*      Container(
            alignment: Alignment.center,
            child: Text(
              'OR Sign-in With',
              style: TextStyle(letterSpacing: 1.0),
            ),
          ),*/
/*          Container(
            padding: EdgeInsets.only(top: 13.0),
            alignment: Alignment.center,
            child: GestureDetector(
              onTap: () async {
                print('Google Sign in Tapped');
              //  var _gAuth = GoogleAuthenticate(context);
               // await _gAuth.loginViaGoogle();
              },
              child: Image.asset(
                'assets/google.png',
                width: 45.0,
              ),
            ),
          ),*/
          SizedBox(
            height: 20.0,
          ),
        ],
      ),
    );
  }

  Widget _buildSignUp(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(top: 23.0, bottom: 10),
        child: Column(children: <Widget>[
          Stack(
            alignment: Alignment.topCenter,
            // ignore: deprecated_member_use
            overflow: Overflow.visible,
            children: [
              // SingleChildScrollView(
              //   child:
              Container(
                padding: EdgeInsets.only(top: 23.0),
                child: Column(
                  children: <Widget>[
                    Stack(
                      alignment: Alignment.topCenter,
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      children: <Widget>[
                        Card(
                          elevation: 2.0,
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Container(
                            width: 300.0,
                            height: 300.0,
                            child: ListView(
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.only(
                                      top: 5.0,
                                      bottom: 11.0,
                                      left: 25.0,
                                      right: 25.0),
                                  child: TextField(
                                    focusNode: myFocusNodeName,
                                    controller: signupNameController,
                                    keyboardType: TextInputType.text,
                                    textCapitalization:
                                        TextCapitalization.words,
                                    style: TextStyle(
                                        fontFamily: 'WorkSansSemiBold',
                                        fontSize: 16.0,
                                        color: Colors.black),
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      icon: Icon(
                                        FontAwesomeIcons.user,
                                        color: Colors.black,
                                      ),
                                      hintText: 'Username',
                                      hintStyle: TextStyle(
                                          fontFamily: 'WorkSansSemiBold',
                                          fontSize: 16.0),
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 250.0,
                                  height: 1.0,
                                  color: Colors.grey[400],
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      top: 11.0, 
                                      bottom: 11.0,
                                      left: 25.0,
                                      right: 25.0),
                                  child: TextField(
                                    focusNode: myFocusNodeMobile,
                                    controller: signupMobileController,
                                    keyboardType: TextInputType.emailAddress,
                                    style: TextStyle(
                                        fontFamily: 'WorkSansSemiBold',
                                        fontSize: 16.0,
                                        color: Colors.black),
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      icon: Icon(
                                        FontAwesomeIcons.mobileAlt,
                                        color: Colors.black,
                                      ),
                                      hintText: 'Mobile Number',
                                      hintStyle: TextStyle(
                                          fontFamily: 'WorkSansSemiBold',
                                          fontSize: 16.0),
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 250.0,
                                  height: 1.0,
                                  color: Colors.grey[400],
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      top: 11.0,
                                      bottom: 11.0,
                                      left: 25.0,
                                      right: 25.0),
                                  child: TextField(
                                    focusNode: myFocusNodeAdhar,
                                    controller: signupAdharController,
                                    keyboardType: TextInputType.phone,
                                    style: TextStyle(
                                        fontFamily: 'WorkSansSemiBold',
                                        fontSize: 16.0,
                                        color: Colors.black),
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      icon: Icon(
                                        FontAwesomeIcons.addressCard,
                                        color: Colors.black,
                                      ),
                                      hintText: 'Adhar Number',
                                      hintStyle: TextStyle(
                                          fontFamily: 'WorkSansSemiBold',
                                          fontSize: 16.0),
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 250.0,
                                  height: 1.0,
                                  color: Colors.grey[400],
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      top: 11.0,
                                      bottom: 11.0,
                                      left: 25.0,
                                      right: 25.0),
                                  child: TextField(
                                    controller: signupDobController,
                                    //obscureText: _obscureTextSignupDob,
                                    style: TextStyle(
                                        fontFamily: 'WorkSansSemiBold',
                                        fontSize: 16.0,
                                        color: Colors.black),
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      icon: Icon(
                                        Icons.date_range,
                                        color: Colors.black,
                                      ),
                                      hintText: 'DOB',
                                      hintStyle: TextStyle(
                                          fontFamily: 'WorkSansSemiBold',
                                          fontSize: 16.0),
                                      /*             suffixIcon: GestureDetector(
                                            onTap: _toggleSignupConfirm,
                                            child: Icon(
                                              _obscureTextSignupConfirm
                                                  ? FontAwesomeIcons.eye
                                                  : FontAwesomeIcons.eyeSlash,
                                              size: 15.0,
                                              color: Colors.black,
                                            )              ,
                                          ),*/
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 250.0,
                                  height: 1.0,
                                  color: Colors.grey[400],
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      top: 11.0,
                                      bottom: 11.0,
                                      left: 25.0,
                                      right: 25.0),
                                  child: TextField(
                                    focusNode: myFocusNodeAddress,
                                    controller: signupAddressController,
                                    keyboardType: TextInputType.phone,
                                    style: TextStyle(
                                        fontFamily: 'WorkSansSemiBold',
                                        fontSize: 16.0,
                                        color: Colors.black),
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      icon: Icon(
                                        FontAwesomeIcons.mapMarkerAlt,
                                        color: Colors.black,
                                      ),
                                      hintText: 'Location',
                                      hintStyle: TextStyle(
                                          fontFamily: 'WorkSansSemiBold',
                                          fontSize: 16.0),
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 250.0,
                                  height: 1.0,
                                  color: Colors.grey[400],
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      top: 11.0,
                                      bottom: 11.0,
                                      left: 25.0,
                                      right: 25.0),
                                  child: TextField(
                                    focusNode: myFocusNodePincode,
                                    controller: signupPincodeController,
                                    keyboardType: TextInputType.phone,
                                    style: TextStyle(
                                        fontFamily: 'WorkSansSemiBold',
                                        fontSize: 16.0,
                                        color: Colors.black),
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      icon: Icon(
                                        FontAwesomeIcons.searchLocation,
                                        color: Colors.black,
                                      ),
                                      hintText: 'Pincode',
                                      hintStyle: TextStyle(
                                          fontFamily: 'WorkSansSemiBold',
                                          fontSize: 16.0),
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 250.0,
                                  height: 1.0,
                                  color: Colors.grey[400],
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      top: 11.0,
                                      bottom: 11.0,
                                      left: 25.0,
                                      right: 25.0),
                                  child: TextField(
                                    controller: signupProfessionController,
                                    // obscureText: signupProfessionController,
                                    style: TextStyle(
                                        fontFamily: 'WorkSansSemiBold',
                                        fontSize: 16.0,
                                        color: Colors.black),
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      icon: Icon(
                                        Icons.work_outline,
                                        color: Colors.black,
                                      ),
                                      hintText: 'Profession',
                                      hintStyle: TextStyle(
                                          fontFamily: 'WorkSansSemiBold',
                                          fontSize: 16.0),
                                      /*        suffixIcon: GestureDetector(
                                            onTap: _toggleSignupConfirm,
                                            child: Icon(
                                              _obscureTextSignupConfirm
                                                  ? FontAwesomeIcons.eye
                                                  : FontAwesomeIcons.eyeSlash,
                                              size: 15.0,
                                              color: Colors.black,
                                            )              ,
                                          ),*/
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 250.0,
                                  height: 1.0,
                                  color: Colors.grey[400],
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 280.0),
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5.0)),
                              boxShadow: <BoxShadow>[
                                // BoxShadow(
                                //   color: Theme.Colors.loginGradientStart,
                                //   offset: Offset(1.0, 6.0),
                                //   blurRadius: 20.0,
                                // ),
                                // BoxShadow(
                                //   color: Theme.Colors.loginGradientEnd,
                                //   offset: Offset(1.0, 6.0),
                                //   blurRadius: 20.0,
                                // ),
                              ],
                              color: Palette.SecondaryColor),
                          child: MaterialButton(
                            highlightColor: Palette.SecondaryColor,
                            splashColor: Palette.SecondaryColor,
                            onPressed: () {
                              showInSnackBar('Signing In.. please wait');
                              Future.delayed(Duration(seconds: 1)).then(
                                  (value) => Navigator.pushNamedAndRemoveUntil(
                                      context,
                                      Switcher.route,
                                      (route) => false));
                            },

                            //shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5.0))),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 42.0),
                              child: Text(
                                'SIGN UP',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 25.0,
                                    fontFamily: 'WorkSansBold'),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          )
        ]));
  }

  openAlertBox() {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(32.0))),
            contentPadding: EdgeInsets.only(top: 10.0),
            content: Container(
              // width: 300.0,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    SizedBox(
                      height: 5.0,
                    ),
                    Padding(
                        padding: EdgeInsets.all(15),
                        child: Text(
                          'Forgot password',
                          style: TextStyle(
                              color: Colors.black54,
                              fontWeight: FontWeight.bold),
                        )),
                    Container(
                      //height: 70,
                      padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                      child: TextFormField(
                        obscureText: false,
                        autofocus: false,
                        // showCursor: false,
                        //  focusNode: myFocusNode1,
                        keyboardType: TextInputType.number,
                        maxLength: 10,
                        //    controller: phoneNumberController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          counterText: "",
                          labelText: 'Mobile number',
                          /*  labelStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: myFocusNode1.hasFocus
                                  ? Colors.black54
                                  : Colors.grey),*/
                          contentPadding:
                              EdgeInsets.fromLTRB(25.0, 15.0, 20.0, 15.0),
                          //  hintStyle: TextStyle(color:Colors.grey),
                          fillColor: Colors.white,
                          enabledBorder: UnderlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(32.0)),
                            borderSide:
                                BorderSide(color: Colors.grey, width: 2),
                          ),
                          alignLabelWithHint: true,
                          focusedBorder: UnderlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(32.0)),
                            borderSide:
                                BorderSide(color: Colors.grey, width: 2),
                          ),
                          errorBorder: UnderlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(32.0)),
                            borderSide: BorderSide(color: Colors.red, width: 2),
                          ),
                          focusedErrorBorder: UnderlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(32.0)),
                            borderSide:
                                BorderSide(color: Colors.grey, width: 2),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      //height: 70,
                      padding: EdgeInsets.fromLTRB(5, 20, 5, 15),
                      child: TextFormField(
                        obscureText: false,
                        autofocus: false,
                        // showCursor: false,
                        //  focusNode: myFocusNode2,
                        keyboardType: TextInputType.number,
                        maxLength: 10,
                        //     controller: phoneNumberController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          counterText: "",
                          labelText: 'Aadhar number',
                          /*        labelStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: myFocusNode2.hasFocus
                                  ? Colors.black54
                                  : Colors.grey),*/
                          contentPadding:
                              EdgeInsets.fromLTRB(25.0, 15.0, 20.0, 15.0),
                          //  hintStyle: TextStyle(color:Colors.grey),
                          fillColor: Colors.white,
                          enabledBorder: UnderlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(32.0)),
                            borderSide:
                                BorderSide(color: Colors.grey, width: 2),
                          ),
                          alignLabelWithHint: true,
                          focusedBorder: UnderlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(32.0)),
                            borderSide:
                                BorderSide(color: Colors.grey, width: 2),
                          ),
                          errorBorder: UnderlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(32.0)),
                            borderSide: BorderSide(color: Colors.red, width: 2),
                          ),
                          focusedErrorBorder: UnderlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(32.0)),
                            borderSide:
                                BorderSide(color: Colors.grey, width: 2),
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, Routes.LOGIN_SCREEN);
                      },
                      child: Container(
                        padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                        decoration: BoxDecoration(
                          color: Palette.SecondaryColor,
                          borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(32.0),
                              bottomLeft: Radius.circular(32.0)),
                        ),
                        child: Text(
                          "SUBMIT",
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ]),
            ),
          );
        });
  }

  void _onSignInButtonPress() {
    _pageController.animateToPage(0,
        duration: Duration(milliseconds: 500), curve: Curves.decelerate);
  }

  void _onSignUpButtonPress() {
    _pageController.animateToPage(1,
        duration: Duration(milliseconds: 500), curve: Curves.decelerate);
  }

  void _toggleLogin() {
    setState(() {
      _obscureTextLogin = !_obscureTextLogin;
    });
  }

  void _toggleSignup() {
    setState(() {
      _obscureTextSignup = !_obscureTextSignup;
    });
  }

  void _toggleSignupConfirm() {
    setState(() {
      _obscureTextSignupConfirm = !_obscureTextSignupConfirm;
    });
  }
}

class FirebaseAuth {}
