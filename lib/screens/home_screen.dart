import 'package:flutter/material.dart';
import '../models/category.dart';
import '../models/unit.dart';
import 'converter_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  List<Category> _buildCategories() {
    final lengthUnits = [
      const Unit(id: 'mm', name: 'Миллиметр', symbol: 'мм', toBase: 0.001),
      const Unit(id: 'cm', name: 'Сантиметр', symbol: 'см', toBase: 0.01),
      const Unit(id: 'm', name: 'Метр', symbol: 'м', toBase: 1.0),
      const Unit(id: 'km', name: 'Километр', symbol: 'км', toBase: 1000.0),
      const Unit(id: 'mi', name: 'Миля', symbol: 'mi', toBase: 1609.344),
    ];

    final massUnits = [
      const Unit(id: 'g', name: 'Грамм', symbol: 'г', toBase: 0.001),
      const Unit(id: 'kg', name: 'Килограмм', symbol: 'кг', toBase: 1.0),
      const Unit(id: 't', name: 'Тонна', symbol: 'т', toBase: 1000.0),
      const Unit(id: 'lb', name: 'Фунт', symbol: 'lb', toBase: 0.45359237),
    ];

    final areaUnits = [
      const Unit(id: 'm2', name: 'Квадратный метр', symbol: 'м²', toBase: 1.0),
      const Unit(id: 'km2', name: 'Квадратный километр', symbol: 'км²', toBase: 1e6),
      const Unit(id: 'ha', name: 'Гектар', symbol: 'га', toBase: 1e4),
      const Unit(id: 'ac', name: 'Акр', symbol: 'ac', toBase: 4046.8564224),
    ];

    final volumeUnits = [
      const Unit(id: 'ml', name: 'Миллилитр', symbol: 'мл', toBase: 1e-6),
      const Unit(id: 'l', name: 'Литр', symbol: 'л', toBase: 1e-3),
      const Unit(id: 'm3', name: 'Кубический метр', symbol: 'м³', toBase: 1.0),
      const Unit(id: 'gal', name: 'Галлон (US)', symbol: 'gal', toBase: 0.003785411784),
    ];

    final temperatureUnits = [
      const Unit(id: 'c', name: 'Цельсий', symbol: '°C', toBase: 1.0),
      const Unit(id: 'f', name: 'Фаренгейт', symbol: '°F', toBase: 1.0),
      const Unit(id: 'k', name: 'Кельвин', symbol: 'K', toBase: 1.0),
    ];

    final currencyUnits = [
      const Unit(id: 'usd', name: 'Доллар США', symbol: 'USD', toBase: 1.0),
      const Unit(id: 'eur', name: 'Евро', symbol: 'EUR', toBase: 1.09),
      const Unit(id: 'rub', name: 'Рубль', symbol: 'RUB', toBase: 0.011),
      const Unit(id: 'gbp', name: 'Фунт стерлингов', symbol: 'GBP', toBase: 1.26),
      const Unit(id: 'jpy', name: 'Иена', symbol: 'JPY', toBase: 0.007),
    ];

    return [
      Category(id: 'length', name: 'Длина', icon: Icons.straighten, type: CategoryType.linear, units: lengthUnits),
      Category(id: 'mass', name: 'Масса', icon: Icons.fitness_center, type: CategoryType.mass, units: massUnits),
      Category(id: 'temperature', name: 'Температура', icon: Icons.device_thermostat, type: CategoryType.temperature, units: temperatureUnits),
      Category(id: 'area', name: 'Площадь', icon: Icons.square_foot, type: CategoryType.area, units: areaUnits),
      Category(id: 'volume', name: 'Объём', icon: Icons.water, type: CategoryType.volume, units: volumeUnits),
      Category(id: 'currency', name: 'Валюта (офлайн)', icon: Icons.attach_money, type: CategoryType.currency, units: currencyUnits),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final categories = _buildCategories();
    return Scaffold(
      appBar: AppBar(title: const Text('Converter')),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemBuilder: (context, index) {
          final c = categories[index];
          return Card(
            elevation: 0,
            color: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: ListTile(
              leading: Icon(c.icon, size: 28),
              title: Text(c.name, style: const TextStyle(fontWeight: FontWeight.w600)),
              subtitle: Text(
                c.id == 'currency'
                    ? 'База: 1 ${c.units.first.symbol}, курсы офлайн'
                    : 'Единиц: ${c.units.length}',
              ),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => ConverterScreen(category: c),
                  ),
                );
              },
            ),
          );
        },
        separatorBuilder: (context, _) => const SizedBox(height: 12),
        itemCount: categories.length,
      ),
    );
  }
}
