import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_jpreader/reader_plugin.dart';

import 'book_entity.dart';

class BookViewModel extends ChangeNotifier {
  bool _disposed = false;
  List<Book> books = [];

  Future<void> notifyNative() async {
    print('=============flutter init completed=============');
    await ReaderPlugin.notifyNativeInitCompleted(null);
  }

  Future<void> openBook(String id) async {
    print('=============Open book=============');
    await ReaderPlugin.pushToOpenBook({"book_id": id});
  }

  Future<void> getLocalBookList() async {
    print('=============get book list=============');
    String? jsonString = await ReaderPlugin.pushToGetLocalBookList(null);
    if (jsonString != null) {
      var booksList = (json.decode(jsonString) as List)
          .map((data) => Book.fromJson(data))
          .toList();
      books.addAll(booksList);
      notifyListeners();
    }
  }

  Future<void> updateLocalBookList() async {
    print('=============update book list=============');
    String? jsonString = await ReaderPlugin.pushToGetLocalBookList(null);
    print('=============update $jsonString =============');
    if (jsonString != null) {
      books.clear();
      var booksList = (json.decode(jsonString) as List)
          .map((data) => Book.fromJson(data))
          .toList();
      books.addAll(booksList);
      notifyListeners();
    }
  }

  Future<String> removeBookFromLibrary(String id) async {
    print('=============Remove book=============');
    return await ReaderPlugin.pushToRemoveBook({"book_id": id});
  }

  Future<void> openFilePicker() async {
    print('=============Open picker=============');
    await ReaderPlugin.pushToOpenFilePicker(null);
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  @override
  void notifyListeners() {
    if (!_disposed) {
      super.notifyListeners();
    }
  }
}
