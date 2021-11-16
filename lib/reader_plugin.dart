
import 'dart:async';

import 'package:flutter/services.dart';

class ReaderPlugin {
  static const MethodChannel _channel =
      const MethodChannel('reader_plugin');

  //flutter initialization completed and notify native
  //NOTE: native flutterEngine must called after flutter initialization completed
  static Future<String> notifyNativeInitCompleted(Map? params) async {
  String resultStr = await _channel.invokeMethod('flutter_component_init_completed', params);
  return resultStr;
  }

  //open native book reader
  static Future<String> pushToOpenBook(Map params) async {
  String resultStr = await _channel.invokeMethod('open_book', params);
  return resultStr;
  }

  //open native file chooser
  static Future<String> pushToOpenFilePicker(Map? params) async {
  String resultStr = await _channel.invokeMethod('open_file_picker', params);
  return resultStr;
  }

  //native db book list
  static Future<String> pushToGetLocalBookList(Map? params) async {
  String resultStr = await _channel.invokeMethod('get_book_list', params);
  return resultStr;
  }

  //native remove book from db by id
  static Future<String> pushToRemoveBook(Map? params) async {
  String resultStr = await _channel.invokeMethod('remove_from_library', params);
  return resultStr;
  }
}
