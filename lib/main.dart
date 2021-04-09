import 'dart:math';

import 'package:accountbook/vo/bill.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';

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
      home: MyHomePage(title: ''),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;

  MyHomePage({Key? key, this.title = ""}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  DateTime? _date;

  _MyHomePageState() {
    _date = DateTime.now().toLocal();
  }

  String formattedDate() {
    final df = DateFormat.yMMM(Localizations.localeOf(context).languageCode);
    return df.format(_date ?? DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBillsView(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      leadingWidth: 96,
      leading: Center(
          child: TextButton(
              onPressed: () {},
              child: Text(formattedDate(),
                  style: Theme.of(context).textTheme.bodyText1))),
      title: Text(widget.title),
    );
  }

  Widget _buildBillsView() {
    // return ListView.builder(
    //   itemCount: bills?.length ?? 0,
    //   itemBuilder: (context, index) {
    //     final bill = bills?.elementAt(index);
    //     if (bill == null) return Container();
    //     return Padding(
    //       padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
    //       child: Row(
    //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //         crossAxisAlignment: CrossAxisAlignment.center,
    //         children: [
    //           Text(
    //             bill.account,
    //             style: Theme.of(context).textTheme.bodyText2,
    //           ),
    //           Text(
    //             "${bill.amount.toString()}${bill.currencySymbol}",
    //             style: Theme.of(context)
    //                 .textTheme
    //                 .bodyText1
    //                 ?.copyWith(color: Colors.red),
    //           ),
    //           Text(bill.genre,
    //               style: Theme.of(context)
    //                   .textTheme
    //                   .bodyText2
    //                   ?.copyWith(color: Colors.black38))
    //         ],
    //       ),
    //     );
    //   },
    // );
    return Container();
  }
}
