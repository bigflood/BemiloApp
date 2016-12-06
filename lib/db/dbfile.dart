import 'dart:io';
import 'dart:convert';

import 'note.dart';
import 'dbdata.dart';


class DBFileLoader {
  final File file;
  final String password;

  DBFileLoader(this.file, this.password) {
  }

  load(DBData data) async {
    data.noteList = <Note>[];

    String contents = await file.readAsString();

    var obj = JSON.decode(contents);
    if (obj is List) {
      data.idSeq = 0;
      List list = obj;
      for(var i in list) {
        data.idSeq += 1;
        data.noteList.add(new Note.fromMap(i) ..id = data.idSeq);
      }
    }
  }
}


class DBFileSaver {
  final File file;
  final String password;

  DBFileSaver(this.file, this.password) {
  }

  save(DBData data) async {
    String content = '[' + _noteListToStrings(data.noteList).join(',') + ']';
    await file.writeAsString(content, flush:true);
  }

  Iterable<String> _noteListToStrings(List<Note> list) sync* {
    var m = <String,dynamic>{};
    for(Note note in list) {
      note.toMap(m);
      yield JSON.encode(m);
    }
  }

}
