import 'package:flutter/material.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  List cardList = [
    {
      'description':
          'The light in living room is not working since 1 week. Please check the issue'
    },
    {
      'description':
          'The fan in living room is not working since 1 week. Please check the issue'
    },
    {
      'description':
          'The printer in living room is not working since 1 week. Please check the issue'
    },
    {
      'description':
          'The Ac in living room is not working since 1 week. Please check the issue'
    },
    {
      'description':
          'The light in living room is not working since 1 week. Please check the issue'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back,
              color: Color(0xffEFCC00), // add custom icons also
            ),
          ),
          title: Text(
            'Notification',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
                fontFamily: 'Montserrat',
                color: Colors.black54),
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0.0,
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
            shadowColor: Color(0x802196F3),
            elevation: 14.0,
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
                          "assets/images/profileIot.jpg",
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
