import 'package:flutter/material.dart';
import '../controllers/counter_controller.dart';

class CounterView extends StatefulWidget {
  const CounterView({super.key});

  @override
  CounterViewState createState() => CounterViewState();
}

class CounterViewState extends State<CounterView> {
  final CounterController _controller = CounterController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Counter MVC Example'),  // Để const ở đây vì Text có const constructor
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(  // Có thể giữ const ở đây
              'Counter Value:',
              style: TextStyle(fontSize: 24),
            ),
            Text(  // Không nên dùng const ở đây vì giá trị của _controller.value thay đổi
              '${_controller.value}',
              style: const TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                IconButton(
                  icon: const Icon(Icons.remove),  // Không cần const ở đây
                  onPressed: () {
                    setState(() {
                      _controller.decrement();
                    });
                  },
                  iconSize: 40,
                ),
                IconButton(
                  icon: const Icon(Icons.add),  // Không cần const ở đây
                  onPressed: () {
                    setState(() {
                      _controller.increment();
                    });
                  },
                  iconSize: 40,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
