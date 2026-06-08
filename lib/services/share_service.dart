import 'dart:typed_data';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'analytics_service.dart';
import 'app_logger.dart';

class ShareService {
  static final ShareService _instance = ShareService._();
  static ShareService get instance => _instance;
  ShareService._() : _logger = AppLogger();
  final AppLogger _logger;

  Future<bool> shareImage(Uint8List imageBytes, {String? text, String? source}) async {
    try {
      final dir = await getTemporaryDirectory();
      final fileName = 'sagen_flex_card_${DateTime.now().millisecondsSinceEpoch}.png';
      final file = File('${dir.path}/$fileName');
      await file.writeAsBytes(imageBytes);

      await SharePlus.instance.share(
        ShareParams(
          files: [XFile(file.path)],
          text: text ?? 'Únete a mi alianza en SAGEN',
        ),
      );
      if (source != null) {
        AnalyticsService.instance.trackFlexCardShared(source);
      }
      return true;
    } catch (e) {
      _logger.error('Share failed', e);
      return false;
    }
  }
}
