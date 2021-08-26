import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:purifier/connector.dart';
import 'package:purifier/views/home.dart';

class LoadingView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (Provider.of<Connector>(context).connected) return HomeView();
    Provider.of<Connector>(context, listen: false).connect();
    final blu = FlutterReactiveBle();
    return Scaffold(
      body: StreamBuilder<BleStatus>(
        stream: blu.statusStream,
        builder: (context, snapshot) {
          if (snapshot.hasError)
            return Center(child: Text(snapshot.error.toString()));
          if (snapshot.data == BleStatus.ready) {
            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: Center(
                child: Provider.of<Connector>(context).isScanning
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
                            onPressed: () =>
                                Provider.of<Connector>(context, listen: false)
                                    .connect(re: true),
                            icon: Icon(Icons.refresh_rounded),
                            color: Theme.of(context).primaryColor,
                            iconSize: 40,
                          )
                        ],
                      ),
              ),
            );
          } else if (snapshot.data == BleStatus.unauthorized) {
            return MessageText(text: "Awaiting Permission");
          } else if (snapshot.data == BleStatus.poweredOff) {
            return MessageText(
              text: "Turn on Bluetooth",
            );
          } else if (snapshot.data == BleStatus.locationServicesDisabled) {
            return MessageText(
              text: "Turn on Location",
            );
          } else {
            return MessageText(
              text: "...",
            );
          }
        },
      ),
    );
  }
}

class MessageText extends StatelessWidget {
  final String text;
  const MessageText({
    Key? key,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Padding(
      padding: const EdgeInsets.all(20),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.headline3,
      ),
    ));
  }
}
