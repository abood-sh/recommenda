import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:recommenda/models/product.dart';
import 'package:recommenda/models/productToList.dart';
import 'package:uuid/uuid.dart';

class StorageMethods {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // إضافة صورة بروفايل للداتابيز

  Future<String> uploadImageToFirebaseStorage(
      String childName, Uint8List file, bool isAproductImage) async {
    Reference ref =
        _storage.ref().child(childName).child(_auth.currentUser!.uid);
    if (isAproductImage) {
      String id = const Uuid().v1();
      ref = ref.child(id);
    }
    UploadTask uploadTask = ref.putData(file);

    TaskSnapshot snap = await uploadTask;
    String downloadUrl = await snap.ref.getDownloadURL();
    return downloadUrl;
  }

  // send a new product to db
  Future<String> sendProductData(
    String productDescription,
    String price,
    Uint8List file,
    String userId,
    String creatorUsername,
    String creatorPersonalImage,
  ) async {
    String res = "There are some errors";

    try {
      String imageURL =
          await uploadImageToFirebaseStorage('products', file, true);

      String productId = const Uuid().v1();
      Product product = Product(
          username: creatorUsername,
          uid: userId,
          description: productDescription.toLowerCase(),
          price: price,
          productid: productId,
          dateCreated: DateTime.now(),
          productURL: imageURL,
          creatorPersonalImage: creatorPersonalImage,
          ranks: []);
      _firestore
          .collection('products')
          .doc(productId)
          .set(product.fromMapToObject());
      res = "success";
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  // send a new product to db
  Future<String> sendProductDataToComparisonList(
      {required String productDescription,
      required String price,
      required String imageUrl,
      required String userId,
      required String productId,
      required String creatorUsername,
      required String creatorPersonalImageUrl,
      required List ranks,
      required String userListId}) async {
    String res = "There are some errors";

    try {
      ProductToList product = ProductToList(
        username: creatorUsername,
        uid: userId,
        description: productDescription,
        price: price,
        productid: productId,
        productURL: imageUrl,
        creatorPersonalImage: creatorPersonalImageUrl,
        ranks: ranks,
      );

      var oneList = await _firestore
          .collection('productsComparisonList')
          .doc(userListId)
          .get();

      if (!oneList.exists) {
        await _firestore
            .collection('productsComparisonList')
            .doc(userListId)
            .set({
          'productsComparisonList': [product.fromMapToObject()]
        });
        res = "success";
      } else {
        var theArray = oneList.data()!['productsComparisonList'][0];
        var theArrayLength = oneList.data()!['productsComparisonList'].length;
        if (theArrayLength == 1) {
          if (theArray['productid'] == productId) {
            // print(theArray['productid']);
            res = 'You have added this before';
          } else {
            await _firestore
                .collection('productsComparisonList')
                .doc(userListId)
                .update({
              'productsComparisonList':
                  FieldValue.arrayUnion([product.fromMapToObject()])
            });

            res = "success";
          }
        } else {
          res = "List is full";
        }
  

      }
    } catch (e) {
      res = e.toString();
    }
    return res;
  }
}
