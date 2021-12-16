import 'package:coolincool/Screens/CustomDialog.dart';
import 'package:coolincool/Utils/Colors.dart';
import 'package:coolincool/Utils/Menudrawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  TextEditingController userNameController =TextEditingController();
  TextEditingController mobilenumberController =TextEditingController();
  TextEditingController emailController =TextEditingController();
  TextEditingController passwordController =TextEditingController();
  TextEditingController addressController =TextEditingController();


  FocusNode myFocusNode1 = new FocusNode();
  FocusNode myFocusNode2 = new FocusNode();
  FocusNode myFocusNode3 = new FocusNode();
  FocusNode myFocusNode4 = new FocusNode();
  FocusNode myFocusNode5 = new FocusNode();

  String userTypeValue = '';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userNameController.text ="Coolincool";
    mobilenumberController.text ="+91 9086456587";
    emailController.text ="coolincoolorganicfoods@gmail.com";
    passwordController.text ="123456";
    addressController.text ="Cool in cool organic foods, Cool in cool garden, Nallakkattippalayam, Thulukkamuthur, Avinashi, Tirupur -641654";
    userTypeValue = "Distributor" ;
  }
  GlobalKey<ScaffoldState> _key = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.top]);
    return Scaffold(
      key: _key,
      resizeToAvoidBottomInset: true,
      drawer: Drawer(
        child: HomeMenuDrawer(),
      ),
      appBar: AppBar(
        backgroundColor: Palette.PrimaryColor,
        leading: IconButton( onPressed: () {
          _key.currentState!.openDrawer();
        }, icon: Image.asset("assets/images/menu.png",width: 27,height: 27,color: Colors.white,),),
        title: Text("Profile",style: TextStyle(fontSize: 23),),
        centerTitle: true,



      ),
        body: Container(
          color: Colors.black12,
          child:Column(
            children: [
              Container(
                height: 50,
                margin: EdgeInsets.only(left: 20,right: 20,top: 25,bottom: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  border: Border.all(

                        color: Palette.textlineColor,
                        width: 0.5,
                      ),
                  color: Colors.white
                ),
                child: TextFormField(
                  obscureText: false,
                  autofocus: false,
                  focusNode: myFocusNode1,
                  controller: userNameController,
                  validator: (value) {
                    String pattern = r'(^[a-zA-Z ]*$)';
                    RegExp regExp = new RegExp(pattern);
                    if (value!.isEmpty) {
                      return "Please enter your name";
                    } else if (!regExp.hasMatch(value)) {
                      return "Name must be a-z and A-Z";
                    }
                    return null;
                  },
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16,color: Palette.textColor),
                  decoration: InputDecoration(

                    border: InputBorder.none,
                    counterText: "",
                    isDense: true,
                    labelText: 'Name',
                    hintStyle: TextStyle(fontWeight: FontWeight.bold),
                    labelStyle: TextStyle(
                      //    fontWeight: FontWeight.bold,
                        fontSize: 16,

                        color:   Colors.black38
                            ),
                    contentPadding:
                    EdgeInsets.fromLTRB(20.0, 8.0, 0.0, 8.0),
                    //  hintStyle: TextStyle(color:Colors.grey),
                    fillColor: Colors.white,

                  ),
                ),
              ),

              Container(
                height: 50,
                margin: EdgeInsets.only(left: 20,right: 20,top:5,bottom: 20),
                padding: EdgeInsets.only(right: 15,top: 8),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    color: Colors.white,
                  border: Border.all(

                    color: Palette.textlineColor,
                    width: 0.5,
                  ),
                ),
                child: DropdownButtonFormField(

                  icon:Icon(Icons.arrow_drop_down_circle),
                  iconSize: 22,
                  autofocus: true,
                  iconEnabledColor: Colors.black26,
                  iconDisabledColor: Colors.black26,
                  validator: (value) {
                    if (value == 'User Type') {
                      return 'Please select usetype';
                    }
                    return null;
                  },
                  hint: userTypeValue == null
                      ? Text('Dropdown')
                      : Text(
                    userTypeValue,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16,color: Palette.textColor),
                  ),

                  decoration: InputDecoration(
                    labelText: "User Type",
                    border: InputBorder.none,
                    labelStyle: TextStyle(color: Colors.black38,fontWeight: FontWeight.bold,),
                    contentPadding:
                    EdgeInsets.fromLTRB(20.0, 0.0, 0.0, 11.0),
                    fillColor: Colors.white,

                  ),
                  items: [
                    'Distributor',
                    'Sales Man',
                  ].map(
                        (val) {
                      return DropdownMenuItem<String>(
                        value: val,
                        child: Text(val),
                      );
                    },
                  ).toList(),
                  onChanged: (val) {
                    print(userTypeValue);
                    setState(
                          () {
                        userTypeValue = val.toString();

                      },
                    );
                  },
                ),
              ),
              Container(
                height: 50,
                margin: EdgeInsets.only(left: 20,right: 20,bottom: 20),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    color: Colors.white,
                  border: Border.all(

                    color: Palette.textlineColor,
                    width: 0.5,
                  ),
                ),
                child: TextFormField(
                  obscureText: false,
                  autofocus: false,
                  maxLength: 10,
                  focusNode: myFocusNode2,
                  controller: mobilenumberController,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16,color: Palette.textColor),

                  decoration: InputDecoration(

                    border: InputBorder.none,
                    counterText: "",
                    isDense: true,
                    labelText: 'Phone Number',
                    labelStyle: TextStyle(

                        fontSize: 16,
                        color: Colors.black38),

                    contentPadding:
                    EdgeInsets.fromLTRB(20.0, 8.0, 0.0, 8.0),
                    //  hintStyle: TextStyle(color:Colors.grey),
                    fillColor: Colors.white,

                  ),
                ),
              ),
              Container(
                height: 50,
                margin: EdgeInsets.only(left: 20,right: 20,bottom: 20),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    color: Colors.white,
                  border: Border.all(

                    color: Palette.textlineColor,
                    width: 0.5,
                  ),
                ),
                child: TextFormField(
                  obscureText: false,
                  autofocus: false,
                  focusNode: myFocusNode3,
                  controller: emailController,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16,color: Palette.textColor),
                  decoration: InputDecoration(

                    border: InputBorder.none,
                    counterText: "",
                    isDense: true,
                    labelText: 'Email',
                    labelStyle: TextStyle(
                      //    fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color:Colors.black38
                            ),
                    contentPadding:
                    EdgeInsets.fromLTRB(20.0, 8.0, 0.0, 8.0),
                    //  hintStyle: TextStyle(color:Colors.grey),
                    fillColor: Colors.white,

                  ),
                ),
              ),
              Container(
                height: 50,
                margin: EdgeInsets.only(left: 20,right: 20,bottom: 20),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    color: Colors.white,
                  border: Border.all(
                    color: Palette.textlineColor,
                    width: 0.5,
                  ),
                ),
                child: TextFormField(
                  obscureText: true,
                  autofocus: false,
                  focusNode: myFocusNode4,
                  controller: passwordController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    counterText: "",
                    isDense: true,
                    labelText: 'Password',

                    labelStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.black38
                            ),
                    contentPadding:
                    EdgeInsets.fromLTRB(20.0, 8.0, 0.0, 8.0),
                    //  hintStyle: TextStyle(color:Colors.grey),
                    fillColor: Colors.white,

                  ),
                ),
              ),
              Container(

                margin: EdgeInsets.only(left: 20,right: 20,bottom: 20),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    color: Colors.white,
                  border: Border.all(
                    color: Palette.textlineColor,
                    width: 0.5,
                  ),
                ),
                child: TextFormField(
                  obscureText: false,
                  autofocus: false,
                  focusNode: myFocusNode5,
                  controller: addressController,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14,color: Palette.textColor,height: 1.5),
                  decoration: InputDecoration(
                    border: InputBorder.none,

                    labelText: 'Address',
                  //  hintStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 14,color: Palette.BottomMenu),
                    labelStyle: TextStyle(

                      //    fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.black38

                           ),
                    contentPadding:
                    EdgeInsets.fromLTRB(20.0, 8.0, 20.0, 8.0),
                    //  hintStyle: TextStyle(color:Colors.grey),
                    fillColor: Colors.white,

                  ),
                ),
              ),
            ],
          )

        ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _optionsDialogSuccess(context);
        },


        child: Icon(Icons.check,size: 36,),
        backgroundColor:Palette.PrimaryColor,
      ),
    );
  }

  Future<void> _optionsDialogSuccess(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return CustomDialogBox(

            descriptions: "Profile Details Updated Successfully",
            text: "Okay",
          );
        });
  }
}
