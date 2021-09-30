import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iot_app/screens/Menudrawer.dart';
import 'package:iot_app/screens/NotificationScreen.dart';

class TopHeader extends StatelessWidget {
  GlobalKey<ScaffoldState> _key = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    return Padding(

      padding: EdgeInsets.only(top: 24, right: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [

          Stack(
            overflow: Overflow.visible,
            children: [
              ClipRRect(
                child: InkWell(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>NotificationScreen()));

                  },
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  width: _width*0.15,
                  height: _height*0.07,
                  child: Image.asset('assets/images/man.jpg',fit: BoxFit.cover,),
                ),
              )),
              Positioned(
                top: -5,
                right: -5,
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: Colors.orangeAccent.shade400,
                    shape: BoxShape.circle
                  ),
                  child: Center(child: Text('4',style: TextStyle(color: Colors.white),)),
                ),
              ),
            ],
          ),
        ],
      ),
    );

  }

}
