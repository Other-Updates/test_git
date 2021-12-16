import 'dart:io';

import 'package:coolincool/Utils/Colors.dart';
import 'package:coolincool/Utils/Menudrawer.dart';
import 'package:coolincool/Utils/Routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
class DistributorScreen extends StatefulWidget {


  @override
  _DistributorScreenState createState() => _DistributorScreenState();
}

class _DistributorScreenState extends State<DistributorScreen> {



  List all_distributor=[
    {"distributor":"CoolinCool Distributor","distributor_type":"wholesalers","mobile_number":"+919564123782","commission":"10%"},
    {"distributor":"F2F Distributor","distributor_type":"Retailers","mobile_number":"+919564123782","commission":"9%"},
    {"distributor":"CIC Distributor","distributor_type":"Agents","mobile_number":"+919564123782","commission":"11%"},
    {"distributor":"CIC Masala Distributor","distributor_type":"Agents","mobile_number":"+919564123782","commission":"13%"},
    {"distributor":"Food Masala Distributor","distributor_type":"wholesalers","mobile_number":"+919564123782","commission":"12%"},
    {"distributor":"CoolinCool Distributor","distributor_type":"Retailers","mobile_number":"+919564123782","commission":"9%"},
    {"distributor":"F2F Distributor","distributor_type":"Retailers","mobile_number":"+919564123782","commission":"10%"},
    {"distributor":"CoolinCool Distributor","distributor_type":"wholesalers","mobile_number":"+919564123782","commission":"7%"},
    {"distributor":"Food Distributor","distributor_type":"wholesalers","mobile_number":"+919564123782","commission":"6%"},
    {"distributor":"CoolinCool Distributor","distributor_type":"wholesalers","mobile_number":"+919564123782","commission":"9%"},
    {"distributor":"F2F Distributor","distributor_type":"Retailers","mobile_number":"+919564123782","commission":"11%"},
    {"distributor":"CIC Distributor","distributor_type":"Agents","mobile_number":"+919564123782","commission":"12%"},
    {"distributor":"CIC Masala Distributor","distributor_type":"Agents","mobile_number":"+919564123782","commission":"9%"},
    {"distributor":"Food Masala Distributor","distributor_type":"wholesalers","mobile_number":"+919564123782","commission":"13%"},
    {"distributor":"CoolinCool Distributor","distributor_type":"Retailers","mobile_number":"+919564123782","commission":"9%"},
    {"distributor":"F2F Distributor","distributor_type":"Retailers","mobile_number":"+919564123782","commission":"6.5%"},
    {"distributor":"CoolinCool Distributor","distributor_type":"wholesalers","mobile_number":"+919564123782","commission":"10%"},
    {"distributor":"Food Distributor","distributor_type":"wholesalers","mobile_number":"+919564123782","commission":"9%"},
  ];

