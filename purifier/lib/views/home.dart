import 'package:flutter/material.dart';

class HomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 100,
            color: Colors.grey,
          ),
          Expanded(
            flex: 3,
            child: Text("Hello"),
          ),
          Expanded(
            flex: 1,
            child: Container(color: Colors.grey),
          )
        ],
      ),
    );
  }
}
