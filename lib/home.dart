// ignore_for_file: use_build_context_synchronously, prefer_const_constructors

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase1/Categories/edit.dart';
import 'package:firebase1/note/view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoadeing = true;

  List<QueryDocumentSnapshot> data = [];
  getData() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('categories')
        .where("id", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
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
          Navigator.of(context).pushNamed("addCategory");
        },
        child: Icon(Icons.add),
      ),
      appBar: AppBar(
        title: Text(
          "HomePage",
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
      body: isLoadeing == true
          ? Center(
              child: CircularProgressIndicator(),
            )
          : GridView.builder(
              itemCount: data.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, mainAxisExtent: 160),
              itemBuilder: (context, i) {
                return InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => ViewNote(categoryId: data[i].id)));
                  },
                  onLongPress: () {
                    AwesomeDialog(
                      context: context,
                      dialogType: DialogType.question,
                      animType: AnimType.rightSlide,
                      title: 'Delete',
                      desc: 'What do you need?',
                      btnOkText: "Edit",
                      btnOkOnPress: () async {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => EditCategory(
                                docId: data[i].id, oldName: data[i]["name"])));
                      },
                      btnCancelText: "Delete",
                      btnCancelOnPress: () async {
                        await FirebaseFirestore.instance
                            .collection('categories')
                            .doc(data[i].id)
                            .delete();
                        Navigator.of(context).pushReplacementNamed("HomePage");
                      },
                    ).show();
                  },
                  child: Card(
                    child: Container(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Image.asset(
                            "assets/image/logo1.png",
                            height: 100,
                          ),
                          Text((data[i]['name'])),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
