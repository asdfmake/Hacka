import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hacka/ProfileScreen.dart';
import 'package:hacka/signin_screen.dart';
import 'package:csv/csv.dart';
import 'package:flutter/services.dart' show rootBundle;

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _dropdownValue = 'NOVI BEOGRAD';
  void dropdownCallback(String? selectedValue) {
    if (selectedValue is String) {
      //2020-08-22 batch_id = 81
      setState(() {
        _dropdownValue = selectedValue;
      });
    }
  }

  String sutra = '126';
  String prekosutra = '110';
  String nakosutra = '139';

  List<List<dynamic>> _data = [];

  void _loadCSV() async {
    final rawData =
        await rootBundle.loadString("assets/tables/pollen_train.csv");
    List<List<dynamic>> listData = const CsvToListConverter().convert(rawData);
    print('==========================================');
    print(listData[0][1]);
    setState(() {
      _data = listData;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadCSV();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Color.fromRGBO(255, 204, 51, 1),
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
                                          image: AssetImage(
                                              'assets/images/profile.png'),
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
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 20,
            ),
            DropdownButton(
              items: const [
                DropdownMenuItem(
                    child: Text('NOVI BEOGRAD'), value: 'NOVI BEOGRAD'),
                DropdownMenuItem(child: Text('VRŠAC'), value: 'VRŠAC'),
                DropdownMenuItem(
                    child: Text('KRAGUJEVAC'), value: 'KRAGUJEVAC'),
                DropdownMenuItem(child: Text('KRALJEVO'), value: 'KRALJEVO'),
                DropdownMenuItem(child: Text('NIŠ'), value: 'NIŠ'),
                DropdownMenuItem(child: Text('POŽAREVAC'), value: 'POŽAREVAC'),
                DropdownMenuItem(child: Text('SUBOTICA'), value: 'SUBOTICA'),
              ],
              value: _dropdownValue,
              onChanged: dropdownCallback,
              hint: Text("Gradovi"),
            ),
            SizedBox(
              height: 40,
            ),
            Padding(
              padding: EdgeInsets.only(left: 25, bottom: 3, right: 25, top: 10),
              child: Card(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ListTile(
                      leading: Icon(Icons.filter_1_rounded),
                      title: Text('Prognoza za sutra:',
                          style: TextStyle(fontSize: 20)),
                      subtitle: Text(
                          'Predviđena koncentracija polena ambrozije u vazduhu: $sutra\nOva količina je potencijalno opasna po Vaše zdravlje.'),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        TextButton(
                          child: const Text('SAVETI',
                              style: TextStyle(
                                  color: Color.fromRGBO(186, 149, 37, 1))),
                          onPressed: () {/* ... */},
                        ),
                        const SizedBox(width: 8),
                        TextButton(
                          child: const Text('MAPA POLENA',
                              style: TextStyle(
                                  color: Color.fromRGBO(186, 149, 37, 1))),
                          onPressed: () {/* ... */},
                        ),
                        const SizedBox(width: 8),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: EdgeInsets.only(left: 25, bottom: 3, right: 25, top: 10),
              child: Card(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ListTile(
                      leading: Icon(Icons.filter_2_rounded),
                      title: Text('Prognoza za prekosutra:',
                          style: TextStyle(fontSize: 20,)),
                      subtitle: Text(
                          'Predviđena koncentracija polena ambrozije u vazduhu: $prekosutra\nOva količina je potencijalno opasna po Vaše zdravlje.'),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        TextButton(
                          child: const Text('SAVETI',
                              style: TextStyle(
                                  color: Color.fromRGBO(186, 149, 37, 1))),
                          onPressed: () {/* ... */},
                        ),
                        const SizedBox(width: 8),
                        TextButton(
                          child: const Text('MAPA POLENA',
                              style: TextStyle(
                                  color: Color.fromRGBO(186, 149, 37, 1))),
                          onPressed: () {/* ... */},
                        ),
                        const SizedBox(width: 8),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: EdgeInsets.only(left: 25, bottom: 3, right: 25, top: 10),
              child: Card(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ListTile(
                      leading: Icon(Icons.filter_3_rounded),
                      title: Text('Prognoza za nakosutra:',
                          style: TextStyle(fontSize: 20)),
                      subtitle: Text(
                          'Predviđena koncentracija polena ambrozije u vazduhu: $nakosutra\nOva količina je potencijalno opasna po Vaše zdravlje.'),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        TextButton(
                          child: const Text('SAVETI',
                              style: TextStyle(
                                  color: Color.fromRGBO(186, 149, 37, 1))),
                          onPressed: () {/* ... */},
                        ),
                        const SizedBox(width: 8),
                        TextButton(
                          child: const Text('MAPA POLENA',
                              style: TextStyle(
                                  color: Color.fromRGBO(186, 149, 37, 1))),
                          onPressed: () {/* ... */},
                        ),
                        const SizedBox(width: 8),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
