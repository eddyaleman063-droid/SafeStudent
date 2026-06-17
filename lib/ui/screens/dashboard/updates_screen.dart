import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sagen/core/theme/app_colors.dart';
import 'package:sagen/models/update_entry.dart';

class UpdatesScreen extends ConsumerWidget {
  const UpdatesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entries = UpdateEntry.all();
    final grouped = _groupByMonth(entries);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Actualizaciones y novedades',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: context.textPrimary,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 80),
        itemCount: grouped.length,
        itemBuilder: (context, i) {
          final month = grouped.keys.elementAt(i);
          final items = grouped[month]!;
          return _MonthSection(month: month, entries: items);
        },
      ),
    );
  }

  Map<String, List<UpdateEntry>> _groupByMonth(List<UpdateEntry> entries) {
    final map = <String, List<UpdateEntry>>{};
    for (final e in entries) {
      final key = _monthKey(e.date);
      map.putIfAbsent(key, () => []).add(e);
    }
    return map;
  }

  String _monthKey(DateTime d) {
    const months = [
      'Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio',
      'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre',
    ];
    return '${months[d.month - 1]} ${d.year}';
  }
}

class _MonthSection extends StatelessWidget {
  final String month;
  final List<UpdateEntry> entries;

  const _MonthSection({required this.month, required this.entries});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 4),
          child: Text(
            month,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: context.textPrimary,
            ),
          ),
        ),
        ...entries.map((e) => _UpdateCard(entry: e)),
      ],
    );
  }
}

class _UpdateCard extends StatelessWidget {
  final UpdateEntry entry;

  const _UpdateCard({required this.entry});

  Color _typeColor(BuildContext context) {
    switch (entry.type) {
      case UpdateType.feature:
        return const Color(0xFF66BB6A);
      case UpdateType.improvement:
        return const Color(0xFF64B5F6);
      case UpdateType.fix:
        return const Color(0xFFFFB74D);
    }
  }

  IconData get _icon {
    switch (entry.type) {
      case UpdateType.feature:
        return Icons.auto_awesome_rounded;
      case UpdateType.improvement:
        return Icons.trending_up_rounded;
      case UpdateType.fix:
        return Icons.build_rounded;
    }
  }

  String get _typeLabel {
    switch (entry.type) {
      case UpdateType.feature:
        return 'NUEVA FUNCIÓN';
      case UpdateType.improvement:
        return 'MEJORA';
      case UpdateType.fix:
        return 'CORRECCIÓN';
    }
  }

  String get _formattedDate {
    const days = [
      'Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb', 'Dom'
    ];
    return '${days[entry.date.weekday - 1]}, ${entry.date.day}';
  }

  @override
  Widget build(BuildContext context) {
    final typeColor = _typeColor(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: context.shimmerBase,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: typeColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(_icon, color: typeColor, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          entry.title,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: context.textPrimary,
                          ),
                        ),
                      ),
                      if (entry.isNew)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 7, vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: typeColor.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            'NUEVO',
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                              color: typeColor,
                              letterSpacing: 0.8,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    entry.description,
                      style: TextStyle(
                        fontSize: 13,
                        color: context.textSecondary,
                        height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        _typeLabel,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: typeColor,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'v${entry.version}',
                        style: TextStyle(
                          fontSize: 11,
                          color: context.textTertiary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _formattedDate,
                        style: TextStyle(
                          fontSize: 11,
                          color: context.textTertiary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
