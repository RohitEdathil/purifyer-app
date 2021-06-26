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
  void testMode(BuildContext context) async {
    print("Test Mode Triggered");
    await HapticFeedback.heavyImpact();
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ConnectionPopUp(),
    );
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

class ConnectionPopUp extends StatefulWidget {
  @override
  _ConnectionPopUpState createState() => _ConnectionPopUpState();
}

class _ConnectionPopUpState extends State<ConnectionPopUp> {
  final _hostField = TextEditingController();
  final _portField = TextEditingController();
  bool waiting = false;
  void connect(BuildContext context) async {
    setState(() => waiting = true);
    Provider.of<Connector>(context, listen: false).mode =
        ConnectionMode.websocket;
    bool result = await Provider.of<Connector>(context, listen: false)
        .connect_ws(_hostField.value.text, _portField.value.text);
    setState(() => waiting = false);
    result ? _gotoHome(context) : print('Connection Failed');
  }

  void _gotoHome(BuildContext context) {
    Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => HomeView(),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      heightFactor: 0.8,
      child: Container(
        decoration: BoxDecoration(
            color: Theme.of(context).backgroundColor,
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(50), topLeft: Radius.circular(50))),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.all(6),
              height: 6,
              width: 40,
              decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(20)),
            ),
            Text(
              'WebSocket Config',
              textAlign: TextAlign.left,
              style: TextStyle(fontWeight: FontWeight.w900, fontSize: 25),
            ),
            Text(
              'Only to be used in testing ⚠',
              textAlign: TextAlign.left,
              style:
                  TextStyle(fontSize: 15, color: Colors.black.withOpacity(0.4)),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  TextFormField(
                    controller: _hostField,
                    decoration: InputDecoration(
                        labelText: 'Host',
                        border: OutlineInputBorder(
                            borderSide: BorderSide(style: BorderStyle.solid))),
                    autofocus: true,
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _portField,
                    decoration: InputDecoration(
                        labelText: 'Port',
                        border: OutlineInputBorder(
                            borderSide: BorderSide(style: BorderStyle.solid))),
                    keyboardType: TextInputType.number,
                    autofocus: true,
                  ),
                  SizedBox(height: 20),
                  waiting
                      ? CircularProgressIndicator()
                      : TextButton.icon(
                          onPressed: () => connect(context),
                          icon: Icon(Icons.wifi),
                          label: Text("Connect"))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
