import 'package:flutter/material.dart';

class MainIcons extends StatelessWidget {
  const MainIcons({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(20.0),
          child: Image.asset(
            'assets/default_app_icon.png',
            width: 140,
            height: 140,
          ),
        ),
        const Text(
          'LAVA',
          style: TextStyle(
            fontSize: 40,
            color: Color(0xFF05416D),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
