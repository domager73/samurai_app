import 'dart:async';
import 'package:flutter/material.dart';

class BlinkingTime extends StatefulWidget {
  final String Function() getTime;
  final TextStyle style;
  const BlinkingTime({Key? key, required this.getTime, required this.style})
      : super(key: key);

  @override
  _BlinkingTimeState createState() => _BlinkingTimeState();
}

class _BlinkingTimeState extends State<BlinkingTime> {
  bool showColon = true;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer t) => _getTime());
  }

  void _getTime() {
    setState(() {
      showColon = !showColon;
    });
  }

  @override
  Widget build(BuildContext context) {
    final String formattedDateTime = widget.getTime();

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          formattedDateTime.substring(0, 2),
          style: widget.style,
        ),
        Opacity(
          opacity: showColon ? 1 : 0,
          child: Text(
            ':',
            style: widget.style,
          ),
        ),
        Text(
          formattedDateTime.substring(3, 5),
          style: widget.style,
        ),
      ],
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}
