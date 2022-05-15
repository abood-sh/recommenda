import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:recommenda/models/product.dart';
import 'package:uuid/uuid.dart';

class FireStoreMethods {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> rateAProduct(
      String productId, String uid, List ratings, List newList) async {
    try {
      for (var i = 0; i < ratings.length; i++) {
        if (ratings[i]["uid"] == uid) {
          await _firestore.collection('products').doc(productId).update({
            'ranks': FieldValue.arrayRemove([ratings[i]])
          });
        }
      }
      await _firestore
          .collection('products')
          .doc(productId)
          .update({'ranks': FieldValue.arrayUnion(newList)});
    } catch (e) {
      print(e.toString());
    }
  }

// remove a product
  Future<void> removeAProduct(String productId) async {
    try {
      await _firestore.collection('products').doc(productId).delete();
    } catch (e) {
      print(e.toString());
    }
  }
}
