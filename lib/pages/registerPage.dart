import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_social_media/services/firebase_dervices.dart';
import 'package:get_it/get_it.dart';

class RegisterPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _RegisterPageState();
}

final GlobalKey<FormState> _registerFormKey = GlobalKey<FormState>();
String? _email;
String? _password;
String? _name;
File? _image;
late double deviceHeight, deviceWidth;

FireBaseService? _fireBaseService;

class _RegisterPageState extends State<RegisterPage> {
  @override
  void initState() {
    super.initState();
    _fireBaseService = GetIt.instance.get<FireBaseService>();
  }

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
              _imageField(),
              _registerFormField(),
              _registerBtn(),
              // _loginPageLink(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _imageField() {
    return GestureDetector(
      onTap: () async {
        FilePickerResult? result =
            await FilePicker.platform.pickFiles(type: FileType.image);
        if (result != null && result.files.isNotEmpty) {
          setState(() {
            _image = File(result.files.first.path!);
          });
        }
      },
      child: Container(
        height: deviceHeight * 0.16,
        width: deviceWidth * 0.325,
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: _image != null
                ? FileImage(_image!)
                : const NetworkImage("https://avatar.iran.liara.run/public/boy")
                    as ImageProvider,
          ),
        ),
      ),
    );
  }

  Widget _registerFormField() {
    return Container(
      height: deviceHeight * 0.22,
      child: Form(
        key: _registerFormKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _nameField(),
            _emailText(),
            _passwordField(),
          ],
        ),
      ),
    );
  }

  Widget _nameField() {
    return TextFormField(
      decoration: const InputDecoration(hintText: "name..."),
      onSaved: (_value) => _name = _value?.trim(),
      validator: (_value) =>
          (_value?.trim().isNotEmpty ?? false) ? null : "Enter name",
    );
  }

  Widget _emailText() {
    return TextFormField(
      decoration: const InputDecoration(hintText: "email..."),
      onSaved: (_value) => _email = _value?.trim(),
      validator: (_value) {
        final emailRegex = RegExp(
            r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$");
        return emailRegex.hasMatch(_value ?? '')
            ? null
            : "Please enter a valid email";
      },
    );
  }

  Widget _passwordField() {
    return TextFormField(
      decoration: const InputDecoration(hintText: "password..."),
      onSaved: (_value) => _password = _value,
      validator: (_value) {
        if ((_value ?? '').isEmpty) return "Enter password";
        return (_value!.length >= 6) ? null : "Password too short";
      },
      obscureText: true,
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

  // Widget _registerBtn() {
  //   return MaterialButton(
  //     color: Colors.red,
  //     onPressed: _registerUser,
  //     child: const Text(
  //       'Register',
  //       style: TextStyle(
  //         color: Colors.white,
  //         fontSize: 20,
  //       ),
  //     ),
  //   );
  // }

  // void _registerUser() async {
  //   if (_registerFormKey.currentState!.validate() && _image != null) {
  //     _registerFormKey.currentState!.save();
  //     bool _result = await _fireBaseService!.RegisterUser(
  //       name: _name!,
  //       email: _email!,
  //       password: _password!,
  //       image: _image!,
  //     );
  //     print('Registered');
  //     // ignore: use_build_context_synchronously
  //     if (_result) Navigator.pop(context);
  //   }
  // }

  bool _isLoading = false; // Add a loading state variable

Widget _registerBtn() {
  return MaterialButton(
    color: Colors.red,
    onPressed: _isLoading ? null : _registerUser, // Disable if loading
    child: _isLoading 
        ? CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          )
        : const Text(
            'Register',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
  );
}

void _registerUser() async {
  if (_registerFormKey.currentState!.validate() && _image != null) {
    setState(() {
      _isLoading = true; // Show loading spinner
    });

    _registerFormKey.currentState!.save();

    try {
      bool _result = await _fireBaseService!.registerUser(
        name: _name!,
        email: _email!,
        password: _password!,
        image: _image!,
      );

      if (_result) {
        if (!mounted) return; // Ensure the widget is still in the tree
        Navigator.pop(context); // Navigate back after successful registration
      } else {
        // Handle failure
        _showErrorDialog("Registration failed. Please try again.");
      }
    } catch (e) {
      _showErrorDialog("An error occurred: $e");
    } finally {
      setState(() {
        _isLoading = false; // Hide loading spinner
      });
    }
  } else if (_image == null) {
    _showErrorDialog("Please upload a profile image.");
  }
}

void _showErrorDialog(String message) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text("Error"),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("OK"),
        ),
      ],
    ),
  );
}


  Widget _loginPageLink() {
    return GestureDetector(
      onTap: () => Navigator.popAndPushNamed(context, 'login'),
      child: const Text(
        'Already have an account?',
        style: TextStyle(
          color: Colors.blue,
        ),
      ),
    );
  }
}
