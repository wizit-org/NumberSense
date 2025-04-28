typedef LevelUpCallback = void Function(int level);

class LevelManager {
  int _level;
  final List<int> _recentScores = [];
  final LevelUpCallback onLevelUp;
  final int promotionSessions;
  final int promotionThreshold;

  LevelManager({
    int initialLevel = 1,
    required this.onLevelUp,
    this.promotionSessions = 2,
    this.promotionThreshold = 9,
  }) : _level = initialLevel;

  int get level => _level;

  void addScore(int score) {
    _recentScores.add(score);
    if (_recentScores.length > promotionSessions) {
      _recentScores.removeAt(0);
    }
    print('[LevelManager] Scores: $_recentScores, Level: $_level');
    if (_recentScores.length == promotionSessions &&
        _recentScores.every((s) => s >= promotionThreshold)) {
      _level++;
      print('[LevelManager] PROMOTED to level $_level');
      onLevelUp(_level);
      _recentScores.clear();
    }
  }
}
