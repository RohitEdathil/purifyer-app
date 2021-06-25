import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';

class LoadingView extends StatelessWidget {
  void testMode() async {
    await HapticFeedback.selectionClick();
    print("Test Mode Triggered");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Stack(
          children: [
            Center(child: Lottie.asset('assets/connecting.json')),
            GestureDetector(
              onLongPress: testMode,
              child: Container(
                height: 100,
                width: 100,
                color: Colors.grey.withOpacity(0),
              ),
            )
          ],
        ),
      ),
    );
  }
}
