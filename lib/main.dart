
import 'package:flutter/material.dart';
import 'package:dynamic_color/dynamic_color.dart';

import 'screens/home_screen.dart';

void main() {
  runApp(const FTintraApp());
}

class FTintraApp extends StatelessWidget {
  const FTintraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (lightDynamic, darkDynamic) {
        return MaterialApp(
          title: 'f.Tintra',
          debugShowCheckedModeBanner: false,

          themeMode: ThemeMode.system,

          theme: ThemeData(
            colorScheme: lightDynamic ??
                ColorScheme.fromSeed(
                  seedColor: Colors.blue,
                  brightness: Brightness.light,
                ),
            useMaterial3: true,
            textTheme: GoogleFonts.poppinsTextTheme(),
          ),

          darkTheme: ThemeData(
            colorScheme: darkDynamic ??
                ColorScheme.fromSeed(
                  seedColor: Colors.blue,
                  brightness: Brightness.dark,
                ),
            useMaterial3: true,
          ),

          home: const HomeScreen(),
        );
      },
    );
  }
}