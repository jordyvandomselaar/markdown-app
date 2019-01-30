import 'package:flutter/material.dart';

class Editor extends StatefulWidget {
  @override
  State createState() {
    return EditorState();
  }
}

class EditorState extends State<Editor> with SingleTickerProviderStateMixin {
  TabController _tabController;
  TextEditingController _markdownController;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 2, vsync: this);
    _markdownController = TextEditingController();
  }

  void _wrapSelection(String wrapper) {
    String value = _markdownController.value.text;
    String newValue;
    TextSelection newSelection = TextSelection(baseOffset: _markdownController.selection
        .baseOffset + wrapper.length,
        extentOffset: _markdownController.selection.extentOffset + wrapper.length);

    if (_markdownController.selection.start != _markdownController.selection.end) {
      newValue = value.substring(0, _markdownController.selection.start) + wrapper + value
          .substring(_markdownController.selection.start, _markdownController.selection.end) +
          wrapper +
          value.substring(_markdownController.selection.end);
    } else {
      newValue = value.substring(0, _markdownController.selection.start) + wrapper + value
          .substring(_markdownController.selection.start);
    }

    _markdownController.value = TextEditingValue(text: newValue, selection: newSelection);
  }

  build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(
          height: 50,
          child: TabBar(labelColor: Colors.black,controller: _tabController, tabs: <Widget>[
          ConstrainedBox(child: Center(child: Text("Editor"),), constraints:
          BoxConstraints
              .expand
            (),),
          ConstrainedBox(child: Center(child: Text("Rendered"),), constraints: BoxConstraints.expand(),)
        ],),),
      Expanded(child:   TabBarView(
          controller: _tabController,
          children: <Widget>[
            Column(
              children: <Widget>[
                Expanded(
                  child: SingleChildScrollView(
                      child:
                      TextField(
                        controller: _markdownController,
                        maxLines: null,
                        decoration: InputDecoration(labelText: "Your markdown"),
                      )
                  ),
                ),
                BottomAppBar(child: SizedBox(
                  width: double.infinity,
                  child: Wrap(
                    children: <Widget>[
                      FlatButton(child: Text("h1"), onPressed: () => _wrapSelection("# ")),
                      FlatButton(child: Text("h2"), onPressed: () => _wrapSelection("## ")),
                      FlatButton(child: Text("h3"), onPressed: () => _wrapSelection("### ")),
                      FlatButton(child: Text("h4"), onPressed: () => _wrapSelection("#### ")),
                      FlatButton(child: Text("h5"), onPressed: () => _wrapSelection("##### ")),
                      FlatButton(child: Text("h6"), onPressed: () => _wrapSelection("###### ")),
                      FlatButton(child: Text("Bold"), onPressed: () => _wrapSelection("**")),
                      FlatButton(child: Text("Italic"), onPressed: () => _wrapSelection("*")),
                      FlatButton(child: Text("Line"), onPressed: () => _wrapSelection("* * *")),
                    ],
                  ),)
                ),
              ],
            ),
            Text("Hai")
          ]),)
      ],
    );
  }
}
