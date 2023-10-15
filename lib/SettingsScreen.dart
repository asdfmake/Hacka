import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:hacka/signin_screen.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _auth = FirebaseAuth.instance;
  TextEditingController newpasscontroller = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 1,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: Icon(
            Icons.arrow_back,
            color: Color.fromARGB(255, 185, 148, 0),
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.only(left: 16, top: 25, right: 16),
        child: ListView(
          children: [
            Text(
              "Podešavanja",
              style: TextStyle(fontSize: 20 / MediaQuery.textScaleFactorOf(context), fontWeight: FontWeight.w500),
            ),
            SizedBox(
              height: 40,
            ),
            Row(
              children: [
                Icon(
                  Icons.person,
                  color: Color.fromARGB(255, 185, 139, 0),
                ),
                SizedBox(
                  width: 8,
                ),
                Text(
                  "Nalog",
                  style: TextStyle(fontSize: 18 / MediaQuery.textScaleFactorOf(context), fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Divider(
              height: 15,
              thickness: 2,
            ),
            SizedBox(
              height: 10,
            ),
            buildAccountOptionRow(context, "Promena lozinke", '', false),
            buildAccountOptionRow(context, "Jezik",
                "Promena jezika za sada nije dostupna.", true),
            buildAccountOptionRow(context, "Podešavanja privatnosti",
                "Podešavanja privatnosti za sada nisu dostupna.", true),
            SizedBox(
              height: 40,
            ),
            Row(
              children: [
                Icon(
                  Icons.volume_up_outlined,
                  color: Color.fromARGB(255, 185, 157, 0),
                ),
                SizedBox(
                  width: 8,
                ),
                Text(
                  "Obaveštenja",
                  style: TextStyle(fontSize: 18 / MediaQuery.textScaleFactorOf(context), fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Divider(
              height: 15,
              thickness: 2,
            ),
            SizedBox(
              height: 10,
            ),
            buildNotificationOptionRow("Obaveštenja o rezervacijama", true),
            buildNotificationOptionRow("Obaveštenja o porukama", true),
            SizedBox(
              height: 50,
            ),
            Center(
              child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 40),
                  //shape: RoundedRectangleBorder(
                  // borderRadius: BorderRadius.circular(20)),
                  //onPressed: () {},
                  child: GestureDetector(
                    onTap: () async {
                      await FirebaseAuth.instance.signOut();
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (ctx) => SignInScreen()),
                          (route) => false);
                    },
                    child: Text("ODJAVA",
                        style: TextStyle(
                            fontSize: 20 / MediaQuery.textScaleFactorOf(context),
                            letterSpacing: 2.2,
                            color: Colors.black)),
                  )),
            )
          ],
        ),
      ),
    );
  }

  Row buildNotificationOptionRow(String title, bool isActive) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
              fontSize: 15 / MediaQuery.textScaleFactorOf(context),
              fontWeight: FontWeight.w500,
              color: Colors.grey[600]),
        ),
        Transform.scale(
            scale: 0.7,
            child: CupertinoSwitch(
              value: isActive,
              trackColor: Colors.grey,
              activeColor: Color.fromARGB(255, 185, 145, 0),
              onChanged: (bool val) {},
            ))
      ],
    );
  }

  GestureDetector buildAccountOptionRow(
      BuildContext context, String title, String poruka, bool dialog) {
    return GestureDetector(
      onTap: () async {
        if (dialog) {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text(title),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(poruka),
                    ],
                  ),
                  actions: [
                    /*
                  FlatButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text("Close")),*/
                  ],
                );
              });
        } else {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text(title),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: newpasscontroller,
                        obscureText: true,
                        enableSuggestions: false,
                        autocorrect: false,
                      )
                    ],
                  ),
                  actions: [
                    Container(
                      width: double.infinity,
                      height: 60,
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        onPressed: () async {
                          await FirebaseAuth.instance.currentUser!
                              .updatePassword(newpasscontroller.text);
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Color.fromARGB(255, 185, 132, 0),
                          // fixedSize: Size(250, 50),
                        ),
                        child: Text(
                          "Potvrdi",
                        ),
                      ),
                    ),
                    /*GestureDetector(
                        onTap: () async {
                          await FirebaseAuth.instance.currentUser!
                              .updatePassword(newpasscontroller.text);
                        },
                        child: Text("Postavi")),*/
                  ],
                );
              });
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 16 / MediaQuery.textScaleFactorOf(context),
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}
