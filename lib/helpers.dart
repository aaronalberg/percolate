import 'package:flutter/material.dart';
import 'taskcreate.dart';
import 'task.dart';

enum Category {
  Friends(cardColor: Color(0xffd9d2e9), headerColor: Color(0xffb4a7d6)),
  Home(cardColor: Color(0xfff4cccc), headerColor: Color(0xffea9999)),
  Work(cardColor: Color(0xffd9ead3), headerColor: Color(0xffb6d7a8)),
  Misc(cardColor: Color(0xfffff2cc), headerColor: Color(0xffffe599));

  const Category({required this.cardColor, required this.headerColor});

  final Color cardColor;
  final Color headerColor;
}

Icon matchCatStringToIcon(String cat) {
  switch (cat) {
    case "Friends":
      return Icon(Icons.people);
    case "Home":
      return Icon(Icons.house);
    case "Work":
      return Icon(Icons.work);
    default:
      return Icon(Icons.lightbulb);
  }
}

Category matchCatFromString(String cat) {
  switch (cat) {
    case "Friends":
      return Category.Friends;
    case "Home":
      return Category.Home;
    case "Work":
      return Category.Work;
    default:
      return Category.Misc;
  }
}