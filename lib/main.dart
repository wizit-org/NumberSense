import 'package:flutter/material.dart';
import 'screens/compare_two_numbers.dart';
import 'screens/compare_two_prices.dart';
import 'controllers/session_controller.dart';
import 'models/progress_record.dart';
import 'models/user_settings.dart';
import 'screens/home.dart';
import 'screens/settings.dart';
import 'widgets/app_scaffold.dart';
import 'widgets/session_complete_dialog.dart';
import 'engine/level_manager.dart';

void main() {
  runApp(const NumberSenseApp());
}

class NumberSenseApp extends StatefulWidget {
  const NumberSenseApp({super.key});

  @override
  State<NumberSenseApp> createState() => _NumberSenseAppState();
}

class _NumberSenseAppState extends State<NumberSenseApp> {
  ProgressRecord? progress;
  UserSettings? settings;
  bool loading = true;
  bool playing = false;
  late LevelManager levelManager;
  NavigationItem currentNavItem = NavigationItem.home;

  @override
  void initState() {
    super.initState();
    _loadDataAndInitialize();
  }

  Future<void> _loadDataAndInitialize() async {
    final loadedProgress = await ProgressStorage.load();
    final loadedSettings = await UserSettings.load();
    
    setState(() {
      progress = loadedProgress ?? ProgressRecord(level: 1, scores: []);
      settings = loadedSettings;
      
      levelManager = LevelManager(
        initialLevel: progress!.level,
        onLevelUp: (newLevel) {
          print('[NumberSenseApp] PROMOTED to level $newLevel');
          setState(() {
            progress = ProgressRecord(level: newLevel, scores: []);
            // Re-create LevelManager for new level
            levelManager = LevelManager(
              initialLevel: newLevel,
              onLevelUp: levelManager.onLevelUp,
              promotionSessions: 1, // For quick promotion in test mode
              // Use the configured target from settings
              promotionThreshold: settings!.targetCorrectAnswers,
            );
          });
        },
        promotionSessions: 1, // For quick promotion in test mode
        // Use the configured target from settings
        promotionThreshold: settings!.targetCorrectAnswers,
      );
      
      loading = false;
    });
  }

  void _onSessionEnd(ProgressRecord updated, {int? lastScore}) async {
    // Add score to LevelManager and check for promotion
    int oldLevel = progress!.level;
    if (lastScore != null) {
      levelManager.addScore(lastScore);
    }
    int newLevel = levelManager.level;
    List<int> newScores = [...updated.scores];
    if (newLevel > oldLevel) {
      print('[NumberSenseApp] Level up! $oldLevel -> $newLevel');
      newScores = [];
    }
    setState(() {
      progress = ProgressRecord(level: newLevel, scores: newScores);
      playing = false;
    });
    await ProgressStorage.save(progress!);
  }

  void _handleNavigation(NavigationItem item) {
    if (item == currentNavItem) return;
    
    setState(() {
      currentNavItem = item;
      // If we navigate away from the game, stop playing
      if (playing) {
        playing = false;
      }
    });
  }
  
  void _handleSettingsChanged(UserSettings newSettings) async {
    setState(() {
      settings = newSettings;
      // Update LevelManager with new target threshold
      levelManager = LevelManager(
        initialLevel: progress!.level,
        onLevelUp: levelManager.onLevelUp,
        promotionSessions: 1, // For quick promotion in test mode
        promotionThreshold: newSettings.targetCorrectAnswers,
      );
    });
    await UserSettings.save(newSettings);
  }

  @override
  Widget build(BuildContext context) {
    if (loading || progress == null || settings == null) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          scaffoldBackgroundColor: Colors.grey[50],
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.blue.shade700,
            elevation: 0,
          ),
        ),
        home: const Scaffold(body: Center(child: CircularProgressIndicator())),
      );
    }
    
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.grey[50],
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.blue.shade700,
          elevation: 0,
        ),
      ),
      home: playing
        ? GameScreen(
            key: const ValueKey('game'),
            testMode: false,
            onSessionEnd: (updated) => _onSessionEnd(
              updated,
              lastScore: updated.scores.isNotEmpty ? updated.scores.last : null,
            ),
            progress: progress!,
            settings: settings!,
            onNavigate: _handleNavigation,
          )
        : _buildMainScreen(),
    );
  }
  
  Widget _buildMainScreen() {
    switch (currentNavItem) {
      case NavigationItem.settings:
        return SettingsScreen(
          progress: progress!,
          settings: settings!,
          onSettingsChanged: _handleSettingsChanged,
          onNavigate: _handleNavigation,
        );
      case NavigationItem.home:
      default:
        return HomeScreen(
          progress: progress!,
          onPlay: () => setState(() => playing = true),
          onNavigate: _handleNavigation,
          questionsPerSession: settings!.questionsPerLevel,
        );
    }
  }
}

