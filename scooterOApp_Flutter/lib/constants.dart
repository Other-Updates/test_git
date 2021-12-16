import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

final baseurl = "https://demo.f2fsolutions.co.in/ScooterO/api/";
//final baseurl ="https://portal.scooteroride.com/api/";
String basicAuth = "Basic YWRtaW46MTIzNA==";
int cOTPTimer = 30;


