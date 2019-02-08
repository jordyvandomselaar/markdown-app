import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:markdown/Editor.dart';
import 'package:markdown/LoggedInUser.dart';

class DocumentOverview extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
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
    );
  }
}
