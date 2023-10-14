import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

import 'package:hacka/HomeScreen.dart';
import 'package:hacka/SettingsScreen.dart';

CollectionReference _reservationsReference =
    FirebaseFirestore.instance.collection("reservations");

class SettingsUI extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Setting UI",
      home: ProfileScreen(),
    );
  }
}

TextEditingController ime_prezime_controller = new TextEditingController();
TextEditingController email_controller = new TextEditingController();

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  var newimage;
  bool showPassword = false;

  bool get_reservations_num(AsyncSnapshot<QuerySnapshot<Object?>> stream) {
    bool ret = false;
    try {
      for (int i = 0; i < stream.data!.docs.length; i++) {
        if (stream.data!.docs[i]['owner'] ==
            FirebaseAuth.instance.currentUser!.email) {
          if (stream.data!.docs[i]['active'] == 'false' &&
              stream.data!.docs[i]['odbijen'] == 'false') {
            ret = true;
            return ret;
          }
        }
      }
    } catch (e) {}
    return ret;
  }

  bool get_reservations_num_moje(AsyncSnapshot<QuerySnapshot<Object?>> stream) {
    bool ret = false;
    try {
      for (int i = 0; i < stream.data!.docs.length; i++) {
        if (stream.data!.docs[i]['reserver'] ==
            FirebaseAuth.instance.currentUser!.email) {
          if ((stream.data!.docs[i]['active'] == true ||
                  stream.data!.docs[i]['odbijen'] == true) &&
              stream.data!.docs[i]['reserver_seen'] == 'false') {
            ret = true;
            return ret;
          }
        }
      }
    } catch (e) {}
    return ret;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 1,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Color(0xffA3B18D),
          ),
          onPressed: () {
            Navigator.push(context,
                    MaterialPageRoute(builder: (context) => HomeScreen()))
                .onError((error, stackTrace) {
              print("Error ${error.toString()}");
            });
          },
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.settings,
              color: Color(0xffA3B18D),
            ),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => SettingsScreen()));
            },
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          height: 80,
          width: double.maxFinite,
          decoration: BoxDecoration(
            color: Color(0xffA3B18D),
          ),
          child: Row(
            children: <Widget>[
              Spacer(),
              Container(
                  width: MediaQuery.of(context).size.width * 0.95,
                  height: 50,
                  margin: const EdgeInsets.fromLTRB(0, 10, 0, 20),
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(90)),
                  child: ElevatedButton(
                      onPressed: () {
                        setState(() async {
                          print(ime_prezime_controller.text);
                          await FirebaseAuth.instance.currentUser!
                              .updateDisplayName(ime_prezime_controller.text);
                        });
                      },
                      child: Text(
                        'Potvrdi izmene',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize:
                                16 / MediaQuery.textScaleFactorOf(context)),
                      ),
                      style: ButtonStyle(
                          elevation: MaterialStateProperty.all(0),
                          backgroundColor:
                              MaterialStateProperty.resolveWith((states) {
                            if (states.contains(MaterialState.pressed)) {
                              return Colors.white;
                            }
                            return Color(0xff3B5A42);
                            //Color(0xff3B5A42);
                          }),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(15)))))),
              Spacer(),
            ],
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.only(left: 16, top: 25, right: 16),
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: ListView(
            children: [
              Text(
                "Moj nalog",
                style: TextStyle(
                    fontSize: 20 / MediaQuery.textScaleFactorOf(context),
                    fontWeight: FontWeight.w500),
              ),
              SizedBox(
                height: 15,
              ),
              GestureDetector(
                child: Center(
                  child: Stack(
                    children: [
                      Container(
                        width: 130,
                        height: 130,
                        decoration: BoxDecoration(
                            border: Border.all(
                                width: 4,
                                color:
                                    Theme.of(context).scaffoldBackgroundColor),
                            boxShadow: [
                              BoxShadow(
                                  spreadRadius: 2,
                                  blurRadius: 10,
                                  color: Colors.black.withOpacity(0.1),
                                  offset: Offset(0, 10))
                            ],
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage(
                                  _auth.currentUser!.photoURL ??
                                      "https://firebasestorage.googleapis.com/v0/b/hacka-e33f3.appspot.com/o/profile.png?alt=media&token=6b5b67a9-3865-456d-b2c8-f3635f341ac7&_gl=1*133guvm*_ga*MTQyMzkwNzkxNS4xNjkwODk4NTk2*_ga_CW55HF8NVT*MTY5NzI4Nzc1MS44Ni4xLjE2OTcyOTE5ODguMS4wLjA.",
                                ))),
                      ),
                      Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                width: 4,
                                color:
                                    Theme.of(context).scaffoldBackgroundColor,
                              ),
                              color: Color.fromARGB(255, 168, 162, 77),
                            ),
                            child: Icon(
                              Icons.edit,
                              color: Colors.white,
                            ),
                          )),
                    ],
                  ),
                ),
                onTap: () async {

                },
              ),
              SizedBox(
                height: 35,
              ),
              /*
              buildTextField(
                  "Ime i prezime",
                  _auth.currentUser!.displayName ?? '',
                  true,
                  ime_prezime_controller),
              buildTextField("E-mail", _auth.currentUser!.email ?? '', false,
                  email_controller),
                  */
              SizedBox(
                height: 5,
              ),
              Container(
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(90)),
                  child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HomeScreen()))
                            .onError((error, stackTrace) {
                          print("Error ${error.toString()}");
                        });
                      },
                      child: Text(
                        'Home',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize:
                                16 / MediaQuery.textScaleFactorOf(context)),
                      ),
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.resolveWith((states) {
                            if (states.contains(MaterialState.pressed)) {
                              return Colors.white;
                            }
                            return Color(0xff3B5A42);
                          }),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(15)))))),
              Stack(
                children: [
                  Container(
                      width: MediaQuery.of(context).size.width,
                      height: 50,
                      margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(90)),
                      child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            HomeScreen()))
                                .onError((error, stackTrace) {
                              print("Error ${error.toString()}");
                            });
                          },
                          child: Text(
                            'Home',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize:
                                    16 / MediaQuery.textScaleFactorOf(context)),
                          ),
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.resolveWith((states) {
                                if (states.contains(MaterialState.pressed)) {
                                  return Colors.white;
                                }
                                return Color(0xff3B5A42);
                              }),
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(15)))))),
                  StreamBuilder(
                    stream:
                        _reservationsReference.snapshots(), //build connection
                    builder:
                        (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                      if (get_reservations_num_moje(streamSnapshot))
                        return Positioned(
                          top: 5.0,
                          right: 0.0,
                          child: new Icon(Icons.brightness_1,
                              size: 15.0, color: Colors.redAccent),
                        );
                      else
                        return SizedBox(
                          height: 0,
                        );
                    },
                  )
                ],
              ),
              Stack(
                children: [
                  Container(
                      width: MediaQuery.of(context).size.width,
                      height: 50,
                      margin: const EdgeInsets.fromLTRB(0, 10, 0, 20),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(90)),
                      child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            HomeScreen()))
                                .onError((error, stackTrace) {
                              print("Error ${error.toString()}");
                            });
                          },
                          child: Text(
                            'Home',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize:
                                    16 / MediaQuery.textScaleFactorOf(context)),
                          ),
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.resolveWith((states) {
                                if (states.contains(MaterialState.pressed)) {
                                  return Colors.white;
                                }
                                return Color(0xff3B5A42);
                              }),
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(15)))))),
                  StreamBuilder(
                    stream:
                        _reservationsReference.snapshots(), //build connection
                    builder:
                        (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                      if (get_reservations_num(streamSnapshot))
                        return Positioned(
                          top: 5.0,
                          right: 0.0,
                          child: new Icon(Icons.brightness_1,
                              size: 15.0, color: Colors.redAccent),
                        );
                      else
                        return SizedBox(
                          height: 0,
                        );
                    },
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField(String labelText, String placeholder, bool isEnabled,
      TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 35.0),
      child: TextField(
        controller: controller,
        enabled: isEnabled,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.only(bottom: 3),
            labelText: labelText,
            labelStyle:
                TextStyle(fontSize: 16 / MediaQuery.textScaleFactorOf(context)),
            floatingLabelBehavior: FloatingLabelBehavior.always,
            hintText: placeholder,
            hintStyle: TextStyle(
              fontSize: 16 / MediaQuery.textScaleFactorOf(context),
              fontWeight: FontWeight.bold,
              color: Colors.black,
            )),
      ),
    );
  }
}
