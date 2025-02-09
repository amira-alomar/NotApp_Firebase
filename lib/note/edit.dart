import 'package:firebase1/component/button.dart';
import 'package:firebase1/component/textField.dart';
import 'package:firebase1/note/view.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditNote extends StatefulWidget {
  const EditNote(
      {super.key,
      required this.noteDocId,
      required this.CategoryDocId,
      required this.value});
  final String noteDocId;
  final String value;

  final String CategoryDocId;
  @override
  State<EditNote> createState() => _EditNoteState();
}

class _EditNoteState extends State<EditNote> {
  TextEditingController note = TextEditingController();
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  bool isLoading = false;

  Future<void> EditNote() async {
    CollectionReference notes = FirebaseFirestore.instance
        .collection('categories')
        .doc(widget.CategoryDocId)
        .collection("note");
    if (formState.currentState!.validate()) {
      try {
        isLoading = true;
        setState(() {});
        await notes.doc(widget.noteDocId).update({
          'note': note.text,
        });
        isLoading = false;
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ViewNote(categoryId: widget.CategoryDocId)));
      } catch (e) {
        isLoading = false;
        setState(() {});
        print(e);
      }
    }
  }

  @override
  void initState() {
    note.text = widget.value;
    super.initState();
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
        title: const Text("Edit Note"),
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
                        EditNote();
                      }),
                ],
              )),
    );
  }
}
