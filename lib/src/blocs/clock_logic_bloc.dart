import 'package:rxdart/subjects.dart';

class ClockLogicBloc {
  final BehaviorSubject<bool> _shouldFlip = BehaviorSubject<bool>(seedValue: false);
  final BehaviorSubject<DateTime> _dateTime = BehaviorSubject<DateTime>();

  // Get shouldflip and datetime stream
  Stream<bool> get flip => _shouldFlip.stream;
  Stream<DateTime> get date => _dateTime.stream;

  // Add bool and datetime to stream
  Function(bool) get flipStatus => _shouldFlip.sink.add;
  Function(DateTime) get changeDate => _dateTime.sink.add;

  void dispose() {
    _shouldFlip.close();
    _dateTime.close();
  }
}