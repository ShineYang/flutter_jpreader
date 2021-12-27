import 'package:flutter/material.dart';
import 'package:flutter_jpreader/reader_app.dart';
import 'package:flutter_jpreader/reader_theme_data.dart';

void main() => runApp(ReaderAppPage(
      callback: (content) {},
      readerLightThemeData: ReaderThemeData(
          backgroundColor: Colors.white,
          primaryColor: Colors.green,
          subTitleColor: Colors.black38,
          titleColor: Colors.black),
      readerDarkThemeData: ReaderThemeData(
          backgroundColor: Colors.black,
          primaryColor: Colors.green,
          subTitleColor: Colors.grey,
          titleColor: Colors.white),
    ));
