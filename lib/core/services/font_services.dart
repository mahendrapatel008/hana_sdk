import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FontService {
  // FontService._();

  static TextStyle custom({
    double fontSize = 14.0,
    Color color = Colors.black,
    FontWeight fontWeight = FontWeight.normal,
  }) {
    return GoogleFonts.poppins(
      fontSize: fontSize,
      color: color,
      fontWeight: fontWeight,
    );
  }
}
