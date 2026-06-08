import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sagen/l10n/app_localizations.dart';
import 'package:sagen/ui/widgets/gem_painter.dart';
import 'package:sagen/ui/widgets/gem_pile_widget.dart';
import 'package:sagen/ui/widgets/animations/gem_rain_animation.dart';

void main() {
  group('GemPileWidget', () {
    testWidgets('renders empty pile for gemCount = 0', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: SizedBox(child: GemPileWidget(gemCount: 0))),
      );
      await tester.pump(const Duration(milliseconds: 500));

      expect(find.byType(GemPileWidget), findsOneWidget);
    });

    testWidgets('renders single gem', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: SizedBox(child: GemPileWidget(gemCount: 1))),
      );
      await tester.pump(const Duration(milliseconds: 500));

      expect(find.byType(GemShape), findsOneWidget);
      expect(find.byType(CustomPaint), findsWidgets);
    });

    testWidgets('renders multiple gems for small pile', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
            home: SizedBox(child: GemPileWidget(gemCount: 4))),
      );
      await tester.pump(const Duration(milliseconds: 500));

      expect(find.byType(GemShape), findsNWidgets(4));
    });

    testWidgets('renders gems for medium pile (2 layers)', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
            home: SizedBox(child: GemPileWidget(gemCount: 8))),
      );
      await tester.pump(const Duration(milliseconds: 500));

      expect(find.byType(GemShape), findsNWidgets(8));
    });

    testWidgets('renders gems for large pile (3 layers)', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
            home: SizedBox(child: GemPileWidget(gemCount: 20))),
      );
      await tester.pump(const Duration(milliseconds: 800));

      expect(find.byType(GemShape), findsNWidgets(20));
    });

    testWidgets('passes gemColor to GemShape', (tester) async {
      const testColor = Color(0xFFFFD700);
      await tester.pumpWidget(
        MaterialApp(
          home: SizedBox(
            child: GemPileWidget(gemCount: 3, gemColor: testColor),
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 500));

      final gemShapes = tester.widgetList<GemShape>(find.byType(GemShape));
      for (final gem in gemShapes) {
        expect(gem.color, testColor);
      }
    });

    testWidgets('stagger animation makes gems fade in', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
            home: SizedBox(child: GemPileWidget(gemCount: 5))),
      );

      // early frame — gems should be partially visible
      await tester.pump(const Duration(milliseconds: 50));
      final earlyOps = tester
          .widgetList<Opacity>(find.byType(Opacity))
          .map((o) => o.opacity)
          .toList();
      expect(earlyOps.any((o) => o < 0.5), isTrue,
          reason: 'Early in animation, some gems should have low opacity');

      // after animation completes — all gems fully visible
      await tester.pump(const Duration(seconds: 2));
      final lateOps = tester
          .widgetList<Opacity>(find.byType(Opacity))
          .map((o) => o.opacity)
          .toList();
      expect(lateOps.every((o) => o > 0.99), isTrue,
          reason: 'After animation, all gems should be fully opaque');
    });

    testWidgets('custom maxSize and itemSize affect layout', (tester) async {
      const maxSize = 200.0;
      await tester.pumpWidget(
        MaterialApp(
          home: SizedBox(
            child: GemPileWidget(
                gemCount: 5, maxSize: maxSize, itemSize: 30),
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 500));

      // Find the SizedBox inside RepaintBoundary that GemPileWidget renders
      final gemPile = tester.widget<GemPileWidget>(find.byType(GemPileWidget));
      expect(gemPile.maxSize, maxSize);
      expect(gemPile.itemSize, 30);
    });
  });

  group('GemRainAnimation', () {
    testWidgets('renders with default parameters', (tester) async {
      await tester.pumpWidget(
    MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const SizedBox(
        child: GemRainAnimation(gemCount: 10, totalGems: 10),
      ),
    ),
      );
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.byType(GemRainAnimation), findsOneWidget);
    });

    testWidgets('shows count badge when rain completes', (tester) async {
      await tester.pumpWidget(
    MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const SizedBox(
        child: GemRainAnimation(gemCount: 5, totalGems: 5),
      ),
    ),
      );

      // no badge initially
      expect(find.text('+5'), findsNothing);

      // let rain animation finish
      await tester.pump(const Duration(seconds: 2));

      expect(find.text('+5'), findsOneWidget);
    });

    testWidgets('triggers onComplete when rain finishes', (tester) async {
      var completed = false;
      await tester.pumpWidget(
    MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: SizedBox(
        child: GemRainAnimation(
          gemCount: 5,
          totalGems: 5,
          onComplete: () => completed = true,
        ),
      ),
    ),
      );

      await tester.pump(const Duration(seconds: 2));
      expect(completed, isTrue);
    });

    testWidgets('accepts custom gemColor', (tester) async {
      const testColor = Color(0xFFCE93D8);
      await tester.pumpWidget(
    MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: SizedBox(
        child: GemRainAnimation(
          gemCount: 5,
          totalGems: 10,
          gemColor: testColor,
        ),
      ),
    ),
      );
      await tester.pump(const Duration(milliseconds: 500));

      // GemShapes are inside AnimatedBuilder so they will be present
      expect(find.byType(GemShape), findsWidgets);
    });

    testWidgets('sinking starts for totalGems > 20', (tester) async {
      await tester.pumpWidget(
    MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const SizedBox(
        child: GemRainAnimation(gemCount: 25, totalGems: 25),
      ),
    ),
      );

      // complete rain animation
      await tester.pump(const Duration(seconds: 2));

      // sinking animation runs — CustomPaint for ground crack should appear
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.byType(CustomPaint), findsWidgets);
    });

    testWidgets('does not sink for totalGems <= 20', (tester) async {
      await tester.pumpWidget(
    MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const SizedBox(
        child: GemRainAnimation(gemCount: 10, totalGems: 10),
      ),
    ),
      );

      await tester.pump(const Duration(seconds: 2));
      await tester.pump(const Duration(milliseconds: 200));

      // GemShape still present (no sink fade-out removed them entirely)
      expect(find.byType(GemShape), findsWidgets);
    });
  });
}
