import 'package:flutter/material.dart';
import 'package:queuemanagement/Screens/CounterDashboard.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  // final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _passwordController = TextEditingController();

  FocusNode f1 = new FocusNode();
  FocusNode f2 = new FocusNode();
  FocusNode f3 = new FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      key: _scaffoldKey,
      body: Builder(builder: (BuildContext context) {
        return SafeArea(
          child: NotificationListener<OverscrollIndicatorNotification>(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.fromLTRB(10, 100, 10, 10),
                    child: withEmailPassword(),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget withEmailPassword() {
    return Padding(
      padding: const EdgeInsets.only(right: 16, left: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            width: double.infinity,
            child: Container(
              child: Image.asset(
                'assets/images/logo.png',
                scale: 3.5,
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            padding: EdgeInsets.only(bottom: 25),
            child: Text(
              'Login',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          TextFormField(
            focusNode: f1,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
            keyboardType: TextInputType.emailAddress,
            controller: _emailController,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.only(left: 20, top: 10, bottom: 10),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(90.0)),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.grey[350],
              hintText: 'User name',
              hintStyle: TextStyle(
                color: Colors.black26,
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            onFieldSubmitted: (value) {
              f1.unfocus();
              FocusScope.of(context).requestFocus(f2);
            },
            textInputAction: TextInputAction.next,
          ),
          SizedBox(
            height: 25.0,
          ),
          TextFormField(
            focusNode: f2,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
            //keyboardType: TextInputType.visiblePassword,
            controller: _passwordController,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.only(left: 20, top: 10, bottom: 10),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(90.0)),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.grey[350],
              hintText: 'Password',
              hintStyle: TextStyle(
                color: Colors.black26,
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            onFieldSubmitted: (value) {
              f2.unfocus();
              FocusScope.of(context).requestFocus(f3);
            },
            textInputAction: TextInputAction.done,
            // validator: (value) {
            //   if (value!.isEmpty) return 'Please enter the Passord';
            //   return null;
            // },
            obscureText: true,
          ),
          Container(
            padding: const EdgeInsets.only(top: 25.0),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                focusNode: f3,
                child: Text(
                  "Login",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () async {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (BuildContext context) => CounterDashboard()));
                },
                style: ElevatedButton.styleFrom(
                  elevation: 2,
                  primary: Colors.indigo[900],
                  onPrimary: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32.0),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  showLoaderDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: new Row(
        children: [
          CircularProgressIndicator(),
          Container(
              margin: EdgeInsets.only(left: 15), child: Text("Loading...")),
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
