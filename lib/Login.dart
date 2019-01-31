import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Login extends StatelessWidget {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        Center(child: Text("Login", style: TextStyle(fontSize: 32),),),
        Center(child: RaisedButton(child: Text("Google"), onPressed: () async {
          final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
          final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
          final AuthCredential credential = GoogleAuthProvider.getCredential(
            accessToken: googleAuth.accessToken,
            idToken: googleAuth.idToken,
          );

          await _auth.signInWithCredential(credential);
        },))
      ],
    );
  }
}
