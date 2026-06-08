import 'package:flutter/material.dart';
import 'package:sagen/core/theme/theme_constants.dart';

class EmptyChat extends StatelessWidget {
  final bool dark;
  const EmptyChat({super.key, required this.dark});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(colors: PremiumColors.gradientSage),
            ),
            child: const Icon(Icons.auto_awesome_rounded, size: 36, color: Colors.white),
          ),
          const SizedBox(height: AppSpacing.xl),
          Text(
            'Pregunta a Sage',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: dark ? Colors.white.withValues(alpha: 0.8) : Colors.black87,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl * 2),
            child: Text(
              'Escribe cualquier duda sobre ciberseguridad o elige una sugerencia rapida.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: dark ? Colors.white38 : Colors.black45),
            ),
          ),
        ],
      ),
    );
  }
}
