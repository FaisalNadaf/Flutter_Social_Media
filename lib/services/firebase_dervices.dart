import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as p;

final String User_Collection = 'users';
final String Posts_Collection = 'pasts';

class FireBaseService {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseStorage _storage = FirebaseStorage.instance;
  FirebaseFirestore _db = FirebaseFirestore.instance;
  FireBaseService();

  Map? currentUser;

  Future<bool> registerUser({
    required String name,
    required String email,
    required String password,
    required File image,
  }) async {
    try {
      UserCredential _userInfo = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      String _userId = _userInfo.user!.uid;
      String _fileName = Timestamp.now().millisecondsSinceEpoch.toString() +
          p.extension(image.path);
      print(_fileName);
      UploadTask _task =
          _storage.ref('images/$_userId/$_fileName').putFile(image);
      return _task.then((_snapShot) async {
        String _downloadUrl = await _snapShot.ref.getDownloadURL();
        await _db.collection(User_Collection).doc(_userId).set({
          "name": name,
          "email": email,
          "image": _downloadUrl,
        });
        return true;
      });
    } catch (e) {
      print("error in firebase services register user  $e");
      return false;
    }
  }

  // Future<bool> registerUser({
  //   required String name,
  //   required String email,
  //   required String password,
  //   required File image,
  // }) async {
  //   try {
  //     // Create a new user with email and password
  //     UserCredential userInfo = await _auth.createUserWithEmailAndPassword(
  //       email: email,
  //       password: password,
  //     );
  //     String _userId = userInfo.user!.uid;

  //     // Generate a file name for the image
  //     String fileName =
  //         "${Timestamp.now().microsecondsSinceEpoch}${p.extension(image.path)}";

  //     // Upload the image to Firebase Storage
  //     UploadTask uploadTask =
  //         _storage.ref('images/$_userId/$fileName').putFile(image);
  //     TaskSnapshot snapshot = await uploadTask;

  //     // Get the download URL for the uploaded image
  //     String downloadUrl = await snapshot.ref.getDownloadURL();

  //     // Save the user's data in Firestore
  //     await _db.collection(User_Collection).doc(_userId).set({
  //       "name": name,
  //       "email": email,
  //       "image": downloadUrl,
  //     });

  //     return true;
  //   } catch (e) {
  //     // Log the error message
  //     print("Error in Firebase registerUser: $e");
  //     return false;
  //   }
  // }

  Future<bool> LoginUser({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential _userInfo = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (_userInfo != null) {
        currentUser = await getUserData(uid: _userInfo.user!.uid);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print("error in firebase services login user  $e");
      return false;
    }
  }

  Future<Map> getUserData({required String uid}) async {
    DocumentSnapshot _doc =
        await _db.collection(User_Collection).doc(uid).get();
    return _doc.data() as Map;
  }

  Future<void> getUser() async {
    String _userId = _auth.currentUser!.uid;
    DocumentSnapshot _doc =
        await _db.collection(User_Collection).doc(_userId).get();
    Map data = _doc.data() as Map;
    print(data['name']);
    return data['name'];
  }

  Future<bool> uploadImage({
    required File image,
  }) async {
    try {
      String _userId = _auth.currentUser!.uid;
      String _fileName = Timestamp.now().millisecondsSinceEpoch.toString() +
          p.extension(image.path);
      print(_fileName);
      UploadTask _task =
          _storage.ref('images/$_userId/$_fileName').putFile(image);
      return _task.then((_snapShot) async {
        String _downloadUrl = await _snapShot.ref.getDownloadURL();
        await _db.collection(Posts_Collection).add({
          'UserId': _userId,
          'date': Timestamp.now(),
          "image": _downloadUrl,
        });
        return true;
      });
    } catch (e) {
      print("error in firebase services register user  $e");
      return false;
    }
  }

  Stream<QuerySnapshot> getUserPosts() {
    String _userId = _auth.currentUser!.uid;

    return _db
        .collection(Posts_Collection)
        .where('UserId', isEqualTo: _userId)
        .snapshots();
  }

  Stream<QuerySnapshot> getLatestPosts() {
    return _db
        .collection(Posts_Collection)
        .orderBy('date', descending: true)
        .snapshots();
  }

  Future<void> LogOut() async {
    return await _auth.signOut();
  }
}
