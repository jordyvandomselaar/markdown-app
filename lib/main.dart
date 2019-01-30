import 'package:flutter/material.dart';
import 'package:markdown/Editor.dart';

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

class HomePage extends StatelessWidget{
  build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Markdown App")),
      body: Editor(),
      drawer: Drawer(child: ListView(children: <Widget>[
        ListTile(title: Text("Document overview")),
        ListTile(title: Text("Login")),
        ListTile(title: Text("Logout"))
      ],),),
    );
  }
}
