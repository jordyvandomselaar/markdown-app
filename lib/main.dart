import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:markdown/DocumentOverview.dart';
import 'package:markdown/LoggedInUser.dart';
import 'package:markdown/Login.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
          primarySwatch: Colors.blue,
          textTheme: TextTheme()
      ),
      home: HomePage(),
    );
  }
}


class HomePage extends StatelessWidget {
  build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.onAuthStateChanged,
      builder: (BuildContext context, AsyncSnapshot<FirebaseUser> snapshot) {
        if (snapshot.hasError) {
          return Text("Something went wrong, please try again later");
        }

        if (snapshot.hasData) {
          return LoggedInUser(
              user: snapshot.data,
              child: DocumentOverview()
          );
        }

        return Login();
      },
    );
  }
}
