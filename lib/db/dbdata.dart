import 'note.dart';


class DBData {
  int idSeq;
  List<Note> noteList;

  DBData() {
    reset();
  }

  reset() {
    idSeq = 0;
    noteList = <Note>[];
  }

  add(Note note) {
    idSeq += 1;

    note.id = idSeq;

    noteList.add(note);
  }

  bool edit(int id, void f(Note note)) {
    var note = noteList.firstWhere((x) => x.id == id);

    if (note != null) {
      f(note);
      return true;
    } else {
      return false;
    }
  }

  bool delete(int id) {
    var len0 = noteList.length;
    noteList.removeWhere((note) => note.id == id);
    return noteList.length != len0;
  }
}


class DBDataView {
  final DBData data;

  DBDataView(this.data) {
  }

  List<Note> get notes => new List<Note>.unmodifiable(data.noteList);
}
