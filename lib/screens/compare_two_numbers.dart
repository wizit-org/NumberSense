import 'dart:math';
import 'package:flutter/material.dart';
import '../widgets/number_card.dart';
import '../widgets/detailed_progress_bar.dart';

class CompareTwoNumbers extends StatefulWidget {
  final int a;
  final int b;
  final ValueChanged<bool> onAnswer;
  final int currentQuestionIndex;
  final int totalQuestions;
  final int correctCount;
  final int targetCorrectAnswers;

  const CompareTwoNumbers({
    super.key,
    required this.a,
    required this.b,
    required this.onAnswer,
    this.currentQuestionIndex = 0,
    this.totalQuestions = 10,
    this.correctCount = 0,
    this.targetCorrectAnswers = 8,
  });

  @override
  State<CompareTwoNumbers> createState() => _CompareTwoNumbersState();
}

class _CompareTwoNumbersState extends State<CompareTwoNumbers> with SingleTickerProviderStateMixin {
  late List<int> numbers;
  int? tappedIndex;
  bool? correct;
  Color? flashColor;
  late AnimationController _progressAnimationController;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();
    _randomizeOrder();
    
    // Setup progress animation
    _progressAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    _progressAnimation = Tween<double>(
      begin: widget.currentQuestionIndex / widget.totalQuestions,
      end: widget.currentQuestionIndex / widget.totalQuestions,
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

  Future<void> _flash(Color color) async {
    for (int i = 0; i < 3; i++) {
      setState(() => flashColor = color);
      await Future.delayed(const Duration(milliseconds: 100));
      setState(() => flashColor = null);
      await Future.delayed(const Duration(milliseconds: 100));
    }
  }

  void _onTap(int index) async {
    if (tappedIndex != null) return; // Prevent multiple taps
    
    // Update progress animation to next value
    _progressAnimation = Tween<double>(
      begin: widget.currentQuestionIndex / widget.totalQuestions,
      end: (widget.currentQuestionIndex + 1) / widget.totalQuestions,
    ).animate(CurvedAnimation(
      parent: _progressAnimationController, 
      curve: Curves.easeInOut,
    ));
    _progressAnimationController.forward(from: 0);
    
    final picked = numbers[index];
    final isCorrect = picked == (widget.a > widget.b ? widget.a : widget.b);
    setState(() {
      tappedIndex = index;
      correct = isCorrect;
    });
    await _flash(isCorrect ? Colors.green : Colors.red);
    widget.onAnswer(isCorrect);
  }

  void _randomizeOrder() {
    numbers = [widget.a, widget.b];
    numbers.shuffle(Random());
    tappedIndex = null;
    correct = null;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Progress indicator
        Container(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Question ${widget.currentQuestionIndex + 1}/${widget.totalQuestions}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[700],
                    ),
                  ),
                  Text(
                    'Score: ${widget.correctCount}/${widget.currentQuestionIndex}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              DetailedProgressBar(
                totalQuestions: widget.totalQuestions,
                correctAnswers: widget.correctCount,
                incorrectAnswers: widget.currentQuestionIndex - widget.correctCount,
                successThreshold: widget.totalQuestions > 0 
                  ? widget.targetCorrectAnswers / widget.totalQuestions
                  : 0.8,
              ),
            ],
          ),
        ),
        
        // Game content
        Expanded(
          child: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Pick the largest number',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(2, (index) {
                      final isTapped = tappedIndex == index;
                      Color? outline;
                      if (isTapped && correct != null) {
                        outline = correct! ? Colors.green : Colors.red;
                      }
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: outline ?? Colors.transparent,
                              width: 4,
                            ),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: NumberCard(
                            value: numbers[index],
                            onTap: () => _onTap(index),
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              ),
              if (flashColor != null)
                Positioned.fill(
                  child: IgnorePointer(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: flashColor!, width: 12),
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
