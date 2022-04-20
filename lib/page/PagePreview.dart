import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class PagePreview extends StatefulWidget {
  final String title;
  final String markdown;
  const PagePreview(this.title, this.markdown,{Key? key,}) : super(key: key);

  @override
  State<PagePreview> createState() => _PagePreviewState();
}

class _PagePreviewState extends State<PagePreview> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Markdown(
        data: widget.markdown,
        styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)),
      ),
    );
  }
}
