// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:flutter_clock_helper/model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../animation/number_flip.dart';
import '../blocs/clock_logic_bloc.dart';
import '../settings/enums.dart';
import '../settings/themes.dart';

/// A basic digital clock.
///
/// You can do better than this!
class DigitalClock extends StatefulWidget {
  final ClockModel _model;

  const DigitalClock({@required ClockModel model}) : _model = model;

  @override
  _DigitalClockState createState() => _DigitalClockState();
}

class _DigitalClockState extends State<DigitalClock> {
  DateTime _dateTime = DateTime.now();
  Timer _timer;
  ClockLogicBloc _clockLogicBloc;

  @override
  void initState() {
    super.initState();
    widget._model.addListener(_updateModel);
    _updateTime();
    _updateModel();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _clockLogicBloc ??= Provider.of<ClockLogicBloc>(context);
  }

  @override
  void didUpdateWidget(DigitalClock oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget._model != oldWidget._model) {
      oldWidget._model.removeListener(_updateModel);
      widget._model.addListener(_updateModel);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    widget._model.removeListener(_updateModel);
    widget._model.dispose();
    super.dispose();
  }

  void _updateModel() {
    setState(() {
      // Cause the clock to rebuild when the model changes.
    });
  }

  void _updateTime() {
    setState(() {
      _dateTime = DateTime.now();

      // Add the new updated time to the stream
      _clockLogicBloc?.changeDate(_dateTime);

      // Update once per minute. If you want to update every second, use the
      // following code.
      _timer = Timer(
        Duration(minutes: 1) -
            Duration(seconds: _dateTime.second) -
            Duration(milliseconds: _dateTime.millisecond),
        _updateTime,
      );
      // Update once per second, but make sure to do it at the beginning of each
      // new second, so that the clock is accurate.
      // _timer = Timer(
      //   Duration(seconds: 1) - Duration(milliseconds: _dateTime.millisecond),
      //   _updateTime,
      // );
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).brightness == Brightness.light
        ? ClockTheme.lightTheme
        : ClockTheme.darkTheme;
    final hour =
        DateFormat(widget._model.is24HourFormat ? 'HH' : 'hh').format(_dateTime);
    final minute = DateFormat('mm').format(_dateTime);
    final fontSize = MediaQuery.of(context).size.width / 6.5;
    final defaultStyle = TextStyle(
      color: colors[ClockElement.text],
      fontFamily: 'PressStart2P',
      fontSize: fontSize,
      shadows: [
        Shadow(
          blurRadius: 0,
          color: colors[ClockElement.shadow],
          offset: Offset(10, 0),
        ),
      ],
    );

    return Container(
      color: colors[ClockElement.background],
      child: Center(
        child: DefaultTextStyle(
          style: defaultStyle,
          child: Row(
            children: <Widget>[
              Expanded(child: NumberFlip(timeString: hour[0], clockDigit: ClockDigit.hour1)),
              Expanded(child: NumberFlip(timeString: hour[1], clockDigit: ClockDigit.hour2)),
              Expanded(child: Text(':')),
              Expanded(child: NumberFlip(timeString: minute[0], clockDigit: ClockDigit.minute1)),
              Expanded(child: NumberFlip(timeString: minute[1], clockDigit: ClockDigit.minute2)),
            ],
          ),
        ),
      ),
    );
  }
}
