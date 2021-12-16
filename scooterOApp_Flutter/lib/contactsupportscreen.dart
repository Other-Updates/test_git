import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:scotto/utils/Language.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ContactSupportScreen extends StatefulWidget {
  @override
  _ContactSupportScreenState createState() => _ContactSupportScreenState();
}

class _ContactSupportScreenState extends State<ContactSupportScreen> {

  var _GENERIC_CONTACT_SUPPORT_MSG_1 = ' ',_GENERIC_CONTACT_SUPPORT_MSG_2 = '', _GENERIC_SUBMIT ='' ;
  var _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController feedbackcontroller = TextEditingController();

  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  SharedPreferences _sharedPreferences;

  getLanguage() async {
    _sharedPreferences = await _prefs;
    // print(Language.getLocalLanguage(_sharedPreferences,'GENERIC_LOGIN'));
    setState(() {
      _GENERIC_CONTACT_SUPPORT_MSG_1 = Language.getLocalLanguage(_sharedPreferences, 'GENERIC_CONTACT_SUPPORT_MSG_1');
      _GENERIC_CONTACT_SUPPORT_MSG_2 = Language.getLocalLanguage(_sharedPreferences, "GENERIC_CONTACT_SUPPORT_MSG_2");
      _GENERIC_SUBMIT = Language.getLocalLanguage(_sharedPreferences, "GENERIC_SUBMIT");

    });

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
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/images/background.png'),
                        colorFilter: ColorFilter.mode(
                            Color(0xffE6FFE6).withOpacity(1.0),
                            BlendMode.dstATop),
                        fit: BoxFit.cover)),
                child: ListView(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                GestureDetector(
                    child: Container(
                      padding: EdgeInsets.only(left: 15, top: 25),
                      alignment: Alignment.topLeft,
                      child: new Icon(
                        Icons.close,
                        color: Colors.black54,
                        size: 23.0,
                      ),
                    ),
                    onTap: (){
                      Navigator.pop(context);}),
                    Container(
                      padding: EdgeInsets.only(left: 15, top: 20,right: 15),
                      child: Text(_GENERIC_CONTACT_SUPPORT_MSG_1,style: TextStyle(color: Colors.black45,fontSize: 17,fontFamily: 'Montserrat')
                      ),
                    ),
        Form(
          key: _formKey,
                 child:   Container(
                      padding: EdgeInsets.fromLTRB(15, 20, 15,20),
                      child: TextFormField(
                        keyboardType: TextInputType.multiline,
                        controller: feedbackcontroller,
                        maxLength: null,
                        maxLines: 5,
                        decoration: InputDecoration(
                          hintText: _GENERIC_CONTACT_SUPPORT_MSG_2 ,
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontFamily: 'Montserrat',
                            fontSize: 18

                          ),
                          filled: true,
                          fillColor: Colors.white,
                          enabledBorder: OutlineInputBorder(
                            borderRadius:
                            BorderRadius.all(Radius.circular(8.0)),
                            borderSide: BorderSide(
                                color: Color(0xff00DD00), width: 0.8),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius:
                            BorderRadius.all(Radius.circular(8.0)),
                            borderSide: BorderSide(
                                color: Color(0xff00DD00), width: 0.8),
                          ),
                          //  labelText: 'Password',
                        ),
                      ),
                 ) ),

                    Container(
                        height: 55,
                        padding: EdgeInsets.fromLTRB(15, 8, 15, 0),
                        child: RaisedButton(
                          textColor: Colors.white,
                          color: Color(0xff00DD00),
                          child: Text(_GENERIC_SUBMIT ,
                              style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.bold,fontSize: 18)),
                          shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(8.0),
                          ),
                          onPressed: () {
                            final isValid = _formKey.currentState.validate();
                            if (!isValid) {
                              return;
                            }
                         if(feedbackcontroller.text == "") {
                           _showMessageInScaffold("Enter issue details");
                         }else {
                           Navigator.pop(context);
                         }
                          },
                        )),
                  ],
                ))));
  }
  void _showMessageInScaffold(String message){
    _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(message), backgroundColor: Color(0xff00DD00),duration: Duration(seconds: 2),));
  }

}
