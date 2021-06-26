import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:purifier/connector.dart';
import 'package:purifier/views/home.dart';

class LoadingView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Stack(
          children: [
            Center(child: Lottie.asset('assets/connecting.json')),
            SecretTrigger()
          ],
        ),
      ),
    );
  }
}

class SecretTrigger extends StatelessWidget {
  void _gotoHome(BuildContext context) {
    Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => HomeView(),
        ));
  }

  void testMode(BuildContext context) async {
    print("Test Mode Triggered");
    await HapticFeedback.heavyImpact();
    Provider.of<Connector>(context, listen: false).mode =
        ConnectionMode.websocket;
    bool result =
        await Provider.of<Connector>(context, listen: false).connect_ws();

    result ? _gotoHome(context) : print('Connection Failed');
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () => testMode(context),
      child: Container(
        height: 100,
        width: 100,
        color: Colors.grey.withOpacity(0),
      ),
    );
  }
}
