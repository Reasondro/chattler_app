import 'package:chattler_app/screens/chattler.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final kColorScheme = ColorScheme.fromSeed(
    seedColor: const Color.fromARGB(255, 255, 235, 179),
    brightness: Brightness.light);

final theme = ThemeData().copyWith(
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

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chattler',
      theme: theme,
      home: const Chattler(),
    );
  }
}
