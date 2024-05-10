import 'package:bapp/services/color.manager.dart';
import 'package:flutter/material.dart';

class AppStyles {
  static final AppStyles _instance = AppStyles._internal();

  factory AppStyles() {
    return _instance;
  }

  AppStyles._internal() {
    _initialize();
  }

  final ColorManager _colorManager = ColorManager();
  int _colorCode = 0;

  void _initialize() async {
    _colorCode = await _colorManager.prefferedColor() ?? 0;
  }

  InputDecoration get inputFieldStyle => InputDecoration(
        filled: true,
        fillColor: Colors.grey,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none),
        contentPadding: const EdgeInsets.all(8.0),
      );

  TextStyle get defaultTextStyle => const TextStyle(
        fontSize: 16.0,
        color: Colors.black,
      );

  ThemeData buildThemeData() {
    switch (_colorCode) {
      case 1:
        return ThemeData(
          primaryColor: Colors.green,
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.green,
            iconTheme: IconThemeData(
                color: Colors.white), // Setting icon color in the AppBar
          ),
          iconTheme:
              const IconThemeData(color: Colors.green), // Default icon theme
          primaryIconTheme: const IconThemeData(
              color: Colors
                  .white), // Icon theme for icons in primary color context
        );
      case 2:
        return ThemeData(
          primaryColor: Colors.blue,
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.blue,
            iconTheme: IconThemeData(
                color: Colors.white), // Setting icon color in the AppBar
          ),
          iconTheme:
              const IconThemeData(color: Colors.blue), // Default icon theme
          primaryIconTheme: const IconThemeData(
              color: Colors
                  .white), // Icon theme for icons in primary color context
        );
      default:
        return ThemeData(
          primaryColor: Colors.red,
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.red,
            iconTheme: IconThemeData(
                color: Colors.white), // Setting icon color in the AppBar
          ),
          iconTheme:
              const IconThemeData(color: Colors.red), // Default icon theme
          primaryIconTheme: const IconThemeData(
              color: Colors
                  .white), // Icon theme for icons in primary color context
        );
    }
  }

  Color primaryColor() {
    switch (_colorCode) {
      case 1:
        return Colors.green;
      case 2:
        return Colors.blue;
      case 3:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
