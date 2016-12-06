import 'package:flutter/material.dart';

import 'db/db.dart';


class HomeLoadingView extends StatelessWidget {
  NoteStore noteStore;

  HomeLoadingView({this.noteStore}) {
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Loading')
      ),
      body: new Builder(
        builder: _buildBody
      )
    );
  }

  Widget _buildBody(BuildContext context) {
    return new Padding(
      padding: const EdgeInsets.all(24.0),
      child: new Block(
        children: <Widget>[
          new Text(noteStore.state.toString()),
          new Center(
            child: new RaisedButton(
              child: new Text('Retry'),
              onPressed: noteStore.state == NoteStoreState.error ? _onClickRetry : null,
            )
          ),
        ]
        .map((Widget child) {
          return new Container(
            margin: const EdgeInsets.symmetric(vertical: 12.0),
            child: child
          );
        })
        .toList()
      )
    );
  }

  _onClickRetry() {

  }

}
