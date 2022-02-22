import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/places.provider.dart';
import 'add_place.screen.dart';
import 'place_detail.screen.dart';

class PlacesListScreen extends StatelessWidget {
  const PlacesListScreen({Key? key}) : super(key: key);

  Future<void> refreshPlaces(BuildContext context) {
    return Provider.of<Places>(context, listen: false).getAndSetPlaces();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your places'),
        actions: [
          IconButton(
            onPressed: () =>
                Navigator.of(context).pushNamed(AddPlaceScreen.routeName),
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: FutureBuilder(
        future: refreshPlaces(context),
        builder: (_, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator.adaptive());
          }
          return RefreshIndicator(
            onRefresh: () => refreshPlaces(context),
            child: Consumer<Places>(
              child: const Center(
                child: Text('No places available'),
              ),
              builder: (ctx, places, ch) {
                if (places.items.isEmpty) {
                  return ch as Widget;
                }
                return ListView.builder(
                  itemCount: places.items.length,
                  itemBuilder: (ctx, idx) {
                    return ListTile(
                      onTap: () => Navigator.of(context).pushNamed(
                        PlaceDetailScreen.routeName,
                        arguments: places.items[idx].id,
                      ),
                      leading: CircleAvatar(
                        backgroundImage: FileImage(places.items[idx].image),
                      ),
                      title: Text(places.items[idx].title),
                      subtitle: Text(
                        places.items[idx].location?.address ??
                            'unknown address',
                      ),
                    );
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}