  List wholesaler_distributor=[
    {"distributor":"CoolinCool Distributor","distributor_type":"wholesalers","mobile_number":"+919564123782","commission":"10%"},
    {"distributor":"Food Masala Distributor","distributor_type":"wholesalers","mobile_number":"+919564123782","commission":"12%"},
    {"distributor":"CoolinCool Distributor","distributor_type":"wholesalers","mobile_number":"+919564123782","commission":"7%"},
    {"distributor":"Food Distributor","distributor_type":"wholesalers","mobile_number":"+919564123782","commission":"6%"},
    {"distributor":"CoolinCool Distributor","distributor_type":"wholesalers","mobile_number":"+919564123782","commission":"9%"},
    {"distributor":"Food Masala Distributor","distributor_type":"wholesalers","mobile_number":"+919564123782","commission":"13%"},
    {"distributor":"CoolinCool Distributor","distributor_type":"wholesalers","mobile_number":"+919564123782","commission":"10%"},
    {"distributor":"Food Distributor","distributor_type":"wholesalers","mobile_number":"+919564123782","commission":"9%"},
  ];
  List retailers_distributor=[
    {"distributor":"F2F Distributor","distributor_type":"Retailers","mobile_number":"+919564123782","commission":"9%"},
   {"distributor":"CoolinCool Distributor","distributor_type":"Retailers","mobile_number":"+919564123782","commission":"9%"},
    {"distributor":"F2F Distributor","distributor_type":"Retailers","mobile_number":"+919564123782","commission":"10%"},
    {"distributor":"F2F Distributor","distributor_type":"Retailers","mobile_number":"+919564123782","commission":"11%"},
   {"distributor":"CoolinCool Distributor","distributor_type":"Retailers","mobile_number":"+919564123782","commission":"9%"},
    {"distributor":"F2F Distributor","distributor_type":"Retailers","mobile_number":"+919564123782","commission":"6.5%"},
  ];
  List agents_distributor=[
    {"distributor":"CIC Distributor","distributor_type":"Agents","mobile_number":"+919564123782","commission":"11%"},
    {"distributor":"CIC Masala Distributor","distributor_type":"Agents","mobile_number":"+919564123782","commission":"13%"},
    {"distributor":"CIC Distributor","distributor_type":"Agents","mobile_number":"+919564123782","commission":"12%"},
    {"distributor":"CIC Masala Distributor","distributor_type":"Agents","mobile_number":"+919564123782","commission":"9%"},
   ];

