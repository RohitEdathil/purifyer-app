import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:purifier/components/dynamic_image.dart';
import 'package:purifier/components/sensor_display.dart';
import 'package:purifier/components/time_popup.dart';
import 'package:purifier/connector.dart';

class HomeView extends StatelessWidget {
  void _timePopup(context) {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) => TimePopup());
  }

  void _lightToggle(context) {
    Provider.of<Connector>(context, listen: false).toggleLight();
  }

  void _autoToggle(context) {
    Provider.of<Connector>(context, listen: false).toggleAuto();
  }

  @override
  Widget build(BuildContext context) {
    bool isAuto = Provider.of<Connector>(context).auto == 1;
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
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
                    AutoButton(_autoToggle),
                    isAuto
                        ? ScheduleButton(_timePopup)
                        : LightButton(_lightToggle),
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

class ScheduleButton extends StatelessWidget {
  final void Function(BuildContext context) _onPress;
  const ScheduleButton(this._onPress);
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
          icon: Icon(Icons.av_timer_outlined, size: 30),
          color: Theme.of(context).colorScheme.secondary,
          onPressed: () => _onPress(context),
        ),
      ),
    );
  }
}

class LightButton extends StatelessWidget {
  final void Function(BuildContext context) _onPress;
  const LightButton(this._onPress);
  @override
  Widget build(BuildContext context) {
    bool isActive = Provider.of<Connector>(context).light == 1;
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
          icon: Icon(Icons.light_outlined, size: 30),
          color: !isActive
              ? Theme.of(context).colorScheme.secondary
              : Theme.of(context).backgroundColor,
          onPressed: () => _onPress(context),
        ),
      ),
    );
  }
}

class AutoButton extends StatelessWidget {
  final void Function(BuildContext context) _onPress;
  const AutoButton(this._onPress);
  @override
  Widget build(BuildContext context) {
    bool isActive = Provider.of<Connector>(context).auto == 1;
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
          icon: Icon(Icons.brightness_auto_rounded, size: 30),
          color: !isActive
              ? Theme.of(context).colorScheme.secondary
              : Theme.of(context).backgroundColor,
          onPressed: () => _onPress(context),
        ),
      ),
    );
  }
}
