// import 'package:academics/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:academics/model/options.dart';
import 'package:intl/intl.dart';

import '../boxes.dart';

class ListAssignments extends StatefulWidget {
  @override
  _ListAssignmentsState createState() => _ListAssignmentsState();
}

class _ListAssignmentsState extends State<ListAssignments> {
  final formKey = GlobalKey<FormState>();
  bool isLoading = true;
  bool isNull = true;
  String sub;
  String no;
  List myData = [];
  String dueDateString = "No Due Date";

  @override
  void initState() {
    getSubjects();
    super.initState();
  }

  void dispose() {
    Hive.close();
    super.dispose();
  }

  getSubjects() async {
    await Hive.openBox<Subjects>("subjects");
    final box = Boxes.getSubjects();
    var mygetter = box.get('assignkey');
    if (mygetter == null || mygetter.myData.length == 0) {
      isNull = true;
    } else {
      isNull = false;
      myData = box.get('assignkey').myData;

      print(myData);
      print(isNull);
    }
    //

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange,
        child: Icon(Icons.add),
        onPressed: () => showDialog(
            context: context, builder: (context) => addsubject(context)),
      ),
      appBar: AppBar(
        // actions: [
        //   InkWell(
        //       child: Icon(Icons.calendar_view_day_outlined),
        //       onTap: () async {
        //         var myDate = await showDatePicker(
        //             context: context,
        //             initialDate: DateTime.now(),
        //             firstDate: DateTime.now(),
        //             lastDate: DateTime(2024));
        //         print(myDate);
        //       })
        // ],
        backgroundColor: Colors.orange,
        title: Text("Assignments"),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : isNull == true
              ? Center(
                  child: Text(
                  "Add some data !\nIf your assignment is completed then tick the CheckBox!",
                  textAlign: TextAlign.center,
                ))
              : Container(
                  child: ListView.builder(
                      itemCount: myData.length,
                      itemBuilder: (context, ele) {
                        myData.sort((a, b) => a["subject"]
                            .toString()
                            .toLowerCase()
                            .compareTo(b["subject"].toString().toLowerCase()));
                        return Dismissible(
                          background: Container(
                            color: Colors.red,
                          ),
                          secondaryBackground: Container(
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(right: 25.0, top: 20),
                              child: Text(
                                "Remove",
                                textAlign: TextAlign.end,
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            color: Colors.orange,
                          ),
                          onDismissed: (direction) {
                            myData.remove(myData[ele]);
                            final box = Boxes.getSubjects();
                            box.get('assignkey').save();
                            setState(() {});
                          },
                          direction: DismissDirection.endToStart,
                          key: UniqueKey(),
                          child: CheckboxListTile(
                              title: Padding(
                                padding: const EdgeInsets.only(left: 20.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(myData[ele]["subject"].toString()),
                                    Text(
                                      myData[ele]["dueDate"] ?? "No Due Date!",
                                      style: TextStyle(fontSize: 13),
                                    )
                                  ],
                                ),
                              ),
                              activeColor: Colors.orange,
                              value: myData[ele]["value"],
                              onChanged: (value) {
                                setState(() {
                                  myData[ele]["value"] = value;
                                  final box = Boxes.getSubjects();
                                  box.get('assignkey').save();
                                });
                              }),
                        );
                      })),
    );
  }

  addDueDate() async {
    DateTime dueDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2020),
        lastDate: DateTime(2030));
    dueDateString = DateFormat("dd/MM/yyyy").format(dueDate);

    // print(dueDateString);
    // final snackBar = SnackBar(
    //   content: Text('Date selected : $dueDateString'),
    //   duration: Duration(seconds: 1),
    // );
    // ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Widget addsubject(BuildContext context) {
    return AlertDialog(
      title: Text('Add Subject'),
      content: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(height: 8),
              Theme(
                data: Theme.of(context).copyWith(primaryColor: Colors.orange),
                child: TextFormField(
                  initialValue: null,
                  onChanged: (value) {
                    sub = value.trim();
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter Subject {use shortform}',
                  ),
                  validator: (name) =>
                      name != null && name.isEmpty ? 'Enter a subject' : null,
                ),
              ),
              SizedBox(
                height: 25,
              ),
              Theme(
                data: Theme.of(context).copyWith(primaryColor: Colors.orange),
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  initialValue: null,
                  onChanged: (value) {
                    no = value.trim();
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter assignment no.',
                  ),
                  validator: (name) =>
                      name != null && name.isEmpty ? 'e.g 1' : null,
                ),
              ),
              SizedBox(
                height: 25,
              ),
              CupertinoButton(
                child: Text("Add Due Date"),
                onPressed: addDueDate,
                color: Colors.orange,
              )
            ],
          ),
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text(
            "Add",
            style: TextStyle(color: Colors.orangeAccent),
          ),
          onPressed: () async {
            final isValid = formKey.currentState.validate();

            if (isValid) {
              // if (sub.length > 22) {
              //   var newsub = "";
              //   for (var i = 0; i < 21; i++) {
              //     newsub += sub[i];
              //   }
              //   sub = newsub;
              // }

              String name = sub + " " + no;
              setState(() {
                myData.add({
                  "subject": name,
                  "value": false,
                  "dueDate": dueDateString
                });
              });

              final subs = Subjects()..myData = myData;

              // await Hive.openBox("options");
              final box = Boxes.getSubjects();
              // box.add(transaction);
              box.put('assignkey', subs);

              Navigator.of(context).pop();
              getSubjects();
              dueDateString = "No Due Date";
            }
          },
        ),
        TextButton(
          child: Text(
            'Cancel',
            style: TextStyle(color: Colors.orangeAccent),
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }
}
