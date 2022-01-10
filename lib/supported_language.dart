import 'package:flutter/material.dart';

enum ReaderSupportedLanguage { zhSC, zhTC, en }

extension SupportedLanguageValue on ReaderSupportedLanguage {
  String get identifier {
    switch (this) {
      case ReaderSupportedLanguage.zhSC:
        return "zh-Hans";
      case ReaderSupportedLanguage.zhTC:
        return "zh-Hant";
      case ReaderSupportedLanguage.en:
        return "en";
    }
  }

  String get name {
    switch (this) {
      case ReaderSupportedLanguage.zhSC:
        return "中文（简体）";
      case ReaderSupportedLanguage.zhTC:
        return "中文（繁體）";
      case ReaderSupportedLanguage.en:
        return "English";
    }
  }

  Locale get locale {
    switch (this) {
      case ReaderSupportedLanguage.zhSC:
        return const Locale("zh", "CN");
      case ReaderSupportedLanguage.zhTC:
        return const Locale("zh", "TW");
      case ReaderSupportedLanguage.en:
        return const Locale("en", "US");
    }
  }
}
