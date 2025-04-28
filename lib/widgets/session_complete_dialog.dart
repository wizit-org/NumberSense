import 'package:flutter/material.dart';

class SessionCompleteDialog extends StatelessWidget {
  final int score;
  final int totalQuestions;
  final bool leveledUp;
  final int currentLevel;
  final VoidCallback onContinue;
  
  const SessionCompleteDialog({
    super.key,
    required this.score,
    required this.totalQuestions,
    required this.leveledUp,
    required this.currentLevel,
    required this.onContinue,
  });

  @override
  Widget build(BuildContext context) {
    final percentage = (score / totalQuestions) * 100;
    final isPassing = percentage >= 80; // Assuming 80% is passing
    final levelMessage = leveledUp 
      ? 'Congratulations! You advanced to Level ${currentLevel}!'
      : isPassing 
        ? 'Great job! Keep practicing to advance to the next level.'
        : 'Keep practicing to improve your score and advance to the next level.';
    
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.only(
              left: 20,
              top: 45 + 20,
              right: 20,
              bottom: 20,
            ),
            margin: const EdgeInsets.only(top: 45),
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  leveledUp ? 'Level Up!' : 'Session Complete',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: leveledUp ? Colors.blue.shade700 : Colors.black87,
                  ),
                ),
                const SizedBox(height: 15),
                Text(
                  levelMessage,
                  style: const TextStyle(fontSize: 14),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 22),
                
                // Score display
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildScoreStat(
                        'Score',
                        '$score/$totalQuestions',
                        _getScoreColor(percentage),
                      ),
                      _buildScoreStat(
                        'Accuracy',
                        '${percentage.round()}%',
                        _getScoreColor(percentage),
                      ),
                      _buildScoreStat(
                        'Level',
                        '$currentLevel',
                        Colors.blue.shade700,
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 22),
                
                // Continue button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: onContinue,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade700,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: Text(
                      leveledUp ? 'Continue to Level $currentLevel' : 'Back to Home',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Circular avatar at the top
          Positioned(
            left: 20,
            right: 20,
            child: CircleAvatar(
              backgroundColor: _getResultColor(percentage, leveledUp),
              radius: 45,
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(45)),
                child: Icon(
                  _getResultIcon(percentage, leveledUp),
                  color: Colors.white,
                  size: 50,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildScoreStat(String label, String value, Color valueColor) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: valueColor,
          ),
        ),
      ],
    );
  }
  
  Color _getScoreColor(double percentage) {
    if (percentage >= 80) return Colors.green;
    if (percentage >= 60) return Colors.orange;
    return Colors.red;
  }
  
  Color _getResultColor(double percentage, bool leveledUp) {
    if (leveledUp) return Colors.blue.shade700;
    if (percentage >= 80) return Colors.green;
    if (percentage >= 60) return Colors.orange;
    return Colors.red.shade400;
  }
  
  IconData _getResultIcon(double percentage, bool leveledUp) {
    if (leveledUp) return Icons.emoji_events;
    if (percentage >= 80) return Icons.check_circle;
    if (percentage >= 60) return Icons.thumbs_up_down;
    return Icons.thumb_down;
  }
}