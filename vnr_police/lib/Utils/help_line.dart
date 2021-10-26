import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class Help {
  void sendSms(String number) => launch('sms:$number');

  String name;
  String desc;
  String image;
  String subtitle;
  Icon icon;
  IconButton onPressed;

  Help({
    required this.name,
    required this.desc,
    required this.subtitle,
    required this.image,
    required this.icon,
    required this.onPressed,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['desc'] = this.desc;
    data['subtitle'] = this.subtitle;
    data['image'] = this.image;
    data['icon'] = this.icon;
    data['onPressed'] = this.onPressed;
    return data;
  }
}

List<Help> helplines = [

];

Future<void> sendMessage1() async {
  const  url ='sms:+6854623781?body=message';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}
Future<void> callNcdc() async {
  const url = 'tel://080097000010';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

Future<void> launchWhatsappWho() async {
  const url = 'https://api.whatsapp.com/send?phone=41798931892&text=Hi';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

// NCDC toll free number 080097000010