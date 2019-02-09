import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Editor extends StatefulWidget {
  final String documentId;

  Editor({@required this.documentId});

  @override
  State createState() {
    return EditorState(documentId: documentId);
  }
}

class EditorState extends State<Editor> with SingleTickerProviderStateMixin {
  TabController _tabController;
  TextEditingController _markdownController;
  TextEditingController _nameController;
  final String documentId;
  Timer debouncer;

  EditorState({this.documentId});

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 2, vsync: this);
    _markdownController = TextEditingController();
    _nameController = TextEditingController();

    _markdownController.addListener(() {
      if (debouncer != null) {
        debouncer.cancel();
      }

      debouncer = Timer(Duration(milliseconds: 200), () {
        saveData();
      });
    });

    _nameController.addListener(() {
      if (debouncer != null) {
        debouncer.cancel();
      }

      debouncer = Timer(Duration(milliseconds: 200), () {
        saveData();
      });
    });
  }

  void _wrapSelection({@required String start, String end}) {
    String value = _markdownController.value.text;
    String newValue;
    TextSelection newSelection = TextSelection(
        baseOffset: _markdownController.selection.baseOffset + start.length,
        extentOffset:
            _markdownController.selection.extentOffset + start.length);

    if (end != null) {
      newValue = value.substring(0, _markdownController.selection.start) +
          start +
          value.substring(_markdownController.selection.start,
              _markdownController.selection.end) +
          end +
          value.substring(_markdownController.selection.end);
    } else {
      newValue = value.substring(0, _markdownController.selection.start) +
          start +
          value.substring(_markdownController.selection.start);
    }

    _markdownController.value =
        TextEditingValue(text: newValue, selection: newSelection);
  }

  void saveData() {
    Firestore.instance.collection('documents').document(documentId).updateData({
      "markdown": _markdownController.value.text,
      "name": _nameController.value.text
    });
  }

  build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Editor"),
      ),
      body: Column(
        children: <Widget>[
          SizedBox(
            height: 50,
            child: TabBar(
              labelColor: Colors.black,
              controller: _tabController,
              tabs: <Widget>[
                ConstrainedBox(
                  child: Center(
                    child: Text("Editor"),
                  ),
                  constraints: BoxConstraints.expand(),
                ),
                ConstrainedBox(
                  child: Center(
                    child: Text("Rendered"),
                  ),
                  constraints: BoxConstraints.expand(),
                )
              ],
            ),
          ),
          Expanded(
            child: TabBarView(controller: _tabController, children: <Widget>[
              FutureBuilder<DocumentSnapshot>(
                future: Firestore.instance
                    .collection('documents')
                    .document(documentId)
                    .get(),
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return Text("loading…");
                  }

                  _markdownController.value =
                      TextEditingValue(text: snapshot.data["markdown"]);
                  _nameController.value =
                      TextEditingValue(text: snapshot.data["name"]);

                  return Column(
                    children: <Widget>[
                      Expanded(
                          child: ListView(
                        children: <Widget>[
                          TextField(
                            controller: _nameController,
                            maxLines: 1,
                            decoration:
                                InputDecoration(labelText: "Document name"),
                          ),
                          TextField(
                            controller: _markdownController,
                            maxLines: null,
                            decoration: InputDecoration(labelText: "Markdown"),
                          )
                        ],
                      )),
                      BottomAppBar(
                          child: SizedBox(
                        width: double.infinity,
                        child: Wrap(
                          children: <Widget>[
                            FlatButton(
                                child: Text("h1"),
                                onPressed: () => _wrapSelection(start: "# ")),
                            FlatButton(
                                child: Text("h2"),
                                onPressed: () => _wrapSelection(start: "## ")),
                            FlatButton(
                                child: Text("h3"),
                                onPressed: () => _wrapSelection(start: "### ")),
                            FlatButton(
                                child: Text("h4"),
                                onPressed: () =>
                                    _wrapSelection(start: "#### ")),
                            FlatButton(
                                child: Text("h5"),
                                onPressed: () =>
                                    _wrapSelection(start: "##### ")),
                            FlatButton(
                                child: Text("h6"),
                                onPressed: () => _wrapSelection(
                                    start: "###### "
                                        "")),
                            FlatButton(
                                child: Text("Bold"),
                                onPressed: () =>
                                    _wrapSelection(start: "**", end: "**")),
                            FlatButton(
                                child: Text("Italic"),
                                onPressed: () => _wrapSelection(
                                    start: "*"
                                        "",
                                    end: "*")),
                            FlatButton(
                                child: Text("Line"),
                                onPressed: () => _wrapSelection(
                                    start: "* * "
                                        "*")),
                            FlatButton(
                                child: Text("Inline Code"),
                                onPressed: () =>
                                    _wrapSelection(start: "`", end: "`")),
                            FlatButton(
                                child: Text("Code"),
                                onPressed: () => _wrapSelection(
                                    start: "```\n", end: "\n```")),
                          ],
                        ),
                      )),
                    ],
                  );
                },
              ),
              Text("This feature is still being worked on.")
            ]),
          )
        ],
      ),
    );
  }
}
