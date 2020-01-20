import 'package:flutter/material.dart';

import 'enums.dart';

class ClockTheme {
  static final lightTheme = {
    ClockElement.background: Color(0xFF81B3FE),
    ClockElement.text: Colors.white,
    ClockElement.shadow: Colors.black,
  };

  static final darkTheme = {
    ClockElement.background: Colors.black,
    ClockElement.text: Colors.white,
    ClockElement.shadow: Color(0xFF174EA6),
  };

  static Map<ClockElement, Color> colors({BuildContext context}) => Theme.of(context).brightness == Brightness.light
    ? ClockTheme.lightTheme
    : ClockTheme.darkTheme;
    
  static double fontSize({BuildContext context}) => MediaQuery.of(context).size.width / 6.5;
  
  static TextStyle defaultStyle({BuildContext context}) => TextStyle(
    color: colors(context: context)[ClockElement.text],
    fontFamily: 'PressStart2P',
    fontSize: fontSize(context: context),
    shadows: [
      Shadow(
        blurRadius: 0,
        color: colors(context: context)[ClockElement.shadow],
        offset: Offset(10, 0),
      ),
    ],
  );
}