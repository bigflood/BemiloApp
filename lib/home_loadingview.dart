import 'package:flutter/material.dart';

import 'db/db.dart';


class HomeLoadingView extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  NoteStore noteStore;

  HomeLoadingView({this.noteStore}) {
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
        title: new Text(_getTitle())
      ),
      body: new Builder(
        builder: _buildBody
      )
    );
  }

  String _getTitle() {
    if (noteStore.state == NoteStoreState.error) {
      return 'Error';
    } else {
      return 'Loading';
    }
  }

  Widget _buildBody(BuildContext context) {
    return new Padding(
      padding: const EdgeInsets.all(24.0),
      child: new Block( children: _createWidgets(context) )
    );
  }

  List<Widget> _createWidgets(BuildContext context) {
    List<Widget> list = <Widget>[];

    list.add(new Text("${noteStore.state}\n${noteStore.error}\n${noteStore.errorMsg}"));

    if (noteStore.state == NoteStoreState.error &&
      noteStore.error == NoteStoreError.exception) {
        list.add(
         new Center(
           child: new RaisedButton(
             child: new Text('Reset'),
             onPressed: () => _onClickReset(context),
           )
         )
       );
    }

   list = list.map((Widget child) {
     return new Container(
       margin: const EdgeInsets.symmetric(vertical: 12.0),
       child: child
     );
   })
   .toList();

   return list;
  }

  _onClickReset(BuildContext context) {

    showDialog(
      context: context,
      child: new AlertDialog(
        content: new Text(
          'Reset data?',
          //style: dialogTextStyle
        ),
        actions: <Widget>[
          new FlatButton(
            child: new Text('Cancel'),
            onPressed: () { Navigator.pop(context, 'cancel'); }
          ),
          new FlatButton(
            child: new Text('Reset'),
            onPressed: () { Navigator.pop(context, 'reset'); }
          )
        ]
      )
    ).then((value) {
      if (value == 'reset') {
        resetNoteAction(null);
      }
    });
  }

}
