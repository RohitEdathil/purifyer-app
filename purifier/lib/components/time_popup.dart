import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:purifier/connector.dart';

class TimePopup extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      heightFactor: 0.7,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).backgroundColor,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(40),
            topLeft: Radius.circular(40),
          ),
        ),
        child: Column(
          children: [
            Container(
                height: 5,
                width: 40,
                margin: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: Theme.of(context).dividerColor,
                    borderRadius: BorderRadius.circular(20))),
            SizedBox(height: 20),
            Text(
              "Light Schedule",
              style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
                fontSize: 25,
              ),
            ),
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(25),
                  child: TimeSetter(),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class TimeSetter extends StatelessWidget {
  void updateSlider(DragUpdateDetails d, BuildContext context, int time) {
    double num = 360 *
        d.delta.dx *
        d.delta.distance /
        (MediaQuery.of(context).size.width * 0.25);
    if (time + num.round() <= 360 && time + num.round() >= 0) {
      Provider.of<Connector>(context, listen: false)
          .setTime(time + num.round());
    }
  }

  void endSlide(DragEndDetails d, BuildContext context) {
    Provider.of<Connector>(context, listen: false).sendTime();
  }

  @override
  Widget build(BuildContext context) {
    int time = Provider.of<Connector>(context).time;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '0${time ~/ 60}:${time % 60 < 10 ? '0' : ''}${time % 60}',
              style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary, fontSize: 20),
            ),
            Text(
              '${18 + time ~/ 60}:${time % 60 < 10 ? '0' : ''}${time % 60}',
              style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary, fontSize: 20),
            ),
          ],
        ),
        SizedBox(height: 10),
        Container(
          height: 50,
          decoration: BoxDecoration(
              color: Theme.of(context).dividerColor.withOpacity(0.3),
              borderRadius: BorderRadius.circular(50)),
          child: Row(
            children: [
              SizedBox(
                  width: MediaQuery.of(context).size.width * 0.25 * time / 360),
              GestureDetector(
                onHorizontalDragUpdate: (d) => updateSlider(d, context, time),
                onHorizontalDragEnd: (d) => endSlide(d, context),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.75 - 50,
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondary,
                      borderRadius: BorderRadius.circular(50)),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
