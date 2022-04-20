//create a note class have uuid, title, content, category,
class Note {
  String uuid;
  String title;
  String content;
  String category;

  Note(this.uuid, this.title, this.content, this.category);

  Note.fromJson(Map<String, dynamic> json)
      : uuid = json['uuid'],
        title = json['title'],
        content = json['content'],
        category = json['category'];

  Map<String, dynamic> toJson() => <String, dynamic>{
        "uuid": uuid,
        "title": title,
        "content": content,
        "category": category,
      };
}

//get category list by note
List<String> getCategoryList(List<Note> notes) {
  List<String> categoryList = [];
  for (var note in notes) {
    if (!categoryList.contains(note.category)) {
      categoryList.add(note.category);
    }
  }
  return categoryList;
}


