import 'package:firebase1/component/button.dart';
import 'package:firebase1/component/textField.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditCategory extends StatefulWidget {
  final String docId;
  final String oldName;
  const EditCategory({super.key, required this.docId, required this.oldName});

  @override
  State<EditCategory> createState() => _EditCategoryState();
}

class _EditCategoryState extends State<EditCategory> {
  GlobalKey<FormState> formState = GlobalKey<FormState>();

  TextEditingController name = TextEditingController();

  bool isLoading = false;

  CollectionReference categories =
      FirebaseFirestore.instance.collection('categories');
  Future<void> EditCategory() async {
    if (formState.currentState!.validate()) {
      try {
        isLoading = true;
        setState(() {});
        await categories.doc(widget.docId).update({
          "name": name.text,
        });
        isLoading = false;
        Navigator.of(context)
            .pushNamedAndRemoveUntil("HomePage", (route) => false);
      } catch (e) {
        isLoading = false;
        setState(() {});
        print(e);
      }
    }
  }

  @override
  void initState() {
    name.text = widget.oldName;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Category"),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Form(
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
                      title: "Save",
                      onPressed: () {
                        EditCategory();
                      }),
                ],
              )),
    );
  }
}
