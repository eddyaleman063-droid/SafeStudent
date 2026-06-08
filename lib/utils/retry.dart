import 'dart:async';

enum RetryPolicy { fixed, linearBackoff, exponentialBackoff }

class RetryConfig {
  final int maxRetries;
  final Duration baseDelay;
  final RetryPolicy policy;
  final bool Function(Exception) shouldRetry;

  const RetryConfig({
    this.maxRetries = 3,
    this.baseDelay = const Duration(seconds: 1),
    this.policy = RetryPolicy.linearBackoff,
    this.shouldRetry = defaultShouldRetry,
  });

  static bool defaultShouldRetry(Exception e) => true;
}

Future<T> retry<T>(Future<T> Function() fn, {RetryConfig? config}) async {
  final cfg = config ?? const RetryConfig();
  var attempt = 0;

  while (true) {
    try {
      return await fn();
    } on Exception catch (e) {
      attempt++;
      if (attempt > cfg.maxRetries || !cfg.shouldRetry(e)) rethrow;

      final delay = _computeDelay(cfg, attempt);
      await Future.delayed(delay);
    }
  }
}

Duration _computeDelay(RetryConfig cfg, int attempt) {
  switch (cfg.policy) {
    case RetryPolicy.fixed:
      return cfg.baseDelay;
    case RetryPolicy.linearBackoff:
      return cfg.baseDelay * attempt;
    case RetryPolicy.exponentialBackoff:
      return cfg.baseDelay * (1 << (attempt - 1));
  }
}
