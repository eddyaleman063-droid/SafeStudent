sealed class SessionState {
  const SessionState();
}

class SessionIdle extends SessionState {
  const SessionIdle();
}

class SessionActive extends SessionState {
  final String lessonId;
  const SessionActive(this.lessonId);
}

class SessionCompleted extends SessionState {
  final int score;
  final int totalXp;
  final int totalGems;
  const SessionCompleted(this.score, this.totalXp, this.totalGems);
}

class SessionError extends SessionState {
  final String message;
  const SessionError(this.message);
}
