import 'package:flutter/material.dart';
import 'package:flutter_jpreader/reader_app.dart';
import 'package:flutter_jpreader/reader_theme_data.dart';

void main() => runApp(ReaderAppPage(
      callback: (content) {},
      readerThemeData: ReaderThemeData(
          backgroundColor: Colors.black,
          primaryColor: Colors.white,
          subTitleColor: Colors.grey,
          titleColor: Colors.white),
    ));
