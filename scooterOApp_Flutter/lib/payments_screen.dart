import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class PaymentsScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: Colors.green),home: Paymentspage());
  }
}

class Paymentspage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => new _State();

}

class _State extends State<Paymentspage> {
  // TextEditingController entercodeController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  // https://demo.f2fsolutions.co.in/ScooterO/api/api_update_customer_wallet
  //   {"customer_id":"1","pay_amount":"10"}

  Widget build(BuildContext context) {
    return Scaffold(

      // body: SafeArea(
      /*child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
              padding: EdgeInsets.only(left: 20.0, top: 20.0),*/
      /*  appBar: AppBar(

        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                    builder: (BuildContext context) =>HomeScreen()
                )
            );
          },
          child: Icon(
            Icons.close,  // add custom icons also
          ),
        ),
        title: Text('Wallet'),
      centerTitle: true,

        backgroundColor:Color(0xff00DD00),

      ),*/

      //  body: Center(child: SwipeList()));
        body: Center(

            child: Container(


                child: ListView(

                    children: <Widget>[

                      Container(
                        height: 50.0,
                        color: Color(0xff00DD00),
                        child: new Column(
                          children: <Widget>[
                            Padding(
                                padding: EdgeInsets.only(left: 20.0, top: 20.0),
                                child: new Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    new Icon(
                                      Icons.arrow_back_ios_outlined,
                                      color: Colors.white,
                                      size: 22.0,
                                    ),
                                    Padding(

                                      padding: EdgeInsets.only(left: 200.0),
                                      child: new Text('Payments', textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20.0,
                                              fontFamily: 'Montserrat',
                                              color: Colors.white)),
                                    )

                                  ],
                                )),

                          ],
                        ),
                      ),
                      Container(
                          child: new CustomPaint(
                            painter: ShapesPainter(),
                            child: Container(height: 200,
                              width: 460,
                              child: Column(

                                children: <Widget>[
                                  Container(
                                    padding: EdgeInsets.only(top: 100.0),

                                    child:Text('0 SAR',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.white,),),
                                  ),
                                  Text('Available Balance',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.white,),)

                                ],
                              ),),



                          )),
                      Container(
                          height: 55,
                          padding: EdgeInsets.fromLTRB(15,8, 15, 0),
                          child: RaisedButton(
                            textColor: Colors.white,
                            color: Color(0xff00DD00),
                            child: Text('Credited',style:TextStyle(fontFamily: 'Montserrat',fontWeight: FontWeight.bold)),
                            shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(28.0),),
                            onPressed:() {
                              // login();
                            },
                          )
                      ),
                      Container(
                          height: 55,
                          padding: EdgeInsets.fromLTRB(15,8, 15, 0),
                          child: RaisedButton(
                            textColor: Colors.black54,
                            color: Color(0xffE6FFE6),
                            child: Text('Debited',style:TextStyle(fontFamily: 'Montserrat',fontWeight: FontWeight.bold)),
                            shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(28.0),),
                            onPressed:() {

                            },
                          )
                      ),

                      /*  Container(
                          child: ListItemWidget()),*/
                    ]  ) )  ) );


  }

}
const double _kCurveHeight = 35;

class ShapesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final p = Path();
    p.lineTo(0, size.height - _kCurveHeight);
    p.relativeQuadraticBezierTo(size.width / 2, 2 * _kCurveHeight, size.width, 0);
    p.lineTo(size.width, 0);
    p.close();
    canvas.drawPath(p, Paint()..color = Color(0xff00DD00),);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}









/*class SwipeList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ListItemWidget();
  }
}*/

/*
class ListItemWidget extends StatefulWidget {
  List items = getDummyList();

  @override
  Widget build(BuildContext context) {
    return Container(
        child: ListView.builder(

          itemCount: items.length,
          itemBuilder: (context, index) {
            return Dismissible(
              key: Key(items[index]),
              background: Container(
                alignment: AlignmentDirectional.centerEnd,
                color: Colors.red,
                child: Icon(
                  Icons.delete,
                  color: Colors.white,
                ),
              ),
              onDismissed: (direction) {
                setState(() {
                  items.removeAt(index);
                });
              },
              direction: DismissDirection.endToStart,
              child: Card(
                elevation: 5,
                child: Container(
                  height: 100.0,
                  child: Row(
                    children: <Widget>[
                      Container(
                        height: 100.0,
                        width: 70.0,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(5),
                                topLeft: Radius.circular(5)
                            ),
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage("https://is2-ssl.mzstatic.com/image/thumb/Video2/v4/e1/69/8b/e1698bc0-c23d-2424-40b7-527864c94a8e/pr_source.lsr/268x0w.png")
                            )
                        ),
                      ),
                      Container(
                        height: 100,
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(10, 2, 0, 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                items[index],

                              ),
                              Padding(
                                padding: EdgeInsets.fromLTRB(0, 3, 0, 3),
                                child: Container(
                                  width: 30,
                                  decoration: BoxDecoration(
                                      border: Border.all(color: Colors.teal),
                                      borderRadius: BorderRadius.all(Radius.circular(10))
                                  ),
                                  child: Text("3D",textAlign: TextAlign.center,),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.fromLTRB(0, 5, 0, 2),
                                child: Container(
                                  width: 260,
                                  child: Text("His genius finally recognized by his idol Chester",style: TextStyle(
                                      fontSize: 15,
                                      color: Color.fromARGB(255, 48, 48, 54)
                                  ),),


                                ),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        ));
  }

  static List getDummyList() {
    List list = List.generate(10, (i) {
      return "Item ${i + 1}";
    });
    return list;
  }

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    throw UnimplementedError();
  }
*/
//}
/*google_maps_flutter: ^0.5.25
geolocator: ^5.3.0*/

// <key>NSLocationAlwaysUsageDescription</key>
// <string>Needed to access location</string>
// <key>NSLocationWhenInUseUsageDescription</key>
// <string>Needed to access location</string>
