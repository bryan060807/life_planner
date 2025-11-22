import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../store/planner_store.dart';
import 'goal_detail_screen.dart';

class GoalsScreen extends StatefulWidget {
  const GoalsScreen({super.key});

  @override
  State<GoalsScreen> createState() => _GoalsScreenState();
}

class _GoalsScreenState extends State<GoalsScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _addGoal(BuildContext context) async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    final store = context.read<PlannerStore>();
    await store.addGoal(text);
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    final store = context.watch<PlannerStore>();
    final activeGoals = store.goals.where((g) => !g.isArchived).toList();
    final archivedGoals = store.goals.where((g) => g.isArchived).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Goals'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                if (activeGoals.isEmpty)
                  const ListTile(
                    title: Text('No goals yet.'),
                    subtitle: Text('Add one. Or keep drifting. Your call.'),
                  )
                else
                  ...[
                    const ListTile(
                      title: Text(
                        'Active Goals',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    ...activeGoals.map(
                      (goal) => ListTile(
                        title: Text(goal.title),
                        subtitle: goal.why.isNotEmpty
                            ? Text(
                                goal.why,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              )
                            : null,
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => GoalDetailScreen(goal: goal),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                if (archivedGoals.isNotEmpty) ...[
                  const Divider(),
                  const ListTile(
                    title: Text(
                      'Archived',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  ...archivedGoals.map(
                    (goal) => ListTile(
                      title: Text(
                        goal.title,
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ),
                  ),
                ],
              ],
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
                      hintText: 'New goal...',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => _addGoal(context),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () => _addGoal(context),
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
