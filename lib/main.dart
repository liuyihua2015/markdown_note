import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
      ScreenUtilInit(
        designSize: Size(375, 812 - 44 - 34),
        builder: (BuildContext context) {
          return MaterialApp(
            title: 'Markdown Note',
            theme: ThemeData(
              primarySwatch: Colors.blue,
              visualDensity: VisualDensity.adaptivePlatformDensity,
            ),
            home: PageHome(),
          );
        },
      )
    );
  }
}
