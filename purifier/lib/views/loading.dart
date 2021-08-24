import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:purifier/connector.dart';
import 'package:purifier/views/home.dart';

class LoadingView extends StatelessWidget {
  void connect(BuildContext context) {
    Provider.of<Connector>(context, listen: false).connect();
  }

  @override
  Widget build(BuildContext context) {
    connect(context);
    if (Provider.of<Connector>(context).connected) return HomeView();

    final blu = FlutterBlue.instance;
    return Scaffold(
      body: StreamBuilder<BluetoothState>(
        stream: blu.state,
        builder: (context, snapshot) => snapshot.data == BluetoothState.on
            ? Padding(
                padding: const EdgeInsets.all(20.0),
                child: Center(
                    child: StreamBuilder<bool>(
                  stream: blu.isScanning,
                  builder: (context, snapshot) => snapshot.data ?? true
                      ? Lottie.asset('assets/connecting.json')
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Scan failed.',
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.headline3,
                            ),
                            IconButton(
                              onPressed: () => connect(context),
                              icon: Icon(Icons.refresh_rounded),
                              color: Theme.of(context).primaryColor,
                              iconSize: 40,
                            )
                          ],
                        ),
                )),
              )
            : Center(
                child: Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  'Please turn on Bluetooth.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headline3,
                ),
              )),
      ),
    );
  }
}
