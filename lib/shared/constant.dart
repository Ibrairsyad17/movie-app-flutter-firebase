import 'package:flutter/material.dart';

dynamic textFieldDecorate = InputDecoration(
  contentPadding: EdgeInsets.all(15.0),
  enabledBorder: const OutlineInputBorder(
    borderSide: BorderSide(width: 2, color: Colors.red),
    borderRadius: BorderRadius.all(Radius.circular(10))
  ),
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(12.0),
    borderSide: const BorderSide(width: 2, color: Colors.red) 
  ),
  labelStyle: TextStyle(
    color: Colors.red[800],
    fontSize: 15.0
  )
);