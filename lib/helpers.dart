import 'package:flutter/material.dart';

Icon matchCatToIcon(String cat) {
  switch (cat) {
    case "Friend":
      return Icon(Icons.people);
    case "Home":
      return Icon(Icons.house);
    case "Work":
      return Icon(Icons.work);
    default:
      return Icon(Icons.lightbulb);
  }
}