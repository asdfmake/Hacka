import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hacka/ProfileScreen.dart';
import 'package:hacka/signin_screen.dart';

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
        automaticallyImplyLeading: false,
        backgroundColor: Color.fromARGB(255, 253, 255, 110),
        title: Row(
          children: [
            Spacer(),
            Column(children: <Widget>[
              Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    GestureDetector(
                        onTap: () {
                          Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ProfileScreen()))
                              .onError((error, stackTrace) {
                            print("Error ${error.toString()}");
                          });
                        },
                        child: (FirebaseAuth.instance.currentUser!.photoURL !=
                                null)
                            ? Stack(children: <Widget>[
                                Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                            image: AssetImage(
                                                'assets/images/profile.png'),
                                            fit: BoxFit.fill))),
                              ])
                            : Stack(
                                children: [
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                          image: AssetImage('assets/images/profile.png'),
                                          fit: BoxFit.fill),
                                    ),
                                  ),
/*
                                  Image.asset(
                                    'assets/images/profile.png',
                                    width: 40,
                                    height: 40,
                                  ),
                                  */
                                ],
                              )),
                  ]),
            ]),
            Spacer(),
            Container(
                width: MediaQuery.of(context).size.width - 110,
                child: Align(
                  alignment: Alignment.center,
                  /*child: Image.asset(
                    'assets/images/mini_logo.png',
                    fit: BoxFit.contain,
                    height: 50,
                    width: 100,
                  ),*/
                )),
            Spacer(flex: 12),
            GestureDetector(
                onTap: () async {
                  await FirebaseAuth.instance.signOut();
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (ctx) => SignInScreen()),
                      (route) => false);
                  Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SignInScreen()))
                      .onError((error, stackTrace) {
                    print("Error ${error.toString()}");
                  });
                },
                child: const Icon(Icons.logout)),
            Spacer(),
          ],
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
