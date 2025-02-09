import 'package:firebase1/component/button.dart';
import 'package:firebase1/component/textField.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddCategory extends StatefulWidget {
  const AddCategory({super.key});

  @override
  State<AddCategory> createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategory> {
  GlobalKey<FormState> formState = GlobalKey<FormState>();

  TextEditingController name = TextEditingController();

  bool isLoading = false;

  CollectionReference categories =
      FirebaseFirestore.instance.collection('categories');
  Future<void> addCategory() async {
    if (formState.currentState!.validate()) {
      try {
        isLoading = true;
        setState(() {});
        DocumentReference response = await categories.add({
          'name': name.text,
          'id': FirebaseAuth.instance.currentUser!.uid,
        });
        isLoading = false;
        Navigator.of(context)
            .pushNamedAndRemoveUntil("HomePage", (route) => false);
      } catch (e) {
        isLoading = false;
        setState(() {
          
        });
        print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Category"),
      ),
      body: isLoading? Center(child: CircularProgressIndicator(),) : Form(
          key: formState,
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 25),
                child: CustomField(
                    hintText: "Enter Name",
                    mycontroller: name,
                    validator: (val) {
                      if (val == "") {
                        return "Can't be Empty";
                      }
                      return null;
                    }),
              ),
              button(
                  title: "Add",
                  onPressed: () {
                    addCategory();
                  }),
            ],
          )),
    );
  }
}
