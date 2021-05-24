import 'package:academics/boxes.dart';
import 'package:academics/model/options.dart';
import 'package:academics/screens/listassignments.dart';
import 'package:academics/screens/listpbl.dart';
import 'package:academics/screens/listquiz.dart';
import 'package:academics/screens/listtests.dart';
import 'package:academics/screens/listtutorials.dart';
import 'package:academics/screens/registration.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  SharedPreferences pref = await SharedPreferences.getInstance();
  var data = pref.getString("isLoggedIn");
  Hive.registerAdapter(OptionsAdapter());
  Hive.registerAdapter(SubjectsAdapter());
  await Hive.openBox<Options>('options');
  await Hive.openBox<Subjects>('Subjects');

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      primarySwatch: Colors.blue,
    ),
    home: data == null ? Registration() : MyHomePage(),
    routes: {
      "/registration": (context) => Registration(),
      "/homepage": (context) => MyHomePage(),
    },
  ));
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List options = [];
  bool isLoading = true;
  Box<Options> mybox;

  erase() async {
    await Hive.deleteBoxFromDisk('Subjects');
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.clear();
    Navigator.pop(context);
    Navigator.pushReplacementNamed(context, '/registration');
  }

  @override
  void initState() {
    print("initial : $options");
    super.initState();
  }

  onpressed(String selected) {
    if (selected == "Assignments") {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => ListAssignments()));
    } else if (selected == "Tutorials/Practicals") {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => ListTutorials()));
    } else if (selected == "Quiz") {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => ListQuiz()));
    } else if (selected == "PBL") {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => ListPBL()));
    } else if (selected == "Unit tests") {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => ListTests()));
    }
  }

  Future onclicked() async {
    mybox = await Hive.openBox<Options>("options");
    final box = Boxes.getOptions();
    // print(box.get('optionskey').options);
    options = box.get('optionskey').options;
    return options;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.orange,
          title: Text("Academics Manager"),
          actions: [
            InkWell(
              onLongPress: () {
                return AlertDialog(
                    content: Text("Your All data will be wiped!"));
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 22.0, top: 17),
                child: Text(
                  "Reset",
                  style: TextStyle(fontSize: 19),
                ),
              ),
              onTap: () => showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                        content: Text("Do you want to erase all your data ?"),
                        actions: [
                          CupertinoButton(
                              color: Colors.orange,
                              child: Text("Erase!"),
                              onPressed: erase)
                        ],
                      )),
            )
          ],
        ),
        body: home(context));
  }

  Widget home(BuildContext context) {
    print("final options $options");
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              "Manage All your Academic records\nAssignments, Tutorials, Quizes, PBL",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 23,
                  color: Colors.orange,
                  fontWeight: FontWeight.bold),
            ),
          ),
          FutureBuilder(
              initialData: ["Loading"],
              future: onclicked(),
              builder: (context, snap) {
                print(snap.data);
                return ListView.builder(
                    shrinkWrap: true,
                    itemCount: snap.data.length,
                    itemBuilder: (context, ele) {
                      return Padding(
                        padding: const EdgeInsets.only(
                            left: 15.0, right: 15.0, bottom: 8.0),
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: Colors.orange),
                            onPressed: () {
                              print(snap.data[ele]);
                              onpressed(snap.data[ele].toString());
                            },
                            child: Text(snap.data[ele])),
                      );
                    });
              })
        ],
      ),
    );
  }
}
