import 'package:flutter/material.dart';
import 'package:flutter_clock_helper/customizer.dart';
import 'package:flutter_clock_helper/model.dart';
import 'package:provider/provider.dart';

import 'blocs/clock_logic_bloc.dart';
import 'screens/digital_clock.dart';

class App extends StatelessWidget {
  const App();

  @override
  Widget build(BuildContext buildContext) {
    return MultiProvider(
      providers: [Provider<ClockLogicBloc>.value(value: ClockLogicBloc())],
      child: ClockCustomizer((ClockModel model) => DigitalClock(model: model,)),
    );
  }
}