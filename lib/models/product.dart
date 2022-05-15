import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:recommenda/models/user.dart';

class Product {
  final String username;
  final String uid;
  final String description;
  final String price;
  final String productid;
  final   dateCreated;
  final String productURL;
  final String creatorPersonalImage;
  final ranks;

  Product(
      { 
        required this.username,
     required this.uid,
      required this.description,
      required this.price,
      required this.productid,
      required this.dateCreated,
      required this.productURL,
      required this.creatorPersonalImage,
      required this.ranks});

  Map<String, dynamic> fromMapToObject() {
    return {
      'username': username,
      'uid': uid,
      'description': description,
      'price': price,
      'productid': productid,
      'dateCreated': dateCreated,
      'productURL': productURL,
      'creatorPersonalImage': creatorPersonalImage,
      'ranks': ranks,
    };
  }

  static Product fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return Product(
      username: snapshot['username'],
      uid: snapshot['uid'],
      description: snapshot['description'],
      price: snapshot['price'],
      productid: snapshot['productid'],
      dateCreated: snapshot['dateCreated'],
      productURL: snapshot['productURL'],
      creatorPersonalImage: snapshot['creatorPersonalImage'],
      ranks: snapshot['ranks'],
    );
  }
}
