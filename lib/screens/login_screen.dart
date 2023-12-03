import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:notes_app_ui/mixins/login_mixin.dart';
import 'package:notes_app_ui/screens/signup_screen.dart';
import 'package:page_transition/page_transition.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  static String routeName = '/login_screen';
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with LoginMixin {
  //Form key
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  // isObscure boolean to show password
  bool isObscure = true;
  // boolean for animation on tapping the signup button
  late bool isLoading;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    isLoading = false;
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
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
            // height: MediaQuery.of(context).size.height * 0.5,
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
                    padding: EdgeInsets.only(bottom: 40),
                    child: Text(
                      "Log In",
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
                              textField(),
                              passwordWidget(),
                              loginButton(context, size),
                              doesntHaveAccountWidget(),
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

  Row doesntHaveAccountWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Dont't have an account ? ",
          style: TextStyle(color: Colors.black, fontSize: 16),
        ),
        TextButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              PageTransition(
                type: PageTransitionType.leftToRight,
                child: const SignUpScreen(),
                duration: const Duration(milliseconds: 500),
              ),
            );
          },
          child: const Text(
            'Sign Up',
            style: TextStyle(color: Colors.pink, fontSize: 16),
          ),
        )
      ],
    );
  }

  Widget loginButton(BuildContext context, Size size) {
    return InkWell(
      onTap: () async {
        FocusScope.of(context).unfocus();
        if (formKey.currentState!.validate()) {
          try {
            UserCredential userCredential = await FirebaseAuth.instance
                .signInWithEmailAndPassword(
                    email: emailController.text,
                    password: passwordController.text);
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
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

  Widget textField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
          controller: emailController,
          // controller: _textEditingController,
          decoration: InputDecoration(
              filled: true,
              fillColor: Colors.transparent,
              label: const Text('Email'),
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
              prefixIcon: const Icon(Icons.email),
              prefixIconColor: Colors.black),
          cursorColor: Colors.black,
          keyboardType: TextInputType.emailAddress,
          style: const TextStyle(color: Colors.black),
          validator: emailValidator),
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
              label: const Text("Mot de passe"),
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
}
