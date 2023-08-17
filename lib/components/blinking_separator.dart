import 'dart:async';

import 'package:flutter/material.dart';

class BlinkingSeparator extends StatefulWidget {
  const BlinkingSeparator({super.key});

  @override
  _BlinkingSeparatorState createState() => _BlinkingSeparatorState();
}

class _BlinkingSeparatorState extends State<BlinkingSeparator>
    with SingleTickerProviderStateMixin {
  late Timer _timer;
  double _opacity = 1;

  @override
  void initState() {
    super.initState();

    // Start the periodic timer which rebuilds our widget
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _opacity = _opacity == 1 ? 0 : 1;
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: _opacity,
      duration: const Duration(milliseconds: 500),
      child: const Text(
        ":",
        style: TextStyle(fontSize: 40.0, fontWeight: FontWeight.w900),
      ),
    );
  }
}
