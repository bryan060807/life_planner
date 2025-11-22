enum TaskCategory {
  today,
  week,
  month,
  inbox,
}

String taskCategoryToString(TaskCategory cat) => cat.name;

TaskCategory taskCategoryFromString(String value) {
  return TaskCategory.values.firstWhere(
    (e) => e.name == value,
    orElse: () => TaskCategory.inbox,
  );
}
