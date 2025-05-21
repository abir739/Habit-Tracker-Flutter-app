import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';
import 'package:habit_tracker/database/habit_db.dart';
import 'package:habit_tracker/models/app_settings.dart';
import 'package:habit_tracker/models/habit_model.dart';
import 'package:habit_tracker/screens/heat_map_calendar.dart';
import 'package:habit_tracker/screens/motivations_class.dart';
import 'package:habit_tracker/screens/statistics_screen.dart';
import 'package:habit_tracker/theme/dark_mode.dart';
import 'package:habit_tracker/theme/theme_provider.dart';
import 'package:habit_tracker/widgets/my_drawer.dart';
import 'package:provider/provider.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:animations/animations.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:vibration/vibration.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final TextEditingController textController = TextEditingController();
  late TabController _tabController;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // // Sample motivational quotes
  // final List<String> _motivationalQuotes = [
  //   "Tu n’as pas besoin d’être motivé tous les jours. Tu as juste besoin d’être discipliné un peu chaque jour.",
  //   "📌 النجاح لا يبدأ بالاندفاع، بل بالاستمرارية.",
  //   "هذه لحظة تطويري. مهما كان شعوري، سأحترم هذا الموعد."
  //       "أنا أعمل من أجل نفسي، من أجل مستقبلي، من أجل خروجي من الدائرة الحالية."
  //       "البدايات من جديد لا تُقلل من قيمتك، بل تُثبت أنك أقوى من كل عثرة."
  //       "Small steps every day lead to big results.",
  //   "💬أنت لست ضعيفًا، أنت فقط توقفت لفترة. ولكن الآن، أنت في لحظة الرجوع، ولحظة الرجوع هي بداية النصر.",
  //   "Consistency is the key to success.",
  //   "Your habits shape your future.",
  //   "💬الألم الذي تشعر به لأنك لم تدرس، هو نفسه الوقود الذي سيحملك نحو النجاح، فقط تحرّك.",
  //   "Every day is a new chance to grow.",
  //   "💬 افعل القليل اليوم... وغدًا ستكون شخصًا يتجاوز المقابلات بثقة."
  //       "Stay committed, and watch your progress soar!"
  // ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    final habitDatabase = Provider.of<HabitDatabase>(context, listen: false);
    habitDatabase.saveFirstLaunchDate();
    habitDatabase.getAllHabits();
  }

  @override
  void dispose() {
    textController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  void createNewHabit() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 16,
          right: 16,
          top: 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Create New Habit',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: textController,
              decoration: InputDecoration(
                hintText: "What habit would you like to track?",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.primary,
                    width: 2,
                  ),
                ),
                filled: true,
                fillColor: Theme.of(context).colorScheme.surfaceContainer,
              ),
              autofocus: true,
              maxLength: 50,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    String newHabitName = textController.text.trim();
                    if (newHabitName.isNotEmpty) {
                      final newHabit = Habit()
                        ..name = newHabitName
                        ..completedDays = [];
                      context.read<HabitDatabase>().addHabit(newHabit);
                      Navigator.pop(context);
                      textController.clear();
                      Vibration.vibrate(duration: 100);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('New habit created!'),
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          backgroundColor:
                              Theme.of(context).colorScheme.primaryContainer,
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                  ),
                  child: const Text('Create'),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode =
        Provider.of<ThemeProvider>(context).themeData == darkMode;

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          'Habit Tracker',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
            Vibration.vibrate(duration: 50);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(isDarkMode ? Icons.dark_mode : Icons.light_mode),
            onPressed: () {
              Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
              Vibration.vibrate(duration: 50);
            },
            tooltip:
                isDarkMode ? 'Switch to Light Mode' : 'Switch to Dark Mode',
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Theme.of(context).colorScheme.primary,
          indicatorWeight: 4,
          labelStyle: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
          tabs: [
            const Tab(text: 'HABITS', icon: Icon(Icons.list_alt)),
            const Tab(text: 'PROGRESS', icon: Icon(Icons.calendar_month)),
          ],
        ),
      ),
      drawer: const MyDrawer(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: createNewHabit,
        elevation: 4,
        backgroundColor: Theme.of(context).colorScheme.primary,
        icon: Icon(
          Icons.add,
          color: Theme.of(context).colorScheme.onPrimary,
        ),
        label: Text(
          'New Habit',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.2, end: 0.0),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: TabBarView(
        controller: _tabController,
        children: [
          _habitListWidget(),
          _progressWidget(),
        ],
      ),
    );
  }

  // Progress tab with heatmap, stats, and motivational quote
  Widget _progressWidget() {
    return Consumer<HabitDatabase>(
      builder: (context, habitDatabase, child) {
        final habits = habitDatabase.getAllHabits();

        if (habits.isEmpty) {
          return _emptyStateWidget(
            'No habits to track yet',
            'Add your first habit to see your progress!',
            Icons.trending_up,
          );
        }

        final today = DateTime.now();
        final lastWeek = today.subtract(const Duration(days: 7));
        int totalPossible = habits.length * 7;
        int totalCompleted = 0;
        int longestStreak = 0;

        for (var habit in habits) {
          int currentStreak = 0;
          DateTime checkDate = today;
          while (true) {
            final normalizedCheck =
                DateTime(checkDate.year, checkDate.month, checkDate.day);
            if (habit.completedDays.contains(normalizedCheck)) {
              currentStreak++;
              checkDate = checkDate.subtract(const Duration(days: 1));
            } else {
              break;
            }
          }
          longestStreak =
              currentStreak > longestStreak ? currentStreak : longestStreak;
          for (var i = 0; i < 7; i++) {
            final checkDate = today.subtract(Duration(days: i));
            final normalizedDate =
                DateTime(checkDate.year, checkDate.month, checkDate.day);
            if (habit.completedDays.contains(normalizedDate)) {
              totalCompleted++;
            }
          }
        }

        double completionRate =
            totalPossible > 0 ? totalCompleted / totalPossible : 0;

        final AppSettings? settings = habitDatabase.settingsBox.get('settings');
        final DateTime startDate = settings?.firstLaunchDate ?? DateTime.now();

        final habit = habits.first;
        final Map<DateTime, int> datasets = {
          for (var date in habit.completedDays)
            DateTime(date.year, date.month, date.day): 1,
        };
// Function to detect if text is Arabic (RTL)
        bool isArabic(String text) {
          final arabicRegex = RegExp(r'[\u0600-\u06FF]');
          return arabicRegex.hasMatch(text);
        }

        final random = Random();
        final quote =
            motivationalQuotes[random.nextInt(motivationalQuotes.length)];
        return SingleChildScrollView(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Motivational Quote Card
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Daily Motivation',
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          quote.text,
                          style:
                              Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    fontStyle: FontStyle.italic,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurfaceVariant,
                                  ),
                          textDirection: quote.direction,
                          textAlign: quote.direction == TextDirection.rtl
                              ? TextAlign.right
                              : TextAlign.left,
                        ),
                      ],
                    ),
                  ),
                )
                    .animate()
                    .fadeIn(duration: 800.ms)
                    .slideX(begin: -0.2, end: 0.0),
                const SizedBox(height: 24),
                // Streak Summary Card
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Your Streaks',
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _streakTile(
                              context,
                              'Longest Streak',
                              '$longestStreak days',
                              Icons.local_fire_department,
                              Colors.orange,
                            ),
                            _streakTile(
                              context,
                              'Active Habits',
                              '${habits.length}',
                              Icons.favorite,
                              Colors.red,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                )
                    .animate()
                    .fadeIn(duration: 800.ms)
                    .slideX(begin: 0.2, end: 0.0),
                const SizedBox(height: 24),
                // Progress Card
                OpenContainer(
                  transitionType: ContainerTransitionType.fadeThrough,
                  closedElevation: 4,
                  closedShape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  closedBuilder: (context, action) => Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Last 7 Days',
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            CircularPercentIndicator(
                              radius: 60.0,
                              lineWidth: 12.0,
                              percent: completionRate,
                              center: Text(
                                "${(completionRate * 100).toStringAsFixed(0)}%",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20.0,
                                ),
                              ),
                              progressColor:
                                  Theme.of(context).colorScheme.primary,
                              backgroundColor: Theme.of(context)
                                  .colorScheme
                                  .surfaceContainer,
                              circularStrokeCap: CircularStrokeCap.round,
                              animation: true,
                              animationDuration: 1200,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _statRow(Icons.check_circle_outline,
                                    '$totalCompleted Completed', Colors.green),
                                const SizedBox(height: 8),
                                _statRow(
                                    Icons.trending_up,
                                    '${habits.length} Active Habits',
                                    Theme.of(context).colorScheme.primary),
                                const SizedBox(height: 8),
                                _statRow(
                                    Icons.calendar_today,
                                    '${DateTime.now().difference(startDate).inDays} Days Tracked',
                                    Colors.orange),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  openBuilder: (context, action) => const StatisticsScreen(),
                ).animate().fadeIn(duration: 1000.ms).scale(),
                const SizedBox(height: 24),
                Text(
                  'Habit Activity',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                ),
                const SizedBox(height: 16),
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: HeatMap(
                      startDate: startDate,
                      endDate: DateTime.now(),
                      datasets: datasets,
                      colorMode: ColorMode.opacity,
                      defaultColor:
                          Theme.of(context).colorScheme.secondaryContainer,
                      textColor: Theme.of(context).colorScheme.onSurface,
                      showColorTip: true,
                      showText: true,
                      scrollable: true,
                      size: 36,
                      colorsets: {
                        1: Colors.green.shade200,
                        2: Colors.green.shade300,
                        3: Colors.green.shade400,
                        4: Colors.green.shade500,
                        5: Colors.green.shade600,
                      },
                      onClick: (value) {
                        Vibration.vibrate(duration: 50);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              "${value.day}/${value.month}/${value.year}",
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            behavior: SnackBarBehavior.floating,
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                            duration: const Duration(seconds: 1),
                          ),
                        );
                      },
                    ),
                  ),
                )
                    .animate()
                    .fadeIn(duration: 1200.ms)
                    .slideY(begin: 0.2, end: 0.0),
                const SizedBox(height: 24),
                Text(
                  'Habit Details',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                ),
                const SizedBox(height: 8),
                ...habits.map((habit) {
                  int completedCount = habit.completedDays.length;
                  int recentCompletions = 0;
                  for (var i = 0; i < 7; i++) {
                    final checkDate = today.subtract(Duration(days: i));
                    final normalizedDate = DateTime(
                        checkDate.year, checkDate.month, checkDate.day);
                    if (habit.completedDays.contains(normalizedDate)) {
                      recentCompletions++;
                    }
                  }

                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: OpenContainer(
                      transitionType: ContainerTransitionType.fadeThrough,
                      closedElevation: 2,
                      closedShape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      closedBuilder: (context, action) => ListTile(
                        title: Text(
                          habit.name ?? 'Unnamed Habit',
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        subtitle: Text('$recentCompletions/7 days this week'),
                        trailing: CircularPercentIndicator(
                          radius: 24.0,
                          lineWidth: 5.0,
                          percent: recentCompletions / 7,
                          center: Text(
                            "$recentCompletions",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12.0,
                            ),
                          ),
                          progressColor: recentCompletions >= 5
                              ? Colors.green
                              : recentCompletions >= 3
                                  ? Colors.orange
                                  : Colors.red,
                          backgroundColor:
                              Theme.of(context).colorScheme.surfaceContainer,
                          circularStrokeCap: CircularStrokeCap.round,
                        ),
                      ),
                      openBuilder: (context, action) => HeatmapCalendar(
                        habit: habit,
                        datasets: {
                          for (var date in habit.completedDays)
                            DateTime(date.year, date.month, date.day): 1,
                        },
                        startDate:
                            DateTime.now().subtract(const Duration(days: 60)),
                      ),
                    ),
                  )
                      .animate()
                      .fadeIn(duration: 800.ms)
                      .slideX(begin: 0.1, end: 0.0);
                }).toList(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _streakTile(BuildContext context, String title, String value,
      IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 32),
        const SizedBox(height: 8),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
        ),
        Text(
          title,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
        ),
      ],
    );
  }

  Widget _statRow(IconData icon, String text, Color color) {
    return Row(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 8),
        Text(
          text,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ],
    );
  }

  // Habits tab with list of habits
  Widget _habitListWidget() {
    return Consumer<HabitDatabase>(
      builder: (context, habitDatabase, child) {
        final habits = habitDatabase.getAllHabits();

        if (habits.isEmpty) {
          return _emptyStateWidget(
            'No habits yet',
            'Tap the + button to add your first habit!',
            Icons.add_task,
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.only(bottom: 80),
          itemCount: habits.length,
          itemBuilder: (context, index) {
            final habit = habits[index];
            final today = DateTime.now();
            final normalizedToday =
                DateTime(today.year, today.month, today.day);
            final isCompletedToday =
                habit.completedDays.contains(normalizedToday);

            // Calculate streak
            int currentStreak = 0;
            DateTime checkDate = normalizedToday;

            if (isCompletedToday) {
              currentStreak = 1;
              checkDate = checkDate.subtract(const Duration(days: 1));
            }

            while (true) {
              final normalizedCheck =
                  DateTime(checkDate.year, checkDate.month, checkDate.day);
              if (habit.completedDays.contains(normalizedCheck)) {
                currentStreak++;
                checkDate = checkDate.subtract(const Duration(days: 1));
              } else {
                break;
              }
            }

            return Slidable(
              endActionPane: ActionPane(
                motion: const ScrollMotion(),
                children: [
                  SlidableAction(
                    onPressed: (context) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HeatmapCalendar(
                            habit: habit,
                            datasets: {
                              for (var date in habit.completedDays)
                                DateTime(date.year, date.month, date.day): 1,
                            },
                            startDate: DateTime.now()
                                .subtract(const Duration(days: 60)),
                          ),
                        ),
                      );
                    },
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    icon: Icons.calendar_month,
                    label: 'Stats',
                  ),
                  SlidableAction(
                    onPressed: (context) {
                      textController.text = habit.name ?? '';
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text(
                            'Edit Habit',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          content: TextField(
                            controller: textController,
                            decoration: InputDecoration(
                              hintText: 'Edit habit name',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              filled: true,
                              fillColor: Theme.of(context)
                                  .colorScheme
                                  .surfaceContainer,
                            ),
                            autofocus: true,
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Cancel'),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                String newName = textController.text.trim();
                                if (newName.isNotEmpty) {
                                  habitDatabase.UpdateHabitName(index, newName);
                                  Navigator.pop(context);
                                  textController.clear();
                                  Vibration.vibrate(duration: 100);
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Theme.of(context).colorScheme.primary,
                                foregroundColor:
                                    Theme.of(context).colorScheme.onPrimary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text('Save'),
                            ),
                          ],
                        ),
                      );
                    },
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    icon: Icons.edit,
                    label: 'Edit',
                  ),
                  SlidableAction(
                    onPressed: (context) {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Delete Habit'),
                          content: Text(
                            'Are you sure you want to delete "${habit.name}" ?',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () {
                                habitDatabase.deleteHabit(index);
                                Navigator.pop(context);
                                Vibration.vibrate(duration: 100);
                              },
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.red,
                              ),
                              child: const Text('Delete'),
                            ),
                          ],
                        ),
                      );
                    },
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    icon: Icons.delete,
                    label: 'Delete',
                  ),
                ],
              ),
              child: Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: isCompletedToday
                      ? BorderSide(
                          color: Colors.green,
                          // color: Theme.of(context).colorScheme.primary,
                          width: 2)
                      : BorderSide.none,
                ),
                child: ListTile(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  title: Text(
                    habit.name ?? 'Unnamed Habit',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          decoration: isCompletedToday
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                        ),
                  ),
                  subtitle: currentStreak > 0
                      ? Text(
                          '🔥 $currentStreak day streak',
                          style: TextStyle(
                            color: Colors.orange,
                            fontWeight: FontWeight.w600,
                          ),
                        )
                      : null,
                  leading: CircleAvatar(
                    backgroundColor: isCompletedToday
                        ? Colors.green
                        // ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.surfaceContainer,
                    child: IconButton(
                      icon: Icon(
                        isCompletedToday
                            ? Icons.check_circle
                            : Icons.circle_outlined,
                        color: isCompletedToday
                            ? Theme.of(context).colorScheme.onPrimary
                            : Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      onPressed: () {
                        habitDatabase.toggleHabitCompletion(index);
                        Vibration.vibrate(duration: 100);
                      },
                    ),
                  ),
                  trailing: Text(
                    'Total: ${habit.completedDays.length}',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.1, end: 0.0);
          },
        );
      },
    );
  }

  Widget _emptyStateWidget(String title, String subtitle, IconData icon) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 100,
              color: Theme.of(context).colorScheme.primary.withOpacity(0.6),
            ).animate().scale(duration: 800.ms, curve: Curves.easeInOut),
            const SizedBox(height: 24),
            Text(
              title,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              subtitle,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: createNewHabit,
              icon: const Icon(Icons.add),
              label: const Text('Add Your First Habit'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ).animate().fadeIn(duration: 1000.ms).slideY(begin: 0.2, end: 0.0),
          ],
        ),
      ),
    );
  }
}
