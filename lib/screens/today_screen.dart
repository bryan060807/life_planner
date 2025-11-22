import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../store/planner_store.dart';
import '../models/planner_task.dart';
import '../models/task_category.dart';

class TodayScreen extends StatefulWidget {
  const TodayScreen({super.key});

  @override
  State<TodayScreen> createState() => _TodayScreenState();
}

class _TodayScreenState extends State<TodayScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _addTask(BuildContext context) async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    final store = context.read<PlannerStore>();
    await store.addTask(text, TaskCategory.today);
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    final store = context.watch<PlannerStore>();
    final tasks = store.tasksForCategory(TaskCategory.today);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Today's Priorities"),
      ),
      body: Column(
        children: [
          Expanded(
            child: tasks.isEmpty
                ? const Center(
                    child: Text(
                      'No tasks yet. Start pretending to be productive.',
                      textAlign: TextAlign.center,
                    ),
                  )
                : ListView.builder(
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      final task = tasks[index];
                      return _TaskTile(task: task);
                    },
                  ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: "Add today's task...",
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => _addTask(context),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () => _addTask(context),
                  child: const Icon(Icons.add),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TaskTile extends StatelessWidget {
  final PlannerTask task;
  const _TaskTile({required this.task});

  @override
  Widget build(BuildContext context) {
    final store = context.read<PlannerStore>();

    return Dismissible(
      key: ValueKey(task.id),
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
      onDismissed: (_) {
        store.deleteTasksByIds([task.id]);
      },
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
    );
  }
}
