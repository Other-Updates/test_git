import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:iot_app/screens/profile.dart';

class EditProfileScreen extends StatefulWidget {
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  var _scaffoldKey = new GlobalKey<ScaffoldState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController dateofbirthController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  bool _displayNameValid = true;
  bool _bioValid = true;
  //Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
 // SharedPreferences _sharedPreferences;
  var customerId;
  bool _isLoading = false;

  var _GENERIC_PROFILE = ' ',
      _GENERIC_NAME = '',
      _GENERIC_DOB = '',
      _GENERIC_GENDER = ' ',
      _GENERIC_CONTINUE = '';

/*  getLanguage() async {
    _sharedPreferences = await _prefs;
    setState(() {
      _GENERIC_PROFILE =
          Language.getLocalLanguage(_sharedPreferences, "GENERIC_PROFILE");
      _GENERIC_NAME =
          Language.getLocalLanguage(_sharedPreferences, 'GENERIC_NAME');
      _GENERIC_DOB =
          Language.getLocalLanguage(_sharedPreferences, "GENERIC_DOB");
      _GENERIC_GENDER =
          Language.getLocalLanguage(_sharedPreferences, "GENERIC_GENDER");
      _GENERIC_CONTINUE =
          Language.getLocalLanguage(_sharedPreferences, "GENERIC_CONTINUE");
    });
  }

  var customerProfiledetails,id,name,mobile_number,dob,gender,email,_genderValue;

  profile() async {
    await getEditableText();
    String basicAuth = "Basic YWRtaW46MTIzNA==";
    //   SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var data = json.encode({"id": mobile_test6});
    print("dsfsget" +data);
    final response = await http.post(baseurl + 'api_profile_details',
        headers: {'authorization': basicAuth}, body: data);
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      print(jsonResponse);
      if (jsonResponse['status'] == "Success") {
        var profileDetails = jsonResponse['data'];
        setState(() {
          customerProfiledetails = profileDetails;
          id = profileDetails['id'];
          nameController.text = profileDetails['name'];
          mobile_number = profileDetails['mobile_number'];
          dateofbirthController.text = profileDetails['dob'];
          email = profileDetails['email'];
          _genderValue = int.parse(profileDetails['gender']);
          genderController.text = (profileDetails['gender']=="1")?"Male":"Female";
          print("bhjbhjhjh"+genderController.text.toString());

        });
      } else if (jsonResponse['status'] == 'Error') {
        print(jsonResponse['message']);
      }
      //   sharedPreferences.setString("token", jsonResponse['token']);
    } else {
      //   _showMessageInScaffold('Contact Admin!!');
    }
  }


  updateprofile() async {
    await getEditableText();

    if (nameController.text == "") {
      _showMessageInScaffold("Please enter name");
    } else if (dateofbirthController.text == "") {
      _showMessageInScaffold("Please enter date of birth");
    } else if (genderController.text == "") {
      _showMessageInScaffold("Please enter gender");
    }
    var data = json.encode({
      "id": id,
      "name": nameController.text,
      "dob": dateofbirthController.text,
      "gender": (_genderValue ==1)?"Male":"Female",
    });
    print(data);

    final response = await http.post(baseurl + 'api_update_profile_details',
        headers: {'authorization': basicAuth}, body: data);
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      print(jsonResponse);
      if (jsonResponse['status'] == "Success") {
        var customer_details = jsonResponse['data'];
        StorageUtil.setItem("login_customer_detail_id", customer_details['id']);
        StorageUtil.setItem(
            "login_customer_detail_name", customer_details['name']);
        StorageUtil.setItem(
            "login_customer_detail_dob", customer_details['dob']);
        StorageUtil.setItem(
            "login_customer_detail_mobile_gender", customer_details['gender']);
        StorageUtil.setItem(
            "login_customer_detail_email", customer_details['email']);
        _showMessageInScaffold(jsonResponse['message']);
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (BuildContext context) => EditAcknowledgementScreen()),
                (Route<dynamic> route) => false);
      } else if (jsonResponse['status'] == 'Error') {
        _showMessageInScaffold(jsonResponse['message']);
      }
      //   sharedPreferences.setString("token", jsonResponse['token']);
    } else {
      _showMessageInScaffold('Contact Admin!!');
    }
  }*/


