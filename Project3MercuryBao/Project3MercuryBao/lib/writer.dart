import 'package:flutter/material.dart';
import 'globals.dart' as globals;

class Writer extends StatefulWidget {
  Writer({Key key}) : super(key: key);

  @override
  State<Writer> createState() => _WriterState();
}

class _WriterState extends State<Writer> {
  String dropdownValue = 'Low';
  DateTime selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  final myController = TextEditingController();
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  String _urgency = 'Low';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New task'),
      ),
      body: Column(
        children: <Widget>[
          TextField(
            controller: myController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Task description',
            ),
          ),
          Row(
            children: <Widget>[
              Text('Level of urgency: '),
              DropdownButton<String>(
                value: dropdownValue,
                icon: const Icon(Icons.arrow_downward),
                elevation: 16,
                style: const TextStyle(color: Colors.deepPurple),
                underline: Container(
                  height: 2,
                  color: Colors.deepPurpleAccent,
                ),
                onChanged: (String newValue) {
                  setState(() {
                    dropdownValue = newValue;
                    _urgency = newValue;
                  });
                },
                items: <String>['Low', 'Mid', 'High']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              )
            ],
          ),
          Row(
            children: <Widget>[
              Text("Due date: "),
              SizedBox(
                height: 20.0,
              ),
              TextButton(
                onPressed: () => _selectDate(context),
                child: Text("${selectedDate.toLocal()}".split(' ')[0]),
              ),
            ],
          ),
          FloatingActionButton(
            // When the user presses the button, show an alert dialog containing
            // the text that the user has entered into the text field.
            onPressed: () {
              if (myController.text.isEmpty) {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      content: Text("You have to put in description first."),
                    );
                  },
                );
              } else {
                globals.addItem(
                  myController.text,
                  _urgency,
                  "${selectedDate.toLocal()}".split(' ')[0],
                );
                Navigator.pop(context);
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      content: Text("Task added!"),
                    );
                  },
                );
              }
            },
            tooltip: 'Add a new task!',
            child: const Icon(Icons.done),
          ),
        ],
      ),
    );
  }
}
