import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'dart:async';

import 'package:queue_token/Screens/TokenDashboard.dart';

class FeedbackScreen extends StatefulWidget {
  @override
  _FeedbackScreenState createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  TextEditingController feedbackController = TextEditingController();
  TextEditingController ratingController = TextEditingController();

  var _rating;
  int _currentRating = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Timer(
        Duration(seconds: 80),
        () => Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => TokenDashboard())));
    return Scaffold(
        body: Center(
            child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                // color: Color(0xff00BCD4),
                decoration: BoxDecoration(
                    image: DecorationImage(
                        colorFilter: new ColorFilter.mode(
                            Colors.black.withOpacity(0.7), BlendMode.dstATop),
                        image: AssetImage('assets/images/dark.jpg'),
                        fit: BoxFit.cover)),
                child: ListView(
                  //  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                        padding:
                            EdgeInsets.only(top: 80.0, bottom: 10, left: 10.0),
                        alignment: Alignment.center,
                        child: Text(
                          'FEEDBACK',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Montserrat',
                              fontSize: 22),
                        )),
                    Container(
                        padding:
                            EdgeInsets.only(top: 30.0, bottom: 10, left: 10.0),
                        child: Row(children: [
                          Padding(
                              padding: EdgeInsets.only(left: 10.0, right: 20.0),
                              child: Text(
                                'Rating:',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18),
                              )),
                          RatingBar.builder(
                            initialRating: 0,
                            unratedColor: Colors.white,
                            minRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemCount: 5,
                            itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                            itemBuilder: (context, _) => Icon(
                              Icons.star,
                              color: Color(0xfff48f0a),
                            ),
                            onRatingUpdate: (rating) {
                              // print(rating);
                              setState(() {
                                _rating = rating;
                                print("rating changed: rating = $_rating");
                              });
                            },
                          )
                        ])),
                    Container(
                        padding:
                            EdgeInsets.only(top: 30.0, bottom: 10, left: 10.0),
                        child: Row(children: [
                          Padding(
                              padding: EdgeInsets.only(left: 10.0, right: 20.0),
                              child: Text(
                                'Remarks:',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18),
                              )),
                          Container(
                            padding:
                                EdgeInsets.only(left: 18, top: 20, bottom: 15),
                            child: Text(
                              'write your comments',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18),
                            ),
                          ),
                        ])),
                    Container(
                      padding: EdgeInsets.fromLTRB(15, 10, 15, 15),
                      child: TextFormField(
                        textAlign: TextAlign.start,
                        controller: feedbackController,
                        keyboardType: TextInputType.multiline,
                        maxLength: null,
                        maxLines: 5,
                        decoration: InputDecoration(
                          hintStyle: TextStyle(
                              color: Colors.grey, fontFamily: 'Montserrat'),
                          filled: true,
                          fillColor: Colors.white,
                          enabledBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(8.0)),
                            borderSide:
                                BorderSide(color: Colors.grey, width: 0.8),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(8.0)),
                            borderSide:
                                BorderSide(color: Colors.grey, width: 0.8),
                          ),
                          //  labelText: 'Password',
                        ),
                      ),
                    ),
                    Container(
                        height: 75,
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                                child: RaisedButton(
                                  textColor: Colors.white,
                                  color: Colors.red,
                                  child: Text('Cancel',
                                      style: TextStyle(
                                          fontFamily: 'Montserrat',
                                          fontWeight: FontWeight.bold)),
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        new BorderRadius.circular(8.0),
                                  ),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                child: RaisedButton(
                                  textColor: Colors.white,
                                  color: Colors.green,
                                  child: Text('Submit',
                                      style: TextStyle(
                                          fontFamily: 'Montserrat',
                                          fontWeight: FontWeight.bold)),
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        new BorderRadius.circular(8.0),
                                  ),
                                  onPressed: () {
                                    _showSuccessDialog();

                                    //  Navigator.pop(context);
                                  },
                                ),
                              ),
                            ])),
                  ],
                ))));
  }

  Future<void> _showSuccessDialog() async {
    Timer(
        Duration(seconds: 2),
        () => Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => TokenDashboard())));
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
            content: SingleChildScrollView(
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
              Container(
                padding: EdgeInsets.fromLTRB(5, 8, 5, 10),
                child: Text('Thanks!!!',
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54)),
              ),
              Container(
                child: Text('Thanks for your Feedback',
                    maxLines: 1,
                    style: TextStyle(
                        fontFamily: 'Montserrat',
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black38)),
              ),
              // Container(
              //   height: 55,
              //   padding: EdgeInsets.only(top: 15.0),
              //   alignment: Alignment.center,
              //   child: RaisedButton(
              //     textColor: Colors.white,
              //     color: Colors.lightBlueAccent,
              //     child: Text('okay',
              //         style: TextStyle(
              //             fontFamily: 'Montserrat',
              //             fontWeight: FontWeight.bold)),
              //     shape: RoundedRectangleBorder(
              //       borderRadius: new BorderRadius.circular(8.0),
              //     ),
              //     onPressed: () {
              //       Navigator.pop(context);
              //       Navigator.of(context).push(MaterialPageRoute(
              //           builder: (BuildContext context) => TokenDashboard()));
              //     },
              //   ),
              // ),
            ])));
      },
    );
  }
}
