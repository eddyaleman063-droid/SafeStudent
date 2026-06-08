import 'package:flutter_test/flutter_test.dart';
import 'package:sagen/services/ai_service.dart';
import 'package:sagen/services/gemini_api_client.dart';

void main() {
  group('GeminiApiClient', () {
    late GeminiApiClient client;

    setUp(() {
      client = GeminiApiClient();
    });

    test('is not available before init', () {
      expect(client.isAvailable, false);
    });

    test('dispose clears availability', () {
      client.dispose();
      expect(client.isAvailable, false);
    });

    test('generate throws AiException when uninitialized', () {
      expect(
        () => client.generate([]),
        throwsA(isA<AiException>().having((e) => e.type, 'type', AiErrorType.apiKey)),
      );
    });

    test('generateStream throws AiException when uninitialized', () async {
      await expectLater(
        () => client.generateStream([]).first,
        throwsA(isA<AiException>().having((e) => e.type, 'type', AiErrorType.apiKey)),
      );
    });

    test('generate throws AiException for empty Content list', () {
      expect(
        () => client.generate([]),
        throwsA(isA<AiException>()),
      );
    });
  });
}
