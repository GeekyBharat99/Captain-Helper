import 'package:captain_helper/UI/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final style = GoogleFonts.montserrat(
  textStyle: TextStyle(color: titleColor, fontWeight: FontWeight.w500),
);

final style1 = GoogleFonts.montserrat(
  textStyle: TextStyle(
    fontWeight: FontWeight.w500,
    color: underLineColor,
  ),
);

final styleW20C = GoogleFonts.montserrat(
  textStyle: TextStyle(
    fontSize: 20.0,
    fontWeight: FontWeight.w400,
  ),
);

Widget snackSample(var text) {
  return SnackBar(
    content: Text(
      text,
      style: TextStyle(
        color: backGroundColor,
        fontSize: 20,
      ),
      textAlign: TextAlign.center,
    ),
    duration: Duration(seconds: 2),
    backgroundColor: underLineColor,
    behavior: SnackBarBehavior.floating,
    elevation: 10.0,
  );
}
