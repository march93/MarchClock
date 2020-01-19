import 'package:rxdart/subjects.dart';

class ClockLogicBloc {
  final BehaviorSubject<DateTime> _dateTime = BehaviorSubject<DateTime>();

  // Get datetime stream
  Stream<DateTime> get date => _dateTime.stream;

  // Add datetime to stream
  Function(DateTime) get changeDate => _dateTime.sink.add;

  void dispose() {
    _dateTime.close();
  }
}