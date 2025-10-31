class Note {
  int? id;
  String title;
  String content;

  Note({this.id, required this.title, required this.content});

  Map<String, dynamic> toMap() => {
    'id': id,
    'title': title,
    'content': content,
  };

  factory Note.fromMap(Map<String, dynamic> map) =>
      Note(id: map['id'], title: map['title'], content: map['content']);
}