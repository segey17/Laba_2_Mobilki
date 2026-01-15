import 'package:flutter/material.dart';
import '../models/unit.dart';

class UnitSelector extends StatelessWidget {
  final List<Unit> units;
  final Unit selectedFrom;
  final Unit selectedTo;
  final ValueChanged<Unit> onFromChanged;
  final ValueChanged<Unit> onToChanged;
  final bool showRates;
  final String baseSymbol;

  const UnitSelector({
    super.key,
    required this.units,
    required this.selectedFrom,
    required this.selectedTo,
    required this.onFromChanged,
    required this.onToChanged,
    this.showRates = false,
    this.baseSymbol = '',
  });

  String _formatRate(double v) {
    if (v >= 100) return v.toStringAsFixed(0);
    if (v >= 1) return v.toStringAsFixed(2);
    if (v >= 0.1) return v.toStringAsFixed(3);
    return v.toStringAsFixed(4);
  }

  DropdownButton<Unit> _dropdown(Unit selected, ValueChanged<Unit> onChanged) {
    return DropdownButton<Unit>(
      value: selected,
      isExpanded: true,
      items: units
          .map((u) {
            final label = showRates
                ? '${u.name} (${u.symbol} • ${_formatRate(u.toBase)} $baseSymbol)'
                : '${u.name} (${u.symbol})';
            return DropdownMenuItem<Unit>(
              value: u,
              child: Text(label, overflow: TextOverflow.ellipsis),
            );
          })
          .toList(),
      onChanged: (u) {
        if (u != null) onChanged(u);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(child: _dropdown(selectedFrom, onFromChanged)),
        const SizedBox(width: 12),
        const Icon(Icons.arrow_forward, size: 24),
        const SizedBox(width: 12),
        Expanded(child: _dropdown(selectedTo, onToChanged)),
      ],
    );
  }
}
