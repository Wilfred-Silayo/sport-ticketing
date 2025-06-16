import 'package:flutter/material.dart';

class CustomRow extends StatelessWidget {
  final int seats;
  const CustomRow({super.key, required this.seats});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const ColoredBox(
          color: Colors.red,
          child: SizedBox(
            height: 20,
            width: 20,
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        const Text('Sold'),
        const SizedBox(width: 40),
        const ColoredBox(
          color: Colors.green,
          child: SizedBox(
            height: 20,
            width: 20,
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        const Text('Available'),
        const SizedBox(
          width: 40,
        ),
        const Icon(
          Icons.chair,
          size: 25,
        ),
        const SizedBox(
          width: 10,
        ),
        Text("$seats"),
      ],
    );
  }
}
