import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:recommenda/utils/colors.dart';
import 'package:recommenda/widgets/one_product.dart';
import 'package:flutter/material.dart';
import 'package:recommenda/screens/register_screen.dart';
import 'package:recommenda/utils/colors.dart';
import 'package:recommenda/widgets/text_field_input.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../main.dart';
import '../resources/auth_methods.dart';
import '../utils/utils.dart';

class SearchStarScreen extends StatefulWidget {
  const SearchStarScreen({Key? key}) : super(key: key);

  @override
  State<SearchStarScreen> createState() => _SearchStarScreenState();
}

class _SearchStarScreenState extends State<SearchStarScreen> {
  final TextEditingController _searchController = TextEditingController();

 
 
  bool star1 = false;
  bool star2 = false;
  bool star3 = false;
  bool star4 = false;
  bool star5 = false;
  late int starNum = 0;

  @override
  void dispose() {
    super.dispose();
    _searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: androidBackGroundColor,
        centerTitle: false,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
           
            Text(
              'Find By: ',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            IconButton(
                onPressed: () async {
                  setState(() {
                    if (star1) {
                      starNum = 0;
                      star1 = false;
                      star2 = false;
                      star3 = false;
                      star4 = false;
                      star5 = false;
                    } else {
                      starNum = 1;

                      star1 = true;
                      star2 = false;
                      star3 = false;
                      star4 = false;
                      star5 = false;
                    }
                  });
                },
                // await FireStoreMethods().rateAProduct(
                //     widget.oneProduct['productid'],
                //     user.uid,
                //     widget.oneProduct['ranks'], [
                //   {"uid": user.uid, "rateValue": 5}
                // ]);
                icon: star1 ? Icon(Icons.star) : Icon(Icons.star_border)),
            IconButton(
                onPressed: () async {
                  setState(() {
                    starNum = 2;

                    star1 = true;
                    star2 = true;
                    star3 = false;
                    star4 = false;
                    star5 = false;
                  });
                },
                icon: star2 ? Icon(Icons.star) : Icon(Icons.star_border)),
            IconButton(
                onPressed: () async {
                  setState(() {
                    starNum = 3;

                    star1 = true;
                    star2 = true;
                    star3 = true;
                    star4 = false;
                    star5 = false;
                  });
                },
                icon: star3 ? Icon(Icons.star) : Icon(Icons.star_border)),
            IconButton(
                onPressed: () async {
                  setState(() {
                    starNum = 4;

                    star1 = true;
                    star2 = true;
                    star3 = true;
                    star4 = true;
                    star5 = false;
                  });
                },
                icon: star4 ? Icon(Icons.star) : Icon(Icons.star_border)),
            IconButton(
                onPressed: () async {
                  setState(() {
                    starNum = 5;
                    star1 = true;
                    star2 = true;
                    star3 = true;
                    star4 = true;
                    star5 = true;
                  });
                },
                icon: star5 ? Icon(Icons.star) : Icon(Icons.star_border)),
          ],
        ),
      ),
      body: starNum==0
          ? StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('products')
                  .orderBy('dateCreated', descending: true)
                  .snapshots(),
              builder: (context,
                  AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) => OneProduct(
                        oneProduct: snapshot.data!.docs[index].data()));
              })
          : StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('products')             
                  .where('totalRatings', isEqualTo: starNum)
                  .snapshots(),
              builder: (context,
                  AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

     
                return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) => OneProduct(
                        oneProduct: snapshot.data!.docs[index].data()));
              }),
    );
  }
}
