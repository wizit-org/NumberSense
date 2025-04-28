import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class UserSettings {
  final int questionsPerLevel;
  final int targetCorrectAnswers;
  final double successThreshold;

  UserSettings({
    this.questionsPerLevel = 3,
    this.targetCorrectAnswers = 2,
    double? successThreshold,
  }) : successThreshold = successThreshold ?? (targetCorrectAnswers / questionsPerLevel);

  Map<String, dynamic> toJson() {
    return {
      'questionsPerLevel': questionsPerLevel,
      'targetCorrectAnswers': targetCorrectAnswers,
    };
  }

  factory UserSettings.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return UserSettings();
    }
    
    return UserSettings(
      questionsPerLevel: json['questionsPerLevel'] ?? 3,
      targetCorrectAnswers: json['targetCorrectAnswers'] ?? 2,
    );
  }

  String toRawJson() => jsonEncode(toJson());
  
  factory UserSettings.fromRawJson(String json) => 
      UserSettings.fromJson(jsonDecode(json) as Map<String, dynamic>);
      
  static const _filename = 'settings.json';

  static Future<File> _getFile() async {
    final dir = await getApplicationSupportDirectory();
    return File('${dir.path}/$_filename');
  }

  static Future<UserSettings> load() async {
    try {
      final file = await _getFile();
      if (await file.exists()) {
        final contents = await file.readAsString();
        return UserSettings.fromRawJson(contents);
      }
    } catch (_) {
      debugPrint('Failed to load settings, using defaults');
    }
    return UserSettings(); // Return default settings
  }

  static Future<void> save(UserSettings settings) async {
    try {
      final file = await _getFile();
      await file.writeAsString(settings.toRawJson());
    } catch (e) {
      debugPrint('Failed to save settings: $e');
    }
  }
  
  UserSettings copyWith({
    int? questionsPerLevel,
    int? targetCorrectAnswers,
  }) {
    return UserSettings(
      questionsPerLevel: questionsPerLevel ?? this.questionsPerLevel,
      targetCorrectAnswers: targetCorrectAnswers ?? this.targetCorrectAnswers,
    );
  }
}