import 'package:flutter/material.dart';

class AddBillView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AddBillState();
  }
}

class _AddBillState extends State {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("添加账单"),
      ),
      body: Center(
        child: Text("简单地添加一个账单"),
      ),
    );
  }
}
