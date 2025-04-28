import 'package:flutter/material.dart';

class DetailedProgressBar extends StatelessWidget {
  final int totalQuestions;
  final int correctAnswers;
  final int incorrectAnswers;
  final double successThreshold; // e.g. 0.8 for 80%
  
  const DetailedProgressBar({
    super.key,
    required this.totalQuestions,
    required this.correctAnswers,
    required this.incorrectAnswers,
    this.successThreshold = 0.8,
  });

  @override
  Widget build(BuildContext context) {
    final answeredQuestions = correctAnswers + incorrectAnswers;
    final unansweredQuestions = totalQuestions - answeredQuestions;
    
    // Calculate percentages for layout
    final correctPercentage = totalQuestions > 0 ? correctAnswers / totalQuestions : 0.0;
    final incorrectPercentage = totalQuestions > 0 ? incorrectAnswers / totalQuestions : 0.0;
    final thresholdPosition = successThreshold;
    
    // Calculate the target number of correct answers needed
    final targetCorrectAnswers = (totalQuestions * successThreshold).ceil();
    
    return Container(
      height: 12,
      margin: const EdgeInsets.only(bottom: 16), // Add margin for the target label
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(6),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final totalWidth = constraints.maxWidth;
          final correctWidth = totalWidth * correctPercentage;
          final incorrectWidth = totalWidth * incorrectPercentage;
          final thresholdX = totalWidth * thresholdPosition;
          
          return Stack(
            clipBehavior: Clip.none, // Allow the target indicator to overflow
            children: [
              // Correct answers (green from left)
              if (correctPercentage > 0)
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    width: correctWidth,
                    height: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(6),
                        bottomLeft: const Radius.circular(6),
                        topRight: incorrectPercentage <= 0 
                          ? const Radius.circular(6) 
                          : Radius.zero,
                        bottomRight: incorrectPercentage <= 0 
                          ? const Radius.circular(6) 
                          : Radius.zero,
                      ),
                    ),
                  ),
                ),

              // Incorrect answers (red from right)
              if (incorrectPercentage > 0)
                Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    width: incorrectWidth,
                    height: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.red.shade700,
                      borderRadius: BorderRadius.only(
                        topRight: const Radius.circular(6),
                        bottomRight: const Radius.circular(6),
                        topLeft: correctPercentage <= 0 
                          ? const Radius.circular(6) 
                          : Radius.zero,
                        bottomLeft: correctPercentage <= 0 
                          ? const Radius.circular(6) 
                          : Radius.zero,
                      ),
                    ),
                  ),
                ),

              // Target threshold marker - positioned to the right of the threshold
              Positioned(
                left: thresholdX,
                top: 0,
                bottom: 0,
                child: Container(
                  width: 2,
                  decoration: BoxDecoration(
                    color: Colors.blue.shade800,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 1,
                        spreadRadius: 0.5,
                      ),
                    ],
                  ),
                ),
              ),
              
              // Target threshold indicator - positioned to the right of the line
              Positioned(
                left: thresholdX + 4, // Positioned to the right of the marker
                top: -18,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade800,
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: Text(
                    '${(successThreshold * 100).toInt()}%',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              
              // Target number of correct answers needed
              Positioned(
                left: thresholdX - 8, // Centered on the marker
                bottom: -16, // Below the progress bar
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade100,
                    border: Border.all(color: Colors.blue.shade800, width: 1),
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: Text(
                    '$targetCorrectAnswers / $totalQuestions',
                    style: TextStyle(
                      color: Colors.blue.shade800,
                      fontSize: 8,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}