class GameScreen extends StatefulWidget {
  final bool testMode;
  final void Function(ProgressRecord)? onSessionEnd;
  final ProgressRecord progress;
  final UserSettings settings;
  final Function(NavigationItem) onNavigate;
  
  const GameScreen({
    super.key,
    this.testMode = false,
    this.onSessionEnd,
    required this.progress,
    required this.settings,
    required this.onNavigate,
  });
  
  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> with SingleTickerProviderStateMixin {
  late SessionController controller;
  late ProgressRecord progress;
  bool loading = false;
  late AnimationController _progressAnimationController;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();
    progress = widget.progress;
    controller = SessionController(
      level: progress.level,
      totalQuestions: widget.settings.questionsPerLevel,
    );
    loading = false;
    
    // Animation controller for smooth progress updates
    _progressAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    // Initial progress value (0 out of total questions)
    _progressAnimation = Tween<double>(
      begin: 0,
      end: 0,
    ).animate(CurvedAnimation(
      parent: _progressAnimationController, 
      curve: Curves.easeInOut,
    ));
    
    _progressAnimationController.forward();
  }
  
  @override
  void dispose() {
    _progressAnimationController.dispose();
    super.dispose();
  }

  Future<void> _saveProgress() async {
    await ProgressStorage.save(progress);
  }

  void _onAnswer(bool correct) async {
    // Before updating the controller, animate to next progress value
    final nextProgress = (controller.currentIndex + 1) / widget.settings.questionsPerLevel;
    _progressAnimation = Tween<double>(
      begin: _progressAnimation.value,
      end: nextProgress,
    ).animate(CurvedAnimation(
      parent: _progressAnimationController, 
      curve: Curves.easeInOut,
    ));
    
    _progressAnimationController.forward(from: 0);
    
    setState(() {
      controller.answer(correct);
    });
    
    if (controller.isFinished) {
      final score = controller.correctCount;
      setState(() {
        progress = ProgressRecord(
          level: progress.level,
          scores: [...progress.scores, score],
        );
      });
      await _saveProgress();
      await Future.delayed(const Duration(milliseconds: 500));
      if (!mounted) return;
      
      // Check if the user leveled up by adding the score
      int oldLevel = progress.level;
      widget.onSessionEnd?.call(progress);
      
      // Dialog will show the current level (which might be updated after onSessionEnd)
      // and whether the user leveled up
      bool didLevelUp = progress.level > oldLevel;
      bool didPass = score >= widget.settings.targetCorrectAnswers;
      
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => SessionCompleteDialog(
          score: score,
          totalQuestions: widget.settings.questionsPerLevel,
          leveledUp: didLevelUp,
          currentLevel: progress.level,
          onContinue: () {
            Navigator.of(context).pop();
          },
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Center(child: CircularProgressIndicator());
    }
    
    if (controller.isFinished) {
      // Show nothing while dialog is up
      return const SizedBox.shrink();
    }
    
    final q = controller.currentQuestion;
    final gameWidget = q.type == QuestionType.prices
      ? CompareTwoPrices(
          key: ValueKey('price_${controller.currentIndex}'),
          priceA: q.a.toDouble(),
          priceB: q.b.toDouble(),
          imagePathA: q.imagePathA!,
          imagePathB: q.imagePathB!,
          onAnswer: _onAnswer,
          currentQuestionIndex: controller.currentIndex,
          totalQuestions: widget.settings.questionsPerLevel,
          correctCount: controller.correctCount,
          targetCorrectAnswers: widget.settings.targetCorrectAnswers,
        )
      : CompareTwoNumbers(
          key: ValueKey('number_${controller.currentIndex}'),
          a: q.a,
          b: q.b,
          onAnswer: _onAnswer,
          currentQuestionIndex: controller.currentIndex,
          totalQuestions: widget.settings.questionsPerLevel,
          correctCount: controller.correctCount,
          targetCorrectAnswers: widget.settings.targetCorrectAnswers,
        );
    
    return AppScaffold(
      title: 'NumberSense - Level ${this.progress.level}',
      progress: this.progress,
      selectedItem: NavigationItem.home, // Always Home when playing
      onNavigate: widget.onNavigate,
      body: gameWidget,
    );
  }
}
