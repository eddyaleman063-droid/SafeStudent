import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sagen/l10n/app_localizations.dart';
import 'package:sagen/providers/providers.dart';
import 'package:sagen/providers/sage_ai_provider.dart';
import 'package:sagen/ui/screens/dashboard/sage_chat_screen.dart';

class _TestLearningNotifier extends LearningNotifier {
  @override
  LearningState build() => const LearningState(isLoading: false, lessonsCompleted: 10);
}

class _TestSageNotifier extends SageAiNotifier {
  final SageAiChatState _fixedState;

  _TestSageNotifier(this._fixedState);

  @override
  SageAiChatState build() => _fixedState;
}

Widget createTestApp(SageAiChatState sageState) {
  return ProviderScope(
    overrides: [
      learningProvider.overrideWith(() => _TestLearningNotifier()),
      sageAiProvider.overrideWith(() => _TestSageNotifier(sageState)),
    ],
    child: const MaterialApp(
      locale: Locale('es'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: SageChatScreen(),
    ),
  );
}

void main() {
  group('SageChatScreen', () {
    testWidgets('shows locked gatekeeper when locked', (tester) async {
      const state = SageAiChatState(lessonsCompleted: 5);
      await tester.pumpWidget(createTestApp(state));
      await tester.pump();
      expect(find.text('Tutor IA Bloqueado'), findsOneWidget);
    });

    testWidgets('shows chat interface when unlocked', (tester) async {
      const state = SageAiChatState(lessonsCompleted: 10);
      await tester.pumpWidget(createTestApp(state));
      await tester.pump();
      expect(find.text('Sage Tutor'), findsOneWidget);
    });

    testWidgets('shows suggestion chips when messages empty', (tester) async {
      const state = SageAiChatState(lessonsCompleted: 10);
      await tester.pumpWidget(createTestApp(state));
      await tester.pump();
      expect(find.text('¿Qué es el phishing?'), findsOneWidget);
      expect(find.text('Crea una contraseña segura'), findsOneWidget);
      expect(find.text('Identifica una estafa'), findsOneWidget);
    });

    testWidgets('shows input bar', (tester) async {
      const state = SageAiChatState(lessonsCompleted: 10);
      await tester.pumpWidget(createTestApp(state));
      await tester.pump();
      expect(find.byType(TextField), findsOneWidget);
    });
  });
}
