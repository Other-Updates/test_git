import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_swiper/flutter_swiper.dart';

class AdsImages extends StatefulWidget {
  @override
  _AdsImagesState createState() => _AdsImagesState();
}

class _AdsImagesState extends State<AdsImages> {
  List images = [
    {"ads_data_link": AssetImage("assets/images/policeBac.jpg")}
  ];

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
        return ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: Image.asset(
              "assets/images/policeBack.jpg",
              //  images[index]['ads_data_link'],
              fit: BoxFit.fill,
            ));
      },
      itemCount: images.length,
      viewportFraction: 0.8,
      scale: 0.8,
      layout: SwiperLayout.DEFAULT,
    );
  }
}
