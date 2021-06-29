import "package:flutter/material.dart";
import 'package:provider/provider.dart';
import 'package:purifier/connector.dart';

class ErrorView extends StatelessWidget {
  const ErrorView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final error = Provider.of<Connector>(context).error;
    return Scaffold(
        backgroundColor: Theme.of(context).errorColor,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Text(
                error == ErrorType.phError ? "pH" : 'Unknown',
                style: TextStyle(color: Theme.of(context).backgroundColor),
              ),
            )
          ],
        ));
  }
}