  String mobile_test6 = '';
/*
  void getEditableText() async {
    try {
      String data6 = await StorageUtil.getItem("login_customer_detail_id");
      setState(() {
        mobile_test6 = data6;
      });
    } catch (ex) {
      print(ex);
    }
  }


  DateTime selectedDate = DateTime.now();
  DateFormat dateFormat = DateFormat("dd/MM/yyyy");

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1900),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        dateofbirthController.text = selectedDate.toString().substring(0, 10);
      });
  }

  void _showMessageInScaffold(String message) {
    _scaffoldKey.currentState.showSnackBar(
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
  }*/

  @override
  void initState() {
    super.initState();
   // getLanguage();
  //  profile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          leading: GestureDetector(
            onTap: () {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                      builder: (BuildContext context) =>ProfileScreen()
                  )
              );
            },

            child: Icon(
              Icons.close,
              color: Colors.white,// add custom icons also
            ),
          ),
          title: Text(
            _GENERIC_PROFILE,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
                fontFamily: 'Montserrat',
                color: Colors.white),
          ),
          centerTitle: true,
          backgroundColor: Colors.grey,
        ),
        body: Center(
            child: Container(
                color: Colors.white,
                /*   decoration: BoxDecoration(
                    image: DecorationImage(
                       // image: AssetImage('assets/images/background.png'),
                        colorFilter: ColorFilter.mode(Color(0xffF1FDF0).withOpacity(1.0), BlendMode.dstATop),

                        fit: BoxFit.cover)
                ),*/
                child: ListView(
                  children: <Widget>[
                    Container(
                      //  height: 55,
                      padding: EdgeInsets.fromLTRB(15, 8, 15, 0),
                      child: TextFormField(
                        controller: nameController,
                        showCursor: true,
                        decoration: InputDecoration(
                          isDense: true,
                          contentPadding: EdgeInsets.only(top: 5.0,bottom: 5.0),
                          prefixIcon: Icon(Icons.person_outline,
                              color: Colors.grey, size: 28),
                          hintStyle: TextStyle(color:Color(0xff747474),fontSize: 20.0),
                          hintText: 'Enter name',
                          filled: true,
                          fillColor: Colors.white,
                          enabledBorder: OutlineInputBorder(
                            borderRadius:
                            BorderRadius.all(Radius.circular(8.0)),
                            borderSide: BorderSide(
                                color: Colors.grey, width: 0.8),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius:
                            BorderRadius.all(Radius.circular(8.0)),
                            borderSide: BorderSide(
                                color: Colors.grey, width: 0.8),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      //   height: 65,
                        padding: EdgeInsets.fromLTRB(15, 8, 15, 0),
                        child: new Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Flexible(
                              child: Padding(
                                  padding: EdgeInsets.only(right: 10.0),
                                  child: TextFormField(
                                      readOnly: true,
                                      showCursor: false,
                                      cursorColor: Colors.transparent,
                                      controller: dateofbirthController,
                                      onTap: () => {
                                      //  _selectDate(context),
                                      },
                                      decoration: InputDecoration(
                                        isDense: true,
                                        //  contentPadding: EdgeInsets.fromLTRB(5, 15, 5, 0),
                                        prefixIcon: Icon(Icons.date_range,
                                            color: Colors.grey, size: 26),
                                        hintText: 'Date Of Birth',
                                        hintStyle:
                                        TextStyle(color:Color(0xff747474)),
                                        filled: true,
                                        fillColor: Colors.white,
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(8.0)),
                                          borderSide: BorderSide(
                                              color: Colors.grey,
                                              width: 0.8),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(8.0)),
                                          borderSide: BorderSide(
                                              color: Colors.grey,
                                              width: 0.8),
                                        ),
                                      ))),
                              flex: 2,
                            ),
                            Flexible(
                              child: TextFormField(
                                  readOnly: true,
                                  showCursor: false,
                                  cursorColor: Colors.transparent,
                                  controller: genderController,
                                  decoration: InputDecoration(
                                    isDense: true,
                                    prefixIcon: Icon(Icons.female,
                                        color: Colors.grey, size: 28),
                                    hintStyle: TextStyle(
                                        color:Color(0xff747474)
                                    ),
                                    hintText: 'Gender',
                                    filled: true,
                                    fillColor: Colors.white,
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(8.0)),
                                      borderSide: BorderSide(
                                          color: Colors.grey, width: 0.8),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(8.0)),
                                      borderSide: BorderSide(
                                          color: Colors.grey, width: 0.8),
                                    ),
                                  ),
                                  onTap: () {
                                    showModalBottomSheet(
                                      // isDismissible: VerticalDirection.down,
                                        enableDrag: true,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(25),
                                              topRight: Radius.circular(25)),
                                        ),
                                        isScrollControlled: true,
                                        context: context,
                                        builder: (BuildContext context) {
                                          return Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                BorderRadius.circular(18.0),
                                              ),
                                              height: 160.0,
                                              child: new ListView(
                                                children: [
                                                  Container(

                                                      padding:
                                                      EdgeInsets.fromLTRB(
                                                          12, 25, 12, 0),
                                                      child: Text('Gender',
                                                          style: TextStyle(
                                                              fontSize: 20,
                                                              color: Colors

                                                                  .black54,
                                                              fontWeight:
                                                              FontWeight
                                                                  .bold))),
                                                  Container(
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                        BorderRadius.circular(18.0),
                                                     //   color:(_genderValue ==1)?Color(0xff00DD00):Colors.white
                                                    ),
                                                    child: FlatButton(
                                                      textColor: Colors.black38,
                                                      child: Text('Male',
                                                          style: TextStyle(
                                                            fontSize: 20,
                                                            color:
                                                            Colors.black54,
                                                          )),
                                                      onPressed: () {
                                                        genderController.text = "Male";
                                                        setState(() {
                                                     //     _genderValue =1;
                                                        });
                                                        Navigator.of(context).pop();
                                                        setState(() {
                                                          _isLoading = true;
                                                          FocusScope.of(context).requestFocus(new FocusNode());
                                                        });
                                                      },
                                                    ),
                                                  ),
                                                  Container(
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                        BorderRadius.circular(18.0),
                                                   //     color:(_genderValue ==2)?Color(0xff00DD00):Colors.white
                                                    ),
                                                    child: FlatButton(
                                                      textColor: Colors.black38,
                                                      child: Text('Female',
                                                          style: TextStyle(
                                                            fontSize: 20,
                                                            color:
                                                            Colors.black54,
                                                          )),
                                                      onPressed: () {
                                                        genderController.text =
                                                        "Female";
                                                        setState(() {
                                                         // _genderValue=2;
                                                        });
                                                        Navigator.of(context)
                                                            .pop();
                                                        setState(() {
                                                          _isLoading = true;
                                                          FocusScope.of(context)
                                                              .requestFocus(
                                                              new FocusNode());
                                                        });
                                                      },
                                                    ),
                                                  ),
                                                ],
                                              ));
                                        });
                                  }),
                              flex: 2,
                            ),
                          ],
                        )),
                    Container(
                        height: 55,
                        margin: EdgeInsets.fromLTRB(15, 8, 15, 0),
                        child: RaisedButton(
                          textColor: Colors.white,
                          color: Colors.grey,
                          child: Text(_GENERIC_CONTINUE,style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 16.0),),
                          shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(8.0),
                          ),
                          onPressed: () =>  (' '),
                        )),
                  ],
                ))));
  }

}
