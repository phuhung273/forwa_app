import 'package:flutter/material.dart';
import 'package:forwa_app/constants.dart';

final _base = ThemeData.light();

final appTheme = _base.copyWith(
  primaryColor: Colors.white,
  // primaryColorLight: primaryColorLight,
  // primaryColorDark: primaryColorDark,
  // indicatorColor: primaryColor,
  colorScheme: _base.colorScheme.copyWith(
    primary: Colors.white, // affect Appbar
    // primaryVariant: primaryColorLight,
    onPrimary: Colors.black,
    secondary: secondaryColor, // affect FloatingActionButton
    secondaryContainer: secondaryColorLight,
    onSecondary: Colors.white,
    surface: surfaceColor,
    onSurface: onSurfaceColor,
    // onBackground: onSurfaceColor,
  ),
  textTheme: _textTheme,
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      shape: thinRoundedRectangleShape,
      padding: const EdgeInsets.symmetric(vertical: defaultPadding, horizontal: defaultPadding * 2),
      primary: secondaryColor,
      onPrimary: Colors.white,
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      shape: thinRoundedRectangleShape,
      padding: const EdgeInsets.symmetric(vertical: defaultPadding, horizontal: defaultPadding * 2),
      primary: secondaryColor,
      side: const BorderSide(
        color: secondaryColor,
      )
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      padding: const EdgeInsets.symmetric(vertical: defaultPadding, horizontal: defaultPadding * 2),
      primary: onSurfaceColor,
    )
  ),
  inputDecorationTheme: const InputDecorationTheme(
    border: InputBorder.none,
  ),
  dividerTheme: const DividerThemeData(
    color: Colors.white,
    space: defaultSpacing,
  ),
  appBarTheme: AppBarTheme(
    titleTextStyle: TextStyle(
      color: secondaryColor,
      fontSize: _textTheme.subtitle1?.fontSize
    ),
    iconTheme: const IconThemeData(
      color: secondaryColor
    )
  )
);

final _textTheme = _base.textTheme.copyWith(
  // headline1: TextStyle(
  //   fontFamily: 'Montserrat',
  //   fontSize: 96.0,
  //   fontWeight: FontWeight.w300,
  //   color: primaryColor,
  // ),
  // headline2: TextStyle(
  //   fontFamily: 'Montserrat',
  //   fontSize: 60.0,
  //   fontWeight: FontWeight.w300,
  //   color: primaryColor,
  // ),
  // headline3: TextStyle(
  //   fontFamily: 'Montserrat',
  //   fontSize: 48.0,
  //   fontWeight: FontWeight.w400,
  //   color: primaryColor,
  // ),
  // Only use below headline4
  headline4: const TextStyle(
    fontFamily: 'Montserrat',
    // fontSize: 34.0,
    fontWeight: FontWeight.w400,
    color: Colors.black,
  ),
  headline5: const TextStyle(
    fontFamily: 'Montserrat',
    // fontSize: 24.0,
    fontWeight: FontWeight.w500,
    color: Colors.black,
  ),
  headline6: const TextStyle(
    fontFamily: 'Montserrat',
    // fontSize: 20.0,
    fontSize: 24.0,
    fontWeight: FontWeight.w500,
    color: Colors.black,
  ),
  subtitle1: const TextStyle(
    fontFamily: 'Montserrat',
    fontSize: 16.0,
    fontWeight: FontWeight.w500,
    color: Colors.black,
  ),
  subtitle2: const TextStyle(
    fontFamily: 'Montserrat',
    // fontSize: 14.0,
    fontWeight: FontWeight.w500,
    color: Colors.black,
  ),
  bodyText1: const TextStyle(
    fontFamily: 'Montserrat',
    // fontSize: 16.0,
    fontSize: 12.0,
    fontWeight: FontWeight.w400,
    color: Colors.black,
  ),
  bodyText2: const TextStyle(
    fontFamily: 'Montserrat',
    // fontSize: 14.0,
    fontWeight: FontWeight.w400,
    color: Colors.black,
  ),
  button: const TextStyle(
    fontFamily: 'Montserrat',
    // fontSize: 18.0,
    fontWeight: FontWeight.w500,
    // letterSpacing: 1.1,
  ),
  caption: const TextStyle(
    fontFamily: 'Montserrat',
    // fontSize: 12.0,
    fontWeight: FontWeight.w400,
    color: Colors.black,
  ),
);