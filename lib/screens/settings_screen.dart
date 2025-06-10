import 'package:flutter/material.dart';
import '../models/urgency_setting.dart';
import '../models/task.dart';

class SettingsScreen extends StatefulWidget {
  final Map<Urgency, UrgencySetting> settings;
  final void Function(Urgency, int) onChanged;
  const SettingsScreen({super.key, required this.settings, required this.onChanged});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late Map<Urgency, TextEditingController> _controllers;

  @override
  void initState() {
    super.initState();
    _controllers = {
      for (var entry in widget.settings.entries)
        entry.key: TextEditingController(text: entry.value.minutes.toString())
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: widget.settings.keys.map((key) {
          return ListTile(
            title: Text('${key.name} minutes'),
            trailing: SizedBox(
              width: 80,
              child: TextField(
                controller: _controllers[key],
                keyboardType: TextInputType.number,
                onSubmitted: (value) {
                  final minutes = int.tryParse(value) ?? widget.settings[key]!.minutes;
                  widget.onChanged(key, minutes);
                },
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
