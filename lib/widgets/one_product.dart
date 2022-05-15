import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:recommenda/models/user.dart';
import 'package:recommenda/providers/user_provider.dart';
import 'package:recommenda/resources/storage_methods.dart';
import 'package:recommenda/utils/colors.dart';
import 'package:recommenda/utils/utils.dart';
import '../resources/firestore_methods.dart';

class OneProduct extends StatefulWidget {
  final oneProduct;
  const OneProduct({Key? key, required this.oneProduct}) : super(key: key);

  @override
  State<OneProduct> createState() => _OneProductState();
}

class _OneProductState extends State<OneProduct> {
  var yourrank = 0;

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).getUser;
    return Container(
      color: androidBackGroundColor,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16)
                .copyWith(right: 0),
            child: Row(children: [
              CircleAvatar(
                radius: 16,
                backgroundImage:
                    NetworkImage(widget.oneProduct['creatorPersonalImage']),
              ),
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.oneProduct['username'],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(DateFormat.yMMMd()
                        .format(widget.oneProduct['dateCreated'].toDate())),
                    StreamBuilderToDisplayOtherRatings(widget: widget)
                  ],
                ),
              )),
              widget.oneProduct['uid'] == user.uid
                  ? IconButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) => Dialog(
                                  child: ListView(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16),
                                    shrinkWrap: true,
                                    children: [
                                      'delete',
                                      'Add this product to a comparison list'
                                    ]
                                        .map(
                                          (e) => InkWell(
                                            onTap: () async {
                                              if (e == 'delete') {
                                                FireStoreMethods()
                                                    .removeAProduct(
                                                        widget.oneProduct[
                                                            'productid']);
                                                Navigator.of(context).pop();
                                              } else {
                                                var res = await StorageMethods()
                                                    .sendProductDataToComparisonList(
                                                        productDescription: widget
                                                                .oneProduct[
                                                            'description'],
                                                        price: widget.oneProduct[
                                                            'price'],
                                                        imageUrl: widget.oneProduct[
                                                            'productURL'],
                                                        userId: widget
                                                            .oneProduct['uid'],
                                                        productId: widget.oneProduct[
                                                            'productid'],
                                                        creatorUsername:
                                                            widget.oneProduct[
                                                                'username'],
                                                        creatorPersonalImageUrl:
                                                            widget.oneProduct[
                                                                'creatorPersonalImage'],
                                                        ranks: widget
                                                            .oneProduct['ranks'],
                                                        userListId: user.uid);

                                                Navigator.of(context).pop();
                                                showSnackBar(
                                                    res.toString(), context);
                                              }
                                            },
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 12,
                                                      horizontal: 16),
                                              child: Text(e),
                                            ),
                                          ),
                                        )
                                        .toList(),
                                  ),
                                ));
                      },
                      icon: const Icon(Icons.more_vert))
                  : IconButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) => Dialog(
                                  child: ListView(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16),
                                    shrinkWrap: true,
                                    children: [
                                      'Add this product to a comparison list'
                                    ]
                                        .map(
                                          (e) => InkWell(
                                            onTap: () async {
                                              var res = await StorageMethods()
                                                  .sendProductDataToComparisonList(
                                                      productDescription:
                                                          widget
                                                                  .oneProduct[
                                                              'description'],
                                                      price: widget
                                                          .oneProduct['price'],
                                                      imageUrl: widget.oneProduct[
                                                          'productURL'],
                                                      userId: widget
                                                          .oneProduct['uid'],
                                                      productId:
                                                          widget.oneProduct[
                                                              'productid'],
                                                      creatorUsername:
                                                          widget.oneProduct[
                                                              'username'],
                                                      creatorPersonalImageUrl:
                                                          widget.oneProduct[
                                                              'creatorPersonalImage'],
                                                      ranks: widget
                                                          .oneProduct['ranks'],
                                                      userListId: user.uid);

                                              Navigator.of(context).pop();
                                              showSnackBar(
                                                  res.toString(), context);
                                            },
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 12,
                                                      horizontal: 16),
                                              child: Text(e),
                                            ),
                                          ),
                                        )
                                        .toList(),
                                  ),
                                ));
                      },
                      icon: const Icon(Icons.more_vert))
            ]),
            // product
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.35,
            width: double.infinity,
            child: Image.network(
              widget.oneProduct['productURL'],
              fit: BoxFit.cover,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                  child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        'Price: ' + widget.oneProduct['price'] + '\$',
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      )))
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Expanded(
                  child: Align(
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        ' Your rating: ',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ))),
              IconButton(
                  onPressed: () async {
                    await FireStoreMethods().rateAProduct(
                        widget.oneProduct['productid'],
                        user.uid,
                        widget.oneProduct['ranks'], [
                      {"uid": user.uid, "rateValue": 1}
                    ]);
                  },
                  icon: OneStarAfterYourRating(
                    widget: widget,
                    user: user,
                    star: 0,
                  )),
              IconButton(
                  onPressed: () async {
                    await FireStoreMethods().rateAProduct(
                        widget.oneProduct['productid'],
                        user.uid,
                        widget.oneProduct['ranks'], [
                      {"uid": user.uid, "rateValue": 2}
                    ]);
                  },
                  icon: OneStarAfterYourRating(
                    widget: widget,
                    user: user,
                    star: 1,
                  )),
              IconButton(
                  onPressed: () async {
                    await FireStoreMethods().rateAProduct(
                        widget.oneProduct['productid'],
                        user.uid,
                        widget.oneProduct['ranks'], [
                      {"uid": user.uid, "rateValue": 3}
                    ]);
                  },
                  icon: OneStarAfterYourRating(
                    widget: widget,
                    user: user,
                    star: 2,
                  )),
              IconButton(
                  onPressed: () async {
                    await FireStoreMethods().rateAProduct(
                        widget.oneProduct['productid'],
                        user.uid,
                        widget.oneProduct['ranks'], [
                      {"uid": user.uid, "rateValue": 4}
                    ]);
                  },
                  icon: OneStarAfterYourRating(
                    widget: widget,
                    user: user,
                    star: 3,
                  )),
              IconButton(
                  onPressed: () async {
                    await FireStoreMethods().rateAProduct(
                        widget.oneProduct['productid'],
                        user.uid,
                        widget.oneProduct['ranks'], [
                      {"uid": user.uid, "rateValue": 5}
                    ]);
                  },
                  icon: OneStarAfterYourRating(
                    widget: widget,
                    user: user,
                    star: 4,
                  )),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DefaultTextStyle(
                  style: const TextStyle(),
                  child: Text(
                    widget.oneProduct['description'].toString().toUpperCase(),
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          //

          //
        ],
      ),
    );
  }
}

