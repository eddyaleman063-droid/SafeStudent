import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sagen/ui/widgets/gem_painter.dart';
import 'package:sagen/ui/widgets/animations/gem_rain_animation.dart';

void main() {
  group('GemPainter', () {
    test('shouldRepaint returns true when color changes', () {
      final p1 = GemPainter(color: Colors.blue);
      final p2 = GemPainter(color: Colors.red);
      expect(p1.shouldRepaint(p2), isTrue);
    });

    test('shouldRepaint returns true when shine changes', () {
      final p1 = GemPainter(shine: 0.5);
      final p2 = GemPainter(shine: 1.0);
      expect(p1.shouldRepaint(p2), isTrue);
    });

    test('shouldRepaint returns false when nothing changes', () {
      final p = GemPainter(color: const Color(0xFF4FC3F7), shine: 1.0);
      expect(p.shouldRepaint(p), isFalse);
    });

    test('paint does not throw', () {
      final painter = GemPainter(color: Colors.amber, shine: 0.8);
      final canvas = Canvas(
        ui.PictureRecorder(),
        const Rect.fromLTWH(0, 0, 50, 55),
      );
      expect(
        () => painter.paint(canvas, const Size(50, 55)),
        returnsNormally,
      );
    });

    test('paint handles zero shine', () {
      final painter = GemPainter(color: Colors.amber, shine: 0);
      final canvas = Canvas(
        ui.PictureRecorder(),
        const Rect.fromLTWH(0, 0, 30, 33),
      );
      expect(
        () => painter.paint(canvas, const Size(30, 33)),
        returnsNormally,
      );
    });
  });

  group('GemShape', () {
    testWidgets('renders with default parameters', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: SizedBox(child: GemShape())),
      );

      expect(find.byType(GemShape), findsOneWidget);
    });

    testWidgets('renders with custom color and size', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: SizedBox(
            child: GemShape(size: 40, color: Colors.purple, shine: 0.5),
          ),
        ),
      );

      final gemShape = tester.widget<GemShape>(find.byType(GemShape));
      expect(gemShape.color, Colors.purple);
      expect(gemShape.shine, 0.5);
      expect(gemShape.size, 40);
    });
  });

  group('GroundCrackPainter', () {
    test('paint does not throw with sinkT = 0', () {
      final painter = GroundCrackPainter(sinkT: 0);
      final canvas = Canvas(
        ui.PictureRecorder(),
        const Rect.fromLTWH(0, 0, 300, 200),
      );
      expect(
        () => painter.paint(canvas, const Size(300, 200)),
        returnsNormally,
      );
    });

    test('paint does not throw with sinkT = 0.5', () {
      final painter = GroundCrackPainter(sinkT: 0.5);
      final canvas = Canvas(
        ui.PictureRecorder(),
        const Rect.fromLTWH(0, 0, 300, 200),
      );
      expect(
        () => painter.paint(canvas, const Size(300, 200)),
        returnsNormally,
      );
    });

    test('paint does not throw with sinkT = 1.0', () {
      final painter = GroundCrackPainter(sinkT: 1.0);
      final canvas = Canvas(
        ui.PictureRecorder(),
        const Rect.fromLTWH(0, 0, 300, 200),
      );
      expect(
        () => painter.paint(canvas, const Size(300, 200)),
        returnsNormally,
      );
    });

    test('shouldRepaint returns true when sinkT changes', () {
      final p1 = GroundCrackPainter(sinkT: 0.2);
      final p2 = GroundCrackPainter(sinkT: 0.8);
      expect(p1.shouldRepaint(p2), isTrue);
    });

    test('shouldRepaint returns false when sinkT same', () {
      final p = GroundCrackPainter(sinkT: 0.5);
      expect(p.shouldRepaint(p), isFalse);
    });
  });
}
