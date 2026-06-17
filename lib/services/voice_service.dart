import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:speech_to_text/speech_recognition_result.dart';

enum VoiceState { idle, listening, processing, error, denied }

class VoiceService {
  final SpeechToText _speech = SpeechToText();
  bool _available = false;
  bool _initialized = false;
  String _lastWords = '';
  VoiceState _state = VoiceState.idle;
  Completer<void>? _resultCompleter;

  bool get available => _available;
  bool get isListening => _speech.isListening;
  String get lastWords => _lastWords;
  VoiceState get state => _state;

  static const _locale = 'es-ES';

  Future<void> init() async {
    if (_initialized) return;
    _available = await _speech.initialize(
      onError: (e) {
        _state = VoiceState.error;
      },
      onStatus: (status) {
        if (status == 'denied') {
          _state = VoiceState.denied;
        }
      },
    );
    _initialized = true;
  }

  Future<bool> requestPermission() async {
    await init();
    return _available;
  }

  Future<void> startListening({
    required void Function(String text) onResult,
    required VoidCallback onDone,
  }) async {
    if (_speech.isListening) return;

    await init();
    if (!_available) {
      _state = VoiceState.denied;
      return;
    }

    _state = VoiceState.listening;
    _lastWords = '';
    _resultCompleter = Completer<void>();

    await _speech.listen(
      onResult: (SpeechRecognitionResult result) {
        _lastWords = result.recognizedWords;
        onResult(_lastWords);
        if (result.finalResult &&
            _resultCompleter != null &&
            !_resultCompleter!.isCompleted) {
          _resultCompleter!.complete();
        }
      },
      listenOptions: SpeechListenOptions(
        cancelOnError: true,
        localeId: _locale,
        listenFor: const Duration(seconds: 15),
      ),
    );

    _state = VoiceState.processing;
    onDone();
  }

  Future<void> stopListening() async {
    await _speech.stop();
    if (_resultCompleter != null) {
      await _resultCompleter!.future.timeout(const Duration(seconds: 1));
    }
    _resultCompleter = null;
    _state = VoiceState.idle;
  }

  void cancel() {
    _speech.cancel();
    _resultCompleter = null;
    _state = VoiceState.idle;
  }

  void resetState() {
    _state = VoiceState.idle;
    _lastWords = '';
    _resultCompleter = null;
  }

  void dispose() {
    _speech.stop();
  }
}
