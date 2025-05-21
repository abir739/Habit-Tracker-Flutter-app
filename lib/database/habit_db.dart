import 'package:flutter/material.dart';
import 'package:habit_tracker/models/app_settings.dart';
import 'package:habit_tracker/models/habit_model.dart';
import 'package:hive/hive.dart';

class HabitDatabase extends ChangeNotifier {
  // reference the hive box
  // open and get box

  final Box<Habit> habitBox = Hive.box<Habit>('habits');
  final Box<AppSettings> settingsBox = Hive.box<AppSettings>('app_settings');

  // save first launch date
  Future<void> saveFirstLaunchDate() async {
    if (settingsBox.isEmpty) {
      await settingsBox.put(
          'settings', AppSettings()..firstLaunchDate = DateTime.now());
    }
  }

  // get all Habits
  List<Habit> getAllHabits() => habitBox.values.toList();

  // add habit
  Future<void> addHabit(Habit habit) async {
    await habitBox.add(habit);
    notifyListeners();
  }

  // delete habit
  Future<void> deleteHabit(int index) async {
    await habitBox.deleteAt(index);
    notifyListeners();
  }

  // Toggle completion for today : check habit on and off
  Future<void> toggleHabitCompletion(int index) async {
    final habit = habitBox.getAt(index);
    if (habit == null) return;

    final today = DateTime.now();
    final normalizedtoday = DateTime(today.year, today.month, today.day);

    if (habit.completedDays.contains(normalizedtoday)) {
      habit.completedDays.remove(normalizedtoday);
    } else {
      habit.completedDays.add(normalizedtoday);
    }

    // await update and save
    await habitBox.putAt(index, habit);
    notifyListeners();
  }

  // Update: edit Habit name
  Future<void> UpdateHabitName(int index, String newName) async {
    final habit = habitBox.getAt(index);

    if (habit == null) return;

    habit.name = newName;
    await habitBox.putAt(index, habit);
    notifyListeners();
  }


}
