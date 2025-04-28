import 'package:flutter/material.dart';

class NumberCard extends StatelessWidget {
  final int value;
  final VoidCallback onTap;

  const NumberCard({
    super.key, // use super parameter
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final textScaler = MediaQuery.of(context).textScaler;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          constraints: const BoxConstraints(minHeight: 56),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          alignment: Alignment.center,
          child: Text(
            value.toString(),
            style: TextStyle(
              fontSize: textScaler.scale(32),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
