import 'package:flutter/material.dart';

import 'db/db.dart';
import 'bemilo.dart';


class HomeInputPassView extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final GlobalKey<FormFieldState<InputValue>> _passwordFieldKey = new GlobalKey<FormFieldState<InputValue>>();

  NoteStore noteStore;
  String _pass;

  HomeInputPassView({this.noteStore}) {
  }

  bool get _isFileNotFound =>
    (noteStore.state == NoteStoreState.error && noteStore.error == NoteStoreError.fileNotFound);

  void showInSnackBar(String value) {
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: new Text(value)
    ));
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
        title: new Text('Input Pass')
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return new Form(
        key: _formKey,
        child: new Block(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          children:  _createWidgetList(),
        )
      );
  }

  List<Widget> _createWidgetList() {
    var list = <Widget>[];

    list.add(new SizedBox(height: 16.0));
    list.add(new Text(_getMsg()));

    list.add(
      createInputField(
        key: _passwordFieldKey,
        labelText: 'Password',
        hideText: true,
        autofocus: true,
        validator: _validatePassword1,
        onSaved: (InputValue val) { _pass = val.text; },
      )
    );

    if (_isFileNotFound) {
      list.add(
        createInputField(
          labelText: 'Retype password',
          hideText: true,
          validator: _validatePassword2,
        )
      );
    }

    list.add(new Container(
      padding: const EdgeInsets.all(20.0),
      alignment: const FractionalOffset(0.5, 0.5),
      child: new RaisedButton(
        child: new Text('SUBMIT'),
        onPressed: _handleSubmitted,
      ),
    ));

    return list;
  }

  String _validatePassword1(InputValue value) {
    if (value == null || value.text.isEmpty)
      return 'Please choose a password.';
    return null;
  }

  String _validatePassword2(InputValue value) {
    FormFieldState<InputValue> passwordField = _passwordFieldKey.currentState;
    if (passwordField.value == null || passwordField.value.text.isEmpty)
      return 'Please choose a password.';
    if (passwordField.value.text != value.text)
      return 'Passwords don\'t match';
    return null;
  }

  String _getMsg() {
    if (_isFileNotFound) {
      return 'Input password to create file';
    } else if (noteStore.state == NoteStoreState.error) {
      switch(noteStore.error) {
        case NoteStoreError.needPassword:
          return 'Password Needed';
        case NoteStoreError.invalidPassword:
          return 'Incorret Password!';
        default:
          return '${noteStore.error}\n${noteStore.errorMsg}';
      }
    } else {
      return '';
    }
  }

  _handleSubmitted() {
    FormState form = _formKey.currentState;
    if (form.hasErrors) {
      showInSnackBar('Please fix the errors in red before submitting.');
    } else {
      form.save();
      loadWithPassAction(_pass);
    }
  }

}
