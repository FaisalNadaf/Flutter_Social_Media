import 'package:flutter/material.dart';
import 'package:flutter_social_media/pages/feedPage.dart';
import 'package:flutter_social_media/pages/profilePage.dart';

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

class _homePageState extends State<Homepage> {
  @override
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
            onTap: () {},
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
}
