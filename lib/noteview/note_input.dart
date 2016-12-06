import 'package:flutter/material.dart';
import '../db/db.dart';
import '../db/note.dart';

class NoteInputView extends StatefulWidget {
  NoteInputView({ this.note, Key key }) : super(key: key);

  static const String routeName = '/note-input';
  final Note note;

  @override
  _NoteInputViewState createState() => new _NoteInputViewState(note);
}


class _NoteInputViewState extends State<NoteInputView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  Note _info = new Note();

  _NoteInputViewState(Note original) {
    if (original != null) {
      _info = original.clone();
    } else {
      _info = new Note()..id = -1;
    }
  }

  void showInSnackBar(String value) {
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: new Text(value)
    ));
  }


  void _handleSubmitted(BuildContext context) {
    FormState form = _formKey.currentState;
    if (form.hasErrors) {
      showInSnackBar('Please fix the errors in red before submitting.');
    } else {
      form.save();

      if (_info.id < 0) {
        addNoteAction(new AddNote()
          ..time = new DateTime.now()
          ..title = _info.title
          ..content = _info.content
          ..tags = _info.tags
        );
      } else {
        editNoteAction(new EditNote()
          ..id = _info.id
          ..time = new DateTime.now()
          ..title = _info.title
          ..content = _info.content
          ..tags = _info.tags
        );
      }

      //showInSnackBar('${person.name}\'s phone number is ${person.phoneNumber}');
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
        title: new Text(_info.id < 0 ? 'Add' : 'Edit')
      ),
      body: new Form(
        key: _formKey,
        child: new Block(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          children: <Widget>[
            createField(
              labelText: 'Title',
              initialValue: _info.id < 0 ? InputValue.empty : new InputValue(text:_info.title ?? ''),
              onSaved: (InputValue val) { _info.title = val.text; },
            ),
            createField(
              labelText: 'Content',
              initialValue: _info.id < 0 ? InputValue.empty : new InputValue(text:_info.content ?? ''),
              maxLines: 6,
              onSaved: (InputValue val) { _info.content = val.text; },
            ),
            createField(
              labelText: 'Tags',
              hintText: ', seprated tags',
              initialValue: _info.id < 0 ? InputValue.empty : new InputValue(text:_info.tags ?? ''),
              onSaved: (InputValue val) { _info.tags = val.text; },
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

  FormField<InputValue> createField(
    {
      String labelText : '',
      InputValue initialValue : InputValue.empty,
      void onSaved(InputValue val),
      String hintText : '',
      int maxLines : 1,
    }) {

    return new FormField<InputValue>(
      initialValue: initialValue,
      onSaved: onSaved,
      builder: (FormFieldState<InputValue> field) {
        return new Input(
          hintText: hintText,
          labelText: labelText,
          value: field.value,
          onChanged: field.onChanged,
          errorText: field.errorText,
          maxLines: maxLines,
        );
      },
    );
  }
}
