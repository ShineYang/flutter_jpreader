import 'dart:typed_data';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'arch/lifecycle_watcher_state.dart';
import 'arch/provider_widget.dart';
import 'book_entity.dart';
import 'book_view_model.dart';

typedef _ContentCallBack = void Function(String content);

class ReaderHomePage extends StatefulWidget {
  const ReaderHomePage({Key? key, required this.callback}) : super(key: key);

  final _ContentCallBack callback;

  @override
  State<ReaderHomePage> createState() => _ReaderHomePageState();
}

class _ReaderHomePageState extends LifecycleWatcherState<ReaderHomePage> with AutomaticKeepAliveClientMixin {
  BookViewModel? viewModel;

  static const messageChannel =
      BasicMessageChannel('update_tunnel', StringCodec());

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _receiveMessage();
  }

  @override
  Widget build(BuildContext context) {
    return ProviderWidget<BookViewModel>(
      model: BookViewModel(),
      onReady: (model) {
        viewModel = model;
        model.addListener(() {
          setState(() {
            model.notifyNative();
            model.books;
          });
        });
        viewModel?.getLocalBookList();
      },
      builder: (ctx, model, child) {
        return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              elevation: 0,
              actions: [
                IconButton(
                  icon: const Icon(Icons.add, color: Colors.green, size: 28),
                  onPressed: () async {
                    model.openFilePicker();
                  },
                )
              ],
              backgroundColor: Colors.white,
              title: const Text('书架',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  )),
            ),
            backgroundColor: Colors.white,
            body: Container(
              child: _buildBooks(model),
            ));
      },
    );
  }

  _buildBooks(BookViewModel model) {
    return GridView.builder(
      physics: const ClampingScrollPhysics(),
      itemCount: model.books.length,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 10,
          mainAxisSpacing: 20,
          childAspectRatio: 0.54),
      itemBuilder: (BuildContext context, int index) {
        return _buildBookItem(model.books[index]);
      },
    );
  }

  _buildBookItem(Book book) {
    ///处理无封面
    _buildBookCover(List<int>? elements) {
      if (elements == null) {
        return Container(
          alignment: Alignment.topCenter,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFFF4EDE4),
                  Color(0xFFE4D6C5),
                ]),
            color: Colors.blueGrey,
          ),
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  book.title == null ? "" : book.title!,
                  style: const TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Center(
                child: Text(
                  book.author == null ? "" : book.author!,
                  style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF8A7A65),
                      fontWeight: FontWeight.bold),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        );
      } else {
        return Image.memory(
            Uint8List.fromList(
              elements,
            ),
            fit: BoxFit.cover);
      }
    }

    return GestureDetector(
      onTap: () {
        viewModel?.openBook(book.id.toString());
      },
      onLongPress: () async {
        //长按删除
        _showDeleteDialog(context, book);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: _buildBookCover(book.cover)),
          const SizedBox(
            height: 8,
          ),
          Text(
            '${book.title}',
            style: const TextStyle(
                color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(
            height: 4,
          ),
          Text(
            '${book.author}',
            style: const TextStyle(
              color: Color(0xffB1B1B1),
              fontSize: 12,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  _showDeleteDialog(BuildContext context, Book book) {
    Widget cancelButton = TextButton(
      child: const Text('取消', style: TextStyle(color: Colors.green, fontSize: 14),),
      onPressed:  () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = TextButton(
      child: const Text('删除', style: TextStyle(color: Colors.redAccent, fontSize: 14),),
      onPressed:  () {
        _remove(book);
      },
    );

    AlertDialog alert = AlertDialog(
      title: const Text('请确认'),
      content: const Text('将从书库中删除这本书'),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  _update() {
    setState(() {
      viewModel?.updateLocalBookList();
    });
  }

  ///接收native端的更新请求
  _receiveMessage() {
    messageChannel.setMessageHandler((message) => Future<String>(() {
          print('native book insert success');
          switch (message) {
            case 'update_db_success':
              _update();
              break;
            default:
              //分析回调
              widget.callback(message!);
              break;
          }
          return '';
        }));
  }

  ///删除
  _remove(Book book) async {
    String result = await viewModel!.removeBookFromLibrary(book.id.toString());
    if (result == "1") {
      ///删除成功
      viewModel?.books.remove(book);
      _update();
    }
  }

  @override
  void dispose() {
    super.dispose();
    viewModel?.dispose();
  }

  @override
  void onDetached() {}

  @override
  void onInactive() {}

  @override
  void onPaused() {}

  @override
  void onResumed() {
    _update();
  }
}
