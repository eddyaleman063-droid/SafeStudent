import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sagen/core/theme/theme_constants.dart';
import 'package:sagen/providers/providers.dart';

class ThemeSelector extends ConsumerWidget {
  final bool dark;
  const ThemeSelector({super.key, required this.dark});

  static const _options = [
    ThemeOption(value: ThemeMode.system, label: 'Sistema', icon: Icons.settings_brightness_rounded),
    ThemeOption(value: ThemeMode.light, label: 'Claro', icon: Icons.light_mode_rounded),
    ThemeOption(value: ThemeMode.dark, label: 'Oscuro', icon: Icons.dark_mode_rounded),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final effectiveMode = ref.watch(themeProvider.select((t) => t.effectiveMode));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tema',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: dark ? Colors.white.withValues(alpha: 0.7) : Colors.black54,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Row(
          children: _options.map((opt) {
            final selected = effectiveMode == opt.value;
            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(right: opt == _options.last ? 0 : AppSpacing.sm),
                child: GestureDetector(
                  onTap: () => ref.read(themeProvider.notifier).setMode(opt.value),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(AppRadius.lg),
                      color: selected
                          ? PremiumColors.primary
                          : (dark ? Colors.white.withValues(alpha: 0.06) : Colors.black.withValues(alpha: 0.04)),
                      border: Border.all(
                        color: selected
                            ? PremiumColors.primary
                            : (dark ? Colors.white12 : Colors.black.withValues(alpha: 0.08)),
                      ),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          opt.icon,
                          size: 20,
                          color: selected ? Colors.white : (dark ? Colors.white54 : Colors.black45),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          opt.label,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
                            color: selected
                                ? Colors.white
                                : (dark ? Colors.white54 : Colors.black45),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class ThemeOption {
  final ThemeMode value;
  final String label;
  final IconData icon;
  const ThemeOption({required this.value, required this.label, required this.icon});
}
