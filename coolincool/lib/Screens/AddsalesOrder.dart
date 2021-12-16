import 'dart:async';

import 'package:coolincool/Utils/Colors.dart';
import 'package:coolincool/Utils/Routes.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:intl/intl.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:toggle_switch/toggle_switch.dart';

class AddSalesOrderScreen extends StatefulWidget {

  DateTime? initialDate;

  @override
  _AddSalesOrderScreenState createState() => _AddSalesOrderScreenState();
}

class _AddSalesOrderScreenState extends State<AddSalesOrderScreen> {

  TextEditingController salesOrderNumberController =TextEditingController();
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

  String distributorValue = '';
  String productcategoryValue = '';

  DatePickerController _controller = DatePickerController();

  DateTime _selectedValue = DateTime.now();
  DateTime _dateTime = DateTime.now();

  TextEditingController timeinput = TextEditingController();

  List yesterday_distributor = [
    {
      "masala_name": "Chicken Masala",
      "vAttachment" :"assets/images/briyanipaste.png",
      "kilogram": "500g",
      "quantity": "12pcs",
      "amount": "₹ 200",
    },
    {
      "masala_name": "Chilli Chicken Powder",
      "vAttachment" :"assets/images/chickenmasala.png",
      "kilogram": "500g",
      "quantity": "12pcs",
      "amount": "₹ 250",
    },
    {
      "masala_name": "Curry Masala",
      "vAttachment" :"assets/images/CURRY_MASALA.jpg",
      "kilogram": "250g",
      "quantity": "12pcs",
      "amount": "₹ 100",
    },
    {
      "masala_name": "Fish Masala",
      "vAttachment" :"assets/images/chicken_fisj.png",
      "kilogram": "500g",
      "quantity": "12pcs",
      "amount": "₹ 200",
    },
  ];


  String radioValue = '';
  void handleRadioValueChanged(String value) {
    setState(() {
      radioValue = value;

    });
  }

  bool _isChecked = false;

  void _onChecked (bool value) {
    setState(() {
      _isChecked = value ;

    });
  }


  bool productList =false;
  bool subTotal =false;
   int? minValue;
   int? maxValue;


  final _controller1 = TextEditingController();
  final _streamController = StreamController<int>();
  Stream<int> get _stream => _streamController.stream;
  Sink<int> get _sink => _streamController.sink;
  int initValue = 1;

  DateTime? initialDate = DateTime.now();
  @override
  void initState() {
    // TODO: implement initState

    salesOrderNumberController.text ="SAL001";
    productList =false;
    _sink.add(initValue);
    _stream.listen((event) => _controller1.text = event.toString());
    selectedDate = widget.initialDate;
    super.initState();

  }
  DateTime? selectedDate;
  @override
  void dispose() {
    _streamController.close();
    _controller1.dispose();
    super.dispose();
  }
  int _itemCount = 0;
  bool pickerIsExpanded = false;
  int _pickerYear = DateTime.now().month;
  DateTime _selectedMonth = DateTime(

    DateTime.now().month,
    1,
  );

  dynamic _pickerOpen = false;

  void switchPicker() {
    setState(() {
      _pickerOpen ^= true;
    });
  }

  List<Widget> generateRowOfMonths(from, to) {
    List<Widget> months = [];
    for (int i = from; i <= to; i++) {
      DateTime dateTime = DateTime(_pickerYear, i, 1);
      final backgroundColor = dateTime.isAtSameMomentAs(_selectedMonth)
          ? Theme.of(context).accentColor
          : Colors.transparent;
      months.add(
        AnimatedSwitcher(
          duration: kThemeChangeDuration,
          transitionBuilder: (Widget child, Animation<double> animation) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
          child: TextButton(
            key: ValueKey(backgroundColor),
            onPressed: () {
              setState(() {
                _selectedMonth = dateTime;
              });
            },
            style: TextButton.styleFrom(
              backgroundColor: backgroundColor,
              shape: CircleBorder(),
            ),
            child: Text(
              DateFormat('MMM').format(dateTime),
            ),
          ),
        ),
      );
    }
    return months;
  }

