import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sagen/l10n/app_localizations.dart';

class FlexCardWidget extends ConsumerStatefulWidget {
  final String displayName;
  final String? photoUrl;
  final int level;
  final int xp;
  final int streak;
  final int? rank;
  final String? subtitleText;

  const FlexCardWidget({
    super.key,
    required this.displayName,
    this.photoUrl,
    required this.level,
    required this.xp,
    required this.streak,
    this.rank,
    this.subtitleText,
  });

  @override
  ConsumerState<FlexCardWidget> createState() => FlexCardWidgetState();
}

class FlexCardWidgetState extends ConsumerState<FlexCardWidget> {
  final _repaintKey = GlobalKey();

  Future<Uint8List?> capture() async {
    try {
      final boundary = _repaintKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      if (boundary == null) return null;
      final image = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      return byteData?.buffer.asUint8List();
    } catch (e) {
      return null;
    }
  }

  String get _initials {
    final parts = widget.displayName.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
    }
    return widget.displayName.isNotEmpty ? widget.displayName[0].toUpperCase() : '?';
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return RepaintBoundary(
      key: _repaintKey,
      child: Container(
        width: 360,
        height: 640,
        decoration: const BoxDecoration(
          color: Color(0xFF1B2433),
          gradient: RadialGradient(
            center: Alignment.topCenter,
            radius: 1.2,
            colors: [
              Color(0x334AC2DD),
              Color(0xFF1B2433),
              Color(0xFF1B2433),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            children: [
              const Spacer(flex: 2),
              CircleAvatar(
                radius: 48,
                backgroundColor: const Color(0xFF253145),
                backgroundImage: widget.photoUrl != null ? NetworkImage(widget.photoUrl!) : null,
                child: widget.photoUrl == null
                    ? Text(_initials, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white))
                    : null,
              ),
              const SizedBox(height: 16),
              Text(
                widget.displayName,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 0.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: const Color(0x334AC2DD),
                  border: Border.all(color: const Color(0x664AC2DD)),
                ),
                child: Text(
                  l.profileLevelValue(widget.level),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF4AC2DD),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.local_fire_department_rounded, color: Color(0xFFFF6D00), size: 24),
                  const SizedBox(width: 8),
                  Text(
                    '${widget.streak}',
                    style: const TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFFF6D00),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    widget.streak == 1 ? l.profileDay : l.profileDays,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.white.withValues(alpha: 0.5),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.auto_awesome_rounded, color: Color(0xFF7C3AED), size: 18),
                  const SizedBox(width: 6),
                  Text(
                    '${widget.xp} XP',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF7C3AED),
                    ),
                  ),
                ],
              ),
              if (widget.rank != null) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: const Color(0x33FFD700),
                    border: Border.all(color: const Color(0x44FFD700)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.emoji_events_rounded, color: Color(0xFFFFD700), size: 16),
                      const SizedBox(width: 6),
                      Text(
                        l.rankingPosition(widget.rank!),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFFFFD700),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              const Spacer(flex: 3),
              Text(
                widget.subtitleText ?? l.flexCardJoinAlliance,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.white.withValues(alpha: 0.35),
                  letterSpacing: 1.0,
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
