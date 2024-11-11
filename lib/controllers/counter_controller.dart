import '../models/counter.dart';

class CounterController {
  final Counter _counter = Counter();

  int get value => _counter.value;

  void increment() {
    _counter.increment();
  }

  void decrement() {
    _counter.decrement();
  }
}
