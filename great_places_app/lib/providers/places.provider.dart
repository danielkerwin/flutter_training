import 'dart:io';

import 'package:flutter/material.dart';

import '../models/place.model.dart';
import '../services/database.service.dart';

class Places with ChangeNotifier {
  List<Place> _items = [];

  List<Place> get items {
    return [..._items];
  }

  Future<void> getAndSetPlaces() async {
    try {
      final places = await DatabaseService.query(PlacesDatabase.placesTable);
      _items = places
          .map(
            (place) => Place(
              id: place['id'],
              title: place['title'],
              image: File(place['image']),
            ),
          )
          .toList();
      notifyListeners();
    } catch (err) {
      print(err.toString());
    }
  }

  void addPlace(String title, File image) async {
    final newPlace = Place(
      id: DateTime.now().toString(),
      title: title,
      image: image,
      location: null,
    );
    _items.add(newPlace);
    notifyListeners();

    await DatabaseService.insert(
      PlacesDatabase.placesTable,
      {
        'id': newPlace.id,
        'title': newPlace.title,
        'image': newPlace.image.path,
      },
    );
    await DatabaseService.queryById(PlacesDatabase.placesTable, newPlace.id);
  }
}
