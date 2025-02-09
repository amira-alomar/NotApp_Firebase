// ignore_for_file: prefer_const_constructors

import 'package:firebase1/Categories/add.dart';
import 'package:firebase1/auth/login.dart';
import 'package:firebase1/auth/signup.dart';
import 'package:firebase1/home.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyBxyrH11HsgD9gVaRTWweke9YL7lkGLkjo",
      authDomain: "fir-1-b5afe.firebaseapp.com",
      projectId: "fir-1-b5afe",
      storageBucket: "fir-1-b5afe.appspot.com",
      messagingSenderId: "210994824183",
      appId: "1:210994824183:web:e60529868f1a4c2fd264f2",
      measurementId: "G-PXY6CRBZDQ",
    ),
  );

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        print('User is signed in!');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.grey[50],
          titleTextStyle: TextStyle(color: Colors.orange, fontSize: 17,fontWeight: FontWeight.bold),
          iconTheme: IconThemeData(color: Colors.orange),
        )
      ),
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      home: ( FirebaseAuth.instance.currentUser != null && FirebaseAuth.instance.currentUser!.emailVerified)? const HomePage() :  Login(),
      routes: {
        "Signup": (context) => SignUp(),
        "Login": (context) => Login(),
        "HomePage": (context) => const HomePage(),
        "addCategory": (context) => AddCategory(),
      },
    );
  }
}
