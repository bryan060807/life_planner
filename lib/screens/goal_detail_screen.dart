import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/goal.dart';
import '../store/planner_store.dart';

class GoalDetailScreen extends StatefulWidget {
  final Goal goal;
  const GoalDetailScreen({super.key, required this.goal});

  @override
  State<GoalDetailScreen> createState() => _GoalDetailScreenState();
}

class _GoalDetailScreenState extends State<GoalDetailScreen> {
  late Goal _goal;
  final TextEditingController _stepController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _goal = widget.goal.copyWith(); // shallow copy
  }

  @override
  void dispose() {
    _stepController.dispose();
    super.dispose();
  }

  Future<void> _save(BuildContext context) async {
    final store = context.read<PlannerStore>();
    await store.updateGoal(_goal);
    if (mounted) Navigator.of(context).pop();
  }

  void _addStep() {
    final text = _stepController.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _goal.steps.add(text);
      _stepController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Goal'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () => _save(context),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            decoration: const InputDecoration(
              labelText: 'Title',
              border: OutlineInputBorder(),
            ),
            controller: TextEditingController(text: _goal.title),
            onChanged: (value) => _goal.title = value,
          ),
          const SizedBox(height: 16),
          TextField(
            decoration: const InputDecoration(
              labelText: 'Why this matters',
              border: OutlineInputBorder(),
            ),
            minLines: 2,
            maxLines: 5,
            controller: TextEditingController(text: _goal.why),
            onChanged: (value) => _goal.why = value,
          ),
          const SizedBox(height: 24),
          const Text(
            'Steps',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          if (_goal.steps.isEmpty)
            const Text(
              'Add small, painfully specific steps.',
              style: TextStyle(color: Colors.grey),
            ),
          ..._goal.steps.asMap().entries.map(
                (entry) => ListTile(
                  title: Text(entry.value),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      setState(() {
                        _goal.steps.removeAt(entry.key);
                      });
                    },
                  ),
                ),
              ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _stepController,
                  decoration: const InputDecoration(
                    hintText: 'New step...',
                    border: OutlineInputBorder(),
                  ),
                  onSubmitted: (_) => _addStep(),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: _addStep,
                child: const Icon(Icons.add),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SwitchListTile(
            title: const Text('Archive goal'),
            value: _goal.isArchived,
            onChanged: (val) {
              setState(() {
                _goal.isArchived = val;
              });
            },
          ),
        ],
      ),
    );
  }
}
