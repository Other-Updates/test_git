import 'package:coolincool/Utils/Colors.dart';
import 'package:coolincool/Utils/Menudrawer.dart';
import 'package:coolincool/Utils/Routes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/services.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';


class DashboardScreen extends StatefulWidget {

   DateTime? initialDate;

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  DateTime? initialDate = DateTime.now();
  GlobalKey<ScaffoldState> _key = new GlobalKey<ScaffoldState>();

  List<charts.Series<Task, String>>? _seriesPieData;
  List<charts.Series<Sales, int>>? _seriesLineData;

  _generateData() {

    var piedata = [

      new Task('Coolincool', 35.8, Color(0xff3366cc)),
      new Task('F2F Distributor', 8.3, Color(0xff990099)),
      new Task('CIC Distributor', 10.8, Color(0xff109618)),
      new Task('Foood Distributor', 15.6, Color(0xfffdbe19)),
      new Task('Masala Distributor', 19.2, Color(0xffff9900)),
      new Task('Cool Distributor', 19.2, Color(0xffdc3912)),
    ];


    var linesalesdata2 = [
      new Sales(0, 20),
      new Sales(1, 40),
      new Sales(2, 25),
      new Sales(3, 15),
      new Sales(4, 60),
      new Sales(5, 20),
      new Sales(6, 40),
      new Sales(7, 50),
      new Sales(8, 60),
      new Sales(9, 70),
      new Sales(10, 20),
      new Sales(11, 30),
      new Sales(12, 40),
      new Sales(13, 50),
    ];

    _seriesPieData!.add(
      charts.Series(
        domainFn: (Task task, _) => task.task,
        measureFn: (Task task, _) => task.taskvalue,
        colorFn: (Task task, _) =>
            charts.ColorUtil.fromDartColor(task.colorval),
        id: 'Order Distributor',
        data: piedata,
        labelAccessorFn: (Task row, _) => '${row.taskvalue}',
      ),
    );


    _seriesLineData!.add(
      charts.Series(
        colorFn: (__, _) => charts.ColorUtil.fromDartColor(Colors.lightBlueAccent),
        id: 'Sales Order',
        data: linesalesdata2,
        domainFn: (Sales sales, _) => sales.monthval,
        measureFn: (Sales sales, _) => sales.salesval,
      ),
    );
  }

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

  DateTime? selectedDate;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _seriesPieData = <charts.Series<Task, String>>[];
    _seriesLineData = <charts.Series<Sales, int>>[];
    _generateData();
    selectedDate = widget.initialDate;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
        resizeToAvoidBottomInset: true,
        drawer: Drawer(
          child: HomeMenuDrawer(),
        ),
      body: Container(
        color: Colors.black12,
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
          child:  ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                Stack(
              children:[
                buildBackgroundTopCircle(),
                Padding(
padding:EdgeInsets.only(top: 130),
                child:Align(
                  alignment: Alignment.bottomCenter,
              child:  Card(
        margin:EdgeInsets.only(left: 20,right: 20) ,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
    child:  Column(
mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 10,
        ),
        Align(
          alignment: Alignment.topRight,
          child:

        Container(
            height: 35,
           width: 200,
           alignment: Alignment.topRight,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),

            ),
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
                 "December"}'+" , " + '${selectedDate?.year}' ,
                hintStyle: TextStyle(color: Colors.blue , fontSize: 16),
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

            )  ) ),
        SizedBox(
          height: 15,
        ),
        Container(
          height: 180,

        width: double.infinity,
        child:  Row(children: [
            Expanded(child:

             charts.PieChart(
                  _seriesPieData!,
                  animate: true,
                  animationDuration: Duration(seconds: 2),
               defaultRenderer: new charts.ArcRendererConfig(
                   arcWidth: 30,
                   arcRendererDecorators: [
                     new charts.ArcLabelDecorator(
                         labelPosition: charts.ArcLabelPosition.inside)
                   ]),
               defaultInteractions: true,

                  behaviors: [
                    new charts.DatumLegend(
                      outsideJustification: charts.OutsideJustification.middle,
                      position: charts.BehaviorPosition.end,
                      legendDefaultMeasure: charts.LegendDefaultMeasure.none,

                      horizontalFirst: false,
                      desiredMaxRows: 6,

                      cellPadding: new EdgeInsets.only(right: 4.0, bottom: 5.0),
                      entryTextStyle: charts.TextStyleSpec(
                          color: charts.MaterialPalette.purple.shadeDefault,
                          fontFamily: 'Georgia',
                          fontSize: 11),
                    )
                   ],

             ),),


          ])),
           Container(
             height: 150,
                    padding: EdgeInsets.all(8.0),
                  child: Expanded(
                          child: charts.LineChart(
                              _seriesLineData!,
                              defaultRenderer: new charts.LineRendererConfig(
                                  includeArea: true, stacked:false),
                              animate: true,
                              animationDuration: Duration(seconds: 5),

                          ),
                        ),),

      ]))),)
              ]),
                SizedBox(
                  height: 20,
                ),
                Container(

                 child:   _tabSection(context),

                ),
              ])

    ),


    );
  }

  Positioned buildBackgroundTopCircle() {
    return Positioned(
      child: Container(

            height: 190,

            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: Palette.PrimaryColor,
            ),
            child: Column(
              children: [
                SizedBox(
                  height: 15,
                ),
                Row(
                  children: [
                  Align(
            alignment:Alignment.centerRight,
                    child: IconButton( onPressed: () {   _key.currentState!.openDrawer(); }, icon: Image.asset("assets/images/menu.png",width: 27,height: 27,color: Colors.white,),),
                  ),
                    SizedBox(width: 40,),
                    Text( "Today's sales Order",style:TextStyle(color: Colors.white,fontSize: 20),),
                  ],
                ),
                Row(
                  children: [
                    SizedBox(width: 115,),
                    Text( "₹ 25000",style:TextStyle(color: Colors.white,fontSize: 30,fontWeight: FontWeight.bold),),
                    SizedBox(width: 60,),
                    IconButton( onPressed: () {  }, icon: Icon(Icons.refresh,color: Colors.white,size: 35,)),
                  ],
                ),
              ],
            ),
          ),


    );
  }

  Widget _tabSection(BuildContext context) {

    return DefaultTabController(
      length: 3,
      initialIndex: 1,
      child: ListView(
        physics: ClampingScrollPhysics(),
        shrinkWrap: true,
        children: <Widget>[
          SizedBox(
            height: 5,
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
                      ) : (visitorHistory['status'] == "NOT SHIPPED") ? Icon(
                        Icons.home,
                        color: Colors.white,
                        size: 20,
                      ) : Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 20,
                      ),
                    )),
              )),
        ]));
  }
}
class Pollution {
  String place;
  int year;
  int quantity;

  Pollution(this.year, this.place, this.quantity);
}

class Task {
  String task;
  double taskvalue;
  Color colorval;

  Task(this.task, this.taskvalue, this.colorval);
}

class Sales {
  int monthval;
  int salesval;

  Sales(this.monthval, this.salesval);
}