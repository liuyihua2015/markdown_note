import 'package:flutter/material.dart';
import 'package:markdown_note/model/note.dart';
import 'package:markdown_note/note/NoteStore.dart';
import 'package:markdown_note/page/PageEditor.dart';
import 'dart:math';

class PageHome extends StatefulWidget {
  const PageHome({Key? key}) : super(key: key);

  @override
  State<PageHome> createState() => _PageHomeState();
}

class _PageHomeState extends State<PageHome> {
  List<Note> noteListData = [];
  List<String> categoryList = ["All"];
  String currentCategory = "All";

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setState(() {
      debugPrint('didChangeDependencies');

      List<Note> allNotes = NoteStore.notes(context);

      //Get corresponding data according to classification
      if (currentCategory == "All") {
        noteListData = allNotes;
      } else {
        noteListData = allNotes.where((note) => note.category == currentCategory).toList();
      }
      categoryList = getCategoryList(allNotes);
      categoryList.insert(0, "All");

    });
  }

  Widget getDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            child: Text(
              '分类列表',
              style: TextStyle(fontSize: 24, color: Colors.white),
            ),
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
          ),
          SizedBox(
            height: double.maxFinite,
            child: ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  child: ListTile(
                    title: Text(
                      categoryList[index],
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                      setState(() {
                        currentCategory = categoryList[index];
                      });
                      didChangeDependencies();
                    },
                  ),
                );
              },
              itemCount: categoryList.length,
            ),
          ),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Markdown 笔记'),
      ),
      drawer: getDrawer(),
      body: Center(
        child: ListView.builder(
          itemBuilder: (BuildContext context, int index) {
            Note note = noteListData[index];
            return ListTile(
              isThreeLine: true,
              title: Text(note.title),
              subtitle: Text(note.content,overflow: TextOverflow.ellipsis,maxLines: 1,),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => PageEditor(note)));
              },
            );
          },
          itemCount: noteListData.length,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => PageEditor(null)));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
