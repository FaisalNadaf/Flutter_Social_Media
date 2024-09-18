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
        backgroundColor: Colors.red,
        toolbarHeight: deviceHeight * 0.1,
        title: const Text(
          'social-media',
        ),
        actions: [
          GestureDetector(
            onTap: _uploadImage,
            child: const Icon(
              Icons.add_a_photo,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: deviceWidth * 0.03,
            ),
          ),
          GestureDetector(
            onTap: () {},
            child: const Icon(
              Icons.logout,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: deviceWidth * 0.03,
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
