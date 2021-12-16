import 'package:coolincool/Utils/Colors.dart';
import 'package:coolincool/Utils/Menudrawer.dart';
import 'package:coolincool/Utils/Routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
class SalesOrderScreen extends StatefulWidget {
  const SalesOrderScreen({Key? key}) : super(key: key);

  @override
  _SalesOrderScreenState createState() => _SalesOrderScreenState();
}

class _SalesOrderScreenState extends State<SalesOrderScreen> {
  List yesterday_distributor = [
    {
      "distributor_id": "SAL001",
      "distributor": "CoolinCool Distributor",
      "date": "08/12/2021",
      "amount": "₹ 1500",
      "status": "DELIVERED"
    },
    {
      "distributor_id": "SAL002",
      "distributor": "F2F Distributor",
      "date": "08/12/2021",
      "amount": "₹ 1000",
      "status": "NOT SHIPPED"
    },
    {
      "distributor_id": "SAL003",
      "distributor": "CIC Distributor",
      "date": "08/12/2021",
      "amount": "₹ 2000",
      "status": "CANCELLED"
    },
    {
      "distributor_id": "SAL004",
      "distributor": "Food Masala Distributor",
      "date": "08/12/2021",
      "amount": "₹ 3000",
      "status": "DELIVERED"
    },
    {
      "distributor_id": "SAL005",
      "distributor": "CIC Masala Distributor",
      "date": "08/12/2021",
      "amount": "₹ 1500",
      "status": "DELIVERED"
    },
    {
      "distributor_id": "SAL006",
      "distributor": "F2F Distributor",
      "date": "08/12/2021",
      "amount": "₹ 2000",
      "status": "NOT SHIPPED"
    },
    {
      "distributor_id": "SAL007",
      "distributor": "CIC Distributor",
      "date": "08/12/2021",
      "amount": "₹ 1000",
      "status": "CANCELLED"
    },
    {
      "distributor_id": "SAL008",
      "distributor": "CoolinCool Distributor",
      "date": "08/12/2021",
      "amount": "₹ 3000",
      "status": "NOT SHIPPED"
    },
    {
      "distributor_id": "SAL009",
      "distributor": "Food Masala Distributor",
      "date": "08/12/2021",
      "amount": "₹ 2500",
      "status": "CANCELLED"
    },
  ];
  List today_distributor = [
    {
      "distributor_id": "SAL001",
      "distributor": "CoolinCool Distributor",
      "date": "09/12/2021",
      "amount": "₹ 1500",
      "status": "DELIVERED"
    },
    {
      "distributor_id": "SAL002",
      "distributor": "F2F Distributor",
      "date": "09/12/2021",
      "amount": "₹ 1000",
      "status": "NOT SHIPPED"
    },
    {
      "distributor_id": "SAL003",
      "distributor": "CIC Distributor",
      "date": "09/12/2021",
      "amount": "₹ 2000",
      "status": "CANCELLED"
    },
    {
      "distributor_id": "SAL004",
      "distributor": "Food Masala Distributor",
      "date": "09/12/2021",
      "amount": "₹ 3000",
      "status": "DELIVERED"
    },
    {
      "distributor_id": "SAL005",
      "distributor": "CIC Masala Distributor",
      "date": "09/12/2021",
      "amount": "₹ 1500",
      "status": "DELIVERED"
    },
    {
      "distributor_id": "SAL006",
      "distributor": "F2F Distributor",
      "date": "09/12/2021",
      "amount": "₹ 2000",
      "status": "NOT SHIPPED"
    },
    {
      "distributor_id": "SAL007",
      "distributor": "CIC Distributor",
      "date": "09/12/2021",
      "amount": "₹ 1000",
      "status": "CANCELLED"
    },
    {
      "distributor_id": "SAL008",
      "distributor": "CoolinCool Distributor",
      "date": "09/12/2021",
      "amount": "₹ 3000",
      "status": "NOT SHIPPED"
    },
    {
      "distributor_id": "SAL009",
      "distributor": "Food Masala Distributor",
      "date": "09/12/2021",
      "amount": "₹ 2500",
      "status": "CANCELLED"
    },
  ];
  List tommorrow_distributor = [
    {
      "distributor_id": "SAL001",
      "distributor": "CoolinCool Distributor",
      "date": "10/12/2021",
      "amount": "₹ 1500",
      "status": "DELIVERED"
    },
    {
      "distributor_id": "SAL002",
      "distributor": "F2F Distributor",
      "date": "10/12/2021",
      "amount": "₹ 1000",
      "status": "NOT SHIPPED"
    },
    {
      "distributor_id": "SAL003",
      "distributor": "CIC Distributor",
      "date": "10/12/2021",
      "amount": "₹ 2000",
      "status": "CANCELLED"
    },
    {
      "distributor_id": "SAL004",
      "distributor": "Food Masala Distributor",
      "date": "10/12/2021",
      "amount": "₹ 3000",
      "status": "DELIVERED"
    },
    {
      "distributor_id": "SAL005",
      "distributor": "CIC Masala Distributor",
      "date": "10/12/2021",
      "amount": "₹ 1500",
      "status": "DELIVERED"
    },
    {
      "distributor_id": "SAL006",
      "distributor": "F2F Distributor",
      "date": "10/12/2021",
      "amount": "₹ 2000",
      "status": "NOT SHIPPED"
    },
    {
      "distributor_id": "SAL007",
      "distributor": "CIC Distributor",
      "date": "10/12/2021",
      "amount": "₹ 1000",
      "status": "CANCELLED"
    },
    {
      "distributor_id": "SAL008",
      "distributor": "CoolinCool Distributor",
      "date": "10/12/2021",
      "amount": "₹ 3000",
      "status": "NOT SHIPPED"
    },
    {
      "distributor_id": "SAL009",
      "distributor": "Food Masala Distributor",
      "date": "10/12/2021",
      "amount": "₹ 2500",
      "status": "CANCELLED"
    },
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
        title: Text("Sales Order",style: TextStyle(fontSize: 23),),
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
                  child: IconButton( onPressed: () { Navigator.pushNamed(context, Routes.ADDSALESORDERSCREEN);}, icon: Image.asset("assets/images/plus.png",width: 15,height: 15,color: Colors.white,),),

                ),

              ]
          )
        ],

        systemOverlayStyle: SystemUiOverlayStyle(
          // Navigation bar
            statusBarColor: Palette.PrimaryColor,
            statusBarBrightness: Brightness.light// Status bar
        ),

      ),
      body: Container(
        color: Colors.black12,

        child: _tabSection(context),
      ),
    );
  }

  Widget _tabSection(BuildContext context) {
    return DefaultTabController(
      length: 3,
initialIndex: 1,

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
                indicatorPadding: EdgeInsets.only(
                    left: 5, right: 5, top: 5, bottom: 5),
                tabs: [
                  Tab(
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        "Yesterday",
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
                        "Today",
                        maxLines: 1,
                        style: TextStyle(
                          fontSize: 14,),
                      ),
                    ),
                  ),
                  Tab(
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        "Tomorrow",
                        maxLines: 1,
                        style: TextStyle(
                          fontSize: 14,),
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
            height: MediaQuery
                .of(context)
                .size
                .height,
            child: TabBarView(children: [

              Expanded(

                  child: (yesterday_distributor.length > 0)
                      ? ListView.separated(
                    separatorBuilder: (BuildContext context, int index) {
                      return SizedBox(height: 6);
                    },
                    physics: ClampingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: yesterday_distributor.length,
                    itemBuilder: (context, index) =>
                        EachList(yesterday_distributor[index]),
                  )
                      : Center(
                    child: Image.asset('assets/images/loader.gif'),
                  )

              ),
              Expanded(
                  child: (today_distributor.length > 0)
                      ? ListView.separated(
                    separatorBuilder: (BuildContext context, int index) {
                      return SizedBox(height: 6);
                    },
                    physics: ClampingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: today_distributor.length,
                    itemBuilder: (context, index) =>
                        EachList(today_distributor[index]),
                  )
                      : Center(
                    child: Image.asset('assets/images/loader.gif'),
                  )

              ),
              Expanded(
                  child: (tommorrow_distributor.length > 0)
                      ? ListView.separated(
                    separatorBuilder: (BuildContext context, int index) {
                      return SizedBox(height: 6);
                    },
                    physics: ClampingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: tommorrow_distributor.length,
                    itemBuilder: (context, index) =>
                        EachList(tommorrow_distributor[index]),
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



  Widget EachList(visitorHistory) {
    return GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, Routes.EDITSALESORDERSCREEN);
        },
        child: Stack(children: [
          Container(
            height: 70,
            child: Card(
              margin: EdgeInsets.only(left: 30, bottom: 8, right: 15),

              shadowColor: Colors.black,
              elevation: 2.0,
              color: Colors.white,
              shape: new RoundedRectangleBorder(
                  side: new BorderSide(color: Colors.white, width: 2.0),
                  borderRadius: BorderRadius.circular(12.0)),
              child: Column(children: [
                SizedBox(
                  height: 5,
                ),
                Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        width: 20,
                      ),
                      Expanded(
                          child: Row(children: [

                            Container(
                              child: Text(
                                visitorHistory['distributor_id'],
                                style: TextStyle(color:Palette.BottomMenu,fontWeight: FontWeight.bold,),
                              ),),

                          ])),

                      Container(
                        child: Text(
                          visitorHistory['amount'],
                          style: TextStyle(color:Palette.BottomMenu,fontWeight: FontWeight.bold,),
                        ),
                      ),
                      SizedBox(
                        width: 12,
                      ),
                    ]),
                SizedBox(
                  height: 3,
                ),
                Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        width: 20,
                      ),
                      Expanded(
                          child: Row(children: [

                            Container(
                              child: Text(
                                visitorHistory['distributor'],
                                style: TextStyle(color: Colors.black, fontSize: 13),
                              ),
                            ),

                          ])),

                      Container(
                        child: Text(
                          visitorHistory['status'],
                          style: TextStyle(   color: (visitorHistory['status'] == "DELIVERED")
                              ? Palette.PrimaryColor
                              : (visitorHistory['status'] == "NOT SHIPPED")
                              ? Colors.blueAccent
                              : Colors.red, fontSize: 14),

                        ),
                      ),
                      SizedBox(
                        width: 12,
                      ),
                    ]),
                SizedBox(
                  height: 3,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 20,
                    ),


                    Container(
                      child: Text(visitorHistory['date'],style: TextStyle(color: Colors.black38,fontSize: 11),),
                    ),
                  ],
                ),
              ]),
            ),
          ),
          Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(top: 18, bottom: 5,left: 15),
                child: SizedBox(

                  //     child: CircleAvatar(
                  //   radius: 10,
                  //   backgroundImage: AssetImage("assets/images/locked-house.png"),
                  //   backgroundColor: Colors.white,
                  // )
                    child: Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: (visitorHistory['status'] == "DELIVERED")
                              ? Palette.PrimaryColor
                              : (visitorHistory['status'] == "NOT SHIPPED")
                              ? Colors.blueAccent
                              : Colors.red),
                      child: (visitorHistory['status'] == "DELIVERED") ? Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 20,
                      ) : (visitorHistory['status'] == "NOT SHIPPED") ? Image(
                        color:Colors.white,
                        height: 10,
                        width: 20,
fit: BoxFit.cover,
                        image:   AssetImage("assets/images/notshipped.png"),) :
                      Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 20,
                      ),
                    )),
              )),
        ]));
  }
}


