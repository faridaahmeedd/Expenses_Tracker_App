import 'package:expenses_tracker_app/screens/expenses_screen.dart';
import 'package:flutter/material.dart';

final colorScheme = ColorScheme.light(
  primary: Colors.indigo.shade400,
  onPrimary: Colors.white,
  secondary: Colors.black87,
  error: Colors.red,
);

final darkColorScheme = ColorScheme.dark(
  primary: Colors.indigo.shade400,
  onPrimary: Colors.black87,
  secondary: Colors.white,
  error: Colors.red,
);

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      darkTheme: ThemeData.dark().copyWith(
        // accentColor: darkColorScheme.primary,
        colorScheme: darkColorScheme,
        inputDecorationTheme: const InputDecorationTheme(
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
            labelStyle: TextStyle(
              color: Colors.white,
            )),
      ),
      theme: ThemeData().copyWith(
        // accentColor: colorScheme.primary,
        //copyWith() method is used to copy the existing theme and modify some of its properties
        colorScheme: colorScheme,

        inputDecorationTheme: const InputDecorationTheme(
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black),
            ),
            labelStyle: TextStyle(
              color: Colors.black87,
            )),
      ),

      title: 'Expenses Tracker',
      home: const Expenses(),
      // themeMode: ThemeMode.dark,
    );
  }
}
