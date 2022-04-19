import 'package:flutter/material.dart';
import 'package:markdown_note/page/PageMeta.dart';
import 'package:uuid/uuid.dart';

import '../model/note.dart';
import '../note/NoteStore.dart';

class PageEditor extends StatefulWidget {
  late Note? originNote = null;

  PageEditor(this.originNote, {Key? key}) : super(key: key);

  @override
  State<PageEditor> createState() => _PageEditorState();
}

class _PageEditorState extends State<PageEditor> {
  late TextEditingController controller;
  late String newTitle;
  late String newCategory;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: widget.originNote?.content ?? "");
    newTitle = widget.originNote?.title ?? "";
    newCategory = widget.originNote?.category ?? "";
  }

  void saveNote() async {
    NoteOperationRet result;
    if (widget.originNote == null) {
      String uuid = const Uuid().v4();
      result = await NoteStore.createNote(
          context, Note(uuid, newTitle, newCategory, controller.text));
    } else {
      String uuid = widget.originNote?.uuid ?? "";
      result = await NoteStore.updateNote(
          context,Note(uuid, newTitle, newCategory, controller.text));
    }
    if (result != NoteOperationRet.SUCCESS) {
      // 后续可改为弹出对话框等用户可感知的提示形式
      print("笔记存储失败");
    } else {
      Navigator.of(context).pop();
    }
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      title: Row(
        children: [
          Text(newTitle.isNotEmpty ? newTitle : '输入标题'),
          IconButton(
              icon: const Icon(
                Icons.edit,
                color: Colors.white,
              ),
              onPressed: () => Navigator.of(context)
                      .push(MaterialPageRoute(
                          builder: (context) =>
                              PageMeta(newTitle, newCategory)))
                      .then((meta) {
                    if (meta != null) {
                      setState(() {
                        newTitle = meta["newTitle"];
                        newCategory = meta["newCategory"];
                      });
                    }
                  })),
        ],
      ),
      actions: [
        IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.movie,
              color: Colors.white,
            )),
        IconButton(
            onPressed: saveNote,
            icon: const Icon(
              Icons.check,
              color: Colors.white,
            )),
      ],
    );
  }



  /// 获取位置
  int _getEditorPosition() {
    return controller.selection.base.offset;
  }
  /// 向光标位置插入文本
  void _insertText(String text, {int deltaIndex = 0}) {
    int cursorPosition = _getEditorPosition();
    String textBefore = controller.text.substring(0, cursorPosition);
    String textAfter = controller.text.substring(cursorPosition);
    controller.text = textBefore + text + textAfter;
    controller.selection = TextSelection.fromPosition(
        TextPosition(offset: cursorPosition+text.length + deltaIndex));

    // int position = _getEditorPosition();
    //
    // String headString = controller.text.substring(0, position);
    // String tailString = controller.text.substring(position);
    //
    // controller.value = TextEditingValue(
    //     text: headString + text + tailString,
    //     selection: TextSelection.collapsed(
    //         offset: position + text.length + deltaIndex)
    // );
  }

  //create a textButton have GestureDetector  title and callback
  Widget buildTextButton(String title, VoidCallback callback) {
    return GestureDetector(
      onTap: callback,
      child: Container(
        padding: const EdgeInsets.fromLTRB(10, 14, 10, 14),
        child: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget getToolbar() {
    return SafeArea(
      child: Column(
        children: <Widget>[
          const Divider(
            height: 1,
            thickness: 1,
          ),
          Row(
            children: <Widget>[
              buildTextButton("h1", () => _insertText("# ")),
              buildTextButton("h2", () => _insertText("## ")),
              buildTextButton("h3", () => _insertText("### ")),
              IconButton(
                icon: const Icon(
                    Icons.format_bold, color: Colors.grey),
                onPressed: () => _insertText("****", deltaIndex: -2),
              ),
              IconButton(
                icon: const Icon(
                    Icons.format_italic, color: Colors.grey),
                onPressed: () => _insertText("**", deltaIndex: -1),
              ),
              IconButton(
                icon: const Icon(
                    Icons.format_list_bulleted, color: Colors.grey),
                onPressed: () => _insertText("* "),
              ),
            ],
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: Column(
        children: [
          Expanded(
            child: TextField(
              maxLines: null,
              minLines: 15,
              autofocus: true,
              controller: controller,
              keyboardType: TextInputType.multiline,
              decoration: const InputDecoration(border: InputBorder.none),
            ),
          ),
          getToolbar()
        ],
      ),
    );
  }
}
