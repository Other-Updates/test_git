import 'package:flutter/material.dart';

class StaffInfo {
  final String? pngSrc, title;

  StaffInfo({
    this.pngSrc,
    this.title,
  });
}

List demoMyStaff = [
  StaffInfo(
    title: "General",
    pngSrc: "assets/images/doctor.png",
  ),
  StaffInfo(
    title: "Treatment",
    pngSrc: "assets/images/nurse.png",
  ),
  StaffInfo(
    title: "Cash",
    pngSrc: "assets/images/bed.png",
  ),
  StaffInfo(
    title: "Scan",
    pngSrc: "assets/images/pharm.png",
  ),
];
