import 'package:sagen/providers/learning_provider.dart';

class MockLearningNotifier extends LearningNotifier {
  bool _built = false;

  set lessonsCompleted(int v) {
    if (!_built) return;
    state = state.copyWith(lessonsCompleted: v);
  }

  @override
  LearningState build() {
    _built = true;
    return const LearningState();
  }
}
