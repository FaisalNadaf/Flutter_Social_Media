import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _registerPage();
  }
}

final GlobalKey<FormState> _registerFormKey = GlobalKey<FormState>();
String? _email;
String? _password;
String? _name;

late double deviceHeight, deviceWidth;

class _registerPage extends State<RegisterPage> {
  @override
  Widget build(BuildContext context) {
    deviceHeight = MediaQuery.of(context).size.height;
    deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: deviceWidth * 0.1),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              _titleText(),
              _registerFormField(),
              _registerBtn(),
              _registerPageLink(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _registerFormField() {
    return Container(
      height: deviceHeight * 0.3,
      child: Form(
          key: _registerFormKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _namwField(),
              _emailText(),
              _passwordField(),
            ],
          )),
    );
  }

  Widget _namwField() {
    return TextFormField(
      decoration: const InputDecoration(hintText: "name..."),
      onSaved: (_value) {
        setState(() {
          _name = _value;
        });
      },
      validator: (_value) => _value!.isNotEmpty ? null : "enter name",
    );
  }

  Widget _emailText() {
    return TextFormField(
      decoration: const InputDecoration(hintText: "email..."),
      onSaved: (_value) {
        setState(() {
          _email = _value;
        });
      },
      validator: (_value) {
        bool result = _value!.contains(
          RegExp(
              r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"),
        );
        return result ? null : "please enter valid email ";
      },
    );
  }

  Widget _passwordField() {
    return TextFormField(
      decoration: const InputDecoration(hintText: "password..."),
      onSaved: (_value) {
        setState(() {
          _password = _value;
        });
      },
      validator: (_value) => _value!.length > 6 ? null : "to short! ",
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

  Widget _registerBtn() {
    return MaterialButton(
      color: Colors.red,
      onPressed: _registerUser,
      child: const Text(
        'register',
        style: TextStyle(
          color: Colors.white,
          fontSize: 20,
        ),
      ),
    );
  }

  Widget _registerPageLink() {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, 'login'),
      child: const Text(
        'already have an account?',
        style: TextStyle(
          color: Colors.blue,
        ),
      ),
    );
  }

  void _registerUser() {
    if (_registerFormKey.currentState!.validate()) {
      _registerFormKey.currentState!.save();
    }
  }
}
