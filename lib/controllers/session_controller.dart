import 'dart:math';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../models/progress_record.dart';

class Question {
  final int a;
  final int b;
  final QuestionType type;
  final String? imagePathA;
  final String? imagePathB;

  Question(
    this.a,
    this.b, {
    this.type = QuestionType.numbers,
    this.imagePathA,
    this.imagePathB,
  });
}

enum QuestionType { numbers, prices }

class SessionController {
  final int totalQuestions;
  final List<Question> questions = [];
  int currentIndex = 0;
  int correctCount = 0;
  final int level;

  SessionController({this.totalQuestions = 10, required this.level}) {
    _generateQuestions();
  }

  void _generateQuestions() {
    final rand = Random();
    questions.clear();
    int max = 100;
    if (level == 2) {
      max = 1000;
    } else if (level >= 3) {
      max = 10000;
    }

    // Define grocery item images with their price ranges
    // Use jpg images from Pexels
    final groceryItems = [
      {'image': 'grocery/apple.jpg', 'minPrice': 1, 'maxPrice': 5},
      {'image': 'grocery/banana.jpg', 'minPrice': 2, 'maxPrice': 6},
      {'image': 'grocery/bread.jpg', 'minPrice': 3, 'maxPrice': 8},
      {'image': 'grocery/milk.jpg', 'minPrice': 2, 'maxPrice': 7},
      {'image': 'grocery/cheese.jpg', 'minPrice': 5, 'maxPrice': 15},
      {'image': 'grocery/eggs.jpg', 'minPrice': 3, 'maxPrice': 10},
    ];

    for (int i = 0; i < totalQuestions; i++) {
      // For level 4, introduce price comparison questions
      if (level >= 4 && rand.nextBool()) {
        // Select two different random grocery items
        final itemIndex1 = rand.nextInt(groceryItems.length);
        var itemIndex2 = rand.nextInt(groceryItems.length);
        while (itemIndex1 == itemIndex2) {
          itemIndex2 = rand.nextInt(groceryItems.length);
        }

        final item1 = groceryItems[itemIndex1];
        final item2 = groceryItems[itemIndex2];

        // Generate random prices within the defined ranges
        final priceA =
            (item1['minPrice'] as int) +
            rand.nextInt(
              (item1['maxPrice'] as int) - (item1['minPrice'] as int) + 1,
            );
        final priceB =
            (item2['minPrice'] as int) +
            rand.nextInt(
              (item2['maxPrice'] as int) - (item2['minPrice'] as int) + 1,
            );

        // Ensure prices are different
        if (priceA == priceB) {
          questions.add(
            Question(
              priceA,
              priceB + 1,
              type: QuestionType.prices,
              imagePathA: item1['image'] as String,
              imagePathB: item2['image'] as String,
            ),
          );
        } else {
          questions.add(
            Question(
              priceA,
              priceB,
              type: QuestionType.prices,
              imagePathA: item1['image'] as String,
              imagePathB: item2['image'] as String,
            ),
          );
        }
      } else {
        // Generate regular number comparison questions
        int a = rand.nextInt(max);
        int b = rand.nextInt(max);
        while (a == b) {
          b = rand.nextInt(max);
        }
        questions.add(Question(a, b));
      }
    }
    currentIndex = 0;
    correctCount = 0;
  }

  Question get currentQuestion => questions[currentIndex];

  bool get isFinished => currentIndex >= totalQuestions;

  void answer(bool correct) {
    if (correct) correctCount++;
    currentIndex++;
  }

  void restart() {
    _generateQuestions();
  }
}

class ProgressStorage {
  static const _filename = 'progress.json';

  static Future<File> _getFile() async {
    final dir = await getApplicationSupportDirectory();
    return File('${dir.path}/$_filename');
  }

  static Future<ProgressRecord?> load() async {
    try {
      final file = await _getFile();
      if (await file.exists()) {
        final contents = await file.readAsString();
        return ProgressRecord.fromRawJson(contents);
      }
    } catch (_) {}
    return null;
  }

  static Future<void> save(ProgressRecord record) async {
    try {
      final file = await _getFile();
      await file.writeAsString(record.toRawJson());
    } catch (_) {}
  }
}
