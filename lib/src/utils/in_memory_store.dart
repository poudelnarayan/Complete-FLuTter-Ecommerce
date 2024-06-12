import 'package:rxdart/rxdart.dart';

// A simple in-memory store that holds a value and allows you to listen to changes.
class InMemoryStore<T> {
  InMemoryStore(T initial) : _subject = BehaviorSubject.seeded(initial);

  /// the BehaviourSubject that holds the data
  final BehaviorSubject<T> _subject;

  /// The output stream that can be used to lisetn to changes on data
  Stream<T> get stream => _subject.stream;

  /// a Synchronous getter that returns the current value of the data
  T get value => _subject.value;

  /// a setter that allows you to set the value of the data
  set value(T value) => _subject.add(value);

  /// a method that closes the stream
  void close() => _subject.close();
}
