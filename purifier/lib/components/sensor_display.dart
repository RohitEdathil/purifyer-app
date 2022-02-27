import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:purifier/connector.dart';

class SensorDisplay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "pH",
                style: TextStyle(
                  fontSize: 20,
                  color: Theme.of(context).dividerColor,
                ),
              ),
              Text(
                "${Provider.of<Connector>(context).ph}",
                style: TextStyle(
                    fontSize: 54,
                    color: Theme.of(context).colorScheme.secondary,
                    fontFamily: 'KellySlab'),
              ),
            ],
          ),
          FractionallySizedBox(
              heightFactor: 0.7,
              child: Container(
                width: 3,
                color: Theme.of(context).dividerColor,
              )),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Oxygen",
                style: TextStyle(
                  fontSize: 20,
                  color: Theme.of(context).dividerColor,
                ),
              ),
              Row(
                children: [
                  Text(
                    "${Provider.of<Connector>(context).o2}",
                    style: TextStyle(
                        fontSize: 50,
                        color: Theme.of(context).colorScheme.secondary,
                        fontFamily: 'KellySlab'),
                  ),
                  Text(
                    "%",
                    style: TextStyle(
                        fontSize: 20,
                        color: Theme.of(context).colorScheme.secondary,
                        fontFamily: 'KellySlab'),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
