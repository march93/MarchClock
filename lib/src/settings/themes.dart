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
}