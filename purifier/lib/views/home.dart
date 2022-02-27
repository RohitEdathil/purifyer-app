import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:purifier/components/dynamic_image.dart';
import 'package:purifier/components/sensor_display.dart';
import 'package:purifier/components/time_popup.dart';
import 'package:purifier/connector.dart';
import 'package:purifier/views/error.dart';

class HomeView extends StatelessWidget {
  void _timePopup(context) {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) => TimePopup());
  }

  void _valveToggle(context) {
    Provider.of<Connector>(context, listen: false).toggleValve();
  }

  @override
  Widget build(BuildContext context) {
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
                  color: Theme.of(context).colorScheme.secondary,
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          LightButton(_timePopup),
                          ValveButton(_valveToggle),
                        ],
                      ),
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
          color: Theme.of(context).colorScheme.secondary,
          onPressed: () => _onPress(context),
        ),
      ),
    );
  }
}

class ValveButton extends StatelessWidget {
  final void Function(BuildContext context) _onPress;
  const ValveButton(this._onPress);
  @override
  Widget build(BuildContext context) {
    bool isActive = Provider.of<Connector>(context).valve == 1;
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive
                ? Theme.of(context).colorScheme.secondary
                : Theme.of(context).backgroundColor,
            boxShadow: [
              BoxShadow(
                  blurRadius: 5,
                  offset: Offset(0, 3),
                  color: Theme.of(context).dividerColor)
            ]),
        child: IconButton(
          icon: Icon(Icons.shower, size: 35),
          color: !isActive
              ? Theme.of(context).colorScheme.secondary
              : Theme.of(context).backgroundColor,
          onPressed: () => _onPress(context),
        ),
      ),
    );
  }
}
