import 'package:flutter/material.dart';

Map<String, Color> colorMap = {
  'red': Colors.red,
  'purple': Colors.purple,
  'lightGreen': Colors.lightGreen,
  'amber': Colors.amber,
  'blue': Colors.blue,
  'green': Colors.green,
  'lightBlue': Colors.lightBlue,
  'orange': Colors.orange,
  'pink': Colors.pink,
  'teal': Colors.teal,
};

class Category {
  const Category({
    required this.id,
    required this.title,
    this.color = Colors.orange,
  });

  final String id;
  final String title;
  final Color color;

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      title: json['title'],
      color: colorMap[json['color']]!,
    );
  }
}
