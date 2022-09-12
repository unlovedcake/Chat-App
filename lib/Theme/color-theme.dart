import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyTheme {
  MyTheme._();


  static final TextStyle appTitle = GoogleFonts.grandHotel(fontSize: 36);

  static const TextStyle he = TextStyle(
    color: Color(0xff686795),
    fontSize: 18,
    fontWeight: FontWeight.w600,
    letterSpacing: 1.5,
  );

  static final TextStyle chatSenderName = TextStyle(
    color: Colors.white,
    fontSize: 24,
    fontWeight: FontWeight.bold,
    letterSpacing: 1.5,
  );

  static const TextStyle bodyText1 = const TextStyle(
      color: Color(0xffAEABC9),
      fontSize: 14,
      letterSpacing: 1.2,
      fontWeight: FontWeight.w500);

  static const TextStyle bodyTextMessage =
  TextStyle(fontSize: 13, letterSpacing: 1.5, fontWeight: FontWeight.w600);

  static const TextStyle bodyTextTime = TextStyle(
    color: Color(0xffAEABC9),
    fontSize: 11,
    fontWeight: FontWeight.bold,
    letterSpacing: 1,
  );
}