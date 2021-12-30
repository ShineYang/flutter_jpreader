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
      {Key? key,
      required this.callback,
      required this.readerLightThemeData,
      required this.readerDarkThemeData})
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
    ColorScheme lightColorScheme = ColorScheme(
      primary: widget.readerLightThemeData.primaryColor,
      primaryVariant: widget.readerLightThemeData.primaryColor,
      secondary: widget.readerLightThemeData.subTitleColor,
      secondaryVariant: widget.readerLightThemeData.primaryColor,
      background: widget.readerLightThemeData.backgroundColor,
      surface: widget.readerLightThemeData.primaryColor,
      onBackground: Colors.white,
      error: Colors.redAccent,
      onError: Colors.redAccent,
      onPrimary: Colors.redAccent,
      onSecondary: widget.readerLightThemeData.primaryColor,
      onSurface: widget.readerLightThemeData.primaryColor,
      brightness: Brightness.light,
    );

    ColorScheme darkColorScheme = ColorScheme(
      primary: widget.readerDarkThemeData.primaryColor,
      primaryVariant: widget.readerDarkThemeData.primaryColor,
      secondary: widget.readerDarkThemeData.subTitleColor,
      secondaryVariant: widget.readerDarkThemeData.primaryColor,
      background: widget.readerDarkThemeData.backgroundColor,
      surface: widget.readerDarkThemeData.primaryColor,
      onBackground: Colors.white,
      error: Colors.redAccent,
      onError: Colors.redAccent,
      onPrimary: Colors.redAccent,
      onSecondary: widget.readerDarkThemeData.primaryColor,
      onSurface: widget.readerDarkThemeData.primaryColor,
      brightness: Brightness.light,
    );

    return MaterialApp(
      localizationsDelegates: const [
        S.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      localeResolutionCallback: (locale, supportLocales) {
        if (locale?.languageCode == 'zh') {
          if (locale?.scriptCode == 'Hant' ||
              locale?.countryCode == 'TW' ||
              locale?.countryCode == 'HK' ||
              locale?.countryCode == 'MO') {
            return const Locale('zh', 'TW'); //繁体
          } else {
            return const Locale('zh', 'CN'); //简体
          }
        }
        return const Locale('en', 'US');
      },
      themeMode: ThemeMode.system,
      theme: ThemeData(
        colorScheme: lightColorScheme,
        textTheme: const TextTheme(
          headline1: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          bodyText1: TextStyle(
              fontSize: 14,
              color: Colors.black,
              fontWeight: FontWeight.bold), //title
          subtitle1: TextStyle(fontSize: 12), //author subtitle
        ),
      ),
      darkTheme: ThemeData(
        colorScheme: darkColorScheme,
        textTheme: const TextTheme(
          headline1: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          bodyText1: TextStyle(
              fontSize: 14,
              color: Colors.white,
              fontWeight: FontWeight.bold), //title
          subtitle1: TextStyle(fontSize: 12), //author subtitle
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
