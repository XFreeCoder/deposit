import 'package:deposit/pages/home.dart';
import 'package:flutter/cupertino.dart';

void main() {
  runApp(const DepositApp());
}

class DepositApp extends StatelessWidget {
  const DepositApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const CupertinoApp(
      title: 'Deposit',
      theme: CupertinoThemeData(brightness: Brightness.light),
      home: HomePage(),
    );
  }
}
