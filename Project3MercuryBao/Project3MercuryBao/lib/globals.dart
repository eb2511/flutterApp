import 'package:flutter/material.dart';

List _items = [];

List returnItems() {
  return _items;
}

void addItem(name, urgency, date) {
  _items.add(task(name, urgency, date));
}

class task {
  String name;
  String urgency;
  String textdate;
  bool finished = false;

  task(name, urgency, date) {
    this.name = name;
    this.urgency = urgency;
    this.textdate = date;
  }
}
