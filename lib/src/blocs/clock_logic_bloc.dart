import 'package:rxdart/subjects.dart';

class ClockLogicBloc {
  final BehaviorSubject<DateTime> _dateTime = BehaviorSubject<DateTime>();

  void dispose() {
    _dateTime.close();
  }
}