import 'package:flutter/material.dart';

class CardContainer extends StatelessWidget {
  final Widget child;

  const CardContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: cardDecoration(),
        child: child,
      ),
    );
  }
}

BoxDecoration cardDecoration() => BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),  
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 8, offset: Offset(0, 4)), // Sombra más suave
        ]);
