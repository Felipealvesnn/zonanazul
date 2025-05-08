import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

final ThemeData appThemeData = ThemeData(
  // primarySwatch: colorCustom,
  //primaryColor: colorCustom,

  //buttonColor: successColor,
  //buttonTheme: ButtonThemeData(buttonColor: Colors.blueAccent),
  buttonTheme: ButtonThemeData(buttonColor: Colors.deepOrange),
  brightness: Brightness.light,

  //accentColor: Colors.cyan[600],
  colorScheme: ColorScheme.fromSwatch(accentColor: Colors.cyan[600]),
  appBarTheme: AppBarTheme(
      // color: colorCustom,
      ),
);

final ThemeData appThemeDataDark = ThemeData(
  primaryColor: Colors.black,
  // buttonColor: Colors.black,
  buttonTheme: ButtonThemeData(buttonColor: Colors.blueAccent),
  brightness: Brightness.light,
  //accentColor: Colors.cyan[600],
  colorScheme: ColorScheme.fromSwatch(accentColor: Colors.cyan[600]),
  appBarTheme: AppBarTheme(
    color: Colors.black,
  ),
);

Map<int, Color> color = {
  /*
  50: Color.fromRGBO(0, 92, 169, .1),
  100: Color.fromRGBO(0, 92, 169, .2),
  200: Color.fromRGBO(0, 92, 169, .3),
  300: Color.fromRGBO(0, 92, 169, .4),
  400: Color.fromRGBO(0, 92, 169, .5),
  500: Color.fromRGBO(0, 92, 169, .6),
  600: Color.fromRGBO(0, 92, 169, .7),
  700: Color.fromRGBO(0, 92, 169, 0.8),
  800: Color.fromRGBO(0, 92, 169, 0.9),
  900: Color.fromRGBO(0, 92, 169, 1),
  azul CX */

  50: Color.fromRGBO(37, 42, 255, .1),
  100: Color.fromRGBO(37, 42, 255, .2),
  200: Color.fromRGBO(37, 42, 255, .3),
  300: Color.fromRGBO(37, 42, 255, .4),
  400: Color.fromRGBO(37, 42, 255, .5),
  500: Color.fromRGBO(37, 42, 255, .6),
  600: Color.fromRGBO(37, 42, 255, .7),
  700: Color.fromRGBO(37, 42, 255, 0.8),
  800: Color.fromRGBO(37, 42, 255, 0.9),
  900: Color.fromRGBO(37, 42, 255, 1),
  //azul juno
};

//MaterialColor colorCustom = MaterialColor(0xFF005ca9, color);  //azul caixa
//cor padrao cx    0,92,169      #005ca9

//MaterialColor colorCustom = MaterialColor(0xFF252aff, color); //azul juno
//MaterialColor colorCustomYellow = MaterialColor(0xffcc43, color); //yellow