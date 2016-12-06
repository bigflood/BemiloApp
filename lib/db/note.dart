

class Note {
  //@Property(name:'id')
  int id;
  DateTime time;
  String title, content;
  String tags;

  Note() {
  }

  Note.fromMap(Map m) {
    id = m['id'] ?? -1;
    time = new DateTime.fromMillisecondsSinceEpoch(m['time'] ?? 0);
    title = m['title'] ?? '';
    content = m['content'] ?? '';
    tags = m['tags'] ?? '';
  }

  toMap(Map m) {
    m['id'] = id;
    m['time'] = time.millisecondsSinceEpoch;
    m['title'] = title;
    m['content'] = content;
    m['tags'] = tags;
  }

  Note clone() {
    return new Note()
      ..id = id
      ..time = new DateTime.fromMillisecondsSinceEpoch(time.millisecondsSinceEpoch)
      ..title = title
      ..content = content
      ..tags = tags;
  }
}
