import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String username;
  final String email;
  final String uid;
  final String about;
  final String imgUrl;
  final bool isAdmin;
 

  User(
      {required this.username,
      required this.email,
      required this.uid,
      required this.about,
      required this.imgUrl,
      required this.isAdmin,
      });

  Map<String, dynamic> fromMapToObject() {
    return {
      'username': username,
      'uid': uid,
      'email': email,
      'about': about,
      'imgUrl': imgUrl,
      'isAdmin': isAdmin
    };
  }

  static User fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return User(
        username: snapshot['username'],
        email: snapshot['email'],
        uid: snapshot['uid'],
        about: snapshot['about'],
        imgUrl: snapshot['imgUrl'],
        isAdmin: snapshot['isAdmin']
        );
  }
}
