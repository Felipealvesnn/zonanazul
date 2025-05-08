import 'package:flutter/material.dart';

final ThemeData appTemaTeste = ThemeData(
  colorSchemeSeed: Colors.blue,
);
final ThemeData appTema = ThemeData(
    dialogBackgroundColor: Colors.white,
    dialogTheme: const DialogTheme(
      // Definindo a cor de fundo do AlertDialog
      backgroundColor: Colors.white,
    ),
    colorScheme: ColorScheme.fromSwatch(
      backgroundColor: Colors.white,
      primarySwatch: colorCustom,
      brightness: Brightness.light, // Definindo brilho escuro aqui
    ).copyWith(
      secondary: const Color.fromARGB(255, 255, 0, 64),
    ),
    inputDecorationTheme: InputDecorationTheme(
      fillColor: Colors.white,
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.red),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.black),
      ),
      enabledBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Colors.black),
      ),
    ),
    iconButtonTheme: IconButtonThemeData(
      style: ButtonStyle(
        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
            const EdgeInsets.all(15)),
        // backgroundColor: MaterialStateProperty.all<Color>(Color(0xff252aff)!),
        textStyle: MaterialStateProperty.all(
          const TextStyle(color: Colors.black),
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
            backgroundColor:
                MaterialStateProperty.all<Color>(Colors.grey[300]!),
            textStyle: MaterialStateProperty.all(
                const TextStyle(color: Colors.black)))),
    iconTheme: IconThemeData(color: colorCustom),
    brightness: Brightness.light,
    visualDensity: VisualDensity.standard,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        textStyle: MaterialStateProperty.resolveWith<TextStyle>(
          (Set<MaterialState> states) {
            return const TextStyle(color: Colors.white);
          },
        ),
        backgroundColor: MaterialStateProperty.resolveWith<Color?>(
          (Set<MaterialState> states) {
            return const Color(0xFFffcc43);
          },
        ),
      ),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: colorCustom,
      elevation: 10,
      iconTheme: const IconThemeData(color: Colors.white),
      toolbarTextStyle: const TextTheme(
        titleLarge: TextStyle(
          color: Colors.white,
          fontSize: 20,
        ),
      ).bodyMedium,
      titleTextStyle: const TextTheme(
        titleLarge: TextStyle(
          color: Colors.white,
          fontSize: 20,
        ),
      ).titleLarge,
    ),
    switchTheme: SwitchThemeData(
      // é a cor da bolinha do switch
      thumbColor: MaterialStateProperty.resolveWith<Color?>(
        (Set<MaterialState> states) {
          return colorCustom;
        },
      ),
      trackOutlineColor: MaterialStateProperty.resolveWith<Color?>(
        (Set<MaterialState> states) {
          return colorCustom;
        },
      ),
      // background do switch
      trackColor: MaterialStateProperty.resolveWith<Color?>(
        (Set<MaterialState> states) {
          return Colors.white;
        },
      ),
    ),
    primaryColor: colorCustom,
    primarySwatch: colorCustom,
    cardColor: Colors.white,
    scaffoldBackgroundColor: const Color.fromARGB(255, 233, 233, 233),
    dividerColor: Colors.grey,
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        color: Colors.black,
      ),
    ),
    drawerTheme: DrawerThemeData(
      backgroundColor: colorCustom,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: colorCustom,
      elevation: 10,
      selectedItemColor: colorCustom,
      unselectedItemColor: Colors.black54,
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: colorCustom,
    ));

final ThemeData appTemaDark = ThemeData(
    iconTheme: const IconThemeData(color: Colors.white),
    // brightness: Brightness.dark,
    // visualDensity: VisualDensity.standard,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.resolveWith<Color?>(
            (Set<MaterialState> states) {
          return Colors.grey;
        }),
      ),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xff252aff),
    ),
    primaryColor: Colors.grey,
    primarySwatch: Colors.grey,
    cardColor: Colors.white,
    scaffoldBackgroundColor: Colors.grey,
    dividerColor: Colors.white,
    colorScheme: ColorScheme.fromSwatch(
            primarySwatch: colorCustom, brightness: Brightness.dark)
        .copyWith(secondary: Colors.greenAccent, brightness: Brightness.dark),
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        color: Colors.grey,
      ),
      bodyLarge: TextStyle(
        color: Colors.white,
      ),
    ),
    drawerTheme: const DrawerThemeData(
      backgroundColor: Color.fromARGB(255, 44, 44, 44),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.black54,
        elevation: 10,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white10),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Colors.black45,
    ));

Map<int, Color> color = {
  50: const Color.fromRGBO(0, 51, 153, .1),
  100: const Color.fromRGBO(0, 51, 153, .2),
  200: const Color.fromRGBO(0, 51, 153, .3),
  300: const Color.fromRGBO(0, 51, 153, .4),
  400: const Color.fromRGBO(0, 51, 153, .5),
  500: const Color.fromRGBO(0, 51, 153, .6),
  600: const Color.fromRGBO(0, 51, 153, .7),
  700: const Color.fromRGBO(0, 51, 153, 0.8),
  800: const Color.fromRGBO(0, 51, 153, 0.9),
  900: const Color.fromRGBO(0, 51, 153, 1),
  //azul juno
};

MaterialColor colorCustom = MaterialColor(0xFF003399, color); //azul juno

