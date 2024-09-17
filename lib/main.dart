import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_social_media/pages/homePage.dart';
import 'package:flutter_social_media/pages/loginPage.dart';
import 'package:flutter_social_media/pages/registerPage.dart';
import 'package:flutter_social_media/services/firebase_dervices.dart';
import 'package:get_it/get_it.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  GetIt.instance.registerSingleton<FireBaseService>(
    FireBaseService(),
  );
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
        initialRoute: 'login',
        routes: {
          'register': (context) => RegisterPage(),
          "login": (context) => LoginPage(),
          'home': (context) => Homepage(),
        },
      ),
    );
  }
}
