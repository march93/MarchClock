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
  bool _shouldFlip = true;

  @override
  void initState() {
    super.initState();
    _updateTime();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _clockLogicBloc ??= Provider.of<ClockLogicBloc>(context);
  }

  @override
  void dispose() {
    _timer?.cancel();
    widget._model.dispose();
    super.dispose();
  }

  void _updateTime() {
    _dateTime = DateTime.now();

    // Allow digits to be flipped
    setState(() {
      _shouldFlip = true;
    });

    // Add the new updated time to the stream
    _clockLogicBloc?.changeDate(_dateTime);

    // Prevent digits from flipping
    setState(() {
      Future.delayed(Duration(seconds: 1), () {
        _shouldFlip = false;
      });
    });

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
  }

  @override
  Widget build(BuildContext context) {
    final hour = DateFormat(widget._model.is24HourFormat ? 'HH' : 'hh').format(_dateTime);
    final minute = DateFormat('mm').format(_dateTime);

    return Container(
      color: ClockTheme.colors(context: context)[ClockElement.background],
      child: Center(
        child: DefaultTextStyle(
          style: ClockTheme.defaultStyle(context: context),
          child: Row(
            children: <Widget>[
              Expanded(
                flex: 3,
                child: NumberFlip(
                  hourFormat: widget._model.is24HourFormat ? 'HH' : 'hh',
                  timeString: hour[0],
                  clockDigit: ClockDigit.hour1,
                  shouldFlip: _shouldFlip,
                ),
              ),
              Expanded(
                flex: 3,
                child: NumberFlip(
                  hourFormat: widget._model.is24HourFormat ? 'HH' : 'hh',
                  timeString: hour[1],
                  clockDigit: ClockDigit.hour2,
                  shouldFlip: _shouldFlip,
                ),
              ),
              Container(
                width: 55,
                height: MediaQuery.of(context).orientation == Orientation.landscape
                  ? MediaQuery.of(context).size.height / 3
                  : MediaQuery.of(context).size.height / 10,
                padding: EdgeInsets.only(left: 5),
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: Text(':'),
                )
              ),
              Expanded(
                flex: 3,
                child: NumberFlip(
                  timeString: minute[0],
                  clockDigit: ClockDigit.minute1,
                  shouldFlip: _shouldFlip,
                ),
              ),
              Expanded(
                flex: 3,
                child: NumberFlip(
                  timeString: minute[1],
                  clockDigit: ClockDigit.minute2,
                  shouldFlip: _shouldFlip,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
