import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:scotto/Scprogressdialog.dart';
import 'package:scotto/contactsupportscreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:scotto/constants.dart';
import 'package:scotto/utils/Language.dart';
import 'package:scotto/utils/StorageUtil.dart';
import 'package:shared_preferences/shared_preferences.dart';


class InvoiceDetailsScreen extends StatefulWidget {
  @override
  final Invoice_list;
  InvoiceDetailsScreen(this.Invoice_list);
  _InvoiceDetailsScreenState createState() => _InvoiceDetailsScreenState(this.Invoice_list);

}

class _InvoiceDetailsScreenState extends State<InvoiceDetailsScreen> {

  final Invoice_list;
  _InvoiceDetailsScreenState(this.Invoice_list);

  var _GENERIC_INVOICE_DETAILS = ' ', _GENERIC_RIDE_DETAILS = '', _GENERIC_TRIP_NUMBER ='', _GENERIC_SCOO_SNO = ' ', _GENERIC_START_TIME = '', _GENERIC_END_TIME= '', _GENERIC_UNLOCK_CHARGE = ' ', _GENERIC_SUB_TOTAL = '', _GENERIC_VAT ='',_GENERIC_GRAND_TOTAL = ' ', _GENERIC_SHARE_INVOICE = '', _GENERIC_REPORT_ISSUE_MSG ='',_GENERIC_RIDE_DISTANCE='',_GENERIC_TOTAL_RIDE_TIME='' ;
  var InvoiceallDetails,trip_number = '',invoice_number = '',scootoro_number = '',start_time = '',end_time = '',ride_distance = '',total_ride_amt = '',total_ride_time = '',unlock_charge = '',vat_charge = '',sub_total = '',grand_total = '';
  var _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
   var id;

  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  SharedPreferences _sharedPreferences;

  getLanguage() async {
    _sharedPreferences = await _prefs;
    // print(Language.getLocalLanguage(_sharedPreferences,'GENERIC_LOGIN'));
    setState(() {
      _GENERIC_INVOICE_DETAILS = Language.getLocalLanguage(_sharedPreferences, 'GENERIC_INVOICE_DETAILS');
      _GENERIC_RIDE_DETAILS = Language.getLocalLanguage(_sharedPreferences, "GENERIC_RIDE_DETAILS");
      _GENERIC_TRIP_NUMBER = Language.getLocalLanguage(_sharedPreferences, "GENERIC_TRIP_NUMBER");
      _GENERIC_SCOO_SNO = Language.getLocalLanguage(_sharedPreferences, 'GENERIC_SCOO_SNO');
      _GENERIC_START_TIME = Language.getLocalLanguage(_sharedPreferences, "GENERIC_START_TIME");
      _GENERIC_END_TIME = Language.getLocalLanguage(_sharedPreferences, "GENERIC_END_TIME");
      _GENERIC_UNLOCK_CHARGE = Language.getLocalLanguage(_sharedPreferences, 'GENERIC_UNLOCK_CHARGE');
      _GENERIC_SUB_TOTAL = Language.getLocalLanguage(_sharedPreferences, "GENERIC_SUB_TOTAL");
      _GENERIC_VAT = Language.getLocalLanguage(_sharedPreferences, "GENERIC_VAT");
      _GENERIC_GRAND_TOTAL = Language.getLocalLanguage(_sharedPreferences, 'GENERIC_GRAND_TOTAL');
      _GENERIC_SHARE_INVOICE = Language.getLocalLanguage(_sharedPreferences, "GENERIC_SHARE_INVOICE");
      _GENERIC_REPORT_ISSUE_MSG = Language.getLocalLanguage(_sharedPreferences, "GENERIC_REPORT_ISSUE_MSG");
      _GENERIC_RIDE_DISTANCE = Language.getLocalLanguage(_sharedPreferences, "GENERIC_RIDE_DISTANCE");
      _GENERIC_TOTAL_RIDE_TIME = Language.getLocalLanguage(_sharedPreferences, "GENERIC_TOTAL_RIDE_TIME");


    });

  }



  String customer_id = '';


   getTextFromFile() async {
    try {

      String data = await StorageUtil.getItem("login_customer_detail_id");

      setState(() {
        customer_id = data;

      });
    } catch (ex) {
      print(ex);
    }
  }

  var Invoice_Details='';

