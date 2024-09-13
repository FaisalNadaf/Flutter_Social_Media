import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _loginPage();
  }
}

class _loginPage extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              _titleText(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _titleText() {
    return const Text(
      'social-media',
      style: TextStyle(
        color: Colors.black,
        fontSize: 35,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}
