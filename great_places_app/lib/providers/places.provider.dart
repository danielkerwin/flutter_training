import 'dart:io';

import 'package:flutter/material.dart';

import '../models/place.model.dart';
import '../services/database.service.dart';
import '../services/location.service.dart';

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
              location: PlaceLocation(
                latitude: place['loc_lat'],
                longitude: place['loc_lng'],
                address: place['address'],
              ),
            ),
          )
          .toList();
      notifyListeners();
    } catch (err) {
      print(err.toString());
    }
  }

  Future<void> addPlace(
    String title,
    File image,
    PlaceLocation location,
  ) async {
    final address = await LocationService.getPlaceAddress(
      location.latitude,
      location.longitude,
    );
    final placeLocation = PlaceLocation(
      latitude: location.latitude,
      longitude: location.longitude,
      address: address,
    );
    final newPlace = Place(
      id: DateTime.now().toString(),
      title: title,
      image: image,
      location: placeLocation,
    );
    _items.add(newPlace);
    notifyListeners();

    await DatabaseService.insert(
      PlacesDatabase.placesTable,
      {
        'id': newPlace.id,
        'title': newPlace.title,
        'image': newPlace.image.path,
        'loc_lat': newPlace.location?.latitude,
        'loc_lng': newPlace.location?.latitude,
        'address': newPlace.location?.address,
      },
    );
    await DatabaseService.queryById(PlacesDatabase.placesTable, newPlace.id);
  }

  Place? findById(String id) {
    return _items.firstWhere((item) => item.id == id);
  }
}
