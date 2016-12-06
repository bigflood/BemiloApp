import 'package:flutter/material.dart';

import 'db/db.dart';


class HomePasswordInput extends StatefulWidget {
  HomePasswordInput({ this.noteStore, Key key }) : super(key: key);

  static const String routeName = '/home-pass';
  NoteStore noteStore;

  @override
  _HomePasswordInputState createState() => new _HomePasswordInputState(noteStore: noteStore);
}

class _HomePasswordInputState extends State<HomePasswordInput> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  NoteStore noteStore;
  String _password;

  _HomePasswordInputState({ this.noteStore }) {
  }

  void _handleSubmitted(BuildContext context) {
    FormState form = _formKey.currentState;
    if (form.hasErrors) {
      //showInSnackBar('Please fix the errors in red before submitting.');
    } else {
      form.save();
      loadWithPassAction(_password);

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
        title: new Text('Password')
      ),
      body: new Form(
        key: _formKey,
        child: new Block(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          children: <Widget>[
            createField(
              labelText: 'Password',
              hintText: '*******',
              hideText: true,
              validator: _validatePassword,
              onSaved: (InputValue val) { _password = val.text; },
            ),
            new Container(
              padding: const EdgeInsets.all(20.0),
              alignment: const FractionalOffset(0.5, 0.5),
              child: new RaisedButton(
                child: new Text('SUBMIT'),
                onPressed: () => _handleSubmitted(context),
              ),
            )
          ]
        )
      )
    );
  }

  String _validatePassword(InputValue value) {
    if (value == null || value.text.isEmpty)
      return 'Please enter a password.';
    return null;
  }

  FormField<InputValue> createField(
    {
      String labelText : '',
      InputValue initialValue : InputValue.empty,
      void onSaved(InputValue val),
      String hintText : '',
      int maxLines : 1,
      bool hideText : false,
      FormFieldValidator<InputValue> validator,
    }) {

    return new FormField<InputValue>(
      initialValue: initialValue,
      validator: validator,
      onSaved: onSaved,
      builder: (FormFieldState<InputValue> field) {
        return new Input(
          hintText: hintText,
          labelText: labelText,
          value: field.value,
          onChanged: field.onChanged,
          errorText: field.errorText,
          maxLines: maxLines,
          hideText: hideText,
        );
      },
    );
  }
}
