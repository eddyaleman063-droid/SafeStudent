import 'dart:io';
import 'package:crypto/crypto.dart';
import 'app_logger.dart';

class CertificatePinning {
  final AppLogger _logger = AppLogger();
  final Map<String, List<String>> _pins = {};

  static final CertificatePinning instance = CertificatePinning._();
  CertificatePinning._();

  void addPin(String host, String sha256Fingerprint) {
    _pins.putIfAbsent(host, () => []).add(sha256Fingerprint);
  }

  void addPins(String host, List<String> fingerprints) {
    _pins[host] = fingerprints;
  }

  bool hasPinsFor(String host) => _pins.containsKey(host);

  void clearPins(String host) => _pins.remove(host);

  HttpClient createHttpClient({String? host}) {
    final client = HttpClient();
    if (host != null && _pins.containsKey(host)) {
      client.badCertificateCallback = (X509Certificate cert, String h, int port) {
        if (h != host) return false;
        final digest = sha256.convert(cert.der);
        final fingerprint = digest.toString();
        if (_pins[host]!.contains(fingerprint)) return true;
        _logger.warning('Certificate pinning failed for $host');
        return false;
      };
    }
    return client;
  }
}
