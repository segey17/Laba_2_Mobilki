import '../models/category.dart';
import '../models/unit.dart';
import 'temperature_service.dart';

class ConversionService {
  static double _convertByFactor(double value, Unit from, Unit to) {
    return value * from.toBase / to.toBase;
  }

  static double convert(CategoryType type, double value, Unit from, Unit to) {
    switch (type) {
      case CategoryType.temperature:
        return TemperatureService.convert(value, from.symbol, to.symbol);
      default:
        return _convertByFactor(value, from, to);
    }
  }
}
