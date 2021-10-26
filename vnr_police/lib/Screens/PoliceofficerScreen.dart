import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vnr_police/Components/Colors.dart';
import 'package:vnr_police/Utils/help_line.dart';


class PoliceOfficerDetailsScreen extends StatefulWidget {
  const PoliceOfficerDetailsScreen({Key? key}) : super(key: key);

  @override
  _PoliceOfficerDetailsScreenState createState() =>
      _PoliceOfficerDetailsScreenState();
}

class _PoliceOfficerDetailsScreenState
    extends State<PoliceOfficerDetailsScreen> {



  @override
  Widget build(BuildContext context) {
    final Color color1 = Palette.PrimaryColor;
    final Color color2 = Palette.PrimaryColor;
    //  final String image = avatars[0];
    return Scaffold(
      backgroundColor: Palette.BackgroundColor,
        body: SafeArea(
          child: Column(
            children: [
             /* Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(50.0),
                        bottomRight: Radius.circular(50.0)),
                    gradient: LinearGradient(
                        colors: [color1, color2],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight)),
                child: Container(
                  width: double.infinity,
                  height: 200,
                  child: Container(
                    alignment: Alignment(0.0,2.5),

                  ),
                ),
              ),*/
              Expanded(

                child:   Container(
                  height: double.infinity,
                  margin: const EdgeInsets.only(
                      left: 30.0, right: 30.0, top: 10.0),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(30.0),
                      child: Image.asset(
                        'assets/images/police2.jpg',
                        fit: BoxFit.cover,
                      )),
                ),


              ),
              SizedBox(
                height: 50,
              ),
              Text(
                "Ram Kumar IPS"
                ,style: TextStyle(
                  fontSize: 25.0,
                  color:Palette.PrimaryColor,
                  letterSpacing: 2.0,
                  fontWeight: FontWeight.w400
              ),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.location_on,
                    size: 16.0,
                    color: Colors.grey,
                  ),

                  Text(
                    "B2,RS puram,Coimbatore",
                    style: TextStyle(color: Colors.grey.shade600),
                  )
                ],
              ),
              SizedBox(
                height: 20,
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  RaisedButton(
                    onPressed: (){
                      callNcdc();
                    },
                    shape:  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(80.0),
                    ),
                    child: Ink(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [Palette.SecondaryColor,Colors.redAccent]
                        ),
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      child: Container(
                        constraints: BoxConstraints(maxWidth: 100.0,maxHeight: 40.0,),
                        alignment: Alignment.center,
                        child: Text(
                          "Contact me",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 12.0,
                              letterSpacing: 2.0,
                              fontWeight: FontWeight.w300
                          ),
                        ),
                      ),
                    ),
                  ),
                  RaisedButton(
                    onPressed: (){
                      launchWhatsappWho();
                    },
                    shape:  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(80.0),
                    ),
                    child: Ink(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [Palette.SecondaryColor,Colors.redAccent]
                        ),
                        borderRadius: BorderRadius.circular(80.0),
                      ),
                      child: Container(
                        constraints: BoxConstraints(maxWidth: 100.0,maxHeight: 40.0,),
                        alignment: Alignment.center,
                        child: Text(
                          "Watsapp",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 12.0,
                              letterSpacing: 2.0,
                              fontWeight: FontWeight.w300
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      appBar:AppBar(
        backgroundColor: Palette.SecondaryColor,
      leading: new IconButton(
          alignment: Alignment.topLeft,
          icon: new Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context, true);
          }),
      elevation: 0,
      title: Text(
        'Police officers',
        style:
        TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      centerTitle: true,
      automaticallyImplyLeading: false,
    ),
    );


  }
}
