import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../models/category.dart';
import '../models/unit.dart';
import '../services/conversion_service.dart';
import '../services/temperature_service.dart';
import '../widgets/unit_selector.dart';
import '../widgets/numeric_keyboard.dart';

class ConverterScreen extends StatefulWidget {
  final Category category;
  const ConverterScreen({super.key, required this.category});

  @override
  State<ConverterScreen> createState() => _ConverterScreenState();
}

class _ConverterScreenState extends State<ConverterScreen> {
  late Unit _from;
  late Unit _to;
  final TextEditingController _controller = TextEditingController();
  final FocusNode _inputFocus = FocusNode();
  String? _error;
  double? _result;

  bool get _allowsNegative =>
      widget.category.type == CategoryType.temperature ||
      widget.category.type == CategoryType.currency;

  void _appendDigit(String d) {
    setState(() {
      final t = _controller.text;
      _controller.text = t + d;
      _controller.selection = TextSelection.fromPosition(
        TextPosition(offset: _controller.text.length),
      );
      _recompute();
    });
  }

  void _appendDot() {
    setState(() {
      final t = _controller.text;
      if (t.isEmpty) {
        _controller.text = '0.';
      } else if (!t.contains('.')) {
        _controller.text = '$t.';
      }
      _controller.selection = TextSelection.fromPosition(
        TextPosition(offset: _controller.text.length),
      );
      _recompute();
    });
  }

  void _backspace() {
    setState(() {
      final t = _controller.text;
      if (t.isNotEmpty) {
        _controller.text = t.substring(0, t.length - 1);
      }
      _controller.selection = TextSelection.fromPosition(
        TextPosition(offset: _controller.text.length),
      );
      _recompute();
    });
  }

  void _clear() {
    setState(() {
      _controller.clear();
      _error = null;
      _result = 0;
    });
  }

  void _toggleSign() {
    if (!_allowsNegative) return;
    setState(() {
      final t = _controller.text;
      if (t.startsWith('-')) {
        _controller.text = t.substring(1);
      } else {
        _controller.text = '-$t';
      }
      _controller.selection = TextSelection.fromPosition(
        TextPosition(offset: _controller.text.length),
      );
      _recompute();
    });
  }

  @override
  void initState() {
    super.initState();
    _from = widget.category.units.first;
    _to = widget.category.units[1];
    _recompute();
  }

  @override
  void dispose() {
    _controller.dispose();
    _inputFocus.dispose();
    super.dispose();
  }

  void _swapUnits() {
    setState(() {
      final tmp = _from;
      _from = _to;
      _to = tmp;
      _recompute();
    });
  }

  void _recompute() {
    _error = null;

    double value = 0;
    final text = _controller.text;
    if (text.isNotEmpty && text != '-') {
      final parsed = double.tryParse(text);
      if (parsed == null) {
        _error = 'Некорректный ввод';
        setState(() => _result = null);
        return;
      }
      value = parsed;
    }

    if (!_allowsNegative && value < 0) {
      _error = 'Значение не может быть отрицательным для этой величины';
      _result = null;
      return;
    }

    if (widget.category.type == CategoryType.temperature) {
      final k = TemperatureService.toKelvin(value, _from.symbol);
      if (k < 0) {
        _error = 'Невозможно: ниже абсолютного нуля (0 K)';
        _result = null;
        return;
      }
    }

    final res =
        ConversionService.convert(widget.category.type, value, _from, _to);
    _result = res;
  }

  String _formatDouble(double v) {
    var s = v.toStringAsFixed(10);
    s = s.replaceFirst(RegExp(r'0+$'), '');
    s = s.replaceFirst(RegExp(r'\.$'), '');
    return s;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category.name),
        actions: [
          IconButton(
            tooltip: 'Поменять местами',
            icon: const Icon(Icons.swap_horiz),
            onPressed: _swapUnits,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              elevation: 0,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Исходное значение (${_from.symbol})',
                        style: theme.textTheme.titleMedium),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _controller,
                      focusNode: _inputFocus,
                      keyboardType: TextInputType.numberWithOptions(
                        decimal: true,
                        signed: _allowsNegative,
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(_allowsNegative
                              ? r'^-?\d*\.?\d*$'
                              : r'^\d*\.?\d*$'),
                        ),
                      ],
                      onChanged: (_) => setState(_recompute),
                      decoration: InputDecoration(
                        hintText: '0',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)),
                        filled: true,
                        fillColor: const Color(0xFFFDFDFD),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            setState(() {
                              _controller.clear();
                              _error = null;
                              _result = 0;
                            });
                          },
                        ),
                      ),
                      style: theme.textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 16),
                    Text('Результат (${_to.symbol})',
                        style: theme.textTheme.titleMedium),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFE0E0E0)),
                        color: const Color(0xFFFDFDFD),
                      ),
                      child: Text(
                        _error != null
                            ? '—'
                            : _formatDouble((_result ?? 0)),
                        style: theme.textTheme.headlineSmall
                            ?.copyWith(color: _error != null ? Colors.red : null),
                      ),
                    ),
                    if (_error != null) ...[
                      const SizedBox(height: 8),
                      Text(_error!, style: const TextStyle(color: Colors.red)),
                    ]
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            UnitSelector(
              units: widget.category.units,
              selectedFrom: _from,
              selectedTo: _to,
              onFromChanged: (u) => setState(() {
                _from = u;
                _recompute();
              }),
              onToChanged: (u) => setState(() {
                _to = u;
                _recompute();
              }),
              showRates: widget.category.type == CategoryType.currency,
              baseSymbol: widget.category.type == CategoryType.currency
                  ? widget.category.units.first.symbol
                  : '',
            ),
            const SizedBox(height: 12),
            if (kIsWeb)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: NumericKeyboard(
                  onDigit: _appendDigit,
                  onBackspace: _backspace,
                  onClear: _clear,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
