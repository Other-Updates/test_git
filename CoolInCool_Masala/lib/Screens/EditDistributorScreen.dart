import 'package:coolincool/Screens/CustomDialog.dart';
import 'package:coolincool/Utils/Colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EditDistributorScreen extends StatefulWidget {
  const EditDistributorScreen({Key? key}) : super(key: key);

  @override
  _EditDistributorScreenState createState() => _EditDistributorScreenState();
}

class _EditDistributorScreenState extends State<EditDistributorScreen> {

  TextEditingController distributorNameController =TextEditingController();
  TextEditingController phoneNumberController =TextEditingController();
  TextEditingController companyNameController =TextEditingController();
  TextEditingController emailController =TextEditingController();
  TextEditingController addressController =TextEditingController();
  TextEditingController salesManController =TextEditingController();
  TextEditingController commissionController =TextEditingController();


  FocusNode myFocusNode1 = new FocusNode();
  FocusNode myFocusNode2 = new FocusNode();
  FocusNode myFocusNode3 = new FocusNode();
  FocusNode myFocusNode4 = new FocusNode();
  FocusNode myFocusNode5 = new FocusNode();
  FocusNode myFocusNode6 = new FocusNode();
  FocusNode myFocusNode7 = new FocusNode();
  FocusNode myFocusNode8 = new FocusNode();

  String distributorTypeValue = '';
  String referenceDistributorValue = '';
  String statusValue = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    distributorNameController.text ="Coolincool Distributor";
    distributorTypeValue ="Wholesalers";
    referenceDistributorValue ="CoolInCool";
    statusValue ="Active";
    phoneNumberController.text ="9653214785";
    companyNameController.text ="Coolincool Masala";
    emailController.text ="coolincoolmasala@gmail.com";
    addressController.text ="Cool in cool organic foods, Cool in cool garden, Nallakkattippalayam, Thulukkamuthur, Avinashi, Tirupur -641654";
    salesManController.text ="Coolincool";
    commissionController.text ="9";
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Palette.PrimaryColor,
        leading: IconButton( onPressed: () {
          Navigator.pop(context);
        }, icon: Icon(Icons.arrow_back_ios_new)),

        title: Text("Edit Distributor",style: TextStyle(fontSize: 23),),
        centerTitle: true,

