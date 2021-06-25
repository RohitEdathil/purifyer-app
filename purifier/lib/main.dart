import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:purifier/views/loading.dart';

void main() {
  runApp(PurifyerApp());
}

class PurifyerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
    return MaterialApp(
      theme: ThemeData(primaryColor: Color(0xFF417505)),
      debugShowCheckedModeBanner: false,
      home: LoadingView(),
    );
  }
}
