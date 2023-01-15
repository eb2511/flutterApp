import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PastPage extends StatefulWidget {
  const PastPage({Key key}) : super(key: key);

  @override
  _PastPageState createState() => _PastPageState();
}

class _PastPageState extends State<PastPage> {
  List _items = [];

  // Fetch content from the json file
  Future<void> readJson() async {
    //reads json file, puts items in list
    final String response = await rootBundle.loadString('assets/tasks.json');
    final data = await json.decode(response);
    _items = data;
    setState(() {
      _items = data;
    });
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
          'FinishedList',
        ),
        actions: <Widget>[
          Padding(
              //list refresher
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: readJson,
                child: Icon(Icons.refresh),
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
                          return Card(
                            margin: const EdgeInsets.all(10),
                            child: ListTile(
                              leading: Icon(Icons.done),
                              title: Text(_items[index]["desc"]),
                              subtitle: Text(_items[index]["urgency"]),
                            ),
                          );
                        } else {
                          return Padding(padding: EdgeInsets.zero);
                        }
                      },
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
