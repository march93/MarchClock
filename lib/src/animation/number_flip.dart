import 'package:flutter/material.dart';
import 'package:flutter_flip_view/flutter_flip_view.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../blocs/clock_logic_bloc.dart';
import '../settings/enums.dart';

class NumberFlip extends StatefulWidget {
  final String _hourFormat;
  final String _timeString;
  final ClockDigit _clockDigit;

  const NumberFlip({
    String hourFormat,
    @required String timeString,
    @required ClockDigit clockDigit
  }) : _hourFormat = hourFormat, _timeString = timeString, _clockDigit = clockDigit;

  @override
  _NumberFlipState createState() => _NumberFlipState();
}

class _NumberFlipState extends State<NumberFlip> with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Animation<double> _curvedAnimation;
  ClockLogicBloc _clockLogicBloc;
  String prevTimeDigit;
  String currTimeDigit;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(vsync: this, duration: Duration(seconds: 1));
    _curvedAnimation = CurvedAnimation(parent: _animationController, curve: Curves.easeInOut);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _clockLogicBloc ??= Provider.of<ClockLogicBloc>(context);
  }

  @override
  Widget build(BuildContext buildContext) {
    return StreamBuilder<DateTime>(
      stream: _clockLogicBloc.date,
      builder: (context, snapshot) {
        // Reset animation controller so it can be reused for every animation
        _animationController.reset();

        // Display initial time passed from parent widget
        // Time has not updated yet so there's nothing in the stream
        if (!snapshot.hasData) {
          return Text('${(int.parse(widget._timeString)).toString()}');
        }

        // Previous Time (minus 1 minute)
        final DateTime prevTime = snapshot.data.add(Duration(minutes: -1));

        // Determine which digit to display based on enum passed by parent widget
        switch (widget._clockDigit) {
          case ClockDigit.hour1:
            prevTimeDigit = DateFormat(widget._hourFormat).format(prevTime)[0];
            currTimeDigit = DateFormat(widget._hourFormat).format(snapshot.data)[0];
            break;
          case ClockDigit.hour2:
            prevTimeDigit = DateFormat(widget._hourFormat).format(prevTime)[1];
            currTimeDigit = DateFormat(widget._hourFormat).format(snapshot.data)[1];
            break;
          case ClockDigit.minute1:
            prevTimeDigit = DateFormat('mm').format(prevTime)[0];
            currTimeDigit = DateFormat('mm').format(snapshot.data)[0];
            break;
          case ClockDigit.minute2:
            prevTimeDigit = DateFormat('mm').format(prevTime)[1];
            currTimeDigit = DateFormat('mm').format(snapshot.data)[1];
            break;
        }

        _animationController.forward();

        if (prevTimeDigit == currTimeDigit) {
          // The digit in this case hasn't changed so no need to animate
          return Text(currTimeDigit);
        } else {
          // We no have data in the stream so we can set the back of the
          // flip animation to contain the updated time, and the front will
          // contain the previous time
          return FlipView(
            animationController: _curvedAnimation,
            back: Text(currTimeDigit),
            front: Text(prevTimeDigit),
          );
        }
        
      }
    );
  }
}