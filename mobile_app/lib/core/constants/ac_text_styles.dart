import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ACTextStyles {
  static const double fontSizeExtraSmall = 10.0;
  static const double fontSizeSmall = 12.0;
  static const double fontSizeMedium = 14.0;
  static const double fontSizeLarge = 16.0;
  static const double fontSizeExtraLarge = 18.0;
  static const double fontSizeHuge = 20.0;
  static const double fontSizeTitleSmall = 24.0;
  static const double fontSizeTitle = 32.0;

  static const double lineHeightExtraSmall = 1.2;
  static const double lineHeightSmall = 1.4;
  static const double lineHeightMedium = 1.6;
  static const double lineHeightLarge = 1.8;
  static const double lineHeightExtraLarge = 2.0;

  static TextStyle appBarTitle(Color textColor) => GoogleFonts.urbanist(
        fontSize: fontSizeExtraLarge,
        fontWeight: FontWeight.w600,
        color: textColor,
      );

  static TextStyle headlineTitle(Color textColor) => GoogleFonts.urbanist(
        fontSize: fontSizeTitle,
        fontWeight: FontWeight.bold,
        color: textColor,
      );

  static TextStyle heading(Color textColor) => GoogleFonts.urbanist(
        fontSize: fontSizeTitleSmall,
        fontWeight: FontWeight.bold,
        color: textColor,
      );

  static TextStyle bodyText(Color textColor) => GoogleFonts.urbanist(
        fontSize: fontSizeExtraLarge,
        fontWeight: FontWeight.normal,
        height: lineHeightLarge,
        color: textColor,
      );

  static TextStyle smallerBodyText(Color textColor) => GoogleFonts.urbanist(
        fontSize: fontSizeMedium,
        fontWeight: FontWeight.normal,
        height: lineHeightLarge,
        color: textColor,
      );

  static TextStyle buttonText(Color textColor) => GoogleFonts.urbanist(
        fontSize: fontSizeExtraLarge,
        fontWeight: FontWeight.bold,
        height: lineHeightLarge,
        color: textColor,
      );

  static TextStyle inputFormBody(Color textColor) => GoogleFonts.urbanist(
        fontSize: fontSizeSmall,
        fontWeight: FontWeight.normal,
        height: lineHeightLarge,
        color: textColor,
      );
}
