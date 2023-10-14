import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hacka/util/reusable_widgets.dart';

class PasswordResetScreen extends StatefulWidget {
  @override
  _PasswordResetScreenState createState() => _PasswordResetScreenState();
}

class _PasswordResetScreenState extends State<PasswordResetScreen> {
  TextEditingController _emailTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/reset_pass.png"),
                fit: BoxFit.cover,
              ),
            ),
            child: SingleChildScrollView(
                child: Stack(
              children: [
                Padding(
                    padding: EdgeInsets.fromLTRB(
                        20, MediaQuery.of(context).size.height * 0.2, 20, 0),
                    child: Column(children: <Widget>[
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.35,
                      ),
                      reusableTextField(context, "Email adresa",
                          Icons.person_outline, false, _emailTextController),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.1,
                      ),
                      signInSignUpButton(
                          context, "Pošalji reset lozinke na mejl", () async {
                        try {
                          FirebaseAuth.instance
                              .sendPasswordResetEmail(
                                  email: _emailTextController.text)
                              .then((value) => Navigator.of(context).pop());
                        } on FirebaseAuthException catch (error) {
                          print("Error ${error.toString()}");
                        }
                      }),
                    ])),
                Positioned(
                  top: 0.0,
                  left: 0.0,
                  right: 0.0,
                  child: AppBar(
                    leading: new IconButton(
                      icon: new Icon(Icons.arrow_back_ios, color: Colors.black),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    backgroundColor: Colors.blue
                        .withOpacity(0.0), //You can make this transparent
                    elevation: 0.0, //No shadow
                  ),
                )
              ],
            ))));
  }
}
