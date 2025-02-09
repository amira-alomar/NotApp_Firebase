// ignore_for_file: use_build_context_synchronously, prefer_const_constructors

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase1/Categories/edit.dart';
import 'package:firebase1/home.dart';
import 'package:firebase1/note/add.dart';
import 'package:firebase1/note/edit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ViewNote extends StatefulWidget {
  const ViewNote({super.key, required this.categoryId});

  final String categoryId;
  @override
  State<ViewNote> createState() => _ViewNoteState();
}

class _ViewNoteState extends State<ViewNote> {
  bool isLoadeing = true;

  List<QueryDocumentSnapshot> data = [];
  getData() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('categories')
        .doc(widget.categoryId)
        .collection("note")
        .get();
    data.addAll(querySnapshot.docs);
    isLoadeing = false;
    setState(() {});
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.orange,
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (contex) => AddNote(docId: widget.categoryId)));
          },
          child: Icon(Icons.add),
        ),
        appBar: AppBar(
          title: Text(
            "ViewNote",
            style: Theme.of(context).appBarTheme.titleTextStyle,
          ),
          actions: [
            IconButton(
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil("Login", (route) => false);
                },
                icon: const Icon(Icons.exit_to_app)),
          ],
        ),
        body: PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, result) {
            if (didPop) return;
            Navigator.of(context)
                .pushNamedAndRemoveUntil("HomePage", (route) => false);
          },
          child: isLoadeing == true
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : GridView.builder(
                  itemCount: data.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, mainAxisExtent: 160),
                  itemBuilder: (context, i) {
                    return InkWell(
                      onLongPress: () {
                        AwesomeDialog(
                          context: context,
                          dialogType: DialogType.question,
                          animType: AnimType.rightSlide,
                          title: 'Delete',
                          desc: 'Are you sure?',
                          btnCancelOnPress: (){},
                          btnOkOnPress: () async {
                            await FirebaseFirestore.instance
                                .collection('categories')
                                .doc(widget.categoryId)
                                .collection("note")
                                .doc(data[i].id)
                                .delete();
                            Navigator.of(context)
                                .push(MaterialPageRoute(builder: (context)=> ViewNote(categoryId: widget.categoryId)));
                          },
                        ).show();
                      },
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (Context) => EditNote(
                                noteDocId: data[i].id,
                                CategoryDocId: widget.categoryId,
                                value: data[i]["note"])));
                      },
                      child: Card(
                        child: Container(
                          padding: EdgeInsets.all(23),
                          child: Column(
                            children: [
                              Text((data[i]['note'])),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
        ));
  }
}