class OneStarAfterYourRating extends StatelessWidget {
  const OneStarAfterYourRating({
    Key? key,
    required this.widget,
    required this.user,
    required this.star,
  }) : super(key: key);

  final OneProduct widget;
  final User user;
  final int star;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
          .collection('products')
          .doc(widget.oneProduct['productid'])
          .snapshots(),
      builder: (_, snapshot) {
        if (snapshot.hasError) return Text('Error = ${snapshot.error}');

        if (snapshot.hasData) {
          var output = snapshot.data!.data();
          var value = output!['ranks'];
          dynamic yourRate = 0;
          for (var i = 0; i < value.length; i++) {
            if (value[i]['uid'] == user.uid) {
              yourRate = value[i]['rateValue'];
              break;
            }
          }

          return yourRate > star
              ? const Icon(
                  Icons.star,
                )
              : const Icon(
                  Icons.star_border,
                );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}

// Extracts
class StreamBuilderToDisplayOtherRatings extends StatelessWidget {
  const StreamBuilderToDisplayOtherRatings({
    Key? key,
    required this.widget,
  }) : super(key: key);

  final OneProduct widget;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
          .collection('products')
          .doc(widget.oneProduct['productid'])
          .snapshots(),
      builder: (_, snapshot) {
        if (snapshot.hasError) return Text('Error = ${snapshot.error}');

        if (snapshot.hasData) {
          var output = snapshot.data!.data();
          // var value = output!['ranks'][0]['rateValue'];
          var value = output!['ranks'];
          dynamic sum = 0;
          for (var i = 0; i < value.length; i++) {
            sum = sum + value[i]['rateValue'];
          }

          var length = value.length == 0 ? 1 : value.length;

          var avg = (sum / length).ceil();

          FirebaseFirestore.instance
              .collection('products')
              .doc(widget.oneProduct['productid'])
              .update(
                {
                  
  "totalRatings": avg
                }
              );

          switch (avg) {
            case 0:
              return const OtherRatings(
                val1: Icons.star_border_outlined,
                val2: Icons.star_border_outlined,
                val3: Icons.star_border_outlined,
                val4: Icons.star_border_outlined,
                val5: Icons.star_border_outlined,
              );
            case 1:
              return const OtherRatings(
                val1: Icons.star,
                val2: Icons.star_border_outlined,
                val3: Icons.star_border_outlined,
                val4: Icons.star_border_outlined,
                val5: Icons.star_border_outlined,
              );
            case 2:
              return const OtherRatings(
                val1: Icons.star,
                val2: Icons.star,
                val3: Icons.star_border_outlined,
                val4: Icons.star_border_outlined,
                val5: Icons.star_border_outlined,
              );
            case 3:
              return const OtherRatings(
                val1: Icons.star,
                val2: Icons.star,
                val3: Icons.star,
                val4: Icons.star_border_outlined,
                val5: Icons.star_border_outlined,
              );
            case 4:
              return const OtherRatings(
                val1: Icons.star,
                val2: Icons.star,
                val3: Icons.star,
                val4: Icons.star,
                val5: Icons.star_border_outlined,
              );
            case 5:
              return const OtherRatings(
                val1: Icons.star,
                val2: Icons.star,
                val3: Icons.star,
                val4: Icons.star,
                val5: Icons.star,
              );

            default:
          }
        }

        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}

class OtherRatings extends StatelessWidget {
  final IconData val1;
  final IconData val2;
  final IconData val3;
  final IconData val4;
  final IconData val5;

  const OtherRatings({
    required this.val1,
    required this.val2,
    required this.val3,
    required this.val4,
    required this.val5,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      const Expanded(
        child: Align(
          alignment: Alignment.bottomLeft,
          child: Text(
            ' Others rating: ',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      Icon(val1),
      Icon(val2),
      Icon(val3),
      Icon(val4),
      Icon(val5),
    ]);
  }
}
