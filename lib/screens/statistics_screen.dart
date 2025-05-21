import 'package:flutter/material.dart';
import 'package:habit_tracker/database/habit_db.dart';
import 'package:habit_tracker/models/app_settings.dart';
import 'package:provider/provider.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<HabitDatabase>(
      builder: (context, habitDatabase, child) {
        final habits = habitDatabase.getAllHabits();
        final AppSettings? settings = habitDatabase.settingsBox.get('settings');
        final DateTime startDate = settings?.firstLaunchDate ?? DateTime.now();
        final int daysSinceStart = DateTime.now().difference(startDate).inDays + 1;

        int totalCompletions = habits.fold(0, (sum, habit) => sum + habit.completedDays.length);
        double completionRate = habits.isEmpty
            ? 0
            : (totalCompletions / (habits.length * daysSinceStart)) * 100;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Statistics'),
            centerTitle: true,
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Overall Progress',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                        ),
                        const SizedBox(height: 8),
                        Text('Total Habits: ${habits.length}'),
                        Text('Total Completions: $totalCompletions'),
                        Text('Completion Rate: ${completionRate.toStringAsFixed(1)}%'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}