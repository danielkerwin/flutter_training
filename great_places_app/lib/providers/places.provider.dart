import 'package:flutter/material.dart';

import '../models/place.model.dart';

class Places with ChangeNotifier {
  List<Place> _items = [];

  List<Place> get items {
    return [..._items];
  }
}
