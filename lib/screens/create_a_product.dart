import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:recommenda/models/user.dart';
import 'package:recommenda/providers/user_provider.dart';
import 'package:recommenda/resources/storage_methods.dart';
import 'package:recommenda/utils/colors.dart';
import 'package:recommenda/utils/utils.dart';

class CreateAProduct extends StatefulWidget {
  const CreateAProduct({Key? key}) : super(key: key);

  @override
  State<CreateAProduct> createState() => _CreateAProductState();
}

class _CreateAProductState extends State<CreateAProduct> {
  Uint8List? _file;
  final TextEditingController _productDescriptionController =
      TextEditingController();
  final TextEditingController _productPriceController = TextEditingController();

  bool _isLoading = false;
  void navigteToAddNewProduct() {
    setState(() {
      _file = null;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _productDescriptionController.dispose();
    _productPriceController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).getUser;

    return _file == null
        ? Center(
            child: IconButton(
              icon: const Icon(Icons.upload_file),
              onPressed: () => _selectImage(context),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: androidBackGroundColor,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: navigteToAddNewProduct,
              ),
              title: const Text('A New Product Details'),
              actions: [
                TextButton(
                    onPressed: () =>
                        sendProductData(user.uid, user.username, user.imgUrl),
                    child: const Text(
                      'Add',
                      style: TextStyle(
                          color: Color.fromARGB(255, 131, 27, 44),
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ))
              ],
            ),
            body: Column(children: [
              _isLoading ? const LinearProgressIndicator() : Container(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * .5,
                    child: TextField(
                      controller: _productDescriptionController,
                      decoration: const InputDecoration(
                          hintText: 'Product description',
                          border: InputBorder.none),
                      maxLines: 8,
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * .2,
                    child: TextField(
                        controller: _productPriceController,
                        decoration: const InputDecoration(
                            hintText: 'Price', border: InputBorder.none),
                        maxLines: 1,
                        keyboardType: TextInputType.number),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: SizedBox(
                      height: 150,
                      width: 100,
                      child: AspectRatio(
                        aspectRatio: 487 / 451,
                        child: Container(
                            decoration: BoxDecoration(
                                image: DecorationImage(
                          image: MemoryImage(_file!),
                          fit: BoxFit.fill,
                        ))),
                      ),
                    ),
                  ),
                  const Divider(),
                ],
              )
            ]),
          );
  }

  _selectImage(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: const Text('Add a Product'),
            children: [
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Select an image'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List file = await pickImage(ImageSource.gallery);
                  setState(() {
                    _file = file;
                  });
                },
              ),
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  void sendProductData(
      String creatorId, String username, userPersonalImage) async {
    setState(() {
      _isLoading = true;
    });
    try {
      String res = await StorageMethods().sendProductData(
        _productDescriptionController.text,
        _productPriceController.text,
        _file!,
        creatorId,
        username,
        userPersonalImage,
      );
      if (res == "success") {
        setState(() {
          _isLoading = false;
        });
        showSnackBar('Created Successfuly', context);
        navigteToAddNewProduct();
      } else {
        setState(() {
          _isLoading = false;
        });
        showSnackBar(res, context);
      }
    } catch (e) {
      showSnackBar(e.toString(), context);
    }
  }
}
