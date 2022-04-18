import 'package:flutter/material.dart';
import 'package:markdown_note/page/PageHome.dart';
import 'package:markdown_note/note/NoteStore.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NoteStore(
       MaterialApp(
        title: "markdown_note",
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home:const PageHome(),
      ),
    );
  }
}
