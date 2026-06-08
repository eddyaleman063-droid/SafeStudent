import 'dart:async';
import 'package:app_links/app_links.dart';
import 'app_logger.dart';

sealed class DeepLinkAction {
  const DeepLinkAction();
}

class ProfileDeepLink extends DeepLinkAction {
  final String uid;
  const ProfileDeepLink(this.uid);
}

class RankingDeepLink extends DeepLinkAction {
  const RankingDeepLink();
}

class LessonDeepLink extends DeepLinkAction {
  final String stageId;
  const LessonDeepLink(this.stageId);
}

class UnknownDeepLink extends DeepLinkAction {
  final Uri uri;
  const UnknownDeepLink(this.uri);
}

class DeepLinkService {
  static final DeepLinkService instance = DeepLinkService._();
  DeepLinkService._() : _logger = AppLogger();
  final AppLogger _logger;

  final AppLinks _appLinks = AppLinks();
  StreamSubscription<Uri>? _sub;
  Uri? _initialLink;

  final StreamController<DeepLinkAction> _actionController =
      StreamController<DeepLinkAction>.broadcast();
  final StreamController<int> _tabSwitchController =
      StreamController<int>.broadcast();

  Uri? get initialLink => _initialLink;
  Stream<Uri> get uriLinkStream => _appLinks.uriLinkStream;
  Stream<DeepLinkAction> get actionStream => _actionController.stream;
  Stream<int> get tabSwitchStream => _tabSwitchController.stream;

  Future<void> init() async {
    try {
      _initialLink = await _appLinks.getInitialLink();
      if (_initialLink != null) {
        _actionController.add(handleDeepLink(_initialLink!));
      }
      _sub = _appLinks.uriLinkStream.listen((uri) {
        _logger.info('DeepLink received: $uri');
        _actionController.add(handleDeepLink(uri));
      });
      _logger.info('DeepLinkService initialized');
    } catch (e) {
      _logger.error('DeepLinkService init failed', e);
    }
  }

  DeepLinkAction handleDeepLink(Uri uri) {
    final host = uri.host.toLowerCase();
    final params = uri.queryParameters;

    switch (host) {
      case 'profile':
        final uid = params['uid'];
        if (uid != null && uid.isNotEmpty) {
          return ProfileDeepLink(uid);
        }
        _logger.warning('DeepLink /profile missing uid');
        return UnknownDeepLink(uri);

      case 'ranking':
        return const RankingDeepLink();

      case 'lesson':
        final stageId = params['stageId'];
        if (stageId != null && stageId.isNotEmpty) {
          return LessonDeepLink(stageId);
        }
        _logger.warning('DeepLink /lesson missing stageId');
        return UnknownDeepLink(uri);

      default:
        _logger.warning('DeepLink unknown host: $host');
        return UnknownDeepLink(uri);
    }
  }

  Uri buildProfileDeepLink(String uid) =>
      Uri.parse('sagen://profile?uid=$uid');
  Uri buildRankingDeepLink() => Uri.parse('sagen://ranking');
  Uri buildLessonDeepLink(String stageId) =>
      Uri.parse('sagen://lesson?stageId=$stageId');

  void requestTabSwitch(int index) => _tabSwitchController.add(index);

  Future<void> dispose() async {
    await _sub?.cancel();
    _sub = null;
    await _actionController.close();
    await _tabSwitchController.close();
  }
}
