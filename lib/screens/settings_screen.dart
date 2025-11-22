import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // For now this is just vibes & text. You can hook real settings later.
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: const [
          ListTile(
            title: Text('Daily reminder'),
            subtitle: Text(
              'To actually remind you, you’ll need to wire platform notifications.\nThis is just the part where you pretend you’ll do it later.',
            ),
          ),
          Divider(),
          ListTile(
            title: Text('About'),
            subtitle: Text(
              'Get-Your-Life-Together Planner\nBuilt by you, bullied into existence by an AI.',
            ),
          ),
        ],
      ),
    );
  }
}
