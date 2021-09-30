import 'package:flutter/material.dart';
import 'package:iot_app/Animation/Signup.dart';
import 'package:iot_app/screens/home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  late String email, password;
  bool isLoading = false;
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

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
                      Center(
                          /*   child: Image.asset(
                            "assets/images/logo.png",
                            height: 30,
                            width: 30,
                            alignment: Alignment.center,
                          )*/
                          ),
                      SizedBox(
                        height: 13,
                      ),
                      Text("IOT APP",
                          style: TextStyle(
                              fontSize: 27,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1)),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        width: 180,
                        /*     child: Text(
                          "RRTutors, India",
                          textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white54,
                                letterSpacing: 0.6,
                                fontSize: 11),

                        ),*/
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      Text(
                        "Login",
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
                        height: 30,
                      ),
                      Form(
                        key: _formKey,
                        child: Container(
                          margin: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 25),
                          child: Column(
                            children: <Widget>[
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
                                height: 16,
                              ),
                              TextFormField(
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                                controller: _passwordController,
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
                                  email = val!;
                                },
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              Stack(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  HomeScreen()));

                                      /*       if(isLoading)
                                      {
                                        return;
                                      }
                                      if(_emailController.text.isEmpty||_passwordController.text.isEmpty)
                                      {
                                        _scaffoldKey.currentState!.showSnackBar(SnackBar(content:Text("Please Fill all fileds")));
                                        return;
                                      }
                                      login(_emailController.text,_passwordController.text);
                                      setState(() {
                                        isLoading=true;
                                      });*/
                                      //Navigator.pushReplacementNamed(context, "/home");
                                    },
                                    child: Container(
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
                                      child: Text("SUBMIT",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                              letterSpacing: 1)),
                                    ),
                                  ),
                                  Positioned(
                                    child: (isLoading)
                                        ? Center(
                                            child: Container(
                                                height: 26,
                                                width: 26,
                                                child:
                                                    CircularProgressIndicator(
                                                  backgroundColor: Colors.green,
                                                )))
                                        : Container(),
                                    right: 30,
                                    bottom: 0,
                                    top: 0,
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "OR",
                        style: TextStyle(fontSize: 14, color: Colors.white60),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      // Image.asset(
                      //   "assets/images/fingerprint.jpg",
                      //   height: 36,
                      //   width: 36,
                      // ),
                      SizedBox(
                        height: 30,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (BuildContext context) => Signup()));
                        },
                        child: Text("Don't have an account? Signup here",
                            style: TextStyle(
                                color: Colors.white70,
                                fontSize: 16,
                                decoration: TextDecoration.underline,
                                letterSpacing: 0.5)),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  void login(String text, String text2) {}

/*  login(email,password) async
  {



    Map data = {
      'email': email,
      'password': password
    };
    print(data.toString());
    final  response= await http.post(
        LOGIN,
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/x-www-form-urlencoded"
        },


        body: data,
        encoding: Encoding.getByName("utf-8")
    )  ;
    setState(() {
      isLoading=false;
    });
    if (response.statusCode == 200) {
      Map<String,dynamic>resposne=jsonDecode(response.body);
      if(!resposne['error'])
      {
        Map<String,dynamic>user=resposne['data'];
        print(" User name ${user['id']}");
        savePref(1,user['name'],user['email'],user['id']);
        Navigator.pushReplacementNamed(context, "/home");
      }else{
        print(" ${resposne['message']}");
      }
      _scaffoldKey.currentState.showSnackBar(SnackBar(content:Text("${resposne['message']}")));

    } else {
      _scaffoldKey.currentState.showSnackBar(SnackBar(content:Text("Please try again!")));
    }


  }*/
/*  savePref(int value, String name, String email, int id) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    preferences.setInt("value", value);
    preferences.setString("name", name);
    preferences.setString("email", email);
    preferences.setString("id", id.toString());
    preferences.commit();

  }*/
}
