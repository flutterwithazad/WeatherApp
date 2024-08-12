import 'package:flutter/material.dart';

class AdditionalInformation extends StatelessWidget {
  final String numberData;
  final String unitData;
  final IconData icon;
  const AdditionalInformation({
    super.key,
    required this.numberData,
    required this.unitData,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Icon(
              icon,
              size: 38,
            ),
            const SizedBox(height: 8),
            Text(
              unitData,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              numberData.toString(),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
