class Goal {
  final String id;
  String title;
  String why;
  List<String> steps;
  bool isArchived;

  Goal({
    String? id,
    required this.title,
    this.why = '',
    List<String>? steps,
    this.isArchived = false,
  })  : id = id ?? DateTime.now().microsecondsSinceEpoch.toString(),
        steps = steps ?? [];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'why': why,
      'steps': steps,
      'isArchived': isArchived,
    };
  }

  factory Goal.fromJson(Map<String, dynamic> json) {
    return Goal(
      id: json['id'] as String?,
      title: json['title'] as String? ?? '',
      why: json['why'] as String? ?? '',
      steps: (json['steps'] as List?)?.cast<String>() ?? <String>[],
      isArchived: json['isArchived'] as bool? ?? false,
    );
  }

  Goal copyWith({
    String? title,
    String? why,
    List<String>? steps,
    bool? isArchived,
  }) {
    return Goal(
      id: id,
      title: title ?? this.title,
      why: why ?? this.why,
      steps: steps ?? List<String>.from(this.steps),
      isArchived: isArchived ?? this.isArchived,
    );
  }
}
