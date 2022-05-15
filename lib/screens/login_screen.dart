import 'package:flutter/material.dart';
import 'package:recommenda/screens/register_screen.dart';
 import 'package:recommenda/utils/colors.dart';
import 'package:recommenda/widgets/text_field_input.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../main.dart';
import '../resources/auth_methods.dart';
import '../utils/utils.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
            // صورة
            SvgPicture.asset('assets/logo.svg',
                color: primaryColor, height: 65, width: 65),
            const SizedBox(
              height: 64,
            ),
            // ايميل
            TextFieldInput(
                textEditingController: _emailController,
                hintText: 'Enter The Email',
                textInputType: TextInputType.emailAddress),
            const SizedBox(
              height: 24,
            ),
            // كلمة مرور
            TextFieldInput(
              textEditingController: _passwordController,
              hintText: 'Enter The Password',
              textInputType: TextInputType.text,
              isAPassword: true,
            ),
            // زر تسجيل دخول
            const SizedBox(height: 24),
            InkWell(
              onTap: loginMethod,
              child: Container(
                child: _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: primaryColor,
                        ),
                      )
                    : const Text('Log in'),
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
            // اذا لم تكن مسجل دخول
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
                  onTap: goToRegister,
                  child: Container(
                    child: const Text(
                      'Sign up!',
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

  void loginMethod() async {
    setState(() {
      _isLoading = true;
    });
    String result = await AuthMethods().login(
      email: _emailController.text,
      password: _passwordController.text,
    );

    if (result == 'success') {
     
       Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const MyApp()));

    
    } else {
      showSnackBar(result, context);
    }
    setState(() {
      _isLoading = false;
    });
  }

  void goToRegister() {
       Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const RegisterScreen()));
  }
  
}
