import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:purifier/connector.dart';

class PurifierPhoto extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final currentTime = DateTime.now().hour * 60 + DateTime.now().minute;
    final time = Provider.of<Connector>(context).time;
    final manuallyOn = Provider.of<Connector>(context).light == 1;
    bool isAuto = Provider.of<Connector>(context).auto == 1;
    bool light = isAuto
        ? (currentTime >= time && currentTime <= time + 1080 ? true : false)
        : manuallyOn;
    final error = Provider.of<Connector>(context).error != ErrorType.noError;

    return FractionallySizedBox(
      heightFactor: 0.8,
      child: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            ImageFiltered(
              imageFilter: ImageFilter.blur(
                sigmaX: error ? 20 : 0,
                sigmaY: error ? 20 : 0,
              ),
              child: Stack(
                alignment: Alignment.center,
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
            !error
                ? SizedBox()
                : Icon(
                    Icons.warning_rounded,
                    color: Colors.amber,
                    size: 60,
                  ),
          ],
        ),
      ),
    );
  }
}
