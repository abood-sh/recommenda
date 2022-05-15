import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:recommenda/models/user.dart';
import 'package:recommenda/utils/colors.dart';

import '../providers/user_provider.dart';

import 'package:recommenda/providers/user_provider.dart';

class ComparisonScreen extends StatelessWidget {
  const ComparisonScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).getUser;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: androidBackGroundColor,
        centerTitle: false,
        title: Row(
          children: [
            SvgPicture.asset(
              'assets/logo.svg',
              color: primaryColor,
            ),
            IconButton(
                onPressed: () async {
                  FirebaseFirestore.instance
                      .collection('productsComparisonList')
                      .doc(user.uid)
                      .delete();
                },
                icon: Icon(Icons.delete))
          ],
        ),
      ),
      body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance
              .collection('productsComparisonList')
              .doc(user.uid)
              .snapshots(),
          builder: (_, snapshot) {
            // if (snapshot.hasError) return Text('Error = ${snapshot.error}');

            if (snapshot.data!.exists) {
              var output = snapshot.data!.data();
              var value = output!['productsComparisonList'];

// start calculate rating
              // value[0]['ranks'];
              if (value.length != 0) {
                var getRatingForComparisonOne =
                    getRatingForComparison(value[0]['ranks']);
                var getRatingForComparisonTwo =
                    getRatingForComparison(value[1]['ranks']);
// end rating

                return ListView(
                  children: [
                    Row(
                      children: [
                        Column(
                          children: [
                            Row(
                              children: [
                                Text(
                                  ' Product 1: ' +
                                      value[0]['description']
                                          .toString()
                                          .toUpperCase(),
                                  style: const TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  '    Price: ' + value[0]['price'].toString(),
                                  style: const TextStyle(
                                    fontSize: 22,
                                  ),
                                ),
                              ],
                            ),
                            Image(
                              image: NetworkImage(value[0]['productURL']),
                              height: 300,
                              width: 350,
                            ),
                            Text(
                              'Ratings: ' +
                                  getRatingForComparisonOne.toString(),
                              style: const TextStyle(
                                  fontSize: 22, fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ],
                    ),
                    const Text(
                        '---------------------------------------------------------------------------------------------------'),
                    const SizedBox(
                      height: 50,
                    ),
                    Row(
                      children: [
                        Column(
                          children: [
                            Row(
                              children: [
                                Text(
                                  ' Product 2: ' +
                                      value[1]['description']
                                          .toString()
                                          .toUpperCase(),
                                  style: const TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  '    Price: ' + value[1]['price'].toString(),
                                  style: TextStyle(fontSize: 22),
                                ),
                              ],
                            ),
                            Image(
                              image: NetworkImage(value[1]['productURL']),
                              height: 300,
                              width: 350,
                            ),
                            Text(
                              'Ratings: ' +
                                  getRatingForComparisonTwo.toString(),
                              style: const TextStyle(
                                  fontSize: 22, fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ],
                    ),
                  ],
                );
              } else {
                return Container();
              }
            } else {
              return const Center(
                  child: Text(
                'Your list is empty',
                style: TextStyle(fontWeight: FontWeight.bold),
              ));
            }
          }),
    );
  }

  int getRatingForComparison(value) {
    dynamic sum = 0;
    for (var i = 0; i < value.length; i++) {
      sum = sum + value[i]['rateValue'];
    }

    var length = value.length == 0 ? 1 : value.length;

    var avg = (sum / length).ceil();
    return avg;
  }
}
