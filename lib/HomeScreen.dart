import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        backgroundColor: Color.fromARGB(255, 253, 255, 110),
        title: Text(
          'Polen alarm',
          style: TextStyle(color: Colors.black),
        ),
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
