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

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  late String val;

  late bool isEmptyVal = true;

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
        title: Column(
          children: [
            TextField(
              onChanged: (value) {
                setState(() {
                  if (value.isNotEmpty) {
                    val = value;
                    isEmptyVal = false;
                    // print(val);
                  } else {
                    isEmptyVal = true;
                  }
                });
              },
              decoration: const InputDecoration(
                hintText: 'Your search term',
                contentPadding: EdgeInsets.all(8),
              ),
            ),
          ],
        ),
      ),
      body: isEmptyVal
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
                  .where('description',
                      isGreaterThanOrEqualTo: val.toLowerCase())
                  .where('description', isLessThan: val.toLowerCase() + 'z')
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
