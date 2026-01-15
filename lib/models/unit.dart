import 'package:flutter/foundation.dart';

@immutable
class Unit {
  final String id;
  final String name;
  final String symbol;
  final double toBase;

  const Unit({
    required this.id,
    required this.name,
    required this.symbol,
    required this.toBase,
  });
}
