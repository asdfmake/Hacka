import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hacka/signin_screen.dart';
import 'package:hacka/util/reusable_widgets.dart';

class PocetakScreen extends StatefulWidget {
  const PocetakScreen({Key? key}) : super(key: key);

  @override
  _PocetakScreenState createState() => _PocetakScreenState();
}

class _PocetakScreenState extends State<PocetakScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/pocetak_back_avs.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: SingleChildScrollView(
              child: Padding(
                  padding: EdgeInsets.fromLTRB(
                      20, MediaQuery.of(context).size.height * 0.2, 20, 0),
                  child: Column(children: <Widget>[
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.65,
                    ),
                    signInSignUpButton(context, "Početak", () {
                      Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SignInScreen()))
                          .onError((error, stackTrace) {
                        print("Error ${error.toString()}");
                      });
                    }),
                  ])))),
    );
  }
}
