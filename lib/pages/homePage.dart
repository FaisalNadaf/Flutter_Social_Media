import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_social_media/pages/feedPage.dart';
import 'package:flutter_social_media/pages/profilePage.dart';
import 'package:flutter_social_media/services/firebase_dervices.dart';
import 'package:get_it/get_it.dart';

class Homepage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _homePageState();
  }
}

late double deviceHeight, deviceWidth;
int currentPage = 0;

List<Widget> pages = [
  FeedPage(),
  ProfilePage(),
];

FireBaseService? _fireBaseService;

class _homePageState extends State<Homepage> {
  @override
  @override
  void initState() {
    super.initState();
    _fireBaseService = GetIt.instance.get<FireBaseService>();
  }

  Widget build(BuildContext context) {
    deviceHeight = MediaQuery.of(context).size.height;
    deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.redAccent,
        elevation: 4.0, // Adds slight shadow
        toolbarHeight: deviceHeight * 0.1,
        title: const Text(
          'Social Media',
          style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 1.2, // Slight letter spacing for better appearance
          ),
        ),
        // centerTitle: true, // Centers the title
        actions: [
          // Upload Image Button
          Padding(
            padding: EdgeInsets.only(right: deviceWidth * 0.03),
            child: InkWell(
              onTap: _uploadImage,
              borderRadius:
                  BorderRadius.circular(50), // Adds ripple effect to round area
              child: const Icon(
                Icons.add_a_photo,
                color: Colors.white,
                size: 28.0,
              ),
            ),
          ),

          // Logout Button with Confirmation
          Padding(
            padding: EdgeInsets.only(right: deviceWidth * 0.03),
            child: InkWell(
              onTap: () async {
                bool? confirmLogout = await showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Logout Confirmation'),
                    content: const Text('Are you sure you want to logout?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        child: const Text('Logout'),
                      ),
                    ],
                  ),
                );

                if (confirmLogout == true) {
                  _fireBaseService!.LogOut();
                  Navigator.popAndPushNamed(context, 'login');
                }
              },
              borderRadius: BorderRadius.circular(50),
              child: const Icon(
                Icons.logout,
                color: Colors.white,
                size: 28.0,
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _navigationBar(),
      body: pages[currentPage],
    );
  }

  Widget _navigationBar() {
    return BottomNavigationBar(
      onTap: (_index) {
        setState(() {
          currentPage = _index;
        });
      },
      currentIndex: currentPage,
      items: [
        BottomNavigationBarItem(
          label: 'Feed',
          icon: Icon(
            Icons.feed,
          ),
        ),
        BottomNavigationBarItem(
          label: 'Profile',
          icon: Icon(
            Icons.account_box,
          ),
        ),
      ],
    );
  }

  void _uploadImage() async {
    FilePickerResult? _result =
        await FilePicker.platform.pickFiles(type: FileType.image);
    File _image = File(_result!.files.first.path!);
    await _fireBaseService!.uploadImage(image: _image);
  }
}
