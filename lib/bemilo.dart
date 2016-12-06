import 'package:flutter/material.dart';
//import 'package:flutter/rendering.dart';

const double kFlexibleSpaceMaxHeight = 256.0;

final ThemeData kTheme = new ThemeData(
  brightness: Brightness.light,
  primarySwatch: Colors.teal,
  accentColor: Colors.redAccent[200],
);

FormField<InputValue> createInputField(
  {
    Key key,
    String labelText : '',
    InputValue initialValue : InputValue.empty,
    FormFieldSetter<InputValue> onSaved,
    FormFieldValidator<InputValue> validator,
    String hintText : '',
    int maxLines : 1,
    bool hideText : false,
    bool autofocus : false,
  }) {

  return new InputFormField(
    key: key,
    initialValue: initialValue,
    validator: validator,
    onSaved: onSaved,
    hintText: hintText,
    labelText: labelText,
    maxLines: maxLines,
    hideText: hideText,
    autofocus: autofocus,
  );

  // return new FormField<InputValue>(
  //   key: key,
  //   initialValue: initialValue,
  //   validator: validator,
  //   onSaved: onSaved,
  //   builder: (FormFieldState<InputValue> field) {
  //     return new Input(
  //       hintText: hintText,
  //       labelText: labelText,
  //       value: field.value,
  //       onChanged: field.onChanged,
  //       errorText: field.errorText,
  //       maxLines: maxLines,
  //       hideText: hideText,
  //       autofocus: autofocus,
  //     );
  //   },
  // );
}
