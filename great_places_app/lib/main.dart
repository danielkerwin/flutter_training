import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/places.provider.dart';
import 'screens/places_list.screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final theme = ThemeData(
    primarySwatch: Colors.indigo,
  );

  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Places(),
        )
      ],
      child: MaterialApp(
        title: 'Great Places',
        theme: theme.copyWith(
          colorScheme: theme.colorScheme.copyWith(
            secondary: Colors.amber,
          ),
        ),
        home: const PlacesListScreen(),
      ),
    );
  }
}
