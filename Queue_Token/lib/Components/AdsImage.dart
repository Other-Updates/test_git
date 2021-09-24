import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class AdsImages extends StatefulWidget {
  @override
  _AdsImagesState createState() => _AdsImagesState();
}

class _AdsImagesState extends State<AdsImages> {
  List images = [];

  // adsapi() async {
  //   String basicAuth = "Basic YWRtaW46MTIzNA==";
  //   //   SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  //   //var data = json.encode({"name":usernameController.text,"mobile_number":phonenumberController.text,"email_id":emailController.text,"password":passwordController.text});
  //   final response = await http.get(BASE_URL + 'get_adverstisment_details',
  //       headers: {'authorization': basicAuth});
  //   if (response.statusCode == 200) {
  //     var jsonResponse = json.decode(response.body);
  //     // print(jsonResponse);
  //     if (jsonResponse['status'] == "success") {
  //       setState(() {
  //         images = jsonResponse['data'][0]['ads_details'];
  //       });
  //
  //       //  print(images);
  //
  //       //  Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => CustomerDashboardScreen()), (Route<dynamic> route) => false);
  //     }
  //     //   sharedPreferences.setString("token", jsonResponse['token']);
  //   }
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Swiper(
      itemWidth: double.infinity,
      autoplay: true,
      itemBuilder: (BuildContext context, int index) {
        return (Image.network(
          images[index],
          fit: BoxFit.fill,
        ));
      },
      itemCount: 1,
      viewportFraction: 1.0,
      scale: 0.9,
      layout: SwiperLayout.DEFAULT,
    );
  }
}
