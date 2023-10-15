import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hacka/HomeScreen.dart';
import 'package:hacka/PasswordResetScreen.dart';
import 'package:hacka/signup_screen.dart';
import 'package:hacka/util/reusable_widgets.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _emailTextController = TextEditingController();
  String errorMessage = '';
  String errorMessageCode = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/signin_back.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: SingleChildScrollView(
            child: Padding(
                padding: EdgeInsets.fromLTRB(
                    20, MediaQuery.of(context).size.height * 0.2, 20, 0),
                child: Stack(children: [
                  Column(
                    children: <Widget>[
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.35,
                      ),
                      reusableTextField(context, "Email adresa",
                          Icons.person_outline, false, _emailTextController),
                      (errorMessageCode == 'email')
                          ? Column(
                              children: [
                                Text(errorMessage,
                                    style: TextStyle(color: Colors.red)),
                                SizedBox(
                                  height: 3,
                                )
                              ],
                            )
                          : SizedBox(
                              height: 20,
                            ),
                      reusableTextField(context, "Lozinka", Icons.lock_outline,
                          true, _passwordTextController),
                      (errorMessageCode == 'password')
                          ? Text(errorMessage,
                              style: TextStyle(color: Colors.red))
                          : SizedBox(
                              height: 20,
                            ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.025,
                      ),
                      Row(children: [
                        Spacer(),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        PasswordResetScreen() //ServiceChoiceScreen()
                                    ));
                          },
                          child: Text("Zaboravili ste lozinku?",
                              textScaleFactor: 1.0,
                              style: TextStyle(
                                  color: Color.fromARGB(210, 222, 151, 0), fontSize: 14)),
                        ),
                        Spacer(),
                      ]),
                      SizedBox(
                        height: 0,
                      ),
                      signInSignUpButton(context, "Prijavite se", () async {
                        try {
                          final bool emailValid = RegExp(
                                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                              .hasMatch(_emailTextController.text);
                          if (_emailTextController.text == '') {
                            setState(() {
                              errorMessage = "Unesite email";
                              errorMessageCode = 'email';
                            });
                            return;
                          }
                          if (!emailValid) {
                            setState(() {
                              errorMessage = "Neipsravan email";
                              errorMessageCode = 'email';
                            });
                            return;
                          }
                          if (_passwordTextController.text == '') {
                            setState(() {
                              errorMessage = "Unesite lozinku";
                              errorMessageCode = 'password';
                            });
                            return;
                          }
                          await FirebaseAuth.instance
                              .signInWithEmailAndPassword(
                                  email: _emailTextController.text,
                                  password: _passwordTextController.text);
                          if (!FirebaseAuth
                              .instance.currentUser!.emailVerified) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        HomeScreen() //ServiceChoiceScreen()
                                    ));
                          } else
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        HomeScreen()));
                        } on FirebaseAuthException catch (error) {
                          print("Error ${error.toString()}");
                          switch (error.code) {
                            case "network-request-failed":
                              setState(() {
                                errorMessage = "Niste povezani na internet";
                                errorMessageCode = 'email';
                              });
                              break;
                            case "invalid-email":
                              setState(() {
                                errorMessage =
                                    "Neipsravan email, pokušajte ponovo";
                                errorMessageCode = 'email';
                              });
                              break;
                            case "wrong-password":
                              setState(() {
                                errorMessage = "Pogrešna lozinka";
                                errorMessageCode = 'password';
                              });
                              break;
                            case "user-not-found":
                              setState(() {
                                errorMessage =
                                    "Korisnik s ovim emailom ne postoji";
                                errorMessageCode = 'email';
                              });
                              break;
                            case "user-disabled":
                              errorMessage =
                                  "User with this email has been disabled.";
                              break;
                            case "too-many-requests":
                              errorMessage = "Too many requests";
                              break;
                            case "operation-not-allowed":
                              errorMessage =
                                  "Signing in with Email and Password is not enabled.";
                              break;
                            default:
                              setState(() {
                                errorMessageCode = 'email';
                                print('$error.code');
                                errorMessage = "Nedefinisana greška";
                              });
                          }
                        }
                      }),
                      signUpOption()
                    ],
                  ),
                ])),
          ),
        ));
  }

  Row signUpOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Nemate nalog?",
            textScaleFactor: 1.0,
            style: TextStyle(color: Colors.black, fontSize: 14)),
        GestureDetector(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => SignUpScreen()));
          },
          child: Text(
            " Registracija",
            textScaleFactor: 1.0,
            style: TextStyle(
                color: Color.fromARGB(210, 222, 151, 0),
                fontWeight: FontWeight.bold,
                fontSize: 14),
          ),
        )
      ],
    );
  }
}
