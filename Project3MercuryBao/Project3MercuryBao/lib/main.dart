import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart';

import 'globals.dart' as globals;
import 'package:flutter/material.dart';
import 'package:jsonDecode/past.dart';
import 'package:jsonDecode/writer.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      // Hide the debug banner
      debugShowCheckedModeBanner: false,
      title: 'Project3MercuryBao',
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List _items = globals.returnItems();
  // Fetch content from the json file
  Future<void> readJson() async {
    //reads json file, puts items in list
    String response = await rootBundle
        .loadString('assets/tasks.json'); //problem here, every read is the same
    var data = await json.decode(response);
    _items = data;
    setState(() {});
  }

  //turns on alarm if close to due date, turns on late sign if due date is passed
  Icon _selectIcon(DateTime item) {
    if (item.isBefore(DateTime.now())) {
      return Icon(Icons.assignment_late);
    } else if (item.isBefore(DateTime.now().add(const Duration(hours: 24)))) {
      return Icon(Icons.alarm, color: Colors.black);
    } else {
      return Icon(Icons.alarm, color: Colors.black.withOpacity(0));
    }
  }

  //color code the cards based on urgency
  Color _selectColor(String urgency) {
    if (urgency == "low") {
      return Colors.green[200];
    } else if (urgency == "midium") {
      return Colors.yellow[200];
    } else {
      return Colors.red[200];
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => readJson());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Checklist',
        ),
        actions: <Widget>[
          Padding(
              //list refresher
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {
                  _items = globals.returnItems();
                  setState(() {});
                  void rebuild(Element el) {
                    el.markNeedsBuild();
                    el.visitChildren(rebuild);
                  }

                  (context as Element).visitChildren(rebuild);
                },
                child: Icon(Icons.refresh),
              )),
          Padding(
              //json writer
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Writer()),
                  );
                },
                child: Icon(Icons.add),
              )),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          children: [
            // Display the data loaded from tasks.json
            _items.isNotEmpty
                ? Expanded(
                    child: ListView.builder(
                      itemCount: _items.length,
                      itemBuilder: (context, index) {
                        if (_items[index]["finished"] == true) {
                          return Padding(padding: EdgeInsets.zero);
                        } else {
                          return Card(
                            color: _selectColor(_items[index]["urgency"]),
                            margin: const EdgeInsets.all(10),
                            child: ListTile(
                              leading: _selectIcon(
                                  DateTime.parse(_items[index]["textdate"])),
                              title: Text(_items[index]["desc"]),
                              subtitle: Text(_items[index]["urgency"] +
                                  ", due: " +
                                  _items[index]["textdate"]),
                              onTap: () {
                                _items[index]["finished"] = true;

                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        content: Text("You did it!"),
                                      );
                                    });
                              },
                            ),
                          );
                        }
                      },
                    ),
                  )
                : Container(),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PastPage()),
                  );
                },
                child: const Text('finished tasks'))
          ],
        ),
      ),
    );
  }
}