  List<Widget> generateMonths() {
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: generateRowOfMonths(1, 6),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: generateRowOfMonths(7, 12),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Palette.PrimaryColor,
        leading: IconButton( onPressed: () {
          Navigator.pop(context);
        }, icon: Icon(Icons.arrow_back_ios_new)),

        title: Text("Add Sales Order",style: TextStyle(fontSize: 23),),
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
                  controller: salesOrderNumberController,
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
                    labelText: 'Sales Order Number',
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
                margin: EdgeInsets.only(left: 20,right: 20,bottom: 25),
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

                  autofocus: false,
                  validator: (value) {
                    if (value == 'Distributor Type') {
                      return 'Please select distributor type';
                    }
                    return null;
                  },
                  hint: distributorValue == null
                      ? Text('Dropdown')
                      : Text(
                    distributorValue,
                    style: TextStyle(
                      color: Colors.black54,
                    ),
                  ),
                  decoration: InputDecoration(
                    labelText: "Distributor",
                    border: InputBorder.none,
                    contentPadding:
                    EdgeInsets.fromLTRB(20.0, 0.0, 0.0, 8.0),
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
                    print(distributorValue);
                    setState(
                          () {
                        distributorValue = val.toString();
                      },
                    );
                  },
                ),
              ),
          Container(
            margin: EdgeInsets.only(left: 20,right: 20,bottom: 10),
            child: Text("Products List",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
          ),
          Container(
            margin: EdgeInsets.only(left: 20,right: 20,bottom: 10),
            child:
              Divider(
                color: Palette.textlineColor,
              ),),
              Container(
                height: 50,
                margin: EdgeInsets.only(left: 20,right: 20,top:5,bottom: 20),
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
                  autofocus: false,
                  validator: (value) {
                    if (value == 'Product Category') {
                      return 'Please select product categoryor';
                    }
                    return null;
                  },
                  hint: productcategoryValue == null
                      ? Text('Dropdown')
                      : Text(
                    productcategoryValue,
                    style: TextStyle(
                      color: Colors.black54,
                    ),
                  ),
                  decoration: InputDecoration(
                    labelText: "Product category",
                    border: InputBorder.none,
                    contentPadding:
                    EdgeInsets.fromLTRB(20.0, 0.0, 0.0, 8.0),
                    fillColor: Colors.white,
                    alignLabelWithHint: true,
                  ),
                  items: [
                    'Pure Spices',
                    'Spice Blend',
                   'Other Masala',
                    'Pickle',
                    'Premium Range Tea',
                    'Juice',
                    'Oil',
                    'Natural',
                    'Organic Food',
                    'Premium Range Of Masala'
                  ].map(
                        (val) {
                      return DropdownMenuItem<String>(
                        value: val,
                        child: Text(val),
                      );
                    },
                  ).toList(),
                  onChanged: (val) {
                    print(productcategoryValue);
                    setState(
                          () {
                        productcategoryValue = val.toString();
                        productList =true;
                      },
                    );
                  },
                ),
              ),
              Visibility(
                visible: productList,
                maintainSize: false,

                child:
                Container(

                  child: (yesterday_distributor.length > 0)
                      ? ListView.builder(
                    physics: ClampingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: yesterday_distributor.length,
                    itemBuilder: (context, index) =>
                        EachList(yesterday_distributor[index]),
                  )
                      : Center(child: Text("No Product found"),),
                  ),
              ),
              SizedBox(
                height: 8,
              ),
          Visibility(
            visible: subTotal,
            maintainSize: false,

            child: Container(
                margin: EdgeInsets.only(right: 20),
                alignment:Alignment.centerRight,
                child:       Text("SubTotal Cost :  ₹1200",style: TextStyle(color: Palette.BottomMenu,fontSize: 18,fontWeight: FontWeight.bold),),

              ),),
              SizedBox(
                height: 15,
              ),
          Container(
            margin: EdgeInsets.only(left: 20,right: 20),
          child:Row(
            children: [
            Text("Sales Order Date",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18)),
              SizedBox(
                width: 20,
              ),
              Align(
                alignment: Alignment.centerRight,
                child:   Container(
                  height: 35,
                  width: 160,


                  child:TextField(
                    readOnly: true,

                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText:   '${(selectedDate?.month == "1" )? "January" :
                        (selectedDate?.month == 2 )? "February" :(selectedDate?.month == 3 )? "March" :
                        (selectedDate?.month == 4 )? "April" :(selectedDate?.month == 5 )? "May" :
                        (selectedDate?.month == 6 )? "June" :(selectedDate?.month == 7 )? "July" :
                        (selectedDate?.month == 8 )? "August" :(selectedDate?.month == 9 )? "September" :
                        (selectedDate?.month == 10 )? "October" :(selectedDate?.month == 11 )? "November" :
                        "December"}' ,
                        hintStyle: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),
                        contentPadding: EdgeInsets.only(left: 30),
                        suffixIcon: IconButton(
                          alignment: Alignment.center,

                          icon: Icon(Icons.arrow_drop_down,size: 22,color: Palette.textColor,), onPressed: () {
                          showMonthPicker(
                            context: context,
                            firstDate: DateTime(DateTime.now().year - 50, 5),
                            lastDate: DateTime(DateTime.now().year + 50, 9),
                            initialDate:  DateTime.now()  ,

                          ).then((date) {
                            if (date != null) {
                              setState(() {
                                selectedDate = date;
                              });
                            }
                          });

                        },
                        )
                    ),
                    style: TextStyle(color: Colors.blue , fontSize: 19),
                    onTap: () async {
                      showMonthPicker(
                        context: context,
                        firstDate: DateTime(DateTime.now().year - 50, 5),
                        lastDate: DateTime(DateTime.now().year + 50, 9),
                        initialDate:  DateTime.now()  ,

                      ).then((date) {
                        if (date != null) {
                          setState(() {
                            selectedDate = date;
                          });
                        }
                      });


                    },

                  )  ))
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
              SizedBox(height: 20,),
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
                      textAlign: TextAlign.center,
                      readOnly: true,
                      controller: timeinput,
                      decoration: InputDecoration(
                        border: InputBorder.none,
contentPadding: EdgeInsets.only(bottom: 12),
                      ),
                      style: TextStyle(color: Colors.black),
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
                            timeinput.text = pickedTime.format(context); //set the value of text field.
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
              Container(
                  height: 65,
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.fromLTRB(25, 15, 25, 0),
                  child: RaisedButton(
                    textColor: Colors.white,
                    color: Palette.PrimaryColor,
                    child: Text('Save Order',
                        style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold,fontSize: 18)),
                    shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(15.0),
                    ),
                    onPressed: () {
                      showModalBottomSheet(
                          isScrollControlled: true,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(50),
                                topRight: Radius.circular(50)),
                          ),
                          context: context,

                          builder: (BuildContext context) {
                            return StatefulBuilder(
                                builder: (BuildContext context, StateSetter setState ) {
                                  return Padding(
                                      padding: MediaQuery.of(context)
                                          .viewInsets,
                                      child: new Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          Container(
                                              padding:
                                              EdgeInsets.fromLTRB(
                                                  20, 40, 20, 0),
                                              alignment:
                                              Alignment.centerLeft,
                                              child: Text(
                                                  'Check Out',
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      color: Palette.BottomMenu,
                                                      fontFamily:
                                                      'Montserrat',
                                                      fontWeight:
                                                      FontWeight
                                                          .bold))),
                                          Container(
                                              padding:
                                              EdgeInsets.fromLTRB(
                                                  20, 15, 20, 0),
                                              alignment:
                                              Alignment.centerLeft,
                                              child: Text(
                                                  'Delivery Method',
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      color: Palette.BottomMenu,
                                                      fontFamily:
                                                      'Montserrat',
                                                      fontWeight:
                                                      FontWeight
                                                          .bold))),
                                          Card(
                                            margin: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0),
                                            color: Color(0xffDEDEDE),
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0),side: BorderSide(color: Colors.white,width: 3)),

                                            child: new Column(children: [

                                              Container(
                                                  padding: EdgeInsets.only(left: 12),
                                                  child: new Row(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      children: <Widget>[

                                                        Flexible(
                                                          child: Container(
                                                              child: new Radio(
                                                                autofocus: true,
                                                                value: 'doorDelivery',
                                                                groupValue: radioValue,
                                                                hoverColor: Palette.SecondaryColor,
                                                                focusColor: Palette.SecondaryColor,
                                                                activeColor:
                                                                Palette.SecondaryColor,
                                                                onChanged: (String? value) {
                                                                  setState(() {
                                                                    handleRadioValueChanged(
                                                                        value!);
                                                                  });

                                                                },
                                                              )),
                                                          flex: 2,
                                                        ),
                                                        Flexible(
                                                          child: Container(
                                                            child: new Text(
                                                              'Door delivery',
                                                              textAlign: TextAlign.left,
                                                              style: TextStyle(
                                                                  color: Palette.BottomMenu,
                                                                  fontWeight: FontWeight.bold,
                                                                  fontSize: 16.0
                                                              ),
                                                            ),
                                                          ),
                                                          flex: 2,
                                                        ),
                                                      ])),



                                              Container(
                                                  padding: EdgeInsets.only(left: 12),
                                                  child: new Row(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      children: <Widget>[
                                                        Flexible(
                                                          child: Container(
                                                            child: new Radio(
                                                              autofocus: true,
                                                              value: 'pickup',
                                                              groupValue: radioValue,
                                                              hoverColor: Palette.SecondaryColor,
                                                              focusColor: Palette.SecondaryColor,
                                                              activeColor: Palette.SecondaryColor,
                                                              onChanged: (String? value) {
                                                                setState(() {
                                                                  handleRadioValueChanged(
                                                                      value!);
                                                                });
                                                              },
                                                            ),
                                                          ),
                                                          flex: 2,
                                                        ),
                                                        Flexible(
                                                          child: Container(
                                                            child: new Text(
                                                              'Pick up',
                                                              textAlign: TextAlign.left,
                                                              style: TextStyle(
                                                                  color: Palette.BottomMenu,
                                                                  fontWeight: FontWeight.bold,
                                                                  fontSize: 16.0),
                                                              //    "${questionBank[_counter.toString()]["ans2"]}")
                                                              //  ],
                                                            ),
                                                          ),
                                                          flex: 2,
                                                        ),

                                                      ])),


                                            ]),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(left: 20,right: 20),
                                            child:
                                            Divider(
                                              color: Palette.textlineColor,
                                            ),),
                                          Container(
                                              padding: EdgeInsets.only(top:5,left: 20,right: 20,bottom: 5),
                                              child: new Row(
                                                  mainAxisSize: MainAxisSize.max,
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                                  children: <Widget>[
                                                    Flexible(
                                                      child: Padding(
                                                          padding:
                                                          EdgeInsets.only(right: 10.0),
                                                          child: Container(
                                                              alignment: Alignment.centerLeft,
                                                              padding: EdgeInsets.only(left: 15),

                                                              //   height: MediaQuery.of(context).size.height ,
                                                              //  width:MediaQuery.of(context).size.width
                                                              child: Text('Subtotal',style:TextStyle (color:Palette.BottomMenu,fontFamily: 'Montserrat',fontSize: 13.0))
                                                          )     ),
                                                      flex: 2,
                                                    ),
                                                    Flexible(
                                                      child: Padding(
                                                          padding: EdgeInsets.only(right: 15.0),
                                                          child: Container(
                                                            alignment: Alignment.centerRight,
                                                            child: Text('₹1000.00',style: TextStyle(color: Color(0xff3D3D3D),fontSize: 14,fontFamily:'Montserrat',fontWeight: FontWeight.bold)),
                                                          )  ),
                                                      flex: 2,
                                                    ),
                                                  ] )  ),
                                          Container(
                                            margin: EdgeInsets.only(left: 20,right: 20),
                                            child:
                                            Divider(
                                              color: Palette.textlineColor,
                                            ),),
                                          Container(
                                              padding: EdgeInsets.only(top:5,left: 20,right: 20,bottom: 5),
                                              child: new Row(
                                                  mainAxisSize: MainAxisSize.max,
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                                  children: <Widget>[
                                                    Flexible(
                                                      child: Padding(
                                                          padding:
                                                          EdgeInsets.only(right: 10.0),
                                                          child: Container(
                                                              alignment: Alignment.centerLeft,
                                                              padding: EdgeInsets.only(left: 15),

                                                              //   height: MediaQuery.of(context).size.height ,
                                                              //  width:MediaQuery.of(context).size.width
                                                              child: Text('Taxes And Charges',style:TextStyle (color: Palette.BottomMenu,fontSize:13.0,fontFamily: 'Montserrat'))
                                                          )     ),
                                                      flex: 2,
                                                    ),
                                                    Flexible(
                                                      child: Padding(
                                                          padding: EdgeInsets.only(right: 15.0),
                                                          child: Container(
                                                            alignment: Alignment.centerRight,
                                                            child: Text('₹100.00',style: TextStyle(color: Color(0xff3D3D3D),fontSize: 14,fontWeight:FontWeight.bold,fontFamily:'Montserrat')),
                                                          )  ),
                                                      flex: 2,
                                                    ),
                                                  ] )  ),
                                          Container(
                                            margin: EdgeInsets.only(left: 20,right: 20),
                                            child:
                                            Divider(
                                              color: Palette.textlineColor,
                                            ),),
                                          Container(
                                              padding: EdgeInsets.only(top:5,left: 20,right: 20,bottom: 5),
                                              child: new Row(
                                                  mainAxisSize: MainAxisSize.max,
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                                  children: <Widget>[
                                                    Flexible(
                                                      child: Padding(
                                                          padding:
                                                          EdgeInsets.only(right: 10.0),
                                                          child: Container(
                                                              alignment: Alignment.centerLeft,
                                                              padding: EdgeInsets.only(left: 15),

                                                              //   height: MediaQuery.of(context).size.height ,
                                                              //  width:MediaQuery.of(context).size.width
                                                              child: Text('Delivery Cost',style:TextStyle (fontSize:13.0,color:Palette.BottomMenu,fontFamily: 'Montserrat'))
                                                          )     ),
                                                      flex: 2,
                                                    ),
                                                    Flexible(
                                                      child: Padding(
                                                          padding: EdgeInsets.only(right: 15.0),
                                                          child: Container(
                                                            alignment: Alignment.centerRight,
                                                            child: Text('₹100.00',style: TextStyle(color: Color(0xff3D3D3D),fontSize: 14,fontWeight:FontWeight.bold,fontFamily:'Montserrat')),
                                                          )  ),
                                                      flex: 2,
                                                    ),
                                                  ] )  ),
                                          Container(
                                            margin: EdgeInsets.only(left: 20,right: 20),
                                            child:
                                            Divider(
                                              color: Palette.textlineColor,
                                            ),),


                                          Container(
                                              padding: EdgeInsets.only(top:5,left: 20,right: 20,bottom: 5),
                                              child: new Row(
                                                  mainAxisSize: MainAxisSize.max,
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                                  children: <Widget>[
                                                    Flexible(
                                                      child: Padding(
                                                          padding:
                                                          EdgeInsets.only(right: 10.0),
                                                          child: Container(
                                                              alignment: Alignment.centerLeft,
                                                              padding: EdgeInsets.only(left: 15),

                                                              //   height: MediaQuery.of(context).size.height ,
                                                              //  width:MediaQuery.of(context).size.width
                                                              child: Text('Total Cost',style:TextStyle (color: Palette.BottomMenu,fontWeight:FontWeight.bold,fontSize:18.0,fontFamily: 'Montserrat'))
                                                          )     ),
                                                      flex: 2,
                                                    ),
                                                    Flexible(
                                                      child: Padding(
                                                          padding:
                                                          EdgeInsets.only(right: 15.0),
                                                          child: Container(
                                                            alignment: Alignment.centerRight,
                                                            child: Text('₹1200.00',style: TextStyle(color: Color(0xff3D3D3D),fontSize: 18,fontWeight:FontWeight.bold,fontFamily:'Montserrat')),
                                                          )  ),
                                                      flex: 2,
                                                    ),
                                                  ] )  ),

                                          Container(
                                            margin: EdgeInsets.only(left: 20,right: 20),
                                            child:
                                            Divider(
                                              color: Palette.textlineColor,
                                            ),),
                                          Padding(
                                              padding:EdgeInsets.only(left: 20,right: 20),

                                              child: new Row(
                                                children: <Widget>[
                                                  new Checkbox(
                                                    activeColor: Palette.SecondaryColor,
                                                    checkColor: Palette.BackGroundColor,
                                                    value: _isChecked,
                                                    onChanged: (bool? value) {
                                                      setState(() {
                                                        _onChecked(value!);
                                                      });

                                                    },
                                                  ),
                                                  Expanded(

                                                    child:   Text(
                                                      "By placing an order you agree to our Terms And Conditions",
                                                      textAlign: TextAlign.start,
                                                      overflow: TextOverflow.ellipsis,
                                                      maxLines: 2,
                                                      softWrap: true,
                                                      style: TextStyle(

                                                          color: Palette.BottomMenu,
                                                          fontSize: 16),
                                                    ),
                                                  )


                                                ],
                                              )),

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
                                                  'Place Order',
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
                                                  Navigator.pushNamed(context, Routes.CONFIRMPLACEEDITORDERSCREEN);
                                                },
                                              )),
                                        ],
                                      ));});
                          });
                    },
                  )),
              SizedBox(
                height: 20,
              ),
            ],
          )

      ),

    );
  }


  Widget EachList(visitorHistory) {
    return Container(
            height: 90,
            child: Card(
              margin: EdgeInsets.only(left: 20, bottom: 8, right: 20),

              elevation: 1.0,
              color: Colors.white,
              shape: new RoundedRectangleBorder(
                  side: new BorderSide(color: Colors.white, width: 2.0),
                  borderRadius: BorderRadius.circular(12.0)),
              child: Row(children: [
                SizedBox(
                  width: 5,
                ),

               Flexible(

                   child:Container(   padding: EdgeInsets.only(top: 25, bottom: 10),
                        height: 70,
                        width: 55,
                        decoration: BoxDecoration(
                          image: DecorationImage
                            (
                            image: AssetImage('assets/images/briyanipaste.png')
                          )
                        ) ),
                 flex: 3,

                       ),
                SizedBox(
                  width: 5,
                ),
                Flexible(

                    child:
                Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        height: 10,
                      ),
Align(
  alignment: Alignment.centerLeft,

             child:         Text(
                                visitorHistory['masala_name'],
                                style: TextStyle(color:Palette.BottomMenu,fontWeight: FontWeight.bold,fontSize: 14),
                             ),),
                      SizedBox(
                        height: 3,
                      ),
              Container(

                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                    Text(
                          visitorHistory['kilogram'],
                          style: TextStyle(color:Colors.black38,fontWeight: FontWeight.bold,fontSize: 12),
                        ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      visitorHistory['quantity'],
                      style: TextStyle(color:Colors.black38,fontWeight: FontWeight.bold,fontSize: 12),
                    ),
                  ])),
                      SizedBox(
                        height: 5,
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child:   Text(
                          visitorHistory['amount'],
                          style: TextStyle(color:Palette.BottomMenu,fontWeight: FontWeight.bold,fontSize: 18),
                        ),
                      )


                    ]),
                      flex:5),


                Flexible(

                    child:Container(
                        alignment: Alignment.bottomRight,

              margin: EdgeInsets.only(bottom: 10),
              child:      Container(
                        alignment: Alignment.centerRight,
                        padding: EdgeInsets.only(left: 3,top: 3,bottom: 3),
                            width: 95,
                        height: 35,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Palette.SecondaryColor),
                        child: Row(
                          children: [
                            SizedBox(width: 8,),
                            InkWell(
                                onTap: () {
                                  // _sink.add(--initValue);
                                  setState(() {
                                   if(_itemCount!= 0 ) { _itemCount-- ; };
                                  });
                                },
                                child: Icon(
                                  Icons.remove,
                                  color: Colors.white,
                                  size: 20,
                                )),
                    SizedBox(width: 8,),
                            Text(_itemCount.toString(),style: TextStyle(color: Colors.white),),
                            SizedBox(width: 8,),
                            InkWell(
                                onTap: () {
                                  setState(() {
                                    _itemCount++ ;
                                    subTotal =true;
                                  });
                               //  _sink.add(++initValue);
                              //   _controller1.text =initValue.toString();

                                },
                                child: Icon(
                                  Icons.add,
                                  color: Colors.white,
                                  size: 20,
                                )),
                          ],
                        ),
              )  ),flex:3),
                   ])





            ),
          );


  }


}
