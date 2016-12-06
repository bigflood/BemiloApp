import 'package:flutter/material.dart';
import '../db/note.dart';
import '../noteview/note_view.dart';


class NoteItemView extends StatelessWidget {
  NoteItemView(this.info) {
    assert(info != null);
  }

  final Note info;

  @override
  Widget build(BuildContext context) {
    return new ListItem(
      title: new Text(info.title),
      leading: new Text('${info.time.hour}:${info.time.minute.toString().padLeft(2, '0')}'),
      subtitle: new Text(info.content),
      onTap: () { showInfoView(context); }
    );
  }

  showInfoView(BuildContext context) {
    Navigator.push(context, new MaterialPageRoute<Null>(
      settings: const RouteSettings(name: "/noteview"),
      builder: (BuildContext context) => new NoteView(info)
    ));
  }
}
