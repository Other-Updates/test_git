import 'dart:async';

import 'package:coolincool/Screens/CustomDialog.dart';
import 'package:coolincool/Utils/Colors.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:toggle_switch/toggle_switch.dart';

class ConfirmPlaceEditOrderScreen extends StatefulWidget {
  const ConfirmPlaceEditOrderScreen({Key? key}) : super(key: key);

  @override
  _ConfirmPlaceEditOrderScreenState createState() => _ConfirmPlaceEditOrderScreenState();
}

class _ConfirmPlaceEditOrderScreenState extends State<ConfirmPlaceEditOrderScreen> {

  DatePickerController _controller = DatePickerController();

  DateTime _selectedValue = DateTime.now();
  DateTime _dateTime = DateTime.now();

  TextEditingController timeinput = TextEditingController();

  final _controller1 = TextEditingController();
  final _streamController = StreamController<int>();
  Stream<int> get _stream => _streamController.stream;
  Sink<int> get _sink => _streamController.sink;
  int initValue = 1;


  TextEditingController phoneNumberController =TextEditingController();
  TextEditingController addressController =TextEditingController();


  FocusNode myFocusNode1 = new FocusNode();
  FocusNode myFocusNode2 = new FocusNode();

  @override
  void initState() {
    // TODO: implement initState

    timeinput.text ="12:00";
    _sink.add(initValue);
    _stream.listen((event) => _controller1.text = event.toString());
      phoneNumberController.text ="+91 9086456587";
      addressController.text ="Cool in cool organic foods, Cool in cool garden, Nallakkattippalayam, Thulukkamuthur, Avinashi, Tirupur -641654";

    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        backgroundColor: Palette.PrimaryColor,
        leading: IconButton( onPressed: () {
          Navigator.pop(context);
        }, icon: Icon(Icons.arrow_back_ios_new)),

        title: Text("Edit Sales Order",style: TextStyle(fontSize: 23),),
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
                SizedBox(height: 20,),
                Container(
                    margin: EdgeInsets.only(left: 20,right: 20),
                    child:Stack(

                      children: [
                      Align(alignment:Alignment.topLeft,child:Text("Delivery Address",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16))),
                       Align(alignment:Alignment.topRight,
                           child: GestureDetector(
                         onTap:() {_optionsDialogBox(context); },
                           child:Text("Change",style: TextStyle(color:Palette.SecondaryColor,fontSize: 15)))),

                      ],
                    )),
                SizedBox(
                  height :10,
                ),
                Card(
                  margin:EdgeInsets.only(left: 20,right: 20),
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),

                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding:EdgeInsets.only(left: 15,right: 15,top: 15),
                        child: Text('Coolincool Distributor',style: TextStyle(color: Palette.BottomMenu,fontWeight: FontWeight.bold,fontSize: 16),),
                      ),
        Padding(
          padding:EdgeInsets.only(left: 15,right: 15),
          child:
                      Divider(
                        color: Palette.textlineColor,
                      ),),
        Padding(
          padding:EdgeInsets.only(left: 15,right: 15),
          child:    Text(
                        "Cool in cool organic foods, Cool in cool garden, Nallakkattippalayam, Thulukkamuthur, Avinashi, Tirupur -641654",
                        textAlign: TextAlign.start,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 3,
                        softWrap: true,
            style: TextStyle(height: 1.5,fontSize: 14 ),
                      ),),
        Padding(
          padding:EdgeInsets.only(left: 15,right: 15),
          child:
                      Divider(
                        color: Palette.textlineColor,
                      ),),
        Padding(
          padding:EdgeInsets.only(left: 15,right: 15,bottom: 10),
          child:   Text('+91 9054367678' , style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500,color:Colors.black54),),),
                    ],
                  ),
                ),
                SizedBox(height: 40,),
      Container(
          margin: EdgeInsets.only(left: 20,right: 20),
          child:Row(
            children: [
              Text("Sales Order Date",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18)),
              // Text("Products List",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18)),
            ],
          )),
      SizedBox(
        height: 20,
      ),
      Container(
        margin: EdgeInsets.only(left: 20,right: 20),
        child:DatePicker(
          DateTime.now(),
          initialSelectedDate: DateTime.now(),

          dayTextStyle: TextStyle(fontWeight: FontWeight.bold),
          dateTextStyle: TextStyle(fontWeight: FontWeight.bold),
          monthTextStyle: TextStyle(fontWeight: FontWeight.bold) ,
          selectionColor: Palette.SecondaryColor,
          selectedTextColor: Colors.white,
          onDateChange: (date) {
            // New date selected
            setState(() {
              _selectedValue = date ;
              print(_selectedValue);
            });
          },
        ),
      ),
      SizedBox(height: 30,),
      Container(
        margin: EdgeInsets.only(left: 20,right: 20),
        child: Row(
          children: [
            Text("Time",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18)),
            SizedBox(
              width: 90,
            ),
            Container(
                height: 35,
                width: 70,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.white
                ),
                child:TextField(
                  readOnly: true,
                  controller: timeinput,
                  decoration: InputDecoration(
                    border: InputBorder.none,

                    contentPadding: EdgeInsets.only(bottom: 10)
                  ),
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),
                  onTap: () async {
                    TimeOfDay? pickedTime =  await showTimePicker(
                      initialTime: TimeOfDay.now(),
                      context: context,


                    );

                    if(pickedTime != null ){
                      print(pickedTime.format(context));
                      // final format = DateFormat('HH:mm');//output 10:51 PM
                      // DateTime parsedTime = DateFormat.jm().parse(pickedTime.format(context).toString());
                      // print(parsedTime); //output 1970-01-01 22:53:00.000
                      // String formattedTime = format.format(parsedTime);


                      //  print("shdfu"+ formattedTime.toString()); //output 14:59:00
                      //DateFormat() is from intl package, you can format the time on any pattern you need.

                      setState(() {
                        timeinput.text = pickedTime.format(context) ; //set the value of text field.
                      });
                    }else{
                      print("Time is not selected");
                    }
                  },

                )   ),
            SizedBox(
              width: 10,
            ),
            ToggleSwitch(
              minWidth: 52.0,
              minHeight: 35,
              initialLabelIndex: 1,
              activeBgColor: Palette.SecondaryColor,
              activeFgColor: Colors.white,
              inactiveBgColor: Colors.white,
              inactiveFgColor: Colors.grey[900],
              labels: ['AM', 'PM'],
              onToggle: (index) {
                print('switched to: $index');
              },
            ),


            //  hourMinute12H(),
          ],
        ),
      ),
                SizedBox(
                  height: 30,
                ),
                Card(
                  margin:EdgeInsets.only(left: 20,right: 20),
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),

                  ),
                  child:    new Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment:
                          MainAxisAlignment.start,
                          children: <Widget>[
                            Flexible(
                              child: Padding(
                                  padding:
                                  EdgeInsets.only(right: 10.0,top: 25,bottom: 25),
                                  child: Container(
                                      alignment: Alignment.centerLeft,
                                      padding: EdgeInsets.only(left: 25),

                                      //   height: MediaQuery.of(context).size.height ,
                                      //  width:MediaQuery.of(context).size.width
                                      child: Text('Total Cost',style:TextStyle (color: Palette.BottomMenu,fontWeight:FontWeight.bold,fontSize:14.0,fontFamily: 'Montserrat'))
                                  )     ),
                              flex: 2,
                            ),
                            Flexible(
                              child: Padding(
                                  padding:
                                  EdgeInsets.only(right: 15.0),
                                  child: Container(
                                    alignment: Alignment.centerRight,
                                    child: Text('₹1200.00',style: TextStyle(color: Color(0xff3D3D3D),fontSize: 14,fontWeight:FontWeight.bold,fontFamily:'Montserrat')),
                                  )  ),
                              flex: 2,
                            ),
                          ] )  ),
                SizedBox(
                  height: 30,
                ),
                Container(
                    height: 80,
                    width:
                    MediaQuery.of(context)
                        .size
                        .width,
                    padding:
                    EdgeInsets.fromLTRB(
                        20, 10, 20, 18),
                    child: RaisedButton(
                      textColor: Colors.white,
                      color:
                      Palette.PrimaryColor,
                      child: Text(
                        'Save Order',
                        style: TextStyle(
                            fontFamily:
                            'Montserrat',
                            fontWeight:
                            FontWeight.bold,
                            fontSize: 17),
                      ),
                      shape:
                      RoundedRectangleBorder(
                        borderRadius:
                        new BorderRadius
                            .circular(8.0),
                      ),
                      onPressed: () {
                        _optionsDialogSuccess(context);
                      },
                    )),

   ]) )  );
  }


  Future<void> _optionsDialogBox(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
      return StatefulBuilder(
          builder: (context, setState) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0)
          ),
          content: new SingleChildScrollView(
            child: new ListBody(
              children: <Widget>[

                Align(
                  alignment: Alignment.topRight,
                  child:IconButton(onPressed: () {
                    Navigator.pop(context);
                  }, icon: Icon(Icons.close,color: Colors.red,size: 22,),

                  )
                ),
                Container(

                  margin: EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    color: Colors.black12,
                    border: Border.all(
                      color: Palette.textlineColor,
                      width: 0.5,
                    ),
                  ),
                  child: TextFormField(
                    obscureText: false,
                    autofocus: false,
                    focusNode: myFocusNode1,
                    controller: addressController,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration: InputDecoration(
                      border: InputBorder.none,

                      labelText: 'Address',
                      hintStyle: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 14),
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
                  margin: EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    color: Colors.black12,
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
                    width:
                    MediaQuery
                        .of(context)
                        .size
                        .width,
                    child: RaisedButton(
                      textColor: Colors.white,
                      color:
                      Palette.PrimaryColor,
                      child: Text(
                        'Save Changes',
                        style: TextStyle(
                            fontFamily:
                            'Montserrat',
                            fontWeight:
                            FontWeight.bold,
                            fontSize: 17),
                      ),
                      shape:
                      RoundedRectangleBorder(
                        borderRadius:
                        new BorderRadius
                            .circular(8.0),
                      ),
                      onPressed: () {

                      },
                    )),

              ],
            ),
          ),
        );
      });
        });
  }


  Future<void> _optionsDialogSuccess(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return CustomDialogBox(

            descriptions: "Changes that you made have updated Successfully",
            text: "Okay",
          );
        });
  }
}
