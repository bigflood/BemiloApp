import 'package:flutter/material.dart';
import 'package:flutter_flux/flutter_flux.dart';
import 'item.dart';
import '../db/note.dart';
import '../db/db.dart';
import '../bemilo.dart';
import '../drawer.dart';
import '../noteview/note_input.dart';
import '../home_appbarbg.dart';


enum _MainAction {
  sortByTime,
  sortByTitle,
}

enum _SortMode {
  time,
  title,
}

class NoteListView extends StatefulWidget {
  @override
  createState() => new _NoteListViewState();
}

class _NoteListViewState extends State<NoteListView> with StoreWatcherMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<ScrollableState> _scrollableKey = new GlobalKey<ScrollableState>();

  NoteStore _noteStore;
  _SortMode _sortMode = _SortMode.time;

  @override
  void initState() {
    _noteStore = listenToStore(noteStoreToken);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget home = new Scaffold(
      key: _scaffoldKey,
      scrollableKey: _scrollableKey,
      drawer: new MainDrawer(),
      appBar: _createAppBar(context),
      appBarBehavior: AppBarBehavior.under,
      floatingActionButton: new FloatingActionButton(
          child: new Icon(Icons.add),
          onPressed: () {
            //_scaffoldKey.currentState.showSnackBar(new SnackBar(
            //  content: new Text('Not supported.')
            //));
            Navigator.pushNamed(context, NoteInputView.routeName);
          },
      ),
      body: _createBody(context),
    );

    return home;
  }

  AppBar _createAppBar(BuildContext context) {
    return new AppBar(
      expandedHeight: kFlexibleSpaceMaxHeight,
      flexibleSpace: new FlexibleSpaceBar(
        title: new Text('Notes'),
        background: new Builder(
          builder: (BuildContext context) {
            return new HomeAppBarBackground(
              animation: _scaffoldKey.currentState.appBarAnimation
            );
          }
        )
      ),
      actions: _createAppBarActions(context)
    );
  }
  List<Widget> _createAppBarActions(BuildContext context) {
    return <Widget>[
      new PopupMenuButton<_MainAction>(
        itemBuilder: (BuildContext context) => <PopupMenuItem<_MainAction>>[
          new CheckedPopupMenuItem<_MainAction>(
            value: _MainAction.sortByTime,
            checked: _sortMode == _SortMode.time,
            child: new Text('Sort by time')
          ),
          new CheckedPopupMenuItem<_MainAction>(
            value: _MainAction.sortByTitle,
            checked: _sortMode == _SortMode.title,
            child: new Text('Sort by title')
          ),
        ],
        onSelected: (_MainAction action) {
          switch (action) {
            case _MainAction.sortByTime:
              setState(() { _sortMode = _SortMode.time; });
              break;
            case _MainAction.sortByTitle:
              setState(() { _sortMode = _SortMode.title; });
              break;
          }
        }
      )
    ];
  }

  Iterable<Note> _getNotes() {
    List<Note> list = _noteStore.data.notes.toList(growable: false);

    switch(_sortMode) {
      case _SortMode.time:
      list.sort((a,b) => a.time.compareTo(b.time));
      break;
      case _SortMode.title:
      list.sort((a,b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()));
      break;
    }

    return list;
  }

  String _categoryOf(NoteItemView view) {
    switch(_sortMode) {
      case _SortMode.time:
        var t = view.info.time;
        return '${t.year}-${t.month}-${t.day}';
        break;
      case _SortMode.title:
        return view.info.title[0].toUpperCase();
        break;
    }

    return null;
  }

  Iterable<NoteItemView> _getListItems() sync* {
    for (Note item in _getNotes()) {
      yield new NoteItemView(item);
    }
  }

  List<Widget> _galleryListItems(BuildContext context) {
    final List<Widget> listItems = <Widget>[];
    final ThemeData themeData = Theme.of(context);
    final TextStyle headerStyle = themeData.textTheme.body2.copyWith(color: themeData.accentColor);
    String category;

    for (NoteItemView galleryItem in _getListItems()) {
      if (category != _categoryOf(galleryItem)) {
        if (category != null)
          listItems.add(new Divider());
        listItems.add(
          new Container(
            height: 48.0,
            padding: const EdgeInsets.only(left: 16.0),
            alignment: FractionalOffset.centerLeft,
            child: new Text(_categoryOf(galleryItem), style: headerStyle)
          )
        );
        category = _categoryOf(galleryItem);
      }
      listItems.add(galleryItem);
    }
    return listItems;
  }

  Widget _createBody(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;

    // The block's padding just exists to occupy the space behind the flexible app bar.
    // As the block's padded region is scrolled upwards, the app bar's height will
    // shrink keep it above the block content's and over the padded region.
    return new Block(
      scrollableKey: _scrollableKey,
      padding: new EdgeInsets.only(top: kFlexibleSpaceMaxHeight + statusBarHeight),
      children: _galleryListItems(context)
    );
  }

}
