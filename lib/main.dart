import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hacka/HomeScreen.dart';
import 'package:hacka/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hacka/pocetak.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HACKA',
      theme: ThemeData(
        colorScheme:
            ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 253, 255, 110)),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'All Vehicle Solution',
      theme: ThemeData(
          primarySwatch: Colors.blue,
          fontFamily: 'Caros',
          scaffoldBackgroundColor: const Color(0xffF2F2F2)),
      home: FirebaseAuth.instance.currentUser != null
          ? HomeScreen()
          : PocetakScreen(), //SignInScreen  //HomeScreen // ChatPage // PocetakScreen // FunkcionalnostiParkingaScreen
    );
  }
}
