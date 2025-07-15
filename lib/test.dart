import 'dart:async';
import 'package:flutter/material.dart';

// Future<void> asyncFunc() {
//   return Future.delayed(Duration(seconds: 2), (() => print('Hello Future')));
// }

// main() {
//   asyncFunc();
//   print('waiting');
// }

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<String> textFunc() {
    // ignore: avoid_print
    return Future.delayed(Duration(seconds: 2), (() => 'Hello Future'));
  }

  Future<String> exceptionFunc() {
    // ignore: avoid_print
    return Future.delayed(Duration(seconds: 2), throw Exception('error'));
  }

  Future<String> textFunc2() {
    var value = Completer<String>();
    // ignore: avoid_print
    Future.delayed(Duration(seconds: 2), (() => value.complete('hello')));
    return value.future;
  }

  var text = 'default';

  onPresed() async {
    text = await textFunc2();
    setState(() {});
  }

  //cach2 streamController
  Logic logic = Logic();
  @override
  void dispose() {
    logic.countController.close();
    super.dispose();
  }

  // onPressed() {
  //   logic.increase();
  // }

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        // children: [
        //   Center(child: Text(text)),
        //   Center(
        //     child: ElevatedButton(onPressed: onPresed, child: Text('click')),
        //   ),
        // ],
        children: [
          // FutureBuilder(
          //   future: textFunc2(),
          //   builder: ((context, snapshot) {
          //     if (snapshot.connectionState == ConnectionState.waiting) {
          //       return CircularProgressIndicator();
          //     }
          //     if (snapshot.hasData) {
          //       var value = snapshot.data.toString();
          //       return Text(value);
          //     }
          //     if (snapshot.hasError) {
          //       print(snapshot.error);
          //     }
          //     return Text('data');
          //   }),
          // ),
          //cách 2
          TextFormField(onChanged: ((value) => logic.addValue(value))),
          Center(
            child: StreamBuilder(
              stream: logic.stream,
              builder: ((context, snapshot) => snapshot.hasData
                  ? Text(snapshot.data.toString())
                  : CircularProgressIndicator()),
            ),
          ),
          // Center(
          //   child: ElevatedButton(onPressed: onPressed, child: Text('click')),
          // ),
        ],
      ),
    );
  }
}

class Logic {
  // StreamController countController = StreamController();

  StreamController<String> countController = StreamController<String>();
  Sink get sink => countController.sink;
  Stream get stream => countController.stream;
  int count = 0;
  // increase() {
  //   count++;
  //   sink.add(count);
  // }
  addValue(String value) {
    if (value == 'a') sink.add(value);
  }
}
