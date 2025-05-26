import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';
import 'package:habit_tracker/models/habit_model.dart';

class HeatmapCalendar extends StatelessWidget {
  final Habit habit;
  final DateTime startDate;
  final Map<DateTime, int> datasets;

  const HeatmapCalendar({
    super.key,
    required this.habit,
    required this.datasets,
    required this.startDate,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
      appBar: AppBar(
        title: Text('${habit.name ?? 'Habit'} Heatmap'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            HeatMap(
              startDate: startDate,
              endDate: DateTime.now(),
              datasets: datasets,
              colorMode: ColorMode.opacity,
              defaultColor: Theme.of(context).colorScheme.secondary,
              textColor: Colors.white,
              showColorTip: true,
              showText: true,
              scrollable: true,
              size: 30,
              colorsets: {
                1: Colors.green.shade200,
                2: Colors.green.shade300,
                3: Colors.green.shade400,
                4: Colors.green.shade500,
                5: Colors.green.shade600,
                6: Colors.green.shade700,
                7: Colors.green.shade800,
              },
              onClick: (value) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(value.toString())),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
