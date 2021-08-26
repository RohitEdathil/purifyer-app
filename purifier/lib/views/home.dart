import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:purifier/components/dynamic_image.dart';
import 'package:purifier/components/sensor_display.dart';
import 'package:purifier/components/time_popup.dart';
import 'package:purifier/connector.dart';
import 'package:purifier/views/error.dart';
import 'package:purifier/views/loading.dart';

class HomeView extends StatelessWidget {
  void _timePopup(context) {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) => TimePopup());
  }

  @override
  Widget build(BuildContext context) {
    if (!Provider.of<Connector>(context).connected) {
      Navigator.of(context).push(
          MaterialPageRoute(builder: (BuildContext context) => LoadingView()));
    }
    return Provider.of<Connector>(context).error != ErrorType.noError
        ? ErrorView()
        : Scaffold(
            backgroundColor: Theme.of(context).backgroundColor,
            appBar: AppBar(
              backgroundColor: Theme.of(context).backgroundColor,
              elevation: 0,
              toolbarHeight: 150,
              centerTitle: true,
              title: Text(
                "Purifyer",
                style: TextStyle(
                  fontSize: 54,
                  fontWeight: FontWeight.w300,
                  color: Theme.of(context).accentColor,
                ),
              ),
            ),
            body: Column(
              children: [
                Expanded(
                  flex: 3,
                  child: Stack(
                    children: [
                      PurifierPhoto(),
                      LightButton(_timePopup),
                    ],
                  ),
                ),
                SensorDisplay()
              ],
            ),
          );
  }
}

class LightButton extends StatelessWidget {
  final void Function(BuildContext context) _onPress;
  const LightButton(this._onPress);
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Theme.of(context).backgroundColor,
            boxShadow: [
              BoxShadow(
                  blurRadius: 5,
                  offset: Offset(0, 3),
                  color: Theme.of(context).dividerColor)
            ]),
        child: IconButton(
          icon: Icon(Icons.light_outlined, size: 35),
          color: Theme.of(context).accentColor,
          onPressed: () => _onPress(context),
        ),
      ),
    );
  }
}
