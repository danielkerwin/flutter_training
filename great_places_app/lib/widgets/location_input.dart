import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

import '../screens/maps.screen.dart';
import '../services/location.service.dart';

class LocationInput extends StatefulWidget {
  final Function(double lat, double lng) onSelectPlace;
  const LocationInput({
    Key? key,
    required this.onSelectPlace,
  }) : super(key: key);

  @override
  _LocationInputState createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  String? _previewImageUrl;

  void _updatePreviewImageUrl(double lat, double long) {
    final previewImageUrl = LocationService.generateLocationPreviewImage(
      lat,
      long,
    );
    setState(() => _previewImageUrl = previewImageUrl);
  }

  Future<void> _getUserLocation() async {
    final location = Location();
    final permissionStatus = await location.requestPermission();
    if (permissionStatus != PermissionStatus.granted) {
      return;
    }
    final locData = await location.getLocation();
    _updatePreviewImageUrl(locData.latitude!, locData.longitude!);
    widget.onSelectPlace(locData.latitude!, locData.longitude!);
  }

  Future<void> _selectOnMap() async {
    final selectedLocation = await Navigator.of(context).push<LatLng>(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (ctx) => const MapsScreen(
          isSelecting: true,
        ),
      ),
    );
    if (selectedLocation == null) {
      return;
    }
    _updatePreviewImageUrl(
      selectedLocation.latitude,
      selectedLocation.longitude,
    );
    widget.onSelectPlace(selectedLocation.latitude, selectedLocation.longitude);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          alignment: Alignment.center,
          height: 170,
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(
              width: 1.0,
              color: Colors.grey,
            ),
          ),
          child: _previewImageUrl == null
              ? const Text('No location entered')
              : Image.network(
                  _previewImageUrl!,
                  fit: BoxFit.cover,
                ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton.icon(
              onPressed: _getUserLocation,
              icon: const Icon(Icons.location_on),
              label: const Text('Current location'),
              style: TextButton.styleFrom(
                primary: Theme.of(context).primaryColor,
              ),
            ),
            TextButton.icon(
              onPressed: _selectOnMap,
              icon: const Icon(Icons.map),
              label: const Text('Select on map'),
              style: TextButton.styleFrom(
                primary: Theme.of(context).primaryColor,
              ),
            )
          ],
        ),
      ],
    );
  }
}
