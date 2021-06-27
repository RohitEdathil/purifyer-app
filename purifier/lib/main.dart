import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:purifier/connector.dart';
import 'package:purifier/views/loading.dart';

void main() {
  runApp(PurifyerApp());
}

class PurifyerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
    return ChangeNotifierProvider(
      create: (BuildContext context) => Connector(),
      child: MaterialApp(
        theme: ThemeData(
            primaryColor: Color(0xFF417505),
            backgroundColor: Colors.white,
            accentColor: Color(0xFF417505),
            dividerColor: Colors.grey),
        debugShowCheckedModeBanner: false,
        home: LoadingView(),
      ),
    );
  }
}
