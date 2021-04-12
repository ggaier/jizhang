import 'dart:math';

import 'package:accountbook/bills/bills_view.dart';
import 'package:accountbook/repository/bills_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate
      ],
      supportedLocales: [
        const Locale("en"),
        const Locale.fromSubtags(languageCode: 'zh'),
        // generic Chinese 'zh'
        const Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hans'),
        // generic simplified Chinese 'zh_Hans'
        const Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant'),
        // generic traditional Chinese 'zh_Hant'
        const Locale.fromSubtags(
            languageCode: 'zh', scriptCode: 'Hans', countryCode: 'CN'),
        // 'zh_Hans_CN'
        const Locale.fromSubtags(
            languageCode: 'zh', scriptCode: 'Hant', countryCode: 'TW'),
        // 'zh_Hant_TW'
        const Locale.fromSubtags(
            languageCode: 'zh', scriptCode: 'Hant', countryCode: 'HK'),
        // 'zh_Hant_HK'
      ],
      theme:
      ThemeData(primaryColor: Colors.white, accentColor: Colors.lightGreen),
      home: RepositoryProvider(
        create: (context) => BillsRepositoryImpl(),
        child: BillsView(title: ""),
      ),
    );
  }
}
