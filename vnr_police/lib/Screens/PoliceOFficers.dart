import 'package:flutter/material.dart';
import 'package:vnr_police/Components/Colors.dart';
import 'package:vnr_police/Utils/Routes.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:vnr_police/Utils/help_line.dart';

class PoliceOfficers extends StatefulWidget {
  const PoliceOfficers({Key? key}) : super(key: key);

  @override
  _PoliceOfficersState createState() => _PoliceOfficersState();
}

class _PoliceOfficersState extends State<PoliceOfficers> {
  List cardList = [
    {'description': 'James', 'position': 'Constable'},
    {'description': 'Peter', 'position': 'Head-Constable'},
    {'description': 'John', 'position': 'Sub-Inspector'},
    {'description': 'Mike', 'position': 'Inspector'},
    {'description': 'Mark', 'position': 'DSP'},
    {'description': 'Joseph', 'position': 'SP'},
    {'description': 'Justin', 'position': 'DIG'},
    {'description': 'Bieber', 'position': 'IG'},
  ];

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Palette.SecondaryColor,
          leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios_outlined,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(context);
              }),
          title: Text(
            'Police Officers',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          automaticallyImplyLeading: false,
        ),
        body: Container(
            color: Palette.BackgroundColor,
            padding: const EdgeInsets.only(left: 10.0, right: 10.0),
            child: Column(
                //crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                      child: ListView.builder(
                    itemCount: cardList.length,
                    itemBuilder: (context, index) => EachList(cardList[index]),
                  )),
                ])));
  }

  @override
  Widget EachList(cardList) {
    return GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, Routes.POLICEOFFICERSDETAILSSCREEN);
        },
        child: new Card(
            shadowColor: Palette.PrimaryColor,
            elevation: 2.0,
            color: Colors.white,
            shape: new RoundedRectangleBorder(
                //  side: new BorderSide(color: Color(0xffADDFDE), width: 2.0),
                borderRadius: BorderRadius.circular(12.0)),
            child: Container(
                height: 80.0,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                padding: EdgeInsets.only(left: 10.0, right: 10.0),
                child: Stack(children: [
                  // CircleAvatar(
                  //     radius: 35,
                  //     backgroundColor: Colors.white,
                  //     child: ClipRRect(
                  //       borderRadius: BorderRadius.circular(35),
                  //       child: Image.asset(
                  //         "assets/images/loginLogin.png",
                  //         width: double.infinity,
                  //         height: double.infinity,
                  //         fit: BoxFit.cover,
                  //       ),
                  //     )),
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Row(children: [
                        Container(
                          width: 15,
                          height: 50,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage("assets/images/icon.png"))),
                        ),
                        // Icon(
                        //   Icons.local_police,
                        //   color: Palette.PrimaryColor,
                        // ),
                        // Expanded(
                        //     child: Padding(
                        //         padding: EdgeInsets.only(left: 10.0, right: 10.0),
                        //         child:
                        SizedBox(
                          width: 30,
                        ),
                        Text(
                          cardList['description'],
                          //  maxLines: 3,
                        ),
                      ])),
                  // ),
                  //           flex: 2),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      cardList['position'],
                      style: TextStyle(
                          color: Palette.PrimaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 14),
                      //  maxLines: 3,
                    ),
                  ),
                  SizedBox(
                    width: 30,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                              icon: Icon(
                                Icons.phone_outlined,
                                color: Colors.green,
                              ),
                              onPressed: () {
                                callNcdc();
                                //   openAlertBox();
                              }),
                          SizedBox(
                            width: 10,
                          ),
                          IconButton(
                              icon: Icon(
                                FontAwesomeIcons.whatsapp,
                                color: Colors.green,
                              ),
                              onPressed: () {
                                launchWhatsappWho();
                                // openAlertBox();
                              }),
                        ]),
                  ),
                ]))));
  }
}
