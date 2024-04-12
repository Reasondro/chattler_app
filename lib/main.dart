import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

// import 'package:chattler_app/screens/chattler.dart';
import 'package:chattler_app/screens/auth.dart';

final ColorScheme kColorScheme = ColorScheme.fromSeed(
    seedColor: Color.fromARGB(255, 148, 243, 255),
    // seedColor: const Color.fromARGB(255, 255, 235, 179),
    brightness: Brightness.light);

final ThemeData theme = ThemeData().copyWith(
    // scaffoldBackgroundColor: ,
    colorScheme: kColorScheme,
    textTheme: GoogleFonts.alexandriaTextTheme().copyWith(
      titleLarge:
          GoogleFonts.alexandria().copyWith(color: kColorScheme.onBackground),
    ),
    appBarTheme: AppBarTheme(
      color: kColorScheme.copyWith().primary,
      foregroundColor: kColorScheme.copyWith().onPrimary,
    ),
    scaffoldBackgroundColor: kColorScheme.background);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //!  ⬆️ important, fixed for the "can't start the app" bug. need to learn how it works though.

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  //!  ⬆️ also important, required by the firebase. (see firebase documentation)

  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chattler',
      theme: theme,
      home: const AuthScreen(),
    );
  }
}
