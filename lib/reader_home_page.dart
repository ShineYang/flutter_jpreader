import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_jpreader/reader_app.dart';
import 'package:flutter_jpreader/reader_theme_data.dart';
import 'arch/lifecycle_watcher_state.dart';
import 'arch/provider_widget.dart';
import 'book_entity.dart';
import 'book_view_model.dart';
import 'generated/l10n.dart';

class ReaderHomePage extends StatefulWidget {
  final ContentCallBack callback;
  const ReaderHomePage({Key? key, required this.callback}) : super(key: key);

  @override
  State<ReaderHomePage> createState() => _ReaderHomePageState();
}

class _ReaderHomePageState extends LifecycleWatcherState<ReaderHomePage>
    with AutomaticKeepAliveClientMixin {
  BookViewModel? viewModel;
  late ReaderThemeData readerThemeData;

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
                  icon: Icon(Icons.add,
                      color: Theme.of(context).colorScheme.primary, size: 28),
                  onPressed: () async {
                    model.openFilePicker();
                  },
                )
              ],
              backgroundColor: Theme.of(context).colorScheme.background,
              title: Text(S.of(context).appbarTitle,
                  style: Theme.of(context).textTheme.headline1),
            ),
            backgroundColor: Theme.of(context).colorScheme.background,
            body: Container(
              child: _buildBooks(model),
            ));
      },
    );
  }

  _buildBooks(BookViewModel model) {
    if (model.books.isNotEmpty) {
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
          return _buildBookItem(context, model.books[index]);
        },
      );
    } else {
      return _buildEmpty();
    }
  }

  _buildEmpty() {
    return Center(
        child: Text(
      S.of(context).emptyTips,
      style: Theme.of(context).textTheme.subtitle1!.copyWith(
          fontSize: 16, color: Theme.of(context).colorScheme.secondary),
    ));
  }

  _buildBookItem(BuildContext context, Book book) {
    ///处理无封面
    _buildBookCover(List<int>? elements) {
      if (elements == null || elements.isEmpty) {
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
        bool? delete = await _showDeleteConfirmDialog(context, book);
        if (delete != null && delete) {
          //删除文件
          _remove(book);
        }
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
            style: Theme.of(context).textTheme.bodyText1,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(
            height: 4,
          ),
          Text(
            '${book.author}',
            style: Theme.of(context)
                .textTheme
                .subtitle1!
                .copyWith(color: Theme.of(context).colorScheme.secondary),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Future<bool?> _showDeleteConfirmDialog(BuildContext context, Book book) {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.background,
          title: Text(
            S.of(context).confirmDeleteTitle,
            style: Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 16),
          ),
          content: Text(
            S.of(context).confirmDelete,
            style: Theme.of(context).textTheme.bodyText1,
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                S.of(context).cancel,
                style: Theme.of(context).textTheme.subtitle1!.copyWith(fontSize: 14),
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),

            TextButton(
              child: Text(
                S.of(context).delete,
                style: const TextStyle(color: Colors.redAccent, fontSize: 14),
              ),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            )
          ],
        );
      },
    );
  }

  _update() {
    viewModel?.updateLocalBookList();
  }

  ///接收native端的更新请求
  _receiveMessage() {
    messageChannel.setMessageHandler((message) => Future<String>(() {
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
    // _update();
  }
}