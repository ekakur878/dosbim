import 'package:dosbim/pages/homepage.dart';
import 'package:dosbim/pages/loginpage.dart';
import 'package:flutter/material.dart';
import 'package:dosbim/pages/SplashScreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dosbim App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/',
      routes: {
        '/': (context) => Splashscreen(),
        '/login': (context) => LoginPage(),
        '/home': (context) => Homepage(),
      },
    );
  }
}
