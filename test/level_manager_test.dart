import 'package:flutter_test/flutter_test.dart';
import 'package:numbersense/engine/level_manager.dart';

void main() {
  test('LevelManager promotes after two consecutive 9/10', () {
    int? promotedTo;
    final manager = LevelManager(
      initialLevel: 1,
      onLevelUp: (level) => promotedTo = level,
    );
    // Simulate a series of scores
    manager.addScore(8);
    expect(promotedTo, isNull);
    manager.addScore(9);
    expect(promotedTo, isNull);
    manager.addScore(9);
    expect(promotedTo, 2);
    // Should reset after promotion
    manager.addScore(9);
    manager.addScore(9);
    expect(promotedTo, 3);
  });

  test('LevelManager does not promote for non-consecutive 9/10', () {
    int? promotedTo;
    final manager = LevelManager(
      initialLevel: 1,
      onLevelUp: (level) => promotedTo = level,
    );
    manager.addScore(9);
    manager.addScore(8);
    manager.addScore(9);
    expect(promotedTo, isNull);
  });

  test('LevelManager promotes after one 9/10 (test mode)', () {
    int? promotedTo;
    final manager = LevelManager(
      initialLevel: 1,
      onLevelUp: (level) {
        promotedTo = level;
        print('[Test] PROMOTED to level $level');
      },
      promotionSessions: 1,
    );
    manager.addScore(9);
    expect(promotedTo, 2);
  });

  test('LevelManager does not promote for <9/10 (test mode)', () {
    int? promotedTo;
    final manager = LevelManager(
      initialLevel: 1,
      onLevelUp: (level) {
        promotedTo = level;
        print('[Test] PROMOTED to level $level');
      },
      promotionSessions: 1,
    );
    manager.addScore(8);
    expect(promotedTo, isNull);
  });

  test('LevelManager logs trace and promotes correctly', () {
    int? promotedTo;
    final manager = LevelManager(
      initialLevel: 1,
      onLevelUp: (level) {
        promotedTo = level;
        print('[Test] PROMOTED to level $level');
      },
      promotionSessions: 1,
    );
    manager.addScore(10);
    expect(promotedTo, 2);
    manager.addScore(10);
    expect(promotedTo, 3);
  });
}