        systemOverlayStyle: SystemUiOverlayStyle(
          // Navigation bar
            statusBarColor: Palette.PrimaryColor,
            statusBarBrightness: Brightness.light// Status bar
        ),

      ),
      body: Container(
          color: Colors.black12,
          child:ListView(
            children: [
              Container(
                height: 50,
                margin: EdgeInsets.only(left: 20,right: 20,top: 25,bottom: 20),
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
                  focusNode: myFocusNode1,
                  controller: distributorNameController,
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
                  decoration: InputDecoration(

                    border: InputBorder.none,
                    counterText: "",
                    isDense: true,
                    labelText: 'Distributor Name',
                    hintStyle: TextStyle(fontWeight: FontWeight.bold),
                    labelStyle: TextStyle(
                      //    fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: myFocusNode1.hasFocus
                            ? Colors.black54
                            : Colors.black54),
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
                padding: EdgeInsets.only(right: 15),
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
                  iconSize: 24,

                  autofocus: true,
                  validator: (value) {
                    if (value == 'Distributor Type') {
                      return 'Please select distributor type';
                    }
                    return null;
                  },
                  hint: distributorTypeValue == null
                      ? Text('Dropdown')
                      : Text(
                    distributorTypeValue,
                    style: TextStyle(
                      color: Colors.black54,
                    ),
                  ),

                  decoration: InputDecoration(
                    labelText: "Distributor Type",
                    labelStyle: TextStyle(color:Colors.black54),
                    border: InputBorder.none,
                    contentPadding:
                    EdgeInsets.fromLTRB(20.0, 5.0, 0.0, 8.0),
                    fillColor: Colors.white,
                    alignLabelWithHint: true,
                  ),
                  items: [
                    'wholesalers',
                    'Retailers',
                    'Agents',
                  ].map(
                        (val) {
                      return DropdownMenuItem<String>(
                        value: val,
                        child: Text(val),
                      );
                    },
                  ).toList(),
                  onChanged: (val) {
                    print(distributorTypeValue);
                    setState(
                          () {
                        distributorTypeValue = val.toString();
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
                  focusNode: myFocusNode2,
                  controller: companyNameController,
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
                  decoration: InputDecoration(

                    border: InputBorder.none,
                    counterText: "",
                    isDense: true,
                    labelText: 'Company Name',
                    hintStyle: TextStyle(fontWeight: FontWeight.bold),
                    labelStyle: TextStyle(
                      //    fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: myFocusNode2.hasFocus
                            ? Colors.black54
                            : Colors.black54),
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
                  maxLength: 10,
                  focusNode: myFocusNode3,
                  controller: phoneNumberController,

                  decoration: InputDecoration(

                    border: InputBorder.none,
                    counterText: "",
                    isDense: true,
                    labelText: 'Phone Number',

                    hintStyle: TextStyle(fontWeight: FontWeight.bold),
                    labelStyle: TextStyle(
                      //    fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: myFocusNode3.hasFocus
                            ? Colors.black54
                            : Colors.black54),
                    contentPadding: EdgeInsets.fromLTRB(20.0, 8.0, 0.0, 8.0),
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
                  focusNode: myFocusNode4,
                  controller: emailController,
                  decoration: InputDecoration(

                    border: InputBorder.none,
                    counterText: "",
                    isDense: true,
                    labelText: 'Email',
                    hintStyle: TextStyle(fontWeight: FontWeight.bold),
                    labelStyle: TextStyle(
                      //    fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: myFocusNode4.hasFocus
                            ? Colors.black54
                            : Colors.black54),
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
                  decoration: InputDecoration(
                    border: InputBorder.none,

                    labelText: 'Address',
                    hintStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    labelStyle: TextStyle(

                      //    fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: myFocusNode5.hasFocus
                            ? Colors.black54
                            : Colors.black54),
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
                padding: EdgeInsets.only(right: 15),
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
                  iconSize: 24,

                  autofocus: true,
                  validator: (value) {
                    if (value == 'Reference Distributor') {
                      return 'Please select reference distributor';
                    }
                    return null;
                  },
                  hint: referenceDistributorValue == null
                      ? Text('Dropdown')
                      : Text(
                    referenceDistributorValue,
                    style: TextStyle(
                      color: Colors.black54,
                    ),
                  ),
                  decoration: InputDecoration(
                    labelText: "Distributor Type",
                    border: InputBorder.none,
                    contentPadding:
                    EdgeInsets.fromLTRB(20.0, 0.0, 0.0, 8.0),
                    fillColor: Colors.white,
                    alignLabelWithHint: true,
                  ),
                  items: [
                    'F2F',
                    'Cool In Cool',
                  ].map(
                        (val) {
                      return DropdownMenuItem<String>(
                        value: val,
                        child: Text(val),
                      );
                    },
                  ).toList(),
                  onChanged: (val) {
                    print(referenceDistributorValue);
                    setState(
                          () {
                            referenceDistributorValue = val.toString();
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

                  autofocus: false,
                  focusNode: myFocusNode6,
                  controller: salesManController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    counterText: "",
                    isDense: true,
                    labelText: 'Sales Man',
                    hintStyle: TextStyle(fontWeight: FontWeight.bold),
                    labelStyle: TextStyle(
                      //    fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: myFocusNode6.hasFocus
                            ? Colors.black54
                            : Colors.black54),
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

                  autofocus: false,
                  focusNode: myFocusNode7,
                  controller: salesManController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    counterText: "",
                    isDense: true,
                    labelText: 'Commission',
                    hintStyle: TextStyle(fontWeight: FontWeight.bold),
                    labelStyle: TextStyle(
                      //    fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: myFocusNode7.hasFocus
                            ? Colors.black54
                            : Colors.black54),
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
                padding: EdgeInsets.only(right: 15),
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
                  iconSize: 24,
                  autofocus: true,
                  validator: (value) {
                    if (value == 'Status') {
                      return 'Please select status';
                    }
                    return null;
                  },
                  hint: statusValue == null
                      ? Text('Dropdown')
                      : Text(
                    statusValue,
                    style: TextStyle(
                      color: Colors.black54,
                    ),
                  ),
                  decoration: InputDecoration(
                    labelText: "Status",
                    border: InputBorder.none,
                    contentPadding:
                    EdgeInsets.fromLTRB(20.0, 0.0, 0.0, 8.0),
                    fillColor: Colors.white,

                  ),
                  items: [
                    'Active',
                    'Inactive',
                  ].map(
                        (val) {
                      return DropdownMenuItem<String>(
                        value: val,
                        child: Text(val),
                      );
                    },
                  ).toList(),
                  onChanged: (val) {
                    print(referenceDistributorValue);
                    setState(
                          () {
                        referenceDistributorValue = val.toString();
                      },
                    );
                  },
                ),
              ),
              SizedBox(
                height: 60,
              )
            ],
          )

      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _optionsDialogBox(context);
        },
        child: Icon(Icons.check,size: 36,),
        backgroundColor:Palette.PrimaryColor,
      ),
    );
  }

  Future<void> _optionsDialogBox(BuildContext context) {
    return showDialog(
        context: context,
  builder: (BuildContext context) {
    return CustomDialogBox(

      descriptions: "Distributor Changes Updated Successfully",
      text: "Okay",
    );
  });
  }


}

