import 'package:flutter/material.dart';
import 'package:flutter_jpreader/reader_home_page.dart';
import 'package:flutter_jpreader/reader_theme_data.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'arch/lifecycle_watcher_state.dart';
import 'generated/l10n.dart';

typedef ContentCallBack = void Function(String content);

class ReaderAppPage extends StatefulWidget {
  final ContentCallBack callback;
  final ReaderThemeData readerLightThemeData;
  final ReaderThemeData readerDarkThemeData;

  const ReaderAppPage(
      {Key? key, required this.callback, required this.readerLightThemeData, required this.readerDarkThemeData})
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
      themeMode: ThemeMode.system,
      theme: ThemeData(
        backgroundColor: widget.readerLightThemeData.backgroundColor,
        scaffoldBackgroundColor: widget.readerLightThemeData.backgroundColor,
        primaryColor: widget.readerLightThemeData.primaryColor,
        textTheme:  TextTheme(
          headline1: const TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold,),
          bodyText1: const TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.bold),//title
          subtitle1: TextStyle(fontSize: 12, color: widget.readerLightThemeData.subTitleColor),//author subtitle
        ),
      ),
      darkTheme: ThemeData(
        backgroundColor: widget.readerDarkThemeData.backgroundColor,
        scaffoldBackgroundColor: widget.readerDarkThemeData.backgroundColor,
      primaryColor: widget.readerDarkThemeData.primaryColor,
      textTheme: TextTheme(
        headline1: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold,),
        bodyText1: const TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.bold),//title
        subtitle1: TextStyle(fontSize: 12, color: widget.readerDarkThemeData.subTitleColor),//author subtitle
      ),
    ),
      home: ReaderHomePage(
        callback: (content) {
          widget.callback(content);
        },
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


