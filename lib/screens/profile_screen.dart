import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:recommenda/models/user.dart';
import 'package:recommenda/screens/homepage_screen.dart';
import 'package:recommenda/utils/colors.dart';

import '../../main.dart';
import '../providers/user_provider.dart';

import 'package:recommenda/providers/user_provider.dart';

import '../resources/auth_methods.dart';
import '../resources/storage_methods.dart';
import '../utils/utils.dart';
import '../widgets/text_field_input.dart';
import 'login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  Uint8List? _image;
  bool _isImageInProfileImage = false;
  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();

    _bioController.dispose();
    _usernameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isKeyboard = MediaQuery.of(context).viewInsets.bottom != 0;
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
                  FirebaseAuth.instance.signOut();
                  goToLogin();
                },
                icon: Icon(Icons.logout_outlined))
          ],
        ),
      ),
      body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .snapshots(),
          builder: (_, snapshot) {
            // if (snapshot.hasError) return Text('Error = ${snapshot.error}');

            if (snapshot.hasData) {
              var output = snapshot.data!.data();
              _usernameController.text = output!['username'];
              _bioController.text = output['about'];

              return SafeArea(
                  child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Container(),
                      flex: 2,
                    ),
                    // svg image

                    // دائرة لاستقبال صورة البروفايل
                    if (!isKeyboard)
                      Stack(
                        children: [
                          _image != null
                              ? CircleAvatar(
                                  radius: 64,
                                  backgroundImage: MemoryImage(_image!))
                              : CircleAvatar(
                                  radius: 64,
                                  backgroundImage: output['imgUrl'] == null
                                      ? const NetworkImage(
                                          'https://i.stack.imgur.com/l60Hf.png')
                                      : NetworkImage(output['imgUrl']),
                                ),
                          Positioned(
                              bottom: -10,
                              left: 80,
                              child: IconButton(
                                onPressed: selectImage,
                                icon: const Icon(Icons.add_a_photo),
                              ))
                        ],
                      ),
                    const SizedBox(
                      height: 24,
                    ),
                    // text field input for username
                    TextFieldInput(
                        textEditingController: _usernameController,
                        hintText: 'Enter The username',
                        textInputType: TextInputType.text),
                    const SizedBox(
                      height: 24,
                    ),
                    // text field input for email

                    // button login
                    const SizedBox(height: 24),
                    // text field input for username
                    TextFieldInput(
                        textEditingController: _bioController,
                        hintText: 'tell others about you',
                        textInputType: TextInputType.text),
                    const SizedBox(
                      height: 24,
                    ),

                    const SizedBox(height: 12),
                    Flexible(
                      child: Container(),
                      flex: 2,
                    ),
                    InkWell(
                      onTap: () async {
                        try {
                          if (_usernameController.text.isNotEmpty ||
                              _bioController.text.isNotEmpty) {
                            if (_isImageInProfileImage) {
                              setState(() {
                                _isLoading = true;
                              });
                              String imgUrl = await StorageMethods()
                                  .uploadImageToFirebaseStorage(
                                      'profilePics', _image!, false);

                              // اضافة بيانات المستخدم للداتابيز

                              await FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(user.uid)
                                  .update({
                                "about": _bioController.text,
                                "username": _usernameController.text,
                                "imgUrl": imgUrl
                              });
                              setState(() {
                                _isLoading = false;
                              });
                            } else {
                              await FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(user.uid)
                                  .update({
                                "about": _bioController.text,
                                "username": _usernameController.text,
                                "imgUrl": output['imgUrl']
                              });
                            }

                            showSnackBar("Done!", context);
                          }
                        } catch (er) {
                          showSnackBar(er.toString(), context);
                        }
                      },
                      child: Container(
                        child: _isLoading
                            ? const Center(
                                child: CircularProgressIndicator(
                                  color: primaryColor,
                                ),
                              )
                            : const Text('Update'),
                        width: double.infinity,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: const ShapeDecoration(
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(4))),
                            color: blueColor),
                      ),
                    ),
                  ],
                ),
              ));
            } else {
              return Container();
            }
          }),
    );
  }

  void selectImage() async {
    Uint8List image = await pickImage(ImageSource.gallery);
    setState(() {
      _isImageInProfileImage = true;
      _image = image;
      print(_image);
    });
  }

  void goToLogin() {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginScreen()));
  }
}
