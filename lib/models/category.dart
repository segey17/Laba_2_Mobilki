import 'package:flutter/material.dart';
import 'unit.dart';

enum CategoryType {
  linear,
  area,
  volume,
  mass,
  temperature,
  currency,
}

@immutable
class Category {
  final String id;
  final String name;
  final IconData icon;
  final CategoryType type;
  final List<Unit> units;

  const Category({
    required this.id,
    required this.name,
    required this.icon,
    required this.type,
    required this.units,
  });
}
