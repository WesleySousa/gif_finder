import 'package:flutter/material.dart';
import 'package:gif_finder/ui/home_page.dart';

void main() {
  runApp(MaterialApp(
    theme: ThemeData(
      accentColor: Colors.white,
      hintColor: Colors.white,
      inputDecorationTheme: InputDecorationTheme(
        enabledBorder:
            OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
        focusedBorder:
            OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
        hintStyle: TextStyle(color: Colors.white),
      ),
    ),
    home: HomePage(),
    debugShowCheckedModeBanner: false,
  ));
}
