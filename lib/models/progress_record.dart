import 'dart:convert';

class ProgressRecord {
  final int level;
  final List<int> scores;

  ProgressRecord({required this.level, required this.scores});

  factory ProgressRecord.fromJson(Map<String, dynamic> json) {
    return ProgressRecord(
      level: json['level'] as int,
      scores: (json['scores'] as List<dynamic>).map((e) => e as int).toList(),
    );
  }

  Map<String, dynamic> toJson() => {'level': level, 'scores': scores};

  String toRawJson() => jsonEncode(toJson());
  factory ProgressRecord.fromRawJson(String str) =>
      ProgressRecord.fromJson(jsonDecode(str));
}
