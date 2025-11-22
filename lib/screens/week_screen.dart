import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../store/planner_store.dart';
import '../models/task_category.dart';
import '../models/planner_task.dart';

class WeekScreen extends StatefulWidget {
  const WeekScreen({super.key});

  @override
  State<WeekScreen> createState() => _WeekScreenState();
}

class _WeekScreenState extends State<WeekScreen> {
  final TextEditingController _controller = TextEditingController();
  TaskCategory _selectedCategory = TaskCategory.week;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _addTask(BuildContext context) async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    final store = context.read<PlannerStore>();
    await store.addTask(text, _selectedCategory);
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    final store = context.watch<PlannerStore>();

    final weekTasks = store.tasksForCategory(TaskCategory.week);
    final monthTasks = store.tasksForCategory(TaskCategory.month);
    final inboxTasks = store.tasksForCategory(TaskCategory.inbox);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Week Overview'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                _buildSection(
                  context,
                  title: 'This Week',
                  tasks: weekTasks,
                ),
                _buildSection(
                  context,
                  title: 'This Month',
                  tasks: monthTasks,
                ),
                _buildSection(
                  context,
                  title: 'Inbox (Brain Dump)',
                  tasks: inboxTasks,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        decoration: const InputDecoration(
                          hintText: 'Add task...',
                          border: OutlineInputBorder(),
                        ),
                        onSubmitted: (_) => _addTask(context),
                      ),
                    ),
                    const SizedBox(width: 8),
                    DropdownButton<TaskCategory>(
                      value: _selectedCategory,
                      onChanged: (value) {
                        if (value == null) return;
                        setState(() {
                          _selectedCategory = value;
                        });
                      },
                      items: const [
                        DropdownMenuItem(
                          value: TaskCategory.week,
                          child: Text('Week'),
                        ),
                        DropdownMenuItem(
                          value: TaskCategory.month,
                          child: Text('Month'),
                        ),
                        DropdownMenuItem(
                          value: TaskCategory.inbox,
                          child: Text('Inbox'),
                        ),
                      ],
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () => _addTask(context),
                      child: const Icon(Icons.add),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required List<PlannerTask> tasks,
  }) {
    final store = context.read<PlannerStore>();

    if (tasks.isEmpty) {
      return ListTile(
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: const Text('Nothing here. Yet.'),
      );
    }

    return ExpansionTile(
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      children: tasks
          .map(
            (task) => Dismissible(
              key: ValueKey(task.id),
              onDismissed: (_) => store.deleteTasksByIds([task.id]),
              background: Container(
                color: Colors.red,
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(left: 16),
                child: const Icon(Icons.delete, color: Colors.white),
              ),
              secondaryBackground: Container(
                color: Colors.red,
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 16),
                child: const Icon(Icons.delete, color: Colors.white),
              ),
              child: CheckboxListTile(
                value: task.isCompleted,
                onChanged: (_) => store.toggleTask(task),
                title: Text(
                  task.title,
                  style: TextStyle(
                    decoration: task.isCompleted
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                  ),
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}
