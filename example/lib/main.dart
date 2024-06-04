import 'package:bex_flutter_plugin_example/pairing.dart';
import 'package:bex_flutter_plugin_example/payment.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(
              tabs: [
                Tab(icon: Text("Payment")),
                Tab(icon: Text("Pairing")),
              ],
            ),
            title: Text('BKM Express Flutter Plugin'),
          ),
          body: TabBarView(
            children: [Payment(), Pairing()],
          ),
        ),
      ),
    );
  }
}
