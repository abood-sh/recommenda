import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:recommenda/models/user.dart' as userModel;
import 'package:recommenda/resources/storage_methods.dart';

// كلاس به مجموعة من الميثودس لادارة تسجيل وتسجيل دخول
class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<userModel.User> getUserDetails() async {
    User currentUser = _auth.currentUser!;

    DocumentSnapshot userFromDb =
        await _firestore.collection('users').doc(currentUser.uid).get();
    // print(userFromDb.data());
    return userModel.User.fromSnap(userFromDb);
  }

  // مستخدم جديد
  Future<String> register(
      {required String email,
      required String password,
      required String username,
      required String about,
      required bool isAdmin,
      required Uint8List file}) async {
    String result = "Error!!!";
    try {
      if (email.isNotEmpty ||
          password.isNotEmpty ||
          about.isNotEmpty ||
          password.isNotEmpty ||
          file != null) {
        UserCredential credential = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);

        String imgUrl = await StorageMethods()
            .uploadImageToFirebaseStorage('profilePics', file, false);

        // اضافة بيانات المستخدم للداتابيز

        userModel.User user = userModel.User(
            username: username,
            email: email,
            uid: credential.user!.uid,
            about: about,
            imgUrl: imgUrl,
            isAdmin: isAdmin);

        await _firestore
            .collection('users')
            .doc(credential.user!.uid)
            .set(user.fromMapToObject());

        result = "success";
      }
    } catch (er) {
      result = er.toString();
    }

    return result;
  }

  // مستخدم تحديث بيانات
  Future<String> update(
      {required String userid,
      required String username,
      required String about,
      required Uint8List file}) async {
    String result = "Error!!!";
    try {
      if (username.isNotEmpty || about.isNotEmpty || file != null) {
        String imgUrl = await StorageMethods()
            .uploadImageToFirebaseStorage('profilePics', file, false);

        // اضافة بيانات المستخدم للداتابيز

      await  _firestore.collection('users').doc(userid).update({

        "about":about,
        "username":username
      });
     
        

        result = "success";
      }
    } catch (er) {
      result = er.toString();
    }

    return result;
  }

  // تسجيل دخول

  Future<String> login(
      {required String email, required String password}) async {
    String result = "Error";
    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        result = "success";
      } else {
        result = "fill all fields";
      }
    } catch (e) {
      result = e.toString();
    }
    return result;
  }
}
