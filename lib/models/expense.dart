import 'package:flutter/material.dart';
// import 'package:uuid/uuid.dart';
//
// const uuid = Uuid();

enum Category {
  Food,
  Travel,
  Transportation,
  Entertainment,
  Clothing,
  Medical,
  Other
}

const Map<Category, IconData> categoryIcons = {
  Category.Food: Icons.fastfood_rounded,
  Category.Travel: Icons.flight_rounded,
  Category.Transportation: Icons.directions_car_rounded,
  Category.Entertainment: Icons.movie_rounded,
  Category.Clothing: Icons.shopping_bag_rounded,
  Category.Medical: Icons.medical_services_rounded,
  Category.Other: Icons.more_horiz_rounded
};

class Expense {
  String id;
  final String title;
  final double amount;
  final DateTime date;
  final TimeOfDay time;
  final Category category;

  Expense({
    required this.id,
    required this.title,
    required this.amount,
    required this.date,
    required this.category,
    this.time = const TimeOfDay(hour: 10, minute: 10),
  });
  get formattedDate {
    return '${date.day}/${date.month}/${date.year}';
  }

  get formattedTime {
    return '${time.hour}:${time.minute}';
  }
}