  GlobalKey<ScaffoldState> _key = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
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
        title: Text("Distributor",style: TextStyle(fontSize: 23),),
        centerTitle: true,
        actions: [
          Row(
            children:[
              Container(
                margin: EdgeInsets.only(top: 8,bottom: 8,left: 10),
                height: 35,
                width: 35,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white24,
                ),
                child: IconButton( onPressed: () {  }, icon: Image.asset("assets/images/search.png",width: 15,height: 15,color: Colors.white,),),

              ),
              SizedBox(
                width: 3,
              ),
              Container(
                margin: EdgeInsets.only(top: 8,bottom: 8,right: 10),
                height: 35,
                width: 35,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white24,
                ),
                child: IconButton( onPressed: () { Navigator.pushNamed(context, Routes.ADDDISTRIBUTORSCREEN);}, icon: Image.asset("assets/images/plus.png",width: 15,height: 15,color: Colors.white,),),

              ),

            ]
          )
        ],


        brightness: Brightness.light,
      ),
      body:  Container(
        color: Colors.black12,

        child: _tabSection(context),
      ),
    );



  }
  Widget _tabSection(BuildContext context) {
    return DefaultTabController(
      length: 4,

      child: ListView(
     //   mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          SizedBox(
            height: 20,
          ),
          Container(
             height: 45,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
            ),
            margin: EdgeInsets.only(left: 16, right: 16),
            child: TabBar(
                unselectedLabelColor: Colors.black54,
                labelColor: Palette.BottomMenu,

                indicatorSize: TabBarIndicatorSize.tab,
                indicatorColor: Color(0xffff7000),
                indicator: BoxDecoration(
                  //  gradient: LinearGradient(
                  //   color: Color(0xff004080), Colors.orangeAccent]),

                    borderRadius: BorderRadius.circular(30),
                    color: Colors.black12),
                indicatorPadding: EdgeInsets.only(left: 5,right: 5,top: 5,bottom: 5),
                tabs: [
                  Tab(
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        "All",
                        softWrap: true,
                        style: TextStyle(
                            fontSize: 14),
                      ),
                    ),
                  ),
                  Tab(
                    child: Expanded(
                      //alignment: Alignment.center,
                      child: Text(
                        "Wholesalers",
                    maxLines: 1,
                        style: TextStyle(
                            fontSize: 14, ),
                      ),
                    ),
                  ),
                  Tab(
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        "Retailers",
                        maxLines: 1,
                        style: TextStyle(
                            fontSize: 14, ),
                      ),
                    ),
                  ),     Tab(
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        "Agents",
                        style: TextStyle(
                            fontSize: 14),
                      ),
                    ),
                  ),
                ]),
          ),
          SizedBox(
            height: 12,
          ),
          Container(
            //Add this to give height
            height: MediaQuery.of(context).size.height,
            child: TabBarView(children: [

              Expanded(

                    child: (all_distributor.length > 0)
                        ? ListView.separated(
      separatorBuilder: (BuildContext context, int index) {
        return SizedBox(height: 6);
      },
                      physics: ClampingScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: all_distributor.length,
                      itemBuilder: (context, index) =>
                          AllList(all_distributor[index]),
                    )
                        : Center(
                      child: Image.asset('assets/images/loader.gif'),
                    )

              ),
              Expanded(
                  child: (wholesaler_distributor.length > 0)
                      ? ListView.separated(
                    separatorBuilder: (BuildContext context, int index) {
                      return SizedBox(height: 6);
                    },
                    physics: ClampingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: wholesaler_distributor.length,
                    itemBuilder: (context, index) =>
                        wholesalersList(wholesaler_distributor[index]),
                  )
                      : Center(
                    child: Image.asset('assets/images/loader.gif'),
                  )

              ),
              Expanded(
                  child: (retailers_distributor.length > 0)
                      ? ListView.separated(
                    separatorBuilder: (BuildContext context, int index) {
                      return SizedBox(height: 6);
                    },
                    physics: ClampingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: retailers_distributor.length,
                    itemBuilder: (context, index) =>
                        RetailerList(retailers_distributor[index]),
                  )
                      : Center(
                    child: Image.asset('assets/images/loader.gif'),
                  )

              ),
              Expanded(
                  child: (agents_distributor.length > 0)
                      ? ListView.separated(
                    separatorBuilder: (BuildContext context, int index) {
                      return SizedBox(height: 6);
                    },
                    physics: ClampingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: agents_distributor.length,
                    itemBuilder: (context, index) =>
                        AgentsList(agents_distributor[index]),
                  )
                      : Center(
                    child: Image.asset('assets/images/loader.gif'),
                  )

              ),
              //  ])),
              //   ),
              // ),
            ]),
          ),
        ],
      ),
    );
  }


  Widget AllList(locked_list) {
    return GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, Routes.EDITDISTRIBUTORSCREEN);
        },
        child: Stack(children: [
          Container(
            child: Card(
                margin: EdgeInsets.only(left: 16, bottom: 8, right: 16),
                shadowColor:Colors.black,
                elevation: 2.0,
                color: Colors.white,
                shape: new RoundedRectangleBorder(
                    side:
                    new BorderSide(color: Colors.white, width: 2.0),
                    borderRadius: BorderRadius.circular(14.0)),
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        child: new Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[

                              Expanded(
                                child: Container(
                                    padding:
                                    EdgeInsets.only(left: 10.0),
                                    alignment: Alignment.bottomLeft,
                                    child: Row(children: [
                                      Text(
                                        locked_list['distributor'] ?? "--",
                                        maxLines: 1,
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: Palette.BottomMenu,
                                          fontWeight: FontWeight.bold
                                        ),
                                      ),
                                    ])),
                              ),
                              Expanded(
                                child: Container(
                                    height: 25,
                                    //  padding: EdgeInsets.only(right: 25.0),
                                    margin: EdgeInsets.only(left: 60, right: 6),
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        color: (locked_list['distributor_type'] == "wholesalers")
                                            ? Palette.WholeSalersButton
                                            : (locked_list['distributor_type'] == "Retailers")
                                            ? Palette.RetailersButton
                                            : Palette.AgentsButton,
                                        borderRadius:
                                        BorderRadius.circular(12.0)),
                                    child: Text(
                                      locked_list['distributor_type'],

                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12.0),
                                    )),
                              ),
                            ]),
                      ),
                      Container(
                          padding: EdgeInsets.only(left: 10.0, top: 5,bottom: 10),
                          child: new Row(children: <Widget>[

                            Expanded(
                                child: Container(

                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      '${(locked_list['mobile_number'])}',
                                      // textAlign: TextAlign.start,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.black54
                                      ),
                                    ))),
                            Expanded(
                          child:    Container(
                                  padding: EdgeInsets.only(left: 40.0),
                                  alignment: Alignment.bottomLeft,
                                  child: Row(children: [
                                    Text(
                                      'Commission: ',
                                      maxLines: 1,
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                        fontSize: 12,
                                          color: Colors.black54
                                      ),
                                    ),

                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      '${locked_list['commission']}',
                                      maxLines: 1,
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Palette.BottomMenu,
                                      ),
                                    ),
                                  ])),
                            ),
                          ])),


                    ])),
          ),

        ]));
  }
  Widget wholesalersList(locked_list) {
    return GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, Routes.EDITDISTRIBUTORSCREEN);
        },
        child: Stack(children: [
          Container(
            child: Card(
                margin: EdgeInsets.only(left: 16, bottom: 8, right: 16),
                shadowColor: Colors.black,
                elevation: 2.0,
                color: Colors.white,
                shape: new RoundedRectangleBorder(
                    side:
                    new BorderSide(color: Colors.white, width: 2.0),
                    borderRadius: BorderRadius.circular(14.0)),
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        child: new Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[

                              Expanded(
                                child: Container(
                                    padding:
                                    EdgeInsets.only(left: 10.0),
                                    alignment: Alignment.bottomLeft,
                                    child: Row(children: [
                                      Text(
                                        locked_list['distributor'] ?? "--",
                                        maxLines: 1,
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                            fontSize: 13,
                                            color: Palette.BottomMenu,
                                            fontWeight: FontWeight.bold
                                        ),
                                      ),
                                    ])),
                              ),
                              Expanded(
                                child: Container(
                                    height: 25,
                                    //  padding: EdgeInsets.only(right: 25.0),
                                    margin: EdgeInsets.only(left: 60, right: 6),
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        color: Palette.WholeSalersButton,
                                        borderRadius:
                                        BorderRadius.circular(12.0)),
                                    child: Text(
                                      locked_list['distributor_type'],

                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12.0),
                                    )),
                              ),
                            ]),
                      ),
                      Container(
                          padding: EdgeInsets.only(left: 10.0, top: 5,bottom: 10),
                          child: new Row(children: <Widget>[

                            Expanded(
                                child: Container(

                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      '${(locked_list['mobile_number'])}',
                                      // textAlign: TextAlign.start,
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.black54
                                      ),
                                    ))),
                            Expanded(
                              child:    Container(
                                  padding: EdgeInsets.only(left: 40.0),
                                  alignment: Alignment.bottomLeft,
                                  child: Row(children: [
                                    Text(
                                      'Commission: ',
                                      maxLines: 1,
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.black54
                                      ),
                                    ),

                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      '${locked_list['commission']}',
                                      maxLines: 1,
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Palette.BottomMenu,
                                      ),
                                    ),
                                  ])),
                            ),
                          ])),


                    ])),
          ),

        ]));
  }
  Widget RetailerList(locked_list) {
    return GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, Routes.EDITDISTRIBUTORSCREEN);
        },
        child: Stack(children: [
          Container(
            child: Card(
                margin: EdgeInsets.only(left: 16, bottom: 8, right: 16),
                shadowColor: Colors.black,
                elevation: 2.0,
                color: Colors.white,
                shape: new RoundedRectangleBorder(
                    side:
                    new BorderSide(color: Colors.white, width: 2.0),
                    borderRadius: BorderRadius.circular(14.0)),
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        child: new Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[

                              Expanded(
                                child: Container(
                                    padding:
                                    EdgeInsets.only(left: 10.0),
                                    alignment: Alignment.bottomLeft,
                                    child: Row(children: [
                                      Text(
                                        locked_list['distributor'] ?? "--",
                                        maxLines: 1,
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                            fontSize: 13,
                                            color: Palette.BottomMenu,
                                            fontWeight: FontWeight.bold
                                        ),
                                      ),
                                    ])),
                              ),
                              Expanded(
                                child: Container(
                                    height: 25,
                                    //  padding: EdgeInsets.only(right: 25.0),
                                    margin: EdgeInsets.only(left: 60, right: 6),
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        color:   Palette.RetailersButton,

                                        borderRadius:
                                        BorderRadius.circular(12.0)),
                                    child: Text(
                                      locked_list['distributor_type'],

                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12.0),
                                    )),
                              ),
                            ]),
                      ),
                      Container(
                          padding: EdgeInsets.only(left: 10.0, top: 5,bottom: 10),
                          child: new Row(children: <Widget>[

                            Expanded(
                                child: Container(

                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      '${(locked_list['mobile_number'])}',
                                      // textAlign: TextAlign.start,
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.black54
                                      ),
                                    ))),
                            Expanded(
                              child:    Container(
                                  padding: EdgeInsets.only(left: 40.0),
                                  alignment: Alignment.bottomLeft,
                                  child: Row(children: [
                                    Text(
                                      'Commission: ',
                                      maxLines: 1,
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.black54
                                      ),
                                    ),

                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      '${locked_list['commission']}',
                                      maxLines: 1,
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Palette.BottomMenu,
                                      ),
                                    ),
                                  ])),
                            ),
                          ])),


                    ])),
          ),

        ]));
  }
  Widget AgentsList(locked_list) {
    return GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, Routes.EDITDISTRIBUTORSCREEN);
        },
        child: Stack(children: [
          Container(
            child: Card(
                margin: EdgeInsets.only(left: 16, bottom: 8, right: 16),
                shadowColor: Colors.black,
                elevation: 2.0,
                color: Colors.white,
                shape: new RoundedRectangleBorder(
                    side:
                    new BorderSide(color: Colors.white, width: 2.0),
                    borderRadius: BorderRadius.circular(14.0)),
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        child: new Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[

                              Expanded(
                                child: Container(
                                    padding:
                                    EdgeInsets.only(left: 10.0),
                                    alignment: Alignment.bottomLeft,
                                    child: Row(children: [
                                      Text(
                                        locked_list['distributor'] ?? "--",
                                        maxLines: 1,
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                            fontSize: 13,
                                            color: Palette.BottomMenu,
                                            fontWeight: FontWeight.bold
                                        ),
                                      ),
                                    ])),
                              ),
                              Expanded(
                                child: Container(
                                    height: 25,
                                    //  padding: EdgeInsets.only(right: 25.0),
                                    margin: EdgeInsets.only(left: 60, right: 6),
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        color:Palette.AgentsButton,

                                        borderRadius:
                                        BorderRadius.circular(12.0)),
                                    child: Text(
                                      locked_list['distributor_type'],

                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12.0),
                                    )),
                              ),
                            ]),
                      ),
                      Container(
                          padding: EdgeInsets.only(left: 10.0, top: 5,bottom: 10),
                          child: new Row(children: <Widget>[

                            Expanded(
                                child: Container(

                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      '${(locked_list['mobile_number'])}',
                                      // textAlign: TextAlign.start,
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.black54
                                      ),
                                    ))),
                            Expanded(
                              child:    Container(
                                  padding: EdgeInsets.only(left: 40.0),
                                  alignment: Alignment.bottomLeft,
                                  child: Row(children: [
                                    Text(
                                      'Commission: ',
                                      maxLines: 1,
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.black54
                                      ),
                                    ),

                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      '${locked_list['commission']}',
                                      maxLines: 1,
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Palette.BottomMenu,
                                      ),
                                    ),
                                  ])),
                            ),
                          ])),


                    ])),
          ),

        ]));
  }
}
