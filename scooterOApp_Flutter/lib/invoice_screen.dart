import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:scotto/Menudrawer.dart';
import 'package:scotto/Scprogressdialog.dart';
import 'package:scotto/constants.dart';
import 'package:scotto/invoicedetailsscreen.dart';
import 'package:scotto/utils/Language.dart';
import 'package:scotto/utils/StorageUtil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';

class InvoiceScreen extends StatefulWidget {
  @override
  InvoiceScreenState createState() => InvoiceScreenState();
}

class InvoiceScreenState extends State<InvoiceScreen> {
  var _GENERIC_INVOICE = ' ';

  GlobalKey<ScaffoldState> _key = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  SharedPreferences _sharedPreferences;
  var Invoice_trip_number, Invoice_amount, Invoice_date, Invoicealllist;

  getLanguage() async {
    _sharedPreferences = await _prefs;
    // print(Language.getLocalLanguage(_sharedPreferences,'GENERIC_LOGIN'));
    setState(() {
      _GENERIC_INVOICE =
          Language.getLocalLanguage(_sharedPreferences, 'GENERIC_INVOICE');
    });
  }

  var customer_details, scootoroDetails;

  String customer_id = '';

  getTextFromFile() async {
    try {
      String data = await StorageUtil.getItem("login_customer_detail_id");
      setState(() {
        customer_id = data;
        print("mobi`lf===`````````````````" + customer_id);
      });
    } catch (ex) {
      print(ex);
    }
  }

  List Invoice_list = [];
  var id = '', trip_number = '', amount = '', date = '', radioValue = '';
  List<String> Names = [
    'Abhishek',
    'John',
    'Robert',
    'Shyam',
    'Sita',
    'Gita',
    'Nitish'
  ];
  List data;

  invoice() async {
    await getTextFromFile();
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Scprogressdialog("Fetching invoice details");
        });
    var data = json.encode({"id": customer_id});
    print("]]]]]]]]]]]]]]]" + data);
    final response = await http.post(baseurl + 'api_invoice_list',
        headers: {'authorization': basicAuth}, body: data);
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      if (jsonResponse['status'] == 'Success') {
        Navigator.of(context).pop();
        print(jsonResponse);
        setState(() {
          Invoice_list = jsonResponse['data'];
        });
      } else if (jsonResponse['status'] == 'Error') {
        Navigator.pop(context);
        _showMessageInScaffold(jsonResponse['message']);
      }
    } else {
      Navigator.pop(context);
      _showMessageInScaffold('Contact Admin!!');
    }
  }

  void _showMessageInScaffold(String message) {
    _key.currentState.showSnackBar(
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
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLanguage();
    invoice();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _key,
      drawer: Drawer(
        child: HomeMenuDrawer(),
      ),
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back_ios,
            color: Colors.white, // add custom icons also
          ),
        ),
        title: Text(
          _GENERIC_INVOICE,
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Color(0xff00DD00),
      ),
      body: new Container(
          color: Color(0xffE6FFE6),
          child: (Invoice_list.length > 0)
              ? ListView.builder(
                  itemCount: Invoice_list.length,
                  itemBuilder: (context, index) =>
                      EachList(Invoice_list[index]),
                )
              : Center(
                  child: Text(
                  'No Invoices available',
                  style: TextStyle(
                      color: Color(0xff676767),
                      fontFamily: 'Montserrat',
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold),
                ))),
    );
  }

  @override
  Widget EachList(Invoice_list) {
    return GestureDetector(
        onTap: () {
          setState(() {
            id = Invoice_list['id'];
          });
          Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) =>
                  InvoiceDetailsScreen(Invoice_list)));
        },
        child: new Card(
            color: Color(0xffE6FFE6),
            child: new Column(children: [
              Container(
                  padding: EdgeInsets.only(top: 15),
                  child: new Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Flexible(
                          child: Padding(
                              padding: EdgeInsets.only(right: 10.0),
                              child: Container(
                                  alignment: Alignment.centerLeft,
                                  padding: EdgeInsets.only(left: 15),

//   height: MediaQuery.of(context).size.height ,
//  width:MediaQuery.of(context).size.width
                                  child: Text(
                                    '${Invoice_list['trip_number']}',
                                    style: TextStyle(
                                        color: Color(0xff747474),
                                        fontFamily: 'Montserrat'),
                                  ))),
                          flex: 2,
                        ),
                        Flexible(
                          child: Padding(
                              padding: EdgeInsets.only(right: 20.0, top: 10.0),
                              child: Container(
                                  alignment: Alignment.bottomRight,
                                  child: Text(
                                    '${Invoice_list['amount']} SAR',
                                    style: TextStyle(
                                        color: Color(0xff676767),
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Montserrat',
                                        fontSize: 16.0),
                                  ))),
                          flex: 2,
                        ),
                      ])),
              Container(
                  padding: EdgeInsets.only(top: 15, bottom: 10),
                  child: new Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Flexible(
                          child: Padding(
                              padding: EdgeInsets.only(right: 10.0),
                              child: Container(
                                  alignment: Alignment.centerLeft,
                                  padding: EdgeInsets.only(left: 15),

                                  //   height: MediaQuery.of(context).size.height ,
                                  //  width:MediaQuery.of(context).size.width
                                  child: Text(
                                    '${Invoice_list['date']}',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'Montserrat'),
                                  ))),
                          flex: 2,
                        ),
                      ])),
            ]))
        /* child:new Card(

            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0)),
           // color: Colors.white,
            color: Color(0xffF1FDF0),

            child: new Column(
                children: [
                  Container(
                      padding: EdgeInsets.only(left: 10,top: 20.0,bottom: 20.0,right: 20.0),
                      child:new Row(
                        //      mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Flexible(
                            child: Container(
                                child: new Text(
                                  '${Invoice_list['trip_number']}',style: TextStyle(color:Colors.grey, )),

                            ),flex: 2, ),

                            Flexible(
                                  child:Container(
                              alignment: Alignment.centerRight,
                              child: new Text(
                                '${Invoice_list['amount']} SAR',style: TextStyle(color:Colors.black54, fontWeight: FontWeight.bold ),
                              ),
                              ),flex: 2, ),


                          ]   ),),
                  Container(
                      padding: EdgeInsets.only(left: 10),
                      alignment: Alignment.bottomLeft,
                      child: Text('${Invoice_list['date']}',style: TextStyle(color:Colors.black45),
                      )    ),

                ]
            ))*/
        );
  }
}
