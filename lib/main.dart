import 'package:flutter/material.dart';
import 'package:flutter_social_media/pages/homePage.dart';
import 'package:flutter_social_media/pages/loginPage.dart';
import 'package:flutter_social_media/pages/registerPage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        initialRoute: 'home',
        routes: {
          'register': (context) => RegisterPage(),
          "login": (context) => LoginPage(),
          'home': (context) => Homepage(),
        },
      ),
    );
  }
}
