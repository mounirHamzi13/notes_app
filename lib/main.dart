import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:notes_app_ui/providers/searchedValue.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:notes_app_ui/screens/login_screen.dart';
import 'package:notes_app_ui/screens/select_category_screen.dart';
import 'package:notes_app_ui/screens/signup_screen.dart';
import 'package:notes_app_ui/screens/testing_screen.dart';
import 'package:notes_app_ui/screens/write_notes_screen.dart';
import 'package:provider/provider.dart';
// import 'package:notes_app_ui/screens/testing_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyBFLJHKoNYEGHSv-NWO6YOXyZy1H-OELu0",
          appId: "1:775315872805:android:8d3add019eea0fa29433cc",
          messagingSenderId: "775315872805",
          projectId: "notes-app-flutter-44c3e"));
  // print("Firebase initialization successful.");
  // print("Firebase initialization failed: $e");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notes App',
      theme: ThemeData(
        textTheme: TextTheme(
          bodyMedium: GoogleFonts.poppins(fontSize: 17, color: Colors.black),
          bodyLarge: GoogleFonts.poppins(
            fontSize: 17,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
          headlineLarge: GoogleFonts.robotoCondensed(
            fontWeight: FontWeight.normal,
            color: Colors.black,
            fontSize: 60,
            letterSpacing: -1.5,
          ),
        ),
      ),
      home:
          // Scaffold(body: TestingScreen()) ,

          StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // return SignUpScreen(); 
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(body: Center(child: CircularProgressIndicator()));
          } else if (snapshot.hasData) {

            return TestingScreen();
          } else {
            return SignUpScreen();
          }
        },
      ),
      routes: {
        LoginScreen.routeName: (context) => const LoginScreen(),
        SignUpScreen.routeName: (context) => const SignUpScreen(),
        WriteNoteScreen.routeName: (context) => const WriteNoteScreen(),
        SelectCategoryScreen.routeName: (context) =>
            const SelectCategoryScreen(),
      },
    );
  }
}
