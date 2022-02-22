import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/place.model.dart';
import '../providers/places.provider.dart';
import 'maps.screen.dart';

class PlaceDetailScreen extends StatelessWidget {
  static const routeName = '/place-detail';
  const PlaceDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final id = ModalRoute.of(context)?.settings.arguments as String;
    final selectedPlace = Provider.of<Places>(context).findById(id);
    return Scaffold(
      appBar: AppBar(
        title: Text(selectedPlace?.title ?? 'Selected place not found'),
      ),
      body: selectedPlace == null
          ? const Center(
              child: Text('Selected place not found'),
            )
          : Column(
              children: [
                SizedBox(
                  height: 250,
                  width: double.infinity,
                  child: Image.file(
                    selectedPlace.image,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  selectedPlace.location?.address ?? 'No address available',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 20, color: Colors.grey),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (ctx) => MapsScreen(
                        initialLocation:
                            selectedPlace.location ?? const PlaceLocation(),
                      ),
                    ),
                  ),
                  child: const Text('View on map'),
                  style: TextButton.styleFrom(
                    primary: Theme.of(context).primaryColor,
                  ),
                )
              ],
            ),
    );
  }
}
