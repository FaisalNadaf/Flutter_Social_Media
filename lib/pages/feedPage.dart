import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_social_media/services/firebase_dervices.dart';
import 'package:get_it/get_it.dart';

class FeedPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _FeedPageState();
  }
}

class _FeedPageState extends State<FeedPage> {
  double? _deviceHeight, _deviceWidth;
  FireBaseService? _firebaseService;

  @override
  void initState() {
    super.initState();
    _firebaseService = GetIt.instance.get<FireBaseService>();
  }

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    return Container(
      height: _deviceHeight!,
      width: _deviceWidth!,
      child: _postsListView(),
    );
  }
//
  // Widget _postsListView() {
  //   return StreamBuilder<QuerySnapshot>(
  //     stream: _firebaseService!.getLatestPosts(),
  //     builder: (BuildContext _context, AsyncSnapshot _snapshot) {
  //       if (_snapshot.hasData) {
  //         List _posts = _snapshot.data!.docs.map((e) => e.data()).toList();
  //         return ListView.builder(
  //           itemCount: _posts.length,
  //           itemBuilder: (BuildContext context, int index) {
  //             Map _post = _posts[index];
  //             return Container(
  //               height: _deviceHeight! * 0.30,
  //               margin: EdgeInsets.symmetric(
  //                 vertical: _deviceHeight! * 0.01,
  //                 horizontal: _deviceWidth! * 0.05,
  //               ),
  //               decoration: BoxDecoration(
  //                 image: DecorationImage(
  //                   fit: BoxFit.cover,
  //                   image: NetworkImage(
  //                     _post["image"],
  //                   ),
  //                 ),
  //               ),
  //             );
  //           },
  //         );
  //       } else {
  //         return const Center(
  //           child: CircularProgressIndicator(),
  //         );
  //       }
  //     },
  //   );
  // }

  Widget _postsListView() {
    return StreamBuilder<QuerySnapshot>(
      stream: _firebaseService!.getLatestPosts(),
      builder: (BuildContext _context, AsyncSnapshot _snapshot) {
        if (_snapshot.hasData) {
          List _posts = _snapshot.data!.docs.map((e) => e.data()).toList();
          return ListView.builder(
            itemCount: _posts.length,
            itemBuilder: (BuildContext context, int index) {
              Map _post = _posts[index];
              return Container(
                margin: EdgeInsets.symmetric(
                  vertical: _deviceHeight! * 0.01,
                  horizontal: _deviceWidth! * 0.05,
                ),
                padding: EdgeInsets.all(6.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 3,
                      blurRadius: 7,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Post Image
                    Container(
                      height: _deviceHeight! * 0.3,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(_post["image"]),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
