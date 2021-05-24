import 'package:academics/main.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:academics/model/options.dart';
import '../boxes.dart';

class Registration extends StatefulWidget {
  @override
  _RegistrationState createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  bool firstLogin = true;

  var values = {
    "Assignments": false,
    "Tutorials/Practicals": false,
    "Quiz": false,
    "PBL": false,
    "Unit tests": false
  };
  List options = [];

  TextStyle stle = TextStyle(fontSize: 21, fontWeight: FontWeight.w400);

  onSubmit() async {
    var keyValues = values.keys.toList();
    keyValues.forEach((element) {
      if (values[element] == true) {
        options.add(element);
      }
    });
    // print(options);
    if (options.length == 0) {
      final snackBar = SnackBar(content: Text('Select at least one category'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      SharedPreferences pref = await SharedPreferences.getInstance();
      pref.setString("isLoggedIn", "true");
      await addOptions(options);
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => MyHomePage()));
    }
  }

  Future addOptions(List options) async {
    final transaction = Options()..options = options;

    await Hive.openBox<Options>("options");
    final box = Boxes.getOptions();

    await box.put('optionskey', transaction);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text("Academics Manager"),
      ),
      body: Container(
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(23.0),
              child: Text(
                "Welcome! We are here to help you to manage your Academic Work-Load",
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange),
                textAlign: TextAlign.center,
                maxLines: 5,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "From options select what you have :",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange),
                textAlign: TextAlign.right,
              ),
            ),
            SizedBox(
              height: 9,
            ),
            Column(
              children: [
                ListView.builder(
                    shrinkWrap: true,
                    itemCount: values.length,
                    itemBuilder: (context, ele) {
                      return CheckboxListTile(
                          value: values[values.keys.toList()[ele].toString()],
                          activeColor: Colors.orange,
                          title: Padding(
                            padding: const EdgeInsets.only(left: 28.0),
                            child: Text(
                              values.keys.toList()[ele],
                              style: stle,
                            ),
                          ),
                          onChanged: (value) {
                            setState(() {
                              values[values.keys.toList()[ele].toString()] =
                                  value;
                            });
                          });
                    }),
                SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: Colors.orange),
                    onPressed: onSubmit,
                    child: Text(
                      "Submit",
                    ))
              ],
            )
          ],
        ),
      ),
    );
  }
}
