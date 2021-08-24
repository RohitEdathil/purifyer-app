import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:purifier/connector.dart';
import 'package:purifier/views/home.dart';

class LoadingView extends StatelessWidget {
  void connect(BuildContext context) {
    Provider.of<Connector>(context, listen: false)
        .connect()
        .then((value) => print(value));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Stack(
          children: [
            Center(child: Lottie.asset('assets/connecting.json')),
          ],
        ),
      ),
    );
  }
}
