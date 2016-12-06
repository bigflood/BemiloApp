import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';

import 'note.dart';
import 'dbdata.dart';
import '../cipher/cipher.dart';


const String _fileMagic = 'NotesData:';

class DBFileDecodeException extends FormatException {
  const DBFileDecodeException([message = ""]) : super(message);
}
class DBFileDecodeInvalidPassword extends FormatException {
  const DBFileDecodeInvalidPassword([message = ""]) : super(message);
}

class DBFileLoader {
  final File file;
  final FileCipherDecode cipher = new FileCipherDecode();

  DBFileLoader(this.file, String password) {
    debugPrint('DBFileLoader constr.."$password"');
    cipher.initCipher(password);
    debugPrint('initCipher..ok');
  }

  load(DBData data) async {
    debugPrint('load..');

    data.noteList = <Note>[];

    List<int> bytes = await file.readAsBytes();

    debugPrint('readAsBytes => ${bytes.length} bytes');

    bytes = cipher.decodeBytes(bytes);
    if (bytes.length <= 4) {
      debugPrint('decode failed');
      throw new DBFileDecodeException('decode failed!');
    }

    int sz = getIntAt(bytes, 0, 4);
    if (sz <= 0 || sz > bytes.length-4) {
      debugPrint('sz failed');
      throw new DBFileDecodeInvalidPassword('decode failed!!');
    }

    debugPrint('sz => $sz');
    bytes = bytes.sublist(4, sz + 4);

    String s = new String.fromCharCodes(bytes);

    if (!s.startsWith(_fileMagic)) {
      debugPrint('file magic failed');
      throw new DBFileDecodeInvalidPassword('decode failed!!!');
    }

    s = s.substring(_fileMagic.length);

    loadFromString(data, s);
  }

  int getIntAt(List<int> list, int start, int n) {
    int m = 1;
    int s = 0;
    for(int i = 0 ; i < n ; ++i) {
      s += list[start + i] * m;
      m *= 256;
    }
    return s;
  }

  loadFromString(DBData data, String s) {
    var obj = JSON.decode(s);
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
  final FileCipherEncode cipher = new FileCipherEncode();

  DBFileSaver(this.file, String password) {
    cipher.initCipher(password);
  }

  save(DBData data) async {
    String content = _fileMagic + '[' + _noteListToStrings(data.noteList).join(',') + ']';

    List<int> contentBytes = UTF8.encode(content);
    int sz = contentBytes.length;

    Uint8List bytes = new Uint8List(sz + 4);

    bytes.setAll(0, intToBytes(sz, 4));
    bytes.setAll(4, contentBytes);

    bytes = cipher.encodeBytes(bytes);

    await file.writeAsBytes(bytes, flush:true);
  }

  Iterable<int> intToBytes(int v, int sz) sync* {
    for(int i = 0 ; i < sz ; ++i) {
      yield v % 256;
      v = v ~/ 256;
    }
  }

  Iterable<String> _noteListToStrings(List<Note> list) sync* {
    var m = <String,dynamic>{};
    for(Note note in list) {
      note.toMap(m);
      yield JSON.encode(m);
    }
  }

}
