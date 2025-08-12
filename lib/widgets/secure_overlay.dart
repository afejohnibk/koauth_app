import 'package:flutter/material.dart';

class SecureOverlay extends StatelessWidget {
  const SecureOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black, // Use dark overlay
      alignment: Alignment.center,
      child: const Text(
        'CoalAuth Locked',
        style: TextStyle(color: Colors.white, fontSize: 24),
      ),
    );
  }
}
