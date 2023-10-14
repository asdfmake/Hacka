import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HACKA',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 253, 255, 110)),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Polen alarm'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Sutra:',
              style: TextStyle(fontSize: 25),
            ),
            SizedBox(
              height: 150,
            ),
            Text(
              'Prekosutra:',
              style: TextStyle(fontSize: 25),
            ),
            SizedBox(
              height: 150,
            ),
            Text(
              'Nakosutra:',
              style: TextStyle(fontSize: 25),
            )
          ],
        ),
      ),
    );
  }
}
