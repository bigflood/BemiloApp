import 'package:flutter/material.dart';
import 'package:flutter_flux/flutter_flux.dart';

import 'db/db.dart';
import 'noteview/note_input.dart';
import 'notelistview/notelistview.dart';
import 'home_loadingview.dart';



class MainApp extends StatefulWidget {

  @override
  MainAppState createState() => new MainAppState();

  Route onGenerateRoute(RouteSettings settings) {
    if (NoteInputView.routeName == settings.name) {
      return new MaterialPageRoute<Null>(
        builder: (BuildContext context) => new NoteInputView(),
        settings: settings,
      );
    } else if (NoteInputView.routeName == settings.name) {
      return new MaterialPageRoute<Null>(
        builder: (BuildContext context) => new NoteInputView(),
        settings: settings,
      );
    }
    return null;
  }
}

class MainAppState extends State<MainApp> with WidgetsBindingObserver, StoreWatcherMixin {
  NoteStore _noteStore;

  @override
  void initState() {
    //debugPrint('* MainApp.initState..');
    _noteStore = listenToStore(noteStoreToken);

    super.initState();

    WidgetsBinding.instance.addObserver(this);
    DBManager.open();
  }

  @override
  Widget build(BuildContext context) {
    Widget home;

    if (_noteStore.state == NoteStoreState.ready) {
      home = new NoteListView();
    } else {
      home = new HomeLoadingView(noteStore: _noteStore);
    }

    return new MaterialApp(
      title: 'BEMILO!',
      theme: new ThemeData(
        primarySwatch: Colors.green,
      ),
      onGenerateRoute: config.onGenerateRoute,
      home: home,
    );
  }

  @override
  didUpdateConfig(MainApp oldConfig) {
    debugPrint('* MainApp.didUpdateConfig');
    super.didUpdateConfig(oldConfig);
  }

  @override
  deactivate() {
    debugPrint("* MainApp.deactivate..");
    super.deactivate();
  }

  @override
  dispose() {
    debugPrint('* MainApp.dispose..');
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  didChangeAppLifecycleState(AppLifecycleState state) {
    debugPrint('* MainApp.didChangeAppLifecycleState.. <$state>');
    switch(state) {
      case AppLifecycleState.paused:
        DBManager.close();
        break;
      case AppLifecycleState.resumed:
        DBManager.open();
        break;
    }
  }



}
