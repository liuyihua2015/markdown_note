import 'package:flutter/material.dart';

class PageMeta extends StatefulWidget {
  final String originTitle;
  final String originCategory;

  const PageMeta(this.originTitle, this.originCategory);

  @override
  State<PageMeta> createState() => _PageMetaState();
}

class _PageMetaState extends State<PageMeta> {
  late TextEditingController titleController;
  late TextEditingController categoryController;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.originTitle);
    categoryController = TextEditingController(text: widget.originCategory);
  }

  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
    categoryController.dispose();
  }

  //submit
  void _submit() {
    Navigator.of(context).pop({
      "newTitle": titleController.text,
      "newCategory": categoryController.text,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("元信息"),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.save,
              color: Colors.white,
            ),
            onPressed: _submit,
          )
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              children: [
                const Text("标题",style: TextStyle(fontSize: 20),),
                const SizedBox(
                  width: 20,
                  height: 0,
                ),
                Expanded(
                  child: TextField(
                    controller: titleController,
                  ),
                ),
              ],
            ),
            const SizedBox(
              width: 0,
              height: 20,
            ),
            Row(
              children: [
                const Text("分类",style: TextStyle(fontSize: 20),),
                const SizedBox(
                  width: 20,
                  height: 0,
                ),
                Expanded(
                  child: TextField(
                    controller: categoryController,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
