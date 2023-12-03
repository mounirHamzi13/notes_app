import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:notes_app_ui/mixins/signup_mixin.dart';
import 'package:notes_app_ui/screens/login_screen.dart';
import 'package:notes_app_ui/screens/testing_screen.dart';
import 'package:page_transition/page_transition.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});
  static String routeName = '/singup_screen';
  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> with SignupMixin {
  //Form key
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  //TextEditing Controller
  // final TextEditingController birthdayController = TextEditingController();
  // isObscure boolean to show password
  bool isObscure = true;
  // for confirmation field
  bool isObscureConfirmation = true;
  // boolean for animation on tapping the signup button
  late bool isLoading;

  //Controllers
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmationController = TextEditingController();

  @override
  void initState() {
    isLoading = false;
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    usernameController.dispose();
    confirmationController.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final heightSize = size.height;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Center(
          child: Container(
            // padding: EdgeInsets.symmetric(horizontal: 10),
            // height: MediaQuery.of(context).size.height * 0.56,
            // width: MediaQuery.of(context).size.width * 0.9,
            decoration: BoxDecoration(
              // color:
              //  const Color.fromRGBO(163, 254, 148, 1),
              border: Border.all(width: 3, color: Colors.black),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(bottom: 20),
                    child: Text(
                      "Sign Up",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 40,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Form(
                      key: formKey,
                      child: Column(
                        children: [
                          Column(
                            children: [
                              textField(
                                  emailController,
                                  'Email',
                                  TextInputType.emailAddress,
                                  Icons.email,
                                  emailValidator,
                                  heightSize),
                              textField(
                                  usernameController,
                                  'Username',
                                  null,
                                  Icons.account_circle_rounded,
                                  usernameValidator,
                                  heightSize),
                              passwordWidget(),
                              // passwordConfirmationWidget(),
                              signupButton(size),
                              hasAccountWidget()
                            ],
                          ),
                        ],
                      )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Row hasAccountWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Do you  Have an Account ?",
          style: TextStyle(color: Colors.black, fontSize: 16),
        ),
        TextButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              PageTransition(
                type: PageTransitionType.rightToLeft,
                child: const LoginScreen(),
                duration: const Duration(milliseconds: 500),
              ),
            );
          },
          child: const Text(
            'Log in',
            style: TextStyle(color: Colors.pink, fontSize: 16),
          ),
        )
      ],
    );
  }

  Widget signupButton(Size size) {
    return InkWell(
      onTap: () async {
        FocusScope.of(context).unfocus();
        if (formKey.currentState!.validate()) {
          try {
            final userWithEmail = await FirebaseFirestore.instance
                .collection('users')
                .where('email', isEqualTo: emailController.text.trim())
                .get();
            if (userWithEmail.docs.isNotEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Email already exists')));
            } else {
              UserCredential userCredential = await FirebaseAuth.instance
                  .createUserWithEmailAndPassword(
                      email: emailController.text.trim(),
                      password: passwordController.text.trim());
              await FirebaseFirestore.instance
                  .collection('users')
                  .doc(userCredential.user!.uid)
                  .set({
                'username': usernameController.text.trim(),
                'email': emailController.text.trim(),
                'categories': [],
                'notesIDs': [],
              });
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TestingScreen(),
                  ));
            }
          } catch (error) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(error.toString())));
          }
        }
      },
      child: Container(
        width: size.width,
        padding: const EdgeInsets.symmetric(horizontal: 95, vertical: 25),
        decoration: BoxDecoration(
            border: Border.all(width: 2, color: Colors.black),
            borderRadius: BorderRadius.circular(20),
            color: const Color.fromRGBO(207, 255, 71, 1)),
        child: const Center(
          child: Text(
            "Confirm",
            style: TextStyle(color: Colors.black),
          ),
        ),
      ),
    );
  }

  Padding passwordWidget() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
          controller: passwordController,
          obscureText: isObscure,
          decoration: InputDecoration(
              filled: true,
              fillColor: Colors.transparent,
              label: const Text("Password"),
              labelStyle: const TextStyle(color: Colors.black),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.0),
                borderSide: const BorderSide(color: Colors.black),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.0),
                borderSide: const BorderSide(color: Colors.black),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.0),
                borderSide: const BorderSide(color: Colors.black),
              ),
              prefixIcon: const Icon(Icons.lock),
              prefixIconColor: Colors.black,
              suffixIcon: IconButton(
                icon: Icon(
                  isObscure ? Icons.visibility : Icons.visibility_off,
                  color: Colors.black,
                ),
                onPressed: () {
                  setState(() {
                    isObscure = !isObscure;
                  });
                },
              )),
          cursorColor: Colors.black,
          keyboardType: TextInputType.visiblePassword,
          style: const TextStyle(color: Colors.black),
          validator: passwordValidator),
    );
  }

  Padding passwordConfirmationWidget() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
          controller: confirmationController,
          obscureText: isObscureConfirmation,
          decoration: InputDecoration(
              filled: true,
              fillColor: Colors.transparent,
              label: const Text("Confirmation"),
              labelStyle: const TextStyle(color: Colors.black),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.0),
                borderSide: const BorderSide(color: Colors.black),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.0),
                borderSide: const BorderSide(color: Colors.black),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.0),
                borderSide: const BorderSide(color: Colors.black),
              ),
              prefixIcon: const Icon(Icons.lock),
              prefixIconColor: Colors.black,
              suffixIcon: IconButton(
                icon: Icon(
                  isObscureConfirmation
                      ? Icons.visibility
                      : Icons.visibility_off,
                  color: Colors.black,
                ),
                onPressed: () {
                  setState(() {
                    isObscureConfirmation = !isObscureConfirmation;
                  });
                },
              )),
          cursorColor: Colors.black,
          keyboardType: TextInputType.visiblePassword,
          style: const TextStyle(color: Colors.black),
          validator: (value) => passwordConfirmationValidator(
              passwordController.text, confirmationController.text)),
    );
  }

  Widget textField(controller, String labelText, keyboardType,
      IconData leadingIcon, String? Function(String?)? validator, height) {
    return Container(
      // height: 70,
      // TODO: fix textfield Size
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
          textCapitalization: TextCapitalization.words,
          controller: controller,
          decoration: InputDecoration(
              filled: true,
              fillColor: Colors.transparent,
              label: Text(labelText),
              labelStyle: const TextStyle(color: Colors.black),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.0),
                borderSide: const BorderSide(color: Colors.black),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.0),
                borderSide: const BorderSide(color: Colors.black),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.0),
                borderSide: const BorderSide(color: Colors.black),
              ),
              prefixIcon: Icon(leadingIcon),
              prefixIconColor: Colors.black),
          cursorColor: Colors.black,
          keyboardType: keyboardType,
          style: const TextStyle(color: Colors.black),
          validator: validator),
    );
  }
}
