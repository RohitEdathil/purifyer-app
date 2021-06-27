import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:purifier/connector.dart';

class HomeView extends StatelessWidget {
  void _timePopup(context) {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (BuildContext context) => TimePopup());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                FractionallySizedBox(
                  heightFactor: 0.8,
                  child: Center(child: PurifierPhoto()),
                ),
                Align(
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
                      onPressed: () => _timePopup(context),
                    ),
                  ),
                )
              ],
            ),
          ),
          SensorDisplay()
        ],
      ),
    );
  }
}

class PurifierPhoto extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final current_time = DateTime.now().hour * 60 + DateTime.now().minute;
    final time = Provider.of<Connector>(context).time;
    bool light =
        current_time >= time && current_time <= time + 360 ? false : true;
    return Stack(
      children: [
        Image.asset(
          'assets/1.png',
        ),
        Opacity(
          opacity: light ? 1 : 0,
          child: Image.asset(
            'assets/2.png',
          ),
        ),
      ],
    );
  }
}

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
                color: Theme.of(context).accentColor,
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
    Provider.of<Connector>(context, listen: false).updateTime();
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
              style:
                  TextStyle(color: Theme.of(context).accentColor, fontSize: 20),
            ),
            Text(
              '${18 + time ~/ 60}:${time % 60 < 10 ? '0' : ''}${time % 60}',
              style:
                  TextStyle(color: Theme.of(context).accentColor, fontSize: 20),
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
                      color: Theme.of(context).accentColor,
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
                    color: Theme.of(context).accentColor,
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
                        color: Theme.of(context).accentColor,
                        fontFamily: 'KellySlab'),
                  ),
                  Text(
                    "%",
                    style: TextStyle(
                        fontSize: 20,
                        color: Theme.of(context).accentColor,
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
