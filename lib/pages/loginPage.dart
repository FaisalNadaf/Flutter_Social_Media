import 'package:flutter/material.dart';
import 'package:flutter_social_media/services/firebase_dervices.dart';
import 'package:get_it/get_it.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _loginPage();
  }
}

final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();

String? _email;
String? _password;
late double deviceHeight, deviceWidth;

FireBaseService? _fireBaseService;

class _loginPage extends State<LoginPage> {
  @override
  void initState() {
    super.initState();
    _fireBaseService = GetIt.instance.get<FireBaseService>();
  }

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
              _loginFormField(),
              _loginBtn(),
              _registerPageLink(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _loginFormField() {
    return Container(
      height: deviceHeight * 0.2,
      child: Form(
          key: _loginFormKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _emailText(),
              _passwordField(),
            ],
          )),
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
      validator: (_value) => _value!.length == 0
          ? "enter password"
          : _value.length >= 6
              ? null
              : "to short! ",
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

  Widget _loginBtn() {
    return MaterialButton(
      color: Colors.red,
      onPressed: _loginUser,
      child: const Text(
        'Login',
        style: TextStyle(
          color: Colors.white,
          fontSize: 20,
        ),
      ),
    );
  }

  Widget _registerPageLink() {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, 'register'),
      child: const Text(
        'dont have an account?',
        style: TextStyle(
          color: Colors.blue,
        ),
      ),
    );
  }

  void _loginUser() async {
    if (_loginFormKey.currentState!.validate()) {
      _loginFormKey.currentState!.save();
      bool _result = await _fireBaseService!
          .LoginUser(email: _email!, password: _password!);
      if (_result) Navigator.popAndPushNamed(context, 'home');
    }
  }
}
