import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:purifier/connector.dart';

class PurifierPhoto extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final currentTime = DateTime.now().hour * 60 + DateTime.now().minute;
    final time = Provider.of<Connector>(context).time;
    bool light =
        currentTime >= time && currentTime <= time + 1080 ? true : false;
    return FractionallySizedBox(
      heightFactor: 0.8,
      child: Center(
        child: Stack(
          children: [
            Image.asset(
              'assets/1.png',
            ),
            Opacity(
              opacity: light ? 1 : 0,
              child: Image.asset(
                'assets/2.png',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
