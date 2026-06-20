class Project {
  final String id;
  final String name;
  final int color;
  final DateTime createdAt;

  const Project({
    required this.id,
    required this.name,
    required this.color,
    required this.createdAt,
  });

  factory Project.fromJson(Map<String, dynamic> json) => Project(
        id: json['id'] as String,
        name: json['name'] as String,
        color: json['color'] as int,
        createdAt: DateTime.parse(json['createdAt'] as String),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'color': color,
        'createdAt': createdAt.toIso8601String(),
      };
}
