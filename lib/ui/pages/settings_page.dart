import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider/scheduling_provider.dart';
import '../../provider/theme_provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Consumer2<ThemeProvider, SchedulingProvider>(
        builder: (context, themeProvider, schedulingProvider, child) {
          return ListView(
            children: [
              Material(
                child: ListTile(
                  title: const Text('Dark Theme'),
                  trailing: Switch.adaptive(
                    value: themeProvider.isDarkTheme,
                    onChanged: (value) {
                      themeProvider.enableDarkTheme(value);
                    },
                  ),
                ),
              ),
              Material(
                child: ListTile(
                  title: const Text('Daily Reminder (11 AM)'),
                  trailing: Switch.adaptive(
                    value: schedulingProvider.isScheduled,
                    onChanged: (value) async {
                      await schedulingProvider.scheduledNews(value);
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
