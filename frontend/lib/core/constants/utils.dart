import 'package:flutter/material.dart';

@Deprecated('Use .a.')
Color strengthenColor(Color color, double factor) {
  int r = (color.r * factor).clamp(0, 255).toInt();
  int g = (color.g * factor).clamp(0, 255).toInt();
  int b = (color.b * factor).clamp(0, 255).toInt();

  return Color.fromARGB(color.alpha, r, g, b);
}

List<DateTime> generateWeekDates(int weekOffSet) {
  final today = DateTime.now();
  DateTime startOfWeek = today.subtract(Duration(days: today.weekday - 1));
  startOfWeek = startOfWeek.add(Duration(days: weekOffSet * 7));

  return List.generate(7, (index) => startOfWeek.add(Duration(days: index)));
}