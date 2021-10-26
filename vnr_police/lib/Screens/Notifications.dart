import 'package:flutter/material.dart';
import 'package:vnr_police/Components/Colors.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  List cardList = [
    {
      'description':
          'The locked house is under police control and prevent from burglaries'
    },
    {
      'description':
          'The locked house is under police control and prevent from burglaries'
    },
    {
      'description':
          'The locked house is under police control and prevent from burglaries'
    },
    {
      'description':
          'The locked house is under police control and prevent from burglaries'
    },
    {
      'description':
          'The locked house is under police control and prevent from burglaries'
    },
    {
      'description':
          'The locked house is under police control and prevent from burglaries'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        backgroundColor: Palette.BackgroundColor,
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
            'Notifications',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          automaticallyImplyLeading: false,
        ),
        body: Container(
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
        child: new Card(
            shadowColor: Palette.PrimaryColor,
            elevation: 4.0,
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
                child: Row(children: [
                  CircleAvatar(
                      radius: 35,
                      backgroundColor: Colors.white,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(35),
                        child: Image.asset(
                          "assets/images/loginLogin.png",
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      )),
                  Expanded(
                      child: Padding(
                          padding: EdgeInsets.only(left: 10.0, right: 10.0),
                          child: Text(
                            cardList['description'],
                            maxLines: 3,
                          )),
                      flex: 2)
                ]))));
  }
}
