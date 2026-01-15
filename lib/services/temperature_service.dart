class TemperatureService {
  static double toKelvin(double value, String symbol) {
    switch (symbol) {
      case '°C':
        return value + 273.15;
      case '°F':
        return (value + 459.67) * 5 / 9;
      case 'K':
        return value;
      default:
        throw ArgumentError('Неизвестная температурная единица: $symbol');
    }
  }

  static double fromKelvin(double kelvin, String symbol) {
    switch (symbol) {
      case '°C':
        return kelvin - 273.15;
      case '°F':
        return kelvin * 9 / 5 - 459.67;
      case 'K':
        return kelvin;
      default:
        throw ArgumentError('Неизвестная температурная единица: $symbol');
    }
  }

  static double convert(double value, String fromSymbol, String toSymbol) {
    final k = toKelvin(value, fromSymbol);
    return fromKelvin(k, toSymbol);
  }
}
