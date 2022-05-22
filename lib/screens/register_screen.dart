import 'dart:ffi';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:recommenda/resources/auth_methods.dart';
import 'package:recommenda/screens/login_screen.dart';
import 'package:recommenda/screens/main_screen.dart';
import 'package:recommenda/utils/colors.dart';
import 'package:recommenda/utils/utils.dart';
import 'package:recommenda/widgets/text_field_input.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';

import '../../main.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  Uint8List? _image;
  bool _isLoading = false;
  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _bioController.dispose();
    _usernameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isKeyboard = MediaQuery.of(context).viewInsets.bottom != 0;
    return Scaffold(
      body: SafeArea(
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

            if (!isKeyboard)
              SvgPicture.asset('assets/logo.svg',
                  color: primaryColor, height: 65, width: 65),

            if (!isKeyboard)
              const SizedBox(
                height: 64,
              ),
            // دائرة لاستقبال صورة البروفايل
            if (!isKeyboard)
              Stack(
                children: [
                  _image != null
                      ? CircleAvatar(
                          radius: 64, backgroundImage: MemoryImage(_image!))
                      : const CircleAvatar(
                          radius: 64,
                          backgroundImage: NetworkImage(
                              'https://i.stack.imgur.com/l60Hf.png'),
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
            TextFieldInput(
                textEditingController: _emailController,
                hintText: 'Enter The Email',
                textInputType: TextInputType.emailAddress),
            const SizedBox(
              height: 24,
            ),
            // text field input for password
            TextFieldInput(
              textEditingController: _passwordController,
              hintText: 'Enter The Password',
              textInputType: TextInputType.text,
              isAPassword: true,
            ),
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
            InkWell(
              onTap: regMethod,
              child: Container(
                child: _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: primaryColor,
                        ),
                      )
                    : const Text('Register'),
                width: double.infinity,
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: const ShapeDecoration(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4))),
                    color: blueColor),
              ),
            ),
            const SizedBox(height: 12),
            Flexible(
              child: Container(),
              flex: 2,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  child: const Text(
                    'or  ',
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                ),
                GestureDetector(
                  onTap: goToLogin,
                  child: Container(
                    child: const Text(
                      'Login!',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                  ),
                )
              ],
            )
          ],
        ),
      )),
    );
  }

  void regMethod() async {
    setState(() {
      _isLoading = true;
    });

    String result = await AuthMethods().register(
        email: _emailController.text,
        password: _passwordController.text,
        username: _usernameController.text,
        about: _bioController.text,
        isAdmin: true,
        file: _image!);
    setState(() {
      _isLoading = false;
    });

    if (result != 'success') {
      showSnackBar(result, context);
    } else {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) =>  MyApp()));
    }
  }

  void selectImage() async {
    Uint8List image = await pickImage(ImageSource.gallery);
    setState(() {
      _image = image;
    });
  }

  void goToLogin() {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginScreen()));
  }
}
