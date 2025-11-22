class Habit {
  final String id;
  String name;

  /// Set of date keys "yyyy-MM-dd" that are completed
  Set<String> completedDays;

  Habit({
    String? id,
    required this.name,
    Set<String>? completedDays,
  })  : id = id ?? DateTime.now().microsecondsSinceEpoch.toString(),
        completedDays = completedDays ?? {};

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'completedDays': completedDays.toList(),
    };
  }

  factory Habit.fromJson(Map<String, dynamic> json) {
    final list = (json['completedDays'] as List?)?.cast<String>() ?? <String>[];
    return Habit(
      id: json['id'] as String?,
      name: json['name'] as String? ?? '',
      completedDays: list.toSet(),
    );
  }

  bool isDoneOn(DateTime date) {
    return completedDays.contains(_dateKey(date));
  }

  void toggleOn(DateTime date) {
    final key = _dateKey(date);
    if (completedDays.contains(key)) {
      completedDays.remove(key);
    } else {
      completedDays.add(key);
    }
  }

  static String _dateKey(DateTime date) {
    return '${date.year.toString().padLeft(4, '0')}-'
        '${date.month.toString().padLeft(2, '0')}-'
        '${date.day.toString().padLeft(2, '0')}';
  }
}
