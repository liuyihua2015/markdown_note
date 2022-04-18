import 'package:flutter/material.dart';
import 'package:markdown_note/model/note.dart';
import 'package:markdown_note/note/NoteStore.dart';
import 'package:markdown_note/page/PageEditor.dart';

class PageHome extends StatefulWidget {
  const PageHome({Key? key}) : super(key: key);

  @override
  State<PageHome> createState() => _PageHomeState();
}

class _PageHomeState extends State<PageHome> {
  List<Note> noteListData = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setState(() {
      noteListData = NoteStore.notes(context);
    });
  }

  Widget getDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            child: Text(
              '分类列表',
              style: TextStyle(fontSize: 24, color: Colors.white),
            ),
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
          ),
          ListTile(
            title: const Text('分类1'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('分类2'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('分类3'),
            onTap: () {
              Navigator.pop(context);
            },
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
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => PageEditor(null)));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
