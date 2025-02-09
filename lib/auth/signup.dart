// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, unused_local_variable, use_build_context_synchronously

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase1/component/button.dart';
import 'package:firebase1/component/logo.dart';
import 'package:firebase1/component/textField.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class SignUp extends StatelessWidget {
  SignUp({super.key});

  GlobalKey<FormState> formState = GlobalKey<FormState>();
  TextEditingController email = TextEditingController();
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(20),
        child: ListView(
          children: [
            Form(
              key: formState,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 50,
                  ),
                  Logo(),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "SignUp",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    "SignUp to continue using the app",
                    style: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 15,
                        fontWeight: FontWeight.w400),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Username",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 17),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  CustomField(
                    hintText: "Enter Your Username",
                    mycontroller: username,
                    validator: (val) {
                        if (val == "") {
                          return "Can't be Empty";
                        }
                        return null;
                      }
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Email",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 17),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  CustomField(
                    hintText: "Enter Your Email",
                    mycontroller: email,
                    validator: (val) {
                        if (val == "") {
                          return "Can't be Empty";
                        }
                        return null;
                      }
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Password",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 17),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  CustomField(
                    hintText: "Enter Your Password",
                    mycontroller: password,
                    validator: (val) {
                        if (val == "") {
                          return "Can't be Empty";
                        }
                        return null;
                      }
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10, bottom: 20),
                    alignment: Alignment.topRight,
                    child: Text(
                      "Forget Password?",
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                    ),
                  ),
                ],
              ),
            ),
            button(
              title: "SignUp",
              onPressed: () async {
                if (formState.currentState!.validate()) {
                  try {
                    final credential = await FirebaseAuth.instance
                        .createUserWithEmailAndPassword(
                      email: email.text.trim(),
                      password: password.text.trim(),
                    );
                    Navigator.of(context).pushReplacementNamed("Login");
                  } on FirebaseAuthException catch (e) {
                    if (e.code == 'weak-password') {
                      AwesomeDialog(
                        context: context,
                        dialogType: DialogType.warning,
                        animType: AnimType.rightSlide,
                        title: 'Warning',
                        desc: 'The password provided is too weak.',
                      ).show();
                    } else if (e.code == 'email-already-in-use') {
                      AwesomeDialog(
                        context: context,
                        dialogType: DialogType.error,
                        animType: AnimType.rightSlide,
                        title: 'Error',
                        desc: 'The account already exists for that email.',
                      ).show();
                    } else {
                      AwesomeDialog(
                        context: context,
                        dialogType: DialogType.error,
                        animType: AnimType.rightSlide,
                        title: 'Error',
                        desc:
                            'The credentials provided are invalid or malformed.',
                      ).show();
                    }
                  } catch (e) {
                    print('Unexpected error: $e');
                  }
                }
              },
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Have an Account? "),
                InkWell(
                  onTap: () {
                    Navigator.of(context).pushNamed("Login");
                  },
                  child: const Text(
                    "Login",
                    style: TextStyle(color: Colors.orange),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
