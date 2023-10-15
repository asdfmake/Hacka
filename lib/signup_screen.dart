import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hacka/HomeScreen.dart';
import 'package:hacka/signin_screen.dart';
import 'package:hacka/util/reusable_widgets.dart';
import 'package:multiselect/multiselect.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

CollectionReference _collectionReference =
    FirebaseFirestore.instance.collection("korisnici");

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _password1TextController = TextEditingController();
  TextEditingController _emailTextController = TextEditingController();
  TextEditingController _userNameTextController = TextEditingController();
  List<String> selected = [];

  String errorMessage = '';
  String errorMessageCode = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        extendBodyBehindAppBar: true,
        /*
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text(
            "Registracija",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),*/
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/registracija.png"), // background
              fit: BoxFit.cover,
            ),
          ),
          child: SingleChildScrollView(
            child: Padding(
                padding: EdgeInsets.fromLTRB(
                    20, MediaQuery.of(context).size.height * 0.05, 20, 0),
                child: Column(
                  children: <Widget>[
                    /* Text('Registracija',
                    style: TextStyle(fontSize: 25),),
                    */
                    /*Image.asset(
                      "assets/images/signup_image.png", 
                      fit: BoxFit.fitWidth,
                    ),*/
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.25,
                    ),
                    reusableTextField(context, "Ime i prezime",
                        Icons.person_outline, false, _userNameTextController),
                    const SizedBox(
                      height: 20,
                    ),
                    DropDownMultiSelect(
                      onChanged: (List<String> x) {
                        setState(() {
                          selected = x;
                        });
                      },
                      options: [
                        'Jova',
                        'Ambrozija',
                        'Pelin',
                        'Breza',
                        'Pepeljuga/Štir',
                        'Leska',
                        'Tise/Čempresi',
                        'Jasen',
                        'Orah',
                        'Bokvica',
                        'Platan',
                        'Trave',
                        'Topola',
                        'Hrast',
                        'Kiselica',
                        'Kopriva'
                      ],
                      selectedValues: selected,
                      whenEmpty: 'Odaberite alergente',
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    reusableTextField(context, "Email", Icons.person_outline,
                        false, _emailTextController),
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
                    reusableTextField(context, "Potvrdi lozinku",
                        Icons.lock_outline, true, _password1TextController),
                    (errorMessageCode == 'password1')
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
                    signInSignUpButton(context, "Registracija", () async {
                      try {
                        final bool emailValid = RegExp(
                                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                            .hasMatch(_emailTextController.text);
                        if (!emailValid) {
                          setState(() {
                            errorMessage = "Neipsravan email, pokušajte ponovo";
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
                        RegExp numReg = RegExp(r".*[0-9].*");
                        RegExp letterReg = RegExp(r".*[A-Za-z].*");
                        if (!letterReg.hasMatch(_passwordTextController.text) ||
                            !numReg.hasMatch(_passwordTextController.text) ||
                            _passwordTextController.text.length < 6) {
                          // weak
                          setState(() {
                            errorMessage = "Slaba lozinka";
                            errorMessageCode = 'password';
                          });
                          return;
                        }
                        if (_password1TextController.text !=
                            _passwordTextController.text) {
                          setState(() {
                            errorMessage = "Lozinke nisu iste";
                            errorMessageCode = 'password1';
                          });
                          return;
                        }
                        await FirebaseAuth.instance
                            .createUserWithEmailAndPassword(
                                email: _emailTextController.text,
                                password: _passwordTextController.text)
                            .then((value) async {
                          await FirebaseAuth.instance.currentUser!
                              .updateDisplayName(
                            _userNameTextController.text,
                          );
                          //await FirebaseAuth.instance.currentUser!.updatePhotoURL('');
                          print("Nalog otvoren!");
                          String alergenti = '';
                          for(int i=0;i<selected.length;i++){
                            alergenti += '${selected[i]} ';
                          }
                    
                          Map<String, String> DataToSend = {
                            'alergenti': alergenti,
                          };
                          _collectionReference
                              .doc(FirebaseAuth.instance.currentUser!.uid)
                              .set(DataToSend);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      HomeScreen() //ServiceChoiceScreen()
                                  ));
                        });
                      } on FirebaseAuthException catch (error) {
                        print("Error ${error.toString()}");
                        switch (error.code) {
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
                          case "weak-password":
                            //print('WAEK PASSWORD CAUGHT ----------------------------');
                            setState(() {
                              errorMessage = "Slaba lozinka";
                              errorMessageCode = 'password';
                            });
                            break;
                          case "email-already-in-use":
                            setState(() {
                              errorMessage = "Email već u upotrebi";
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
                    signInOption()
                  ],
                )),
          ),
        ));
  }

  Row signInOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Već imate nalog?",
            textScaleFactor: 1,
            style: TextStyle(color: Colors.black, fontSize: 14)),
        GestureDetector(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => SignInScreen()));
          },
          child: Text(
            " Prijavi se",
            textScaleFactor: 1,
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
