import 'dart:typed_data';

class MockShareService {
  bool _shareCalled = false;
  Uint8List? _lastBytes;

  bool get shareCalled => _shareCalled;
  Uint8List? get lastBytes => _lastBytes;

  Future<bool> shareImage(Uint8List imageBytes, {String? text}) async {
    _shareCalled = true;
    _lastBytes = imageBytes;
    return true;
  }

  void reset() {
    _shareCalled = false;
    _lastBytes = null;
  }
}
