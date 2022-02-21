import 'package:flutter/material.dart';
import 'package:location/location.dart';

import '../services/location.service.dart';

class LocationInput extends StatefulWidget {
  const LocationInput({Key? key}) : super(key: key);

  @override
  _LocationInputState createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  String? _previewImageUrl;

  final _locationController = TextEditingController();

  Future<void> getUserLocation() async {
    final location = Location();
    final permissionStatus = await location.requestPermission();
    if (permissionStatus != PermissionStatus.granted) {
      return;
    }
    final locData = await location.getLocation();
    final previewImageUrl = LocationService.generateLocationPreviewImage(
      locData.latitude!,
      locData.longitude!,
    );
    setState(() => _previewImageUrl = previewImageUrl);
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
              onPressed: getUserLocation,
              icon: const Icon(Icons.location_on),
              label: const Text('Current location'),
              style: TextButton.styleFrom(
                primary: Theme.of(context).primaryColor,
              ),
            ),
            TextButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.map),
              label: const Text('Select on map'),
              style: TextButton.styleFrom(
                primary: Theme.of(context).primaryColor,
              ),
            )
          ],
        ),
        TextField(
          controller: _locationController,
          decoration: const InputDecoration(
            labelText: 'Place address',
          ),
        )
      ],
    );
  }
}
