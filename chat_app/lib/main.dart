import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'providers/ui.provider.dart';
import 'screens/auth.screen.dart';
import 'screens/chat.screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<UI>(
      create: (context) => UI(),
      child: Consumer<UI>(
        builder: (_, ui, __) {
          final theme = ThemeData(
            primarySwatch: Colors.pink,
            backgroundColor: Colors.pink,
            brightness: ui.isDarkMode ? Brightness.dark : Brightness.light,
          );
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Flutter Chat',
            theme: theme.copyWith(
              // buttonTheme: const ButtonThemeData(buttonColor: Colors.white),
              elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              colorScheme: theme.colorScheme.copyWith(
                secondary: Colors.deepPurple,
                onSecondary: Colors.white,
                tertiary: Colors.grey,
                onTertiary: Colors.white,
              ),
            ),
            home: StreamBuilder<User?>(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, userSnapshot) {
                return userSnapshot.hasData ? ChatScreen() : const AuthScreen();
              },
            ),
          );
        },
      ),
    );
  }
}
