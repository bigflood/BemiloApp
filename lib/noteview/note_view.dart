import 'package:flutter/material.dart';
import '../db/db.dart';
import '../db/note.dart';
import 'note_input.dart';
import '../bemilo.dart';


class NoteView extends StatefulWidget {
  NoteView(this.noteInfo, { Key key }) : super(key: key);

  static const String routeName = '/noteview';
  final Note noteInfo;

  @override
  _NoteViewState createState() => new _NoteViewState();
}

const double _kAppBarHeight = 128.0;
const double _kFabHalfSize = 28.0;  // TODO(mpcomplete): needs to adapt to screen size
const double _kRecipePageMaxWidth = 500.0;


class PestoStyle extends TextStyle {
  const PestoStyle({
    double fontSize: 12.0,
    FontWeight fontWeight,
    Color color: Colors.black87,
    double letterSpacing,
    double height,
  }) : super(
    inherit: false,
    color: color,
    fontFamily: 'Raleway',
    fontSize: fontSize,
    fontWeight: fontWeight,
    textBaseline: TextBaseline.alphabetic,
    letterSpacing: letterSpacing,
    height: height,
  );
}

class _NoteViewState extends State<NoteView> {
  final TextStyle titleStyle = const PestoStyle(fontSize: 34.0);
  final TextStyle descriptionStyle = const PestoStyle(fontSize: 15.0, color: Colors.black54, height: 24.0/15.0);
  final TextStyle headingStyle = const PestoStyle(fontSize: 16.0, fontWeight: FontWeight.bold, height: 24.0/15.0);
  final TextStyle itemAmountStyle = new PestoStyle(fontSize: 15.0, color: kTheme.primaryColor, height: 24.0/15.0);
  final TextStyle itemStyle = const PestoStyle(fontSize: 15.0, height: 24.0/15.0);

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<ScrollableState> _scrollableKey = new GlobalKey<ScrollableState>();


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      appBar: _createAppBar(context),
      body: _buildBody(context),
      floatingActionButton: new FloatingActionButton(
        child: new Icon(Icons.edit),
        onPressed: () {
          Navigator.push(context, new MaterialPageRoute<Null>(
            settings: const RouteSettings(name: NoteInputView.routeName),
            builder: (BuildContext context) => new NoteInputView(note: config.noteInfo)
          ));
        },
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return new ScrollableViewport(
      scrollableKey: _scrollableKey,
      child: new RepaintBoundary(
        child: new Padding(
          padding: new EdgeInsets.only(top: 8.0),
          child: new Stack(
            children: <Widget>[
              new Container(
                padding: new EdgeInsets.only(top: _kFabHalfSize),
                width: null,
                child: _buildContent(context),
              ),
            ],
          )
        )
      )
    );
  }

  Widget _buildContent(BuildContext context) {
    return new Material(
      child: new Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 40.0),
        child: new Table(
          columnWidths: <int, TableColumnWidth>{
            0: const FixedColumnWidth(64.0)
          },
          children: <TableRow>[
            new TableRow(
             children: <Widget>[
                new Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: new Text('title', style: itemAmountStyle),
                ),
                new TableCell(
                  verticalAlignment: TableCellVerticalAlignment.middle,
                  child: new Text(config.noteInfo.title, style: titleStyle)
                ),
              ]
            ),
            _createRow(context, 'content', config.noteInfo.content),
            _createRow(context, 'tags', config.noteInfo.tags),
            _createRow(context, 'time', config.noteInfo.time.toString()),
            _createRow(context, 'id', config.noteInfo.id.toString()),
          ]
        )
      )
    );
  }

  TableRow _createRow(BuildContext context, String label, String v) {
    return new TableRow(
      children: <Widget>[
        new Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: new Text(label, style: itemAmountStyle),
        ),
        new Padding(
          padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
          child: new Text(v, style: itemStyle)
        ),
      ]
    );
  }

  AppBar _createAppBar(BuildContext context) {
    return new AppBar(
      title: new Text('Note info.'),
      actions: <Widget>[
        new PopupMenuButton<String>(
          itemBuilder: (BuildContext context) => <PopupMenuItem<String>>[
            new PopupMenuItem<String>(
              value: 'remove',
              child: new ListItem(
                    leading: new Icon(Icons.delete),
                    title: new Text('Remove')
                  )
            ),
          ],
          onSelected: (String action) {
            switch (action) {
              case 'remove':
                _removeThisItem(context);
                break;
            }
          }
        )
      ]
    );
  }

  _removeThisItem(BuildContext context) {
    deleteNoteAction(new DeleteNote() ..id = config.noteInfo.id);

    Navigator.pop(context);
  }
}
