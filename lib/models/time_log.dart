class TimeLog {
  final String id;
  final String projectId;
  final DateTime startedAt;
  final DateTime finishedAt;
  final Duration duration;

  const TimeLog({
    required this.id,
    required this.projectId,
    required this.startedAt,
    required this.finishedAt,
    required this.duration,
  });

  factory TimeLog.fromJson(Map<String, dynamic> json) => TimeLog(
        id: json['id'] as String,
        projectId: json['projectId'] as String,
        startedAt: DateTime.parse(json['startedAt'] as String),
        finishedAt: DateTime.parse(json['finishedAt'] as String),
        duration: Duration(seconds: json['durationSeconds'] as int),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'projectId': projectId,
        'startedAt': startedAt.toIso8601String(),
        'finishedAt': finishedAt.toIso8601String(),
        'durationSeconds': duration.inSeconds,
      };
}