  invoice() async {
    await getTextFromFile();
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Scprogressdialog("Fetching invoice details");
        }
    );
    var data = json.encode({
      "id": customer_id,
      "trip_id":Invoice_list ['id']
    });
    print(data);
    final response = await http.post(baseurl + 'api_invoice_details',
        headers: {'authorization': basicAuth}, body: data);
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      if (jsonResponse['status'] == 'Success') {
        print(jsonResponse);
        Navigator.pop(context);
        var Invoice_Details = jsonResponse['data'];
        setState(() {
          //InvoiceallDetails= Invoice_Details;
          invoice_number = Invoice_Details ['invoice_number'];
          trip_number =Invoice_Details ['trip_number'];
          scootoro_number = Invoice_Details ['scootoro_number'];
          start_time =Invoice_Details ['start_time'];
          end_time = Invoice_Details ['end_time'];
          ride_distance = Invoice_Details ['ride_distance'];
          total_ride_time =Invoice_Details ['total_ride_time'];
          total_ride_amt = Invoice_Details ['total_ride_amt'];
          unlock_charge = Invoice_Details ['unlock_charge'];
          sub_total =Invoice_Details ['sub_total'];
          vat_charge = Invoice_Details ['vat_charge'];
          grand_total = Invoice_Details ['grand_total'];
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
  }

  @override
  void initState() {
    super.initState();
    getLanguage();
    invoice();
  }


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,// add custom icons also
          ),
        ),
        title: Text(_GENERIC_INVOICE_DETAILS,style: TextStyle(color: Colors.white),),
        centerTitle: true,
        backgroundColor:Color(0xff00DD00),
      ),
      body: new Container(
        color: Color(0xffE6FFE6),
        child: new ListView(
          children: <Widget>[

            Container(
              padding: EdgeInsets.only(top:20),
              alignment:Alignment.center,
              child: Text('Company Name', style: TextStyle(color: Color(0xff676767),fontFamily: 'Montserrat',fontSize: 25,fontWeight: FontWeight.bold),),
            ),

            Container(
              padding: EdgeInsets.only(top: 10,right: 30,left: 30),
              alignment:Alignment.center,
              child: Text(' Building Number, Street Number, Street Name', style: TextStyle(color: Colors.grey,fontSize: 14,fontFamily: 'Montserrat'),),
            ),
            Container(
             // padding: EdgeInsets.only(top: 10,right: 30,left: 30),
              alignment:Alignment.center,
              child: Text('  City-District, Country.', style: TextStyle(color: Colors.grey,fontSize: 14,fontFamily: 'Montserrat'),),
            ),
            Container(

                padding: EdgeInsets.only(top:15),
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
                                child: new Row(
                                    children: <Widget>[
                                      Container(
                                          alignment: Alignment.centerLeft,
                                          padding: EdgeInsets.only(left: 20),

                                          child: Text('Invoice No:',style:TextStyle (fontFamily: 'Montserrat'),)
                                      ),

                                      Container(
                                          alignment: Alignment.centerLeft,
                                          padding: EdgeInsets.only(left: 5),

                                          child: Text('${invoice_number}',style:TextStyle (fontFamily: 'Montserrat'))
                                      )
                                    ])  )     ),
                        flex: 2,
                      ),
                      Flexible(
                        child: Padding(
                            padding: EdgeInsets.only(right: 10.0,left: 30),

                            child: Container(
                                alignment: Alignment.topRight,
                                child: new Row(
                                    children: <Widget>[
                                      Container(

                                          child: new Icon(
                                            Icons.phone_outlined,
                                            color: Color(0xff00DD00),
                                            size: 23.0,
                                          )  ),

                                      Container(

                                          padding: EdgeInsets.only(left: 5),
                                          child: Text('+95 5555555555',style:TextStyle (color: Color(0xff676767),fontFamily: 'Montserrat'))
                                      )
                                    ])  )     ),
                        flex: 2,
                      ),
                    ] )  ),
            Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(left: 20,top:15,),

                child: Text(_GENERIC_RIDE_DETAILS,style:TextStyle (color: Color(0xff676767),fontFamily: 'Montserrat',fontWeight: FontWeight.bold),)
            ),
            Container(
               // height: 200,
                 padding: EdgeInsets.fromLTRB(12.0, 0.0, 12.0, 0),
                child: new Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6.0),
                     ),

                  color: Colors.white,
                  child: new Column(
                      children: [
                        Container(
                            padding: EdgeInsets.only(top:10),
                            child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                MainAxisAlignment.start,
                                children: <Widget>[
                                  Flexible(
                                    child: Padding(
                                        padding:
                                        EdgeInsets.only(right: 0.0),
                                        child: Container(
                                            alignment: Alignment.centerLeft,
                                            padding: EdgeInsets.only(left: 15),

                                            //   height: MediaQuery.of(context).size.height ,
                                            //  width:MediaQuery.of(context).size.width
                                            child: Text(_GENERIC_TRIP_NUMBER, style:TextStyle (color: Color(0xff676767),fontSize:13.0,fontFamily: 'Montserrat'))
                                        )     ),
                                    flex: 2,
                                  ),
                                  Flexible(
                                    child: Padding(
                                        padding: EdgeInsets.only(right: 10.0),
                                        child: Container(
                                          alignment: Alignment.centerRight,
                                          child: Text('${trip_number}',style: TextStyle(color: Color(0xff3D3D3D),fontWeight:FontWeight.bold,fontSize: 13.0,fontFamily:'Montserrat' ),),
                                        )  ),
                                    flex: 2,
                                  ),
                                ] )  ),

                        Container(
                            padding: EdgeInsets.only(top:10),
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
                                            child: Text(_GENERIC_SCOO_SNO,style:TextStyle (color: Color(0xff747474),fontFamily: 'Montserrat',fontSize: 13.0))
                                        )     ),
                                    flex: 2,
                                  ),
                                  Flexible(
                                    child: Padding(
                                        padding: EdgeInsets.only(right: 10.0),
                                        child: Container(
                                          alignment: Alignment.centerRight,
                                          child: Text('${scootoro_number}',style:TextStyle (color: Color(0xff3D3D3D),fontSize: 13,fontFamily: 'Montserrat',fontWeight: FontWeight.bold)),

                                        )  ),
                                    flex: 2,
                                  ),
                                ] )  ),
                        Container(
                            padding: EdgeInsets.only(top:10),
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
                                            child: Text(_GENERIC_START_TIME,style:TextStyle (color: Color(0xff676767),fontFamily: 'Montserrat',fontSize: 13.0))
                                        )     ),
                                    flex: 2,
                                  ),
                                  Flexible(
                                    child: Padding(
                                        padding: EdgeInsets.only(right: 10.0),
                                        child: Container(
                                          alignment: Alignment.centerRight,
                                          child: Text('${start_time}',style: TextStyle(color: Color(0xff3D3D3D),fontSize: 13,fontFamily:'Montserrat',fontWeight: FontWeight.bold)),
                                        )  ),
                                    flex: 2,
                                  ),
                                ] )  ),
                        Container(
                            padding: EdgeInsets.only(top:10),
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
                                            child: Text(_GENERIC_END_TIME,style:TextStyle (color: Color(0xff676767),fontSize:13.0,fontFamily: 'Montserrat'))
                                        )     ),
                                    flex: 2,
                                  ),
                                  Flexible(
                                    child: Padding(
                                        padding: EdgeInsets.only(right: 10.0),
                                        child: Container(
                                          alignment: Alignment.centerRight,
                                          child: Text('${end_time}',style: TextStyle(color: Color(0xff3D3D3D),fontSize: 13,fontWeight:FontWeight.bold,fontFamily:'Montserrat')),
                                        )  ),
                                    flex: 2,
                                  ),
                                ] )  ),
                        Container(
                            padding: EdgeInsets.only(top:10,bottom: 10),
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
                                            child: Text(_GENERIC_RIDE_DISTANCE,style:TextStyle (fontSize:13.0,color: Color(0xff676767),fontFamily: 'Montserrat'))
                                        )     ),
                                    flex: 2,
                                  ),
                                  Flexible(
                                    child: Padding(
                                        padding: EdgeInsets.only(right: 10.0),
                                        child: Container(
                                          alignment: Alignment.centerRight,
                                          child: Text('${ride_distance} KM',style: TextStyle(color: Color(0xff3D3D3D),fontSize: 13,fontWeight:FontWeight.bold,fontFamily:'Montserrat')),
                                        )  ),
                                    flex: 2,
                                  ),
                                ] )  ),
                      ]),
                )),
            Container(
                padding: EdgeInsets.fromLTRB(12.0, 0.0, 12.0, 0),
                child: new Card(
                  shape: RoundedRectangleBorder(

                    borderRadius: BorderRadius.circular(6.0),

                  ),
                  color: Colors.white,
                  child: new Column(
                      children: [
                        Container(
                            padding: EdgeInsets.only(top:10 ),
                            child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                MainAxisAlignment.start,
                                children: <Widget>[
                                  Flexible(
                                    child: Padding(
                                        padding:
                                        EdgeInsets.only(left: 15.0),
                                        child: Container(
                                            alignment: Alignment.centerLeft,
                                            child: Text('${_GENERIC_TOTAL_RIDE_TIME} - ${total_ride_time}',
                                                maxLines:1,style:TextStyle (color: Color(0xff676767),fontSize:13.0,fontFamily: 'Montserrat'))
                                        )     ),
                                    flex: 2,
                                  ),
                                  Flexible(
                                    child: Padding(
                                        padding: EdgeInsets.only(right: 10.0),
                                        child: Container(
                                          alignment: Alignment.centerRight,
                                          child: Text('${total_ride_amt}SAR',style: TextStyle(color: Color(0xff3D3D3D),fontSize: 13,fontWeight:FontWeight.bold,fontFamily:'Montserrat')),
                                        )  ),
                                    flex: 2,
                                  ),
                                ] )  ),

                        Container(
                            padding: EdgeInsets.only(top:10),
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
                                            child: Text(_GENERIC_UNLOCK_CHARGE,style:TextStyle (color: Color(0xff676767),fontSize:13.0,fontFamily: 'Montserrat'))
                                        )     ),
                                    flex: 2,
                                  ),
                                  Flexible(
                                    child: Padding(
                                        padding:
                                        EdgeInsets.only(right: 10.0),
                                        child: Container(
                                          alignment: Alignment.centerRight,
                                          child: Text('${unlock_charge}SAR',style: TextStyle(color: Color(0xff3D3D3D),fontSize: 13,fontWeight:FontWeight.bold,fontFamily:'Montserrat')),
                                        )  ),
                                    flex: 2,
                                  ),
                                ] )  ),
                        Divider(
                          color: Colors.black87,
                          thickness: 0.2,
                          indent: 10,
                          endIndent:10,
                        ),
                        Container(
                            padding: EdgeInsets.only(top:5.0),
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
                                            child: Text(_GENERIC_SUB_TOTAL,style:TextStyle (color: Color(0xff676767),fontSize:13.0,fontFamily: 'Montserrat'))
                                        )     ),
                                    flex: 2,
                                  ),
                                  Flexible(
                                    child: Padding(
                                        padding:
                                        EdgeInsets.only(right: 10.0),
                                        child: Container(
                                          alignment: Alignment.centerRight,
                                          child: Text('${sub_total}SAR',style: TextStyle(color: Color(0xff3D3D3D),fontWeight:FontWeight.bold,fontSize: 13,fontFamily:'Montserrat')),
                                        )  ),
                                    flex: 2,
                                  ),
                                ] )  ),

                        Container(
                            padding: EdgeInsets.only(top:10,bottom: 10),
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
                                            child: Text(_GENERIC_VAT,style:TextStyle (color: Color(0xff676767),fontSize:13.0,fontFamily: 'Montserrat'))
                                        )     ),
                                    flex: 2,
                                  ),
                                  Flexible(
                                    child: Padding(
                                        padding:
                                        EdgeInsets.only(right: 10.0),
                                        child: Container(
                                          alignment: Alignment.centerRight,
                                          child: Text('${vat_charge}SAR',style: TextStyle(color: Color(0xff3D3D3D),fontSize: 13.0,fontWeight:FontWeight.bold,fontFamily:'Montserrat')),
                                        )  ),
                                    flex: 2,
                                  ),
                                ] )  ),
                        Container(
                            color: Color(0xffE6FFE6),
                            height: 55,
                            padding: EdgeInsets.only(top:10,bottom: 10),
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
                                            child: Text(_GENERIC_GRAND_TOTAL,style:TextStyle (color: Color(0xff676767),fontWeight:FontWeight.bold,fontSize:13.0,fontFamily: 'Montserrat'))
                                        )     ),
                                    flex: 2,
                                  ),
                                  Flexible(
                                    child: Padding(
                                        padding:
                                        EdgeInsets.only(right: 10.0),
                                        child: Container(
                                          alignment: Alignment.centerRight,
                                          child: Text('${grand_total}SAR',style: TextStyle(color: Color(0xff3D3D3D),fontSize: 13.0,fontWeight:FontWeight.bold,fontFamily:'Montserrat')),
                                        )  ),
                                    flex: 2,
                                  ),
                                ] )  ),
                      ]),
                )),

            Container(
              padding: EdgeInsets.only(top: 10,bottom: 20),
              alignment: Alignment.center,
              child: FlatButton(
                  textColor: Color(0xff00DD00),

                  child: Text(_GENERIC_REPORT_ISSUE_MSG, style: TextStyle(
                    fontSize: 16, ),),
                  onPressed: () {

                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) => ContactSupportScreen())
                      );
                  }
              ),
            )

          ],
        ),
      ),
    );
  }
}