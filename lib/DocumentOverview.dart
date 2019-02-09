import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:markdown/Editor.dart';
import 'package:markdown/LoggedInUser.dart';

class DocumentOverview extends StatelessWidget {
  void newDocument(BuildContext context) async {
    DocumentReference ref = await Firestore.instance.collection("documents").add({"name": "New "
        "document", "user": LoggedInUser
        .of(context)
        .uid, "markdown": ""});

    Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) =>
        Editor
          (documentId: ref.documentID)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Document overview")),
      drawer: Drawer(
        child: ListView(children: <Widget>[
          ListTile(title: Text("Document overview")),
          ListTile(title: Text("Logout"), onTap: () {
            FirebaseAuth.instance.signOut();
          },)
        ]),
      ),
      floatingActionButton: FloatingActionButton(onPressed: () => newDocument(context), child: Icon
        (Icons
          .add)),
      body: StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection('documents').where("user", isEqualTo: LoggedInUser
            .of(context)
            .uid)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError)
            return new Text('Error: ${snapshot.error}');
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return new Text('Loading...');
            default:
              return new ListView(
                children: snapshot.data.documents.map((DocumentSnapshot document) {
                  return new ListTile(
                    title: new Text(document['name']),
                    onTap: () =>
                        Navigator.of(context).push(MaterialPageRoute(builder:
                            (BuildContext context) => Editor(documentId: document.documentID))),
                  );
                }).toList(),
              );
          }
        },
      ),
    );
  }
}
