import 'package:digital_clock/src/settings/themes.dart';
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
  bool _shouldFlip;

  NumberFlip({
    String hourFormat,
    @required String timeString,
    @required ClockDigit clockDigit,
    @required bool shouldFlip,
  }) : _hourFormat = hourFormat, _timeString = timeString, _clockDigit = clockDigit, _shouldFlip = shouldFlip;

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
      builder: (BuildContext context, AsyncSnapshot<DateTime> dateSnapshot) {
        // Reset animation controller so it can be reused for every animation
        _animationController.reset();

        // Display initial time passed from parent widget
        // Time has not updated yet so there's nothing in the stream
        if (!dateSnapshot.hasData) {
          return digitContainer(context: context, text: int.parse(widget._timeString).toString());
        }

        // Previous Time (minus 1 minute)
        final DateTime prevTime = dateSnapshot.data.add(Duration(minutes: -1));

        // Determine which digit to display based on enum passed by parent widget
        switch (widget._clockDigit) {
          case ClockDigit.hour1:
            prevTimeDigit = DateFormat(widget._hourFormat).format(prevTime)[0];
            currTimeDigit = DateFormat(widget._hourFormat).format(dateSnapshot.data)[0];
            break;
          case ClockDigit.hour2:
            prevTimeDigit = DateFormat(widget._hourFormat).format(prevTime)[1];
            currTimeDigit = DateFormat(widget._hourFormat).format(dateSnapshot.data)[1];
            break;
          case ClockDigit.minute1:
            prevTimeDigit = DateFormat('mm').format(prevTime)[0];
            currTimeDigit = DateFormat('mm').format(dateSnapshot.data)[0];
            break;
          case ClockDigit.minute2:
            prevTimeDigit = DateFormat('mm').format(prevTime)[1];
            currTimeDigit = DateFormat('mm').format(dateSnapshot.data)[1];
            break;
        }

        if (prevTimeDigit != currTimeDigit && widget._shouldFlip) {
          _animationController.forward();
          // We no have data in the stream so we can set the back of the
          // flip animation to contain the updated time, and the front will
          // contain the previous time
          return FlipView(
            animationController: _curvedAnimation,
            back: digitContainer(context: context, text: currTimeDigit),
            front: digitContainer(context: context, text: prevTimeDigit)
          );
        } else {
          // The digit in this case hasn't changed so no need to animate
          return digitContainer(context: context, text: currTimeDigit);
        }
      }
    );
  }

  Widget digitContainer({BuildContext context, String text}) {
    return Card(
      color: Colors.white10,
      elevation: 3,
      child: Container(
        alignment: Alignment.center,
        height: MediaQuery.of(context).size.height,
        child: Text(text,
          textAlign: TextAlign.center,
          style: ClockTheme.defaultStyle(context: context),
        ),
      ),
    );
  }
}