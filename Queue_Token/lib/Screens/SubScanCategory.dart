import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:queue_token/Screens/TokenDashboard.dart';
import 'package:intl/intl.dart';
import 'package:queue_token/responsive.dart';

class SubScanCategory extends StatefulWidget {
  @override
  _SubScanCategoryState createState() => _SubScanCategoryState();
}

class _SubScanCategoryState extends State<SubScanCategory> {
  String text1 = 'CH0002';
  late String currentTtsString;
  double ttsSpeechRate1 = 0.1;
  double ttsSpeechRate2 = 1.0;
  late double currentSpeechRate;

  late FlutterTts flutterTts;
  bool bolSpeaking = false;

  Future playTtsString1() async {
    bolSpeaking = true;
    currentTtsString = text1;
    currentSpeechRate = ttsSpeechRate1;
    await runTextToSpeech(currentTtsString, currentSpeechRate);
    return null;
  }

  var currentDate = DateFormat('dd MMM yyyy  hh:mm:ss').format(DateTime.now());

  bool print = false;
  bool cancel = false;

  void hideWidget() {
    setState(() {
      print = false;
      cancel = false;
    });
  }

  void showWidget() {
    setState(() {
      print = true;
      cancel = true;
    });
  }

  @override
  void initState() {
    super.initState();
    hideWidget();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/loginback.jpg'),
              colorFilter: ColorFilter.mode(
                  Color(0xffADDFDE).withOpacity(0.5), BlendMode.dstATop),
              fit: BoxFit.cover)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.only(bottom: 15.0),
            child: Text(
              'QUEUING MANAGEMENT SYSTEM',
              style: TextStyle(color: Color(0xff004080), fontSize: 22.0),
            ),
          ),
          Container(
            padding: EdgeInsets.only(bottom: 15.0),
            child: Text(
              'Scan',
              style: TextStyle(color: Color(0xff004080), fontSize: 22.0),
            ),
          ),
          Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0)),
            child: new InkWell(
                onTap: () async {
                  // showWidget();
                  await playTtsString1();
                  _showMyDialog();
                },
                child: new Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            right: 22.0, left: 22.0, top: 5.0, bottom: 5.0),
                        child: Image.asset(
                          "assets/images/checkU.jpg",
                          height: !Responsive.isMobile(context) ? 100 : 100,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 15.0),
                        child: Text(
                          'XRay',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0),
                        ),
                      ),
                    ])),
          ),
          Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0)),
            child: new InkWell(
                onTap: () async {
                  // showWidget();
                  await playTtsString1();
                  _showMyDialog();
                },
                child: new Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            right: 22.0, left: 22.0, top: 5.0, bottom: 5.0),
                        child: Image.asset(
                          "assets/images/checkU.jpg",
                          height: !Responsive.isMobile(context) ? 100 : 100,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 15.0),
                        child: Text(
                          'Ultra Sound',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0),
                        ),
                      ),
                    ])),
          ),
          Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0)),
            child: new InkWell(
                onTap: () async {
                  // showWidget();
                  await playTtsString1();
                  _showMyDialog();
                },
                child: new Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            right: 22.0, left: 22.0, top: 5.0, bottom: 5.0),
                        child: Image.asset(
                          "assets/images/checkU.jpg",
                          height: !Responsive.isMobile(context) ? 100 : 100,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 15.0),
                        child: Text(
                          'CT Scan',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0),
                        ),
                      ),
                    ])),
          ),

          Visibility(
            maintainSize: false,
            maintainAnimation: true,
            maintainState: true,
            visible: print,
            child: Container(
                height: 85,
                width: 200,
                padding: EdgeInsets.fromLTRB(15, 15, 15, 0),
                child: RaisedButton.icon(
                  textColor: Colors.white,
                  color: Colors.deepOrangeAccent,
                  onPressed: () async {
                    await playTtsString1();
                    _showMyDialog();
                    //discover;
                  },
                  icon: Icon(Icons.print),
                  label: Text(
                    'Click me!',
                    style:
                        TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold),
                  ),
                )),
          ),
          Visibility(
            maintainSize: false,
            maintainAnimation: true,
            maintainState: true,
            visible: cancel,
            child: Container(
                height: 75,
                width: 200,
                padding: EdgeInsets.fromLTRB(15, 30, 15, 0),
                child: RaisedButton(
                  textColor: Colors.white,
                  color: Colors.lightBlueAccent,
                  child: Text('Cancel',
                      style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.bold)),
                  shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(8.0),
                  ),
                  onPressed: () {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (BuildContext context) => TokenDashboard()));
                  },
                )),
          ),

          // profile['profile_image']
        ],
      ),
    )));
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
            backgroundColor: Colors.purpleAccent,
            content: SingleChildScrollView(
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                  GestureDetector(
                      child: Container(
                          padding: EdgeInsets.only(left: 15, top: 5),
                          alignment: Alignment.topRight,
                          child: new Icon(
                            Icons.close,
                            color: Colors.black54,
                            size: 24.0,
                          )),
                      onTap: () {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (BuildContext context) =>
                                TokenDashboard()));
                      }),
                  Padding(
                    padding: EdgeInsets.fromLTRB(5, 8, 5, 10),
                    child: Text('F2F',
                        style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 22.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black54)),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(5, 8, 5, 10),
                    child: Text(/*'4 sept 2021   15.07.23'*/ currentDate,
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 16.0,
                          color: Colors.black54,
                        )),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(5, 8, 5, 10),
                    child: Text('Your Token Number',
                        style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 16.0,
                            color: Colors.black54)),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(5, 8, 5, 10),
                    child: Text('CH0002',
                        style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 22.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black)),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(5, 8, 5, 10),
                    child: Text('Your Counter Name',
                        style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 16.0,
                            color: Colors.black54)),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(5, 8, 5, 10),
                    child: Text('Cash',
                        style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 22.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black)),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(5, 8, 5, 10),
                    child: Text('Thank You',
                        style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 16.0,
                            color: Colors.black54)),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(5, 8, 5, 10),
                    child: Text('Powered by F2F solutions',
                        style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black54)),
                  ),
                ])));
      },
    );
  }

  Future<void> runTextToSpeech(
      String currentTtsString, double currentSpeechRate) async {
    flutterTts = new FlutterTts();
    await flutterTts.setLanguage("en-US");
    await flutterTts.setVolume(0.2);
    await flutterTts.setPitch(1.0);
    await flutterTts.isLanguageAvailable("en-US");
    await flutterTts.setSpeechRate(currentSpeechRate);

    flutterTts.setCompletionHandler(() {
      setState(() {
        // The following code(s) will be called when the TTS finishes speaking
        bolSpeaking = false;
      });
    });

    flutterTts.speak(currentTtsString);
  }
}
