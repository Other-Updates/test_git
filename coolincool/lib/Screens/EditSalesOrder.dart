import 'dart:async';

import 'package:coolincool/Utils/Colors.dart';
import 'package:coolincool/Utils/Routes.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:intl/intl.dart';
import 'package:toggle_switch/toggle_switch.dart';

class EditSalesOrderScreen extends StatefulWidget {
  const EditSalesOrderScreen({Key? key}) : super(key: key);

  @override
  _EditSalesOrderScreenState createState() => _EditSalesOrderScreenState();
}

class _EditSalesOrderScreenState extends State<EditSalesOrderScreen> {

  TextEditingController salesOrderNumberController =TextEditingController();
  TextEditingController timeinput = TextEditingController();


  FocusNode myFocusNode1 = new FocusNode();


  String distributorValue = '';
  String productcategoryValue = '';

  DatePickerController _controller = DatePickerController();

  DateTime _selectedValue = DateTime.now();
  DateTime _dateTime = DateTime.now();



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


  @override
  void initState() {
    // TODO: implement initState

    salesOrderNumberController.text ="SAL001";
    timeinput.text ="12:00";
    productcategoryValue = "Spice Blend" ;
    distributorValue ="Coolincool Distributor" ;


    super.initState();
    _itemCount =3;
  }

  int _itemCount = 0;

  bool _isChecked = false;

  void _onChecked (bool value) {
    setState(() {
      _isChecked = value ;

    });
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

                  autofocus: true,
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
                alignment: Alignment.centerLeft,
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
                  autofocus: true,
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
                    labelStyle: TextStyle(color: Colors.black54),
                    border: InputBorder.none,
                    contentPadding:
                    EdgeInsets.fromLTRB(20.0, 5.0, 0.0, 8.0),
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

                      },
                    );
                  },
                ),
              ),
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

              Container(
                margin: EdgeInsets.only(right: 20),
                alignment:Alignment.centerRight,
       child:       Text("Total Cost: ₹1200",style: TextStyle(color: Palette.BottomMenu,fontSize: 18,fontWeight: FontWeight.bold),),

              ),
              Container(
                  height: 65,
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.fromLTRB(25, 15, 25, 0),
                  child: RaisedButton(
                    textColor: Colors.white,
                    color: Palette.PrimaryColor,
                    child: Text('Checkout',
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
