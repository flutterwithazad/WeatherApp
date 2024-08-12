import 'package:flutter/material.dart';

class CardWidget extends StatelessWidget {
  final IconData icon;
  final String time;
  final String temperature;

  const CardWidget(
      {super.key,
      required this.icon,
      required this.temperature,
      required this.time});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120,
      child: Card(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(20), top: Radius.circular(20))),
        elevation: 6,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Text(
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                time,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 8,
              ),
              Icon(
                icon,
                size: 34,
              ),
              const SizedBox(
                height: 8,
              ),
              Text(temperature, style: const TextStyle(fontSize: 17)),
            ],
          ),
        ),
      ),
    );
  }
}
