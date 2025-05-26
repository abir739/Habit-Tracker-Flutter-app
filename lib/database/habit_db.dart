import 'package:flutter/material.dart';
import 'package:habit_tracker/models/app_settings.dart';
import 'package:habit_tracker/models/habit_model.dart';
import 'package:hive/hive.dart';

class HabitDatabase extends ChangeNotifier {
  final Box<Habit> habitBox = Hive.box<Habit>('habits');
  final Box<AppSettings> settingsBox = Hive.box<AppSettings>('app_settings');

// Save the app’s first launch date if not already set
  Future<void> saveFirstLaunchDate() async {
    if (settingsBox.isEmpty) {
      await settingsBox.put(
          'settings', AppSettings()..firstLaunchDate = DateTime.now());
    }
  }

// Retrieve all habits
  List<Habit> getAllHabits() => habitBox.values.toList();

// Add a new habit to the box
  Future<void> addHabit(Habit habit) async {
    await habitBox.add(habit);
    notifyListeners();
  }

// Remove a habit by index
  Future<void> deleteHabit(int index) async {
    await habitBox.deleteAt(index);
    notifyListeners();
  }

// Toggle a habit’s completion status for today
  Future<void> toggleHabitCompletion(int index, DateTime date) async {
    final habit = habitBox.getAt(index);
    if (habit == null) return;

    // final today = DateTime.now();
    // final normalizedtoday = DateTime(today.year, today.month, today.day);
    final normalizedtoday = DateTime(date.year, date.month, date.day);
    if (habit.completedDays.contains(normalizedtoday)) {
      habit.completedDays.remove(normalizedtoday);
    } else {
      habit.completedDays.add(normalizedtoday);
    }

    // await update and save
    await habitBox.putAt(index, habit);
    notifyListeners();
  }

  // Update a habit’s name
  Future<void> updateHabitName(int index, String newName) async {
    final habit = habitBox.getAt(index);

    if (habit == null) return;

    habit.name = newName;
    await habitBox.putAt(index, habit);
    notifyListeners();
  }
}
