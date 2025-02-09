// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, unused_local_variable, unused_catch_clause, use_build_context_synchronously

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase1/component/button.dart';
import 'package:firebase1/component/logo.dart';
import 'package:firebase1/component/textField.dart';
import 'package:firebase1/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

// ignore: must_be_immutable
class Login extends StatefulWidget {
  Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController email = TextEditingController();

  TextEditingController password = TextEditingController();

  GlobalKey<FormState> formState = GlobalKey<FormState>();

  Future signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    await FirebaseAuth.instance.signInWithCredential(credential);
    //Navigator.of(context).pushNamedAndRemoveUntil('HomePage', (route) => false);
  }

  void showErrorSnackbar(BuildContext context, String errorMessage) {
    final snackBar = SnackBar(
      content: Text(errorMessage),
      backgroundColor: Colors.red, // Error color
      action: SnackBarAction(
        label: 'Dismiss',
        textColor: Colors.white,
        onPressed: () {
          // Code to execute when dismiss is pressed (optional)
        },
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:isLoading == true? Center(child: CircularProgressIndicator(),) : Container(
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
                    "Login",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    "Login to continue using the app",
                    style: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 15,
                        fontWeight: FontWeight.w400),
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
                      }),
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
                      }),
                  InkWell(
                    onTap: () async {
                      if (email.text.isEmpty) {
                        AwesomeDialog(
                          context: context,
                          dialogType: DialogType.error,
                          animType: AnimType.rightSlide,
                          title: 'Error',
                          desc: 'Please enter your email',
                        ).show();
                        return;
                      }

                      try {
                        await FirebaseAuth.instance
                            .sendPasswordResetEmail(email: email.text.trim());
                        AwesomeDialog(
                          context: context,
                          dialogType: DialogType.success,
                          animType: AnimType.rightSlide,
                          title: 'Done',
                          desc:
                              'If this email is registered, a password reset link has been sent to your inbox.',
                        ).show();
                      } catch (e) {
                        showErrorSnackbar(context, 'An error occurred: $e');
                      }
                    },
                    child: Container(
                      margin: EdgeInsets.only(top: 10, bottom: 20),
                      alignment: Alignment.topRight,
                      child: Text(
                        "Forget Password?",
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w400),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            button(
              title: "Login",
              onPressed: () async {
                if (formState.currentState!.validate()) {
                  try {
                    isLoading = true;
                    setState(() {
                      
                    });
                    final credential =
                        await FirebaseAuth.instance.signInWithEmailAndPassword(
                      email: email.text.trim(),
                      password: password.text.trim(),
                    );
                    isLoading = false;
                    setState(() {
                      
                    });
                    FirebaseAuth.instance.currentUser!.sendEmailVerification();
                    if (credential.user!.emailVerified) {
                      Navigator.of(context).pushReplacementNamed("HomePage");
                    } else {
                      AwesomeDialog(
                        context: context,
                        dialogType: DialogType.info,
                        animType: AnimType.rightSlide,
                        title: 'Error',
                        desc: 'Please go to your mail and verified your email',
                      ).show();
                    }
                  } on FirebaseAuthException catch (e) {
                    isLoading = false;
                    setState(() {
                      
                    });
                    AwesomeDialog(
                      context: context,
                      dialogType: DialogType.error,
                      animType: AnimType.rightSlide,
                      title: 'Error',
                      desc: 'Email or Paaword is incorrect.',
                    ).show();
                  } catch (e) {
                    print('Unexpected error: $e');
                  }
                }
              },
            ),
            SizedBox(
              height: 20,
            ),
            MaterialButton(
              height: 40,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              color: const Color.fromARGB(255, 118, 77, 15),
              onPressed: () {
                signInWithGoogle();
              },
              child: Text(
                "Login using google",
                style: TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Dont Have an Account? "),
                InkWell(
                  onTap: () {
                    Navigator.of(context).pushReplacementNamed("Signup");
                  },
                  child: const Text(
                    "Register",
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
