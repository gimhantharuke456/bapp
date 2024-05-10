import 'package:bapp/models/item.model.dart';
import 'package:flutter/material.dart';

class ItemProvider with ChangeNotifier {
  List<Item> _items = [];
  List<Item> get items => _items;

  set setItems(List<Item> items) => _items = items;
}
