import 'package:flutter/material.dart';
import '../models/progress_record.dart';
import '../models/user_settings.dart';
import '../widgets/app_scaffold.dart';

class SettingsScreen extends StatefulWidget {
  final ProgressRecord progress;
  final Function(NavigationItem)? onNavigate;
  final UserSettings settings;
  final Function(UserSettings) onSettingsChanged;
  
  const SettingsScreen({
    super.key,
    required this.progress,
    required this.settings,
    required this.onSettingsChanged,
    this.onNavigate,
  });

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late int _questionsPerLevel;
  late int _targetCorrectAnswers;
  
  @override
  void initState() {
    super.initState();
    _questionsPerLevel = widget.settings.questionsPerLevel;
    _targetCorrectAnswers = widget.settings.targetCorrectAnswers;
  }
  
  void _updateSettings() {
    final newSettings = widget.settings.copyWith(
      questionsPerLevel: _questionsPerLevel,
      targetCorrectAnswers: _targetCorrectAnswers,
    );
    widget.onSettingsChanged(newSettings);
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Settings',
      progress: widget.progress,
      selectedItem: NavigationItem.settings,
      onNavigate: widget.onNavigate ?? (_) {},
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Settings',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              
              // Game Settings
              const Text(
                'Game Settings',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              
              // Questions per level setting
              _buildSettingCard(
                title: 'Questions per Level',
                description: 'Number of questions in each session',
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove_circle_outline),
                      onPressed: _questionsPerLevel > 1 
                          ? () {
                              setState(() {
                                _questionsPerLevel--;
                                // Ensure target doesn't exceed total questions
                                if (_targetCorrectAnswers > _questionsPerLevel) {
                                  _targetCorrectAnswers = _questionsPerLevel;
                                }
                              });
                              _updateSettings();
                            }
                          : null,
                      color: Colors.blue.shade700,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        '$_questionsPerLevel',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add_circle_outline),
                      onPressed: _questionsPerLevel < 10 
                          ? () {
                              setState(() {
                                _questionsPerLevel++;
                              });
                              _updateSettings();
                            }
                          : null,
                      color: Colors.blue.shade700,
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 12),
              
              // Target correct answers setting
              _buildSettingCard(
                title: 'Target Correct Answers',
                description: 'Number of correct answers needed to pass',
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove_circle_outline),
                      onPressed: _targetCorrectAnswers > 1 
                          ? () {
                              setState(() {
                                _targetCorrectAnswers--;
                              });
                              _updateSettings();
                            }
                          : null,
                      color: Colors.blue.shade700,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        '$_targetCorrectAnswers',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add_circle_outline),
                      onPressed: _targetCorrectAnswers < _questionsPerLevel 
                          ? () {
                              setState(() {
                                _targetCorrectAnswers++;
                              });
                              _updateSettings();
                            }
                          : null,
                      color: Colors.blue.shade700,
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 12),
              
              // Success threshold display
              _buildSettingCard(
                title: 'Success Threshold',
                description: 'Percentage needed to advance',
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade100,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    '${(_targetCorrectAnswers / _questionsPerLevel * 100).round()}%',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.blue.shade700,
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Game Information
              const Text(
                'Game Information',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              _buildInfoCard(
                context, 
                'Current Level', 
                'Level ${widget.progress.level}',
                Icons.trending_up,
              ),
              const SizedBox(height: 12),
              _buildInfoCard(
                context, 
                'Completed Sessions', 
                '${widget.progress.scores.length}',
                Icons.check_circle_outline,
              ),
              
              const SizedBox(height: 24),
              
              // App Settings
              const Text(
                'App Settings',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              _buildSettingsSwitch(
                'Sound Effects',
                true,
                Icons.volume_up,
                (value) {
                  // Would normally save this to user preferences
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Sound setting changed (demo only)'),
                      duration: Duration(seconds: 1),
                    ),
                  );
                }
              ),
              _buildSettingsSwitch(
                'Animations',
                true,
                Icons.animation,
                (value) {
                  // Would normally save this to user preferences
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Animation setting changed (demo only)'),
                      duration: Duration(seconds: 1),
                    ),
                  );
                }
              ),
              
              const SizedBox(height: 24),
              
              // About section
              Center(
                child: Column(
                  children: [
                    const Text('NumberSense', style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text('Version 1.0.0', style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                    const SizedBox(height: 4),
                    Text('© 2025 NumberSense', style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildSettingCard({
    required String title,
    required String description,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(
                  description,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          child,
        ],
      ),
    );
  }
  
  Widget _buildInfoCard(BuildContext context, String title, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue.shade700, size: 24),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(color: Colors.grey[600])),
              const SizedBox(height: 4),
              Text(
                value, 
                style: const TextStyle(
                  fontWeight: FontWeight.bold, 
                  fontSize: 16
                )
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildSettingsSwitch(String title, bool initialValue, IconData icon, Function(bool) onChanged) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue.shade700, size: 24),
          const SizedBox(width: 16),
          Expanded(child: Text(title)),
          Switch(
            value: initialValue,
            onChanged: onChanged,
            activeColor: Colors.blue.shade700,
          ),
        ],
      ),
    );
  }
}