import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flux/flutter_flux.dart';
import 'note.dart';
import 'dbfile.dart';
import 'dbdata.dart';


enum NoteStoreState {
  none,
  loading,
  error,
  ready,
}


class AddNote {
  DateTime time;
  String title, content;
  String tags;

  Note createNote() {
    return new Note()
    ..id = -1
    ..time = time ?? new DateTime.fromMillisecondsSinceEpoch(0)
    ..title = title ?? ''
    ..content = content ?? ''
    ..tags = tags ?? '';
  }
}

class EditNote {
  int id;
  DateTime time;
  String title, content;
  String tags;

  applyToNote(Note note) {
    note
    ..time = time ?? note.time
    ..title = title ?? note.title
    ..content = content ?? note.content
    ..tags = tags ?? note.tags;
  }
}

class DeleteNote {
  int id;
}


class NoteStore extends Store {

  final DBData _data = new DBData();
  NoteStoreState _state = NoteStoreState.none;
  String _password = '';

  NoteStore() {
    loadWithPassAction.listen(_onLoadWithPass);
    addNoteAction.listen(_onAddNote);
    editNoteAction.listen(_onEditNote);
    deleteNoteAction.listen(_onDeleteNote);
    _loadJob = _loadNotes('');
  }

  Future<File> _getLocalFile() async {
    // get the path to the document directory.
    String dir = (await PathProvider.getApplicationDocumentsDirectory()).path;
    return new File('$dir/notes.bin');
  }

  _loadNotes(String pass) async {
    if (_state == NoteStoreState.loading) return;

    _state = NoteStoreState.loading;

    _data.reset();

    try {
      File file = await _getLocalFile();
      if (!await file.exists()) {
        debugPrint('file(${file.path}) not found.');
        return;
      }

      debugPrint('loading file(${file.path})..');

      DBFileLoader loader = new DBFileLoader(file, _password);

      await loader.load(_data);

      debugPrint('loading ok.');
      _state = NoteStoreState.ready;
    } on FileSystemException {
      _state = NoteStoreState.error;
    } on Exception {
      _state = NoteStoreState.error;
    }

    trigger();
  }

  _onLoadWithPass(String arg) {
    if (_state == NoteStoreState.none ||
        _state == NoteStoreState.error) {
      _loadNotes(arg);
    }
  }

  _onAddNote(AddNote arg) async {
    await _loadJob;
    if (_state != NoteStoreState.ready) return;

    _data.add(arg.createNote());
    _setDirty();
  }

  _onEditNote(EditNote arg) async {
    await _loadJob;
    if (_state != NoteStoreState.ready) return;

    if (_data.edit(arg.id, (note) => arg.applyToNote(note))) {
      _setDirty();
    }
  }

  _onDeleteNote(DeleteNote arg) async {
    await _loadJob;
    if (_state != NoteStoreState.ready) return;

    if (_data.delete(arg.id)) {
      _setDirty();
    }
  }

  _setDirty() {
    _dirty = true;
    _saveNotes();
    trigger();
  }

  _saveNotes() async {
    if (_state != NoteStoreState.ready) return;

    debugPrint('save notes..');

    while(_dirty && !_saving) {
      _dirty = false;
      _saving = true;

      try {
        File file = await _getLocalFile();

        debugPrint('saving file(${file.path})..');

        DBFileSaver saver = new DBFileSaver(file, _password);
        saver.save(_data);

        debugPrint('saving file(${file.path})..ok ${await file.exists()}');

      } on FileSystemException {
      }

      _saving = false;
    }
  }

  Future _loadJob;
  bool _dirty = false, _saving = false;

  DBDataView get data => new DBDataView(_data);
  NoteStoreState get state => _state;

}


final Action<String> loadWithPassAction = new Action<String>();
final Action<AddNote> addNoteAction = new Action<AddNote>();
final Action<EditNote> editNoteAction = new Action<EditNote>();
final Action<DeleteNote> deleteNoteAction = new Action<DeleteNote>();

final StoreToken noteStoreToken = new StoreToken(new NoteStore());


class DBManager {

  static Future open() async {
    debugPrint('DBManager.open..');

  }

  static Future close() async {
    debugPrint('DBManager.close..');

    await new Future.delayed(const Duration(seconds:5));

    debugPrint('DBManager.close..ok');
  }

}
