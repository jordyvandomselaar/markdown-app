import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoggedInUser extends InheritedWidget {
  final FirebaseUser user;

  LoggedInUser({this.user, Widget child}) : super(child: child);

  @override
  bool updateShouldNotify(LoggedInUser oldWidget) {
    return user.uid != oldWidget.user.uid;
  }

  static FirebaseUser of(BuildContext context) {
    LoggedInUser loggedInUser =
        context.inheritFromWidgetOfExactType(LoggedInUser);

    return loggedInUser.user;
  }
}
