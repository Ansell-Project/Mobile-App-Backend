import 'package:flutter/material.dart';

class PerformanceMeter extends StatelessWidget {
  final int value; // Expected 0 to 100

  const PerformanceMeter({super.key, required this.value});

  @override
  Widget build(BuildContext context) {
    // Clamp the value to ensure it's between 0 and 100
    final double progress = (value.clamp(0, 100)) / 100;

    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Circular progress
          SizedBox(
            width: 70,
            height: 70,
            child: CircularProgressIndicator(
              value: progress,
              strokeWidth: 5,
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF11493E)),
              backgroundColor: Colors.transparent,
            ),
          ),
          // Center percentage text
          Text(
            '$value%',
            style: const TextStyle(
              fontSize: 20,
              color: Colors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
