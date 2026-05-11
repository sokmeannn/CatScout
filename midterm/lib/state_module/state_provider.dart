import 'package:flutter/material.dart';
import 'package:midterm/state_module/gridstyle_logic.dart';
import 'package:midterm/state_module/screen/main_screen.dart';
import 'package:provider/provider.dart';
import 'theme_logic.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    bool dark = context.watch<ThemeLogic>().dark;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: dark ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData(
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.brown),
        appBarTheme: const AppBarThemeData(
          backgroundColor: Colors.brown,
          foregroundColor: Colors.white,
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.brown,
          brightness: Brightness.dark,
        ),
        appBarTheme: AppBarThemeData(
          backgroundColor: Colors.brown.shade900,
          foregroundColor: Colors.white,
        ),
      ),

      home: const MainScreen(),
    );
  }
}

Widget stateProvider() {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => ThemeLogic()),
      ChangeNotifierProvider(create: (_) => GridstyleLogic()),
    ],
    child: const MyApp(),
  );
}
