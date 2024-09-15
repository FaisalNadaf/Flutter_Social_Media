import 'dart:io';

import 'package:file_picker/file_picker.dart';
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
File? _image;
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
              _imagefield(),
              _registerFormField(),
              _registerBtn(),
              // _loginPageLink(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _imagefield() {
    var _img = _image != null
        ? FileImage(_image!)
        : const NetworkImage(
            "https://avatar.iran.liara.run/public/boy",
          );
    return GestureDetector(
      onTap: () {
        FilePicker.platform.pickFiles(type: FileType.image).then((_result) {
          print(_result);
          setState(() {
            _image = File(_result!.files.first.path!);
          });
        });
      },
      child: Container(
        height: deviceHeight * 0.2,
        width: deviceWidth * 0.41,
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: _img as ImageProvider,
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
      validator: (_value) => _value!.length == 0
          ? "enter password"
          : _value.length > 6
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

  Widget _loginPageLink() {
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
    if (_registerFormKey.currentState!.validate() && _image != null) {
      _registerFormKey.currentState!.save();
    }
  }
}
