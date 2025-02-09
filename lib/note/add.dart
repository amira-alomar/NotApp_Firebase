import 'package:firebase1/component/button.dart';
import 'package:firebase1/component/textField.dart';
import 'package:firebase1/note/view.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddNote extends StatefulWidget {
  const AddNote({super.key, required this.docId});
  final String docId;
  @override
  State<AddNote> createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  TextEditingController note = TextEditingController();
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  bool isLoading = false;

  Future<void> AddNote() async {
    CollectionReference notes = FirebaseFirestore.instance
        .collection('categories')
        .doc(widget.docId)
        .collection("note");
    if (formState.currentState!.validate()) {
      try {
        isLoading = true;
        setState(() {});
        DocumentReference response = await notes.add({
          'note': note.text,
        });
        isLoading = false;
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context)=> ViewNote(categoryId: widget.docId)));
      } catch (e) {
        isLoading = false;
        setState(() {});
        print(e);
      }
    }
  }

  @override
  void dispose() {
    note.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Note"),
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
                        hintText: "Enter note",
                        mycontroller: note,
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
                        AddNote();
                      }),
                ],
              )),
    );
  }
}
