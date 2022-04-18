
import 'package:flutter/material.dart';

import '../model/note.dart';

class PageEditor extends StatefulWidget {

  late Note? originNote = null;

  PageEditor(this.originNote, {Key? key}) : super(key: key);

  @override
  State<PageEditor> createState() => _PageEditorState();
}

class _PageEditorState extends State<PageEditor> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.originNote?.title.toString() ?? 'New Note'),
      ),
      body: Center(
        child: Text(widget.originNote?.content.toString() ?? 'New Note'),
      ),
    );
  }
}
