import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_jpreader/reader_home_page.dart';
import 'package:flutter_jpreader/reader_theme_data.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'arch/lifecycle_watcher_state.dart';
import 'arch/provider_widget.dart';
import 'book_entity.dart';
import 'book_view_model.dart';
import 'generated/l10n.dart';

typedef ContentCallBack = void Function(String content);

class ReaderAppPage extends StatefulWidget {
  final ContentCallBack callback;
  final ReaderThemeData readerThemeData;

  const ReaderAppPage(
      {Key? key, required this.callback, required this.readerThemeData})
      : super(key: key);

  @override
  State<ReaderAppPage> createState() => _ReaderAppPageState();
}

class _ReaderAppPageState extends LifecycleWatcherState<ReaderAppPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: const [
        S.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      localeResolutionCallback: (locale, supportLocales) {
        if (locale?.languageCode == 'zh') {
          return const Locale('zh', 'CN');
        }
        return const Locale('en', 'US');
      },
      home: ReaderHomePage(
        callback: (content) {
          widget.callback(content);
        },
        readerThemeData: widget.readerThemeData,
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void onDetached() {}

  @override
  void onInactive() {}

  @override
  void onPaused() {}

  @override
  void onResumed() {}
}
