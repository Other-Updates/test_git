import 'package:flutter/material.dart';

class TermsConditions extends StatefulWidget {
  const TermsConditions({Key? key}) : super(key: key);

  @override
  _TermsConditionsState createState() => _TermsConditionsState();
}

class _TermsConditionsState extends State<TermsConditions> {
  final List<String> entries = <String>['A', 'B', 'C'];
  final List<int> colorCodes = <int>[600, 500, 100];
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
          backgroundColor: Colors.transparent,
          elevation: 0.0,
        ),
        body: Container(
            padding: const EdgeInsets.only(left: 16),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Padding(
                padding: EdgeInsets.only(left: 10.0, right: 20.0),
                child: Text(
                  'Terms & Conditions',
                  style: TextStyle(
                      color: Colors.black54,
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0),
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              Padding(
                  padding: EdgeInsets.only(left: 10.0, right: 20.0),
                  child: Text(
                    'Here are many variations of passages of Lorem Ipsum available, but the majority have suffered alteration in some form, by injected humour, or randomised words which don look even slightly believable. If you are going to use a passage of Lorem Ipsum, you need to be sure there isnt anything embarrassing hidden in the middle of text.',
                    maxLines: 10,
                    style: TextStyle(fontSize: 18.0),
                  )),
            ])));
  }
}
