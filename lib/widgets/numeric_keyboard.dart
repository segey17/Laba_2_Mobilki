import 'package:flutter/material.dart';

class NumericKeyboard extends StatelessWidget {
  final void Function(String digit) onDigit;
  final VoidCallback onBackspace;
  final VoidCallback onClear;

  const NumericKeyboard({
    super.key,
    required this.onDigit,
    required this.onBackspace,
    required this.onClear,
  });

  Widget _tile(BuildContext context, {String? label, IconData? icon, VoidCallback? onTap}) {
    final theme = Theme.of(context);
    final child = icon != null
        ? Icon(icon, size: 14, color: const Color(0xFF2C3E50))
        : Text(
            label ?? '',
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w600,
              fontSize: 12,
              color: const Color(0xFF2C3E50),
            ),
          );
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: SizedBox.expand(
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: const Color(0xFFF2F4F5),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: const Color(0xFFE1E5E8)),
          ),
          child: child,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cells = <Widget>[
      _tile(context, label: '1', onTap: () => onDigit('1')),
      _tile(context, label: '2', onTap: () => onDigit('2')),
      _tile(context, label: '3', onTap: () => onDigit('3')),
      _tile(context, label: '4', onTap: () => onDigit('4')),
      _tile(context, label: '5', onTap: () => onDigit('5')),
      _tile(context, label: '6', onTap: () => onDigit('6')),
      _tile(context, label: '7', onTap: () => onDigit('7')),
      _tile(context, label: '8', onTap: () => onDigit('8')),
      _tile(context, label: '9', onTap: () => onDigit('9')),
      _tile(context, label: 'C', onTap: onClear),
      _tile(context, label: '0', onTap: () => onDigit('0')),
      _tile(context, icon: Icons.backspace_outlined, onTap: onBackspace),
    ];

    return GridView.custom(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 4,
        mainAxisSpacing: 4,
        mainAxisExtent: 32,
      ),
      childrenDelegate: SliverChildListDelegate(cells),
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
    );
  }
}
