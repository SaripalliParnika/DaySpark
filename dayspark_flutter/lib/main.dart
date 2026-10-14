import 'package:flutter/material.dart';
import 'package:dayspark_client/dayspark_client.dart' as sp;
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

import 'client.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeClient();
  runApp(const DaySparkApp());
}

// ============================================================
// THEME — YOUR ORIGINAL UI
// ============================================================

class DS {
  static const teal = Color(0xFF287C78);
  static const tealDark = Color(0xFF1D625F);
  static const gold = Color(0xFFE4B66B);
  static const coral = Color(0xFFCF796A);
  static const green = Color(0xFF318568);
  static const lightBg = Color(0xFFF5F7F6);
  static const darkBg = Color(0xFF111A20);
  static const darkCard = Color(0xFF1C2931);
}

ThemeData makeTheme(bool dark) {
  final scheme = ColorScheme.fromSeed(
    seedColor: DS.teal,
    brightness: dark ? Brightness.dark : Brightness.light,
  );

  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: dark ? DS.darkBg : DS.lightBg,
    appBarTheme: const AppBarTheme(
      elevation: 0,
      centerTitle: false,
    ),
    cardTheme: CardThemeData(
      elevation: 0,
      color: dark ? DS.darkCard : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      margin: EdgeInsets.zero,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(13),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 15,
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: DS.teal,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 14,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(13),
        ),
      ),
    ),
  );
}

// ============================================================
// APP + AUTHENTICATION GATE
// ============================================================

class DaySparkApp extends StatefulWidget {
  const DaySparkApp({super.key});

  @override
  State<DaySparkApp> createState() => _DaySparkAppState();
}

class _DaySparkAppState extends State<DaySparkApp> {
  bool darkMode = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DaySpark',
      debugShowCheckedModeBanner: false,
      theme: makeTheme(false),
      darkTheme: makeTheme(true),
      themeMode: darkMode ? ThemeMode.dark : ThemeMode.light,
      home: DaySparkAuthGate(
        darkMode: darkMode,
        onThemeChanged: (value) => setState(() => darkMode = value),
      ),
    );
  }
}

class DaySparkAuthGate extends StatefulWidget {
  const DaySparkAuthGate({
    super.key,
    required this.darkMode,
    required this.onThemeChanged,
  });

  final bool darkMode;
  final ValueChanged<bool> onThemeChanged;

  @override
  State<DaySparkAuthGate> createState() => _DaySparkAuthGateState();
}

class _DaySparkAuthGateState extends State<DaySparkAuthGate> {
  bool get authenticated => client.auth.isAuthenticated;

  void refreshAuth() {
    if (mounted) setState(() {});
  }

  Future<void> logout() async {
    try {
      await client.auth.signOutDevice();
      refreshAuth();
    } catch (e) {
      debugPrint('Logout failed: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (authenticated) {
      return DaySparkHome(
        darkMode: widget.darkMode,
        onThemeChanged: widget.onThemeChanged,
        onLogout: logout,
      );
    }

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 460),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: DS.teal.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(22),
                    ),
                    child: const Icon(
                      Icons.wb_sunny_rounded,
                      color: DS.teal,
                      size: 42,
                    ),
                  ),
                  const SizedBox(height: 18),
                  const Text(
                    'DaySpark',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Make progress, one small step at a time.',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 28),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: EmailSignInWidget(
                        client: client,
                        onAuthenticated: refreshAuth,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================================
// TASK MODEL
// ============================================================

class PlanTask {
  PlanTask({
    this.id,
    required this.title,
    required this.category,
    required this.minutes,
    required this.priority,
    required this.completed,
    required this.createdAt,
  });

  int? id;
  String title;
  String category;
  int minutes;
  String priority;
  bool completed;
  DateTime createdAt;
}

// ============================================================
// MAIN SCREEN
// ============================================================

class DaySparkHome extends StatefulWidget {
  const DaySparkHome({
    super.key,
    required this.darkMode,
    required this.onThemeChanged,
    required this.onLogout,
  });

  final bool darkMode;
  final ValueChanged<bool> onThemeChanged;
  final Future<void> Function() onLogout;

  @override
  State<DaySparkHome> createState() => _DaySparkHomeState();
}

class _DaySparkHomeState extends State<DaySparkHome> {
  final List<PlanTask> tasks = [];

  int selectedPage = 0;
  String filter = 'All';
  String categoryFilter = 'All';
  String sortBy = 'Priority';
  String searchQuery = '';

  bool loading = true;
  bool saving = false;
  String? errorMessage;
  String? sparkTaskTitle;

  final searchController = TextEditingController();

  final categories = const [
    'Learning',
    'Career',
    'Personal',
    'Health',
  ];

  @override
  void initState() {
    super.initState();
    loadTasks();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  int priorityToNumber(String priority) {
    switch (priority) {
      case 'High':
        return 3;
      case 'Low':
        return 1;
      default:
        return 2;
    }
  }

  String numberToPriority(int value) {
    if (value >= 3) return 'High';
    if (value <= 1) return 'Low';
    return 'Medium';
  }

  PlanTask fromServer(sp.DayTask task) {
    return PlanTask(
      id: task.id,
      title: task.title,
      category: task.description ?? 'Personal',
      minutes: task.durationMinutes,
      priority: numberToPriority(task.priority),
      completed: task.isCompleted,
      createdAt: task.createdAt,
    );
  }

  sp.DayTask toServer(PlanTask task) {
    return sp.DayTask(
      id: task.id,
      title: task.title,
      description: task.category,
      durationMinutes: task.minutes,
      priority: priorityToNumber(task.priority),
      isCompleted: task.completed,
      createdAt: task.createdAt,
    );
  }

  Future<void> loadTasks() async {
    if (mounted) {
      setState(() {
        loading = true;
        errorMessage = null;
      });
    }

    try {
      final result = await client.task.getTasks();

      if (!mounted) return;

      setState(() {
        tasks
          ..clear()
          ..addAll(result.map(fromServer));
        loading = false;
      });
    } catch (e, stack) {
      debugPrint('Load tasks failed: $e');
      debugPrintStack(stackTrace: stack);

      if (!mounted) return;

      setState(() {
        loading = false;
        errorMessage =
            'Unable to connect. Check that your Serverpod server '
            'and database are running.';
      });
    }
  }

  int get completedCount => tasks.where((t) => t.completed).length;

  int get remainingCount => tasks.where((t) => !t.completed).length;

  int get remainingMinutes => tasks
      .where((t) => !t.completed)
      .fold(0, (sum, task) => sum + task.minutes);

  double get progress =>
      tasks.isEmpty ? 0 : completedCount / tasks.length;

  Color get muted =>
      widget.darkMode ? Colors.white60 : Colors.black54;

  List<PlanTask> get visibleTasks {
    final query = searchQuery.trim().toLowerCase();

    final result = tasks.where((task) {
      if (filter == 'Completed' && !task.completed) return false;
      if (filter == 'Remaining' && task.completed) return false;

      if (categoryFilter != 'All' &&
          task.category != categoryFilter) {
        return false;
      }

      if (query.isNotEmpty &&
          !task.title.toLowerCase().contains(query) &&
          !task.category.toLowerCase().contains(query)) {
        return false;
      }

      return true;
    }).toList();

    result.sort((a, b) {
      if (sortBy == 'Priority') {
        if (a.completed != b.completed) {
          return a.completed ? 1 : -1;
        }
        return priorityToNumber(b.priority)
            .compareTo(priorityToNumber(a.priority));
      }

      if (sortBy == 'Shortest first') {
        return a.minutes.compareTo(b.minutes);
      }

      if (sortBy == 'Longest first') {
        return b.minutes.compareTo(a.minutes);
      }

      if (sortBy == 'Newest first') {
        return b.createdAt.compareTo(a.createdAt);
      }

      return a.title.toLowerCase().compareTo(b.title.toLowerCase());
    });

    return result;
  }

  void showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  // ==========================================================
  // ADD / EDIT TASK
  // ==========================================================

  Future<void> showTaskEditor({PlanTask? existing}) async {
    final editing = existing != null;
    final formKey = GlobalKey<FormState>();

    final titleController = TextEditingController(
      text: existing?.title ?? '',
    );
    final minutesController = TextEditingController(
      text: '${existing?.minutes ?? 25}',
    );

    String category = existing?.category ?? 'Learning';
    String priority = existing?.priority ?? 'Medium';

    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(editing ? 'Edit task' : 'Create a task'),
              content: SizedBox(
                width: 430,
                child: Form(
                  key: formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextFormField(
                          controller: titleController,
                          autofocus: true,
                          maxLength: 100,
                          decoration: const InputDecoration(
                            labelText: 'Task name',
                            hintText: 'e.g. Practice Java for 25 minutes',
                            prefixIcon: Icon(Icons.edit_note_rounded),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter a task name.';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 12),
                        DropdownButtonFormField<String>(
                          initialValue: category,
                          decoration: const InputDecoration(
                            labelText: 'Category',
                            prefixIcon: Icon(Icons.category_outlined),
                          ),
                          items: categories.map((item) {
                            return DropdownMenuItem(
                              value: item,
                              child: Text(item),
                            );
                          }).toList(),
                          onChanged: (value) {
                            if (value != null) {
                              setDialogState(() => category = value);
                            }
                          },
                        ),
                        const SizedBox(height: 14),
                        DropdownButtonFormField<String>(
                          initialValue: priority,
                          decoration: const InputDecoration(
                            labelText: 'Priority',
                            prefixIcon: Icon(Icons.flag_outlined),
                          ),
                          items: const ['High', 'Medium', 'Low'].map((item) {
                            return DropdownMenuItem(
                              value: item,
                              child: Text(item),
                            );
                          }).toList(),
                          onChanged: (value) {
                            if (value != null) {
                              setDialogState(() => priority = value);
                            }
                          },
                        ),
                        const SizedBox(height: 14),
                        TextFormField(
                          controller: minutesController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Estimated duration',
                            suffixText: 'minutes',
                            prefixIcon: Icon(Icons.schedule_outlined),
                          ),
                          validator: (value) {
                            final minutes = int.tryParse(value ?? '');
                            if (minutes == null ||
                                minutes < 1 ||
                                minutes > 1440) {
                              return 'Enter a duration from 1 to 1440.';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext, false),
                  child: const Text('Cancel'),
                ),
                FilledButton.icon(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      Navigator.pop(dialogContext, true);
                    }
                  },
                  icon: Icon(editing ? Icons.save_outlined : Icons.add),
                  label: Text(editing ? 'Save changes' : 'Create task'),
                ),
              ],
            );
          },
        );
      },
    );

    if (result != true || !mounted) {
      titleController.dispose();
      minutesController.dispose();
      return;
    }

    final title = titleController.text.trim();
    final minutes = int.parse(minutesController.text.trim());

    setState(() => saving = true);

    try {
      if (editing) {
        final updated = PlanTask(
          id: existing.id,
          title: title,
          category: category,
          minutes: minutes,
          priority: priority,
          completed: existing.completed,
          createdAt: existing.createdAt,
        );

        await client.task.updateTask(toServer(updated));

        if (!mounted) return;

        final index = tasks.indexWhere((t) => t.id == existing.id);
        if (index != -1) {
          setState(() => tasks[index] = updated);
        }

        showMessage('Task updated successfully.');
      } else {
        final saved = await client.task.addTask(
          title: title,
          description: category,
          durationMinutes: minutes,
          priority: priorityToNumber(priority),
        );

        if (!mounted) return;

        setState(() {
          tasks.add(fromServer(saved));
          errorMessage = null;
        });

        showMessage('Your new task is saved.');
      }
    } catch (e, stack) {
      debugPrint('Save task failed: $e');
      debugPrintStack(stackTrace: stack);
      showMessage(
        editing
            ? 'Could not update the task. Please try again.'
            : 'Could not save the task. Check the server.',
      );
    } finally {
      titleController.dispose();
      minutesController.dispose();

      if (mounted) setState(() => saving = false);
    }
  }

  // ==========================================================
  // COMPLETE / UNCOMPLETE
  // ==========================================================

  Future<void> toggleTask(PlanTask task, bool? checked) async {
    if (checked == null) return;

    final oldValue = task.completed;

    setState(() => task.completed = checked);

    if (task.id == null) {
      setState(() => task.completed = oldValue);
      showMessage('Task ID missing. Refresh and try again.');
      return;
    }

    try {
      await client.task.updateTask(toServer(task));

      if (mounted) {
        showMessage(
          checked ? 'One small win. Well done!' : 'Task marked as remaining.',
        );
      }
    } catch (e) {
      debugPrint('Update completion failed: $e');

      if (!mounted) return;

      setState(() => task.completed = oldValue);
      showMessage('Could not update this task. Please try again.');
    }
  }

  // ==========================================================
  // DELETE
  // ==========================================================

  Future<void> deleteTask(PlanTask task) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        icon: const Icon(
          Icons.delete_outline_rounded,
          color: DS.coral,
          size: 34,
        ),
        title: const Text('Delete this task?'),
        content: Text('“${task.title}” will be removed permanently.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Keep task'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: DS.coral),
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    try {
      if (task.id == null) {
        showMessage('Task ID missing. Refresh and try again.');
        return;
      }

      final deleted = await client.task.deleteTask(task.id!);

      if (!mounted) return;

      if (deleted) {
        setState(() {
          tasks.removeWhere((t) => t.id == task.id);
          if (sparkTaskTitle == task.title) sparkTaskTitle = null;
        });
        showMessage('Task deleted.');
      } else {
        showMessage('Task not found. Refreshing your tasks.');
        await loadTasks();
      }
    } catch (e, stack) {
      debugPrint('Delete task failed: $e');
      debugPrintStack(stackTrace: stack);
      showMessage('Could not delete the task. Please try again.');
    }
  }

  // ==========================================================
  // SPARK START — DASHBOARD TASK ACTION
  // ==========================================================

  void sparkStart(PlanTask task) {
    setState(() => sparkTaskTitle = task.title);

    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        icon: const Icon(
          Icons.bolt_rounded,
          color: DS.gold,
          size: 44,
        ),
        title: const Text('Start small. Start now.'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                task.title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '${task.minutes} minutes planned · ${task.priority} priority',
                style: TextStyle(color: muted),
              ),
              const SizedBox(height: 20),
              const Text(
                'You do not need to finish everything right now. '
                'Just make the first move.',
              ),
              const SizedBox(height: 16),
              const _StepRow(
                number: '1',
                title: 'Open what you need',
                subtitle: 'Prepare your book, code editor, or workspace.',
              ),
              const SizedBox(height: 12),
              const _StepRow(
                number: '2',
                title: 'Work for five minutes',
                subtitle: 'Make the task small enough to begin.',
              ),
              const SizedBox(height: 12),
              const _StepRow(
                number: '3',
                title: 'Choose your next step',
                subtitle: 'Continue, or take a short break without guilt.',
              ),
            ],
          ),
        ),
        actions: [
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Let’s do this'),
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // SPARK START — MAIN DASHBOARD CARD
  // ==========================================================

  void sparkStartNextTask() {
    final pending = tasks.where((t) => !t.completed).toList()
      ..sort((a, b) =>
          priorityToNumber(b.priority).compareTo(priorityToNumber(a.priority)));

    if (pending.isEmpty) {
      showMessage(
        tasks.isEmpty
            ? 'Create your first task, then Spark Start!'
            : 'Amazing! You have no remaining tasks.',
      );
      return;
    }

    sparkStart(pending.first);
  }

  void realityReset() {
    setState(() {
      filter = 'Remaining';
      categoryFilter = 'All';
      searchQuery = '';
      searchController.clear();
      sortBy = 'Priority';
    });

    showMessage('Your unfinished tasks are ready for a fresh start.');
  }

  // ==========================================================
  // MAIN LAYOUT
  // ==========================================================

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.sizeOf(context).width >= 850;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: DS.teal.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.wb_sunny_rounded, color: DS.teal),
            ),
            const SizedBox(width: 10),
            const Text(
              'DaySpark',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Refresh tasks',
            onPressed: loading ? null : loadTasks,
            icon: const Icon(Icons.sync_rounded),
          ),
          IconButton(
            tooltip: widget.darkMode ? 'Light mode' : 'Dark mode',
            onPressed: () => widget.onThemeChanged(!widget.darkMode),
            icon: Icon(
              widget.darkMode
                  ? Icons.light_mode_rounded
                  : Icons.dark_mode_outlined,
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Row(
        children: [
          if (wide)
            NavigationRail(
              selectedIndex: selectedPage,
              onDestinationSelected: (value) {
                setState(() => selectedPage = value);
              },
              labelType: NavigationRailLabelType.all,
              destinations: const [
                NavigationRailDestination(
                  icon: Icon(Icons.grid_view_rounded),
                  label: Text('My day'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.track_changes_rounded),
                  label: Text('Goals'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.history_rounded),
                  label: Text('Day Replay'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.settings_outlined),
                  label: Text('Settings'),
                ),
              ],
            ),
          Expanded(
            child: IndexedStack(
              index: selectedPage,
              children: [
                _dashboard(),
                _goals(),
                _replay(),
                _settings(),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: selectedPage == 0
          ? FloatingActionButton.extended(
              onPressed: saving ? null : () => showTaskEditor(),
              icon: const Icon(Icons.add_rounded),
              label: const Text('New task'),
            )
          : null,
      bottomNavigationBar: wide
          ? null
          : NavigationBar(
              selectedIndex: selectedPage,
              onDestinationSelected: (value) {
                setState(() => selectedPage = value);
              },
              destinations: const [
                NavigationDestination(
                  icon: Icon(Icons.grid_view_rounded),
                  label: 'My day',
                ),
                NavigationDestination(
                  icon: Icon(Icons.track_changes_rounded),
                  label: 'Goals',
                ),
                NavigationDestination(
                  icon: Icon(Icons.history_rounded),
                  label: 'Replay',
                ),
                NavigationDestination(
                  icon: Icon(Icons.settings_outlined),
                  label: 'Settings',
                ),
              ],
            ),
    );
  }

  // ==========================================================
  // DASHBOARD
  // ==========================================================

  Widget _dashboard() {
    return RefreshIndicator(
      onRefresh: loadTasks,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(22, 18, 22, 100),
        children: [
          Text(
            _greeting(),
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.7,
                ),
          ),
          const SizedBox(height: 6),
          Text(
            'Make space for progress, one small step at a time.',
            style: TextStyle(color: muted),
          ),
          const SizedBox(height: 22),

          Card(
            child: Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: widget.darkMode
                      ? const [Color(0xFF203B3C), Color(0xFF1C2931)]
                      : const [Color(0xFFE1F2EC), Color(0xFFFFFFFF)],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'Your day, your pace',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Icon(
                        Icons.auto_awesome_rounded,
                        color: widget.darkMode ? DS.gold : DS.teal,
                        size: 28,
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      _stat('${tasks.length}', 'Total tasks'),
                      _stat('$completedCount', 'Completed'),
                      _stat('$remainingMinutes', 'Minutes left'),
                    ],
                  ),
                  const SizedBox(height: 20),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 9,
                      backgroundColor: widget.darkMode
                          ? Colors.white12
                          : DS.teal.withValues(alpha: 0.12),
                    ),
                  ),
                  const SizedBox(height: 9),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        tasks.isEmpty
                            ? 'Your next chapter starts here.'
                            : '$completedCount of ${tasks.length} completed',
                        style: TextStyle(color: muted, fontSize: 12),
                      ),
                      Text(
                        '${(progress * 100).round()}%',
                        style: const TextStyle(
                          color: DS.teal,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),

          // Spark Start dashboard card is clickable.
          Card(
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: sparkStartNextTask,
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(11),
                      decoration: BoxDecoration(
                        color: DS.gold.withValues(alpha: 0.18),
                        borderRadius: BorderRadius.circular(13),
                      ),
                      child: const Icon(
                        Icons.bolt_rounded,
                        color: DS.gold,
                        size: 25,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Spark Start',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            'Tap to begin your next unfinished task. '
                            'Small steps count.',
                            style: TextStyle(color: muted, height: 1.4),
                          ),
                          const SizedBox(height: 12),
                          const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Start now',
                                style: TextStyle(
                                  color: DS.teal,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(width: 5),
                              Icon(
                                Icons.arrow_forward_rounded,
                                color: DS.teal,
                                size: 18,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(11),
                    decoration: BoxDecoration(
                      color: DS.gold.withValues(alpha: 0.18),
                      borderRadius: BorderRadius.circular(13),
                    ),
                    child: const Icon(
                      Icons.restart_alt_rounded,
                      color: DS.gold,
                      size: 25,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Reality Reset',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          'Plans change. Focus on what matters next, '
                          'without feeling guilty about the rest.',
                          style: TextStyle(color: muted, height: 1.4),
                        ),
                        const SizedBox(height: 12),
                        OutlinedButton.icon(
                          onPressed: realityReset,
                          icon: const Icon(Icons.refresh_rounded),
                          label: const Text('Reset my focus'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          Row(
            children: [
              const Expanded(
                child: Text(
                  'Your tasks',
                  style: TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Text('$remainingCount left', style: TextStyle(color: muted)),
            ],
          ),
          const SizedBox(height: 12),

          TextField(
            controller: searchController,
            onChanged: (value) => setState(() => searchQuery = value),
            decoration: InputDecoration(
              hintText: 'Search tasks or categories',
              prefixIcon: const Icon(Icons.search_rounded),
              suffixIcon: searchQuery.isEmpty
                  ? null
                  : IconButton(
                      onPressed: () {
                        searchController.clear();
                        setState(() => searchQuery = '');
                      },
                      icon: const Icon(Icons.close_rounded),
                    ),
            ),
          ),
          const SizedBox(height: 12),

          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: ['All', 'Remaining', 'Completed'].map((value) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(value),
                    selected: filter == value,
                    onSelected: (_) => setState(() => filter = value),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 8),

          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  initialValue: categoryFilter,
                  decoration: const InputDecoration(
                    labelText: 'Category',
                    isDense: true,
                  ),
                  items: ['All', ...categories].map((value) {
                    return DropdownMenuItem(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) setState(() => categoryFilter = value);
                  },
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: DropdownButtonFormField<String>(
                  initialValue: sortBy,
                  decoration: const InputDecoration(
                    labelText: 'Sort by',
                    isDense: true,
                  ),
                  items: const [
                    'Priority',
                    'Newest first',
                    'Shortest first',
                    'Longest first',
                    'Name',
                  ].map((value) {
                    return DropdownMenuItem(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) setState(() => sortBy = value);
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          if (loading)
            const Padding(
              padding: EdgeInsets.all(35),
              child: Center(child: CircularProgressIndicator()),
            )
          else if (errorMessage != null)
            _errorCard()
          else if (visibleTasks.isEmpty)
            _emptyTasks()
          else
            ...visibleTasks.map(_taskCard),

          const SizedBox(height: 22),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.spa_outlined, color: DS.teal, size: 28),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Small steps create momentum',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'You do not need a perfect day. Just one '
                          'meaningful next step.',
                          style: TextStyle(color: muted, height: 1.5),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _stat(String value, String label) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 23,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(color: muted, fontSize: 11)),
        ],
      ),
    );
  }

  Widget _errorCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Icon(Icons.cloud_off_outlined, size: 42),
            const SizedBox(height: 12),
            Text(errorMessage!, textAlign: TextAlign.center),
            const SizedBox(height: 14),
            FilledButton.icon(
              onPressed: loadTasks,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Try again'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _emptyTasks() {
    final message = searchQuery.isNotEmpty
        ? 'No tasks match your search.'
        : filter == 'Completed'
            ? 'No completed tasks yet.'
            : filter == 'Remaining'
                ? 'Everything is clear. Enjoy the breathing room!'
                : 'A little space for a new beginning.';

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          children: [
            const Icon(Icons.spa_outlined, size: 44, color: DS.teal),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text(
              'Create a small task and start building momentum.',
              textAlign: TextAlign.center,
              style: TextStyle(color: muted),
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: () => showTaskEditor(),
              icon: const Icon(Icons.add_rounded),
              label: const Text('Create your first task'),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================================
  // TASK CARD
  // ==========================================================

  Widget _taskCard(PlanTask task) {
    final priorityColor = task.priority == 'High'
        ? DS.coral
        : task.priority == 'Low'
            ? DS.green
            : DS.gold;

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.all(13),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Checkbox(
                  value: task.completed,
                  activeColor: DS.teal,
                  onChanged: (value) => toggleTask(task, value),
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 9),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          task.title,
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                            decoration: task.completed
                                ? TextDecoration.lineThrough
                                : null,
                            color: task.completed ? muted : null,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 7,
                          runSpacing: 6,
                          children: [
                            _tag(
                              task.category,
                              DS.teal.withValues(alpha: 0.12),
                              DS.teal,
                            ),
                            _tag(
                              '${task.minutes} min',
                              widget.darkMode
                                  ? Colors.white10
                                  : Colors.black.withValues(alpha: 0.05),
                              muted,
                            ),
                            _tag(
                              task.priority,
                              priorityColor.withValues(alpha: 0.15),
                              priorityColor,
                            ),
                          ],
                        ),
                        if (sparkTaskTitle == task.title && !task.completed)
                          const Padding(
                            padding: EdgeInsets.only(top: 9),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.bolt_rounded,
                                  color: DS.gold,
                                  size: 17,
                                ),
                                SizedBox(width: 4),
                                Flexible(
                                  child: Text(
                                    'Your next step is waiting!',
                                    style: TextStyle(
                                      color: DS.teal,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                PopupMenuButton<String>(
                  tooltip: 'Task options',
                  onSelected: (value) {
                    if (value == 'edit') {
                      showTaskEditor(existing: task);
                    } else if (value == 'delete') {
                      deleteTask(task);
                    } else if (value == 'spark') {
                      sparkStart(task);
                    }
                  },
                  itemBuilder: (_) => const [
                    PopupMenuItem(
                      value: 'spark',
                      child: ListTile(
                        leading: Icon(Icons.bolt_rounded),
                        title: Text('Spark Start'),
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                    PopupMenuItem(
                      value: 'edit',
                      child: ListTile(
                        leading: Icon(Icons.edit_outlined),
                        title: Text('Edit task'),
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                    PopupMenuItem(
                      value: 'delete',
                      child: ListTile(
                        leading: Icon(Icons.delete_outline),
                        title: Text('Delete task'),
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const Divider(height: 18),
            Row(
              children: [
                TextButton.icon(
                  onPressed: () => showTaskEditor(existing: task),
                  icon: const Icon(Icons.edit_outlined, size: 17),
                  label: const Text('Edit'),
                ),
                const Spacer(),
                if (!task.completed)
                  FilledButton.tonalIcon(
                    onPressed: () => sparkStart(task),
                    icon: const Icon(Icons.bolt_rounded, size: 18),
                    label: const Text('Spark Start'),
                  )
                else
                  const Row(
                    children: [
                      Icon(
                        Icons.check_circle_rounded,
                        color: DS.green,
                        size: 18,
                      ),
                      SizedBox(width: 5),
                      Text('Completed'),
                    ],
                  ),
                const SizedBox(width: 5),
                IconButton(
                  tooltip: 'Delete task',
                  onPressed: () => deleteTask(task),
                  icon: const Icon(
                    Icons.delete_outline_rounded,
                    color: DS.coral,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _tag(String text, Color background, Color foreground) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: foreground,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  // ==========================================================
  // GOALS
  // ==========================================================

  Widget _goals() {
    final career = tasks
        .where((t) => t.category == 'Career' && t.completed)
        .length;
    final learning = tasks
        .where((t) => t.category == 'Learning' && t.completed)
        .length;
    final health = tasks
        .where((t) => t.category == 'Health' && t.completed)
        .length;
    final personal = tasks
        .where((t) => t.category == 'Personal' && t.completed)
        .length;

    return ListView(
      padding: const EdgeInsets.all(22),
      children: [
        Text(
          'Your goals',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 8),
        Text(
          'Today’s actions can support the future you want.',
          style: TextStyle(color: muted),
        ),
        const SizedBox(height: 22),
        _goalCard(
          Icons.code_rounded,
          'Learn and grow',
          'Practice skills, programming, and problem-solving.',
          learning,
          DS.teal,
        ),
        _goalCard(
          Icons.trending_up_rounded,
          'Build your career',
          'Prepare for opportunities and develop your confidence.',
          career,
          DS.gold,
        ),
        _goalCard(
          Icons.favorite_outline_rounded,
          'Protect your energy',
          'Make room for healthy and sustainable routines.',
          health,
          DS.coral,
        ),
        _goalCard(
          Icons.home_outlined,
          'Make space for yourself',
          'Personal routines and small everyday responsibilities.',
          personal,
          DS.green,
        ),
        const SizedBox(height: 12),
        Text(
          'Progress is calculated from completed tasks. Custom goals '
          'are not stored separately yet.',
          style: TextStyle(color: muted, fontSize: 12, height: 1.5),
        ),
      ],
    );
  }

  Widget _goalCard(
    IconData icon,
    String title,
    String description,
    int completed,
    Color color,
  ) {
    final related = tasks.where((t) {
      if (title == 'Learn and grow') return t.category == 'Learning';
      if (title == 'Build your career') return t.category == 'Career';
      if (title == 'Protect your energy') return t.category == 'Health';
      return t.category == 'Personal';
    }).length;

    final ratio = related == 0 ? 0.0 : completed / related;

    return Card(
      margin: const EdgeInsets.only(bottom: 13),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: color.withValues(alpha: 0.14),
                  child: Icon(icon, color: color),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  '$completed/$related',
                  style: TextStyle(
                    color: muted,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(description, style: TextStyle(color: muted)),
            const SizedBox(height: 14),
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: LinearProgressIndicator(
                value: ratio,
                minHeight: 7,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================================
  // DAY REPLAY
  // ==========================================================

  Widget _replay() {
    return ListView(
      padding: const EdgeInsets.all(22),
      children: [
        Text(
          'Day Replay',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 8),
        Text(
          'Reflect with kindness, not judgment.',
          style: TextStyle(color: muted),
        ),
        const SizedBox(height: 22),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.wb_twilight_rounded,
                  color: DS.gold,
                  size: 40,
                ),
                const SizedBox(height: 14),
                Text(
                  '$completedCount of ${tasks.length} tasks completed',
                  style: const TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 13),
                LinearProgressIndicator(value: progress, minHeight: 8),
                const SizedBox(height: 10),
                Text(
                  '${(progress * 100).round()}% complete',
                  style: TextStyle(color: muted),
                ),
                const Divider(height: 32),
                const Text(
                  'Questions to reflect on',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                const _ReflectionRow(
                  icon: Icons.check_circle_outline_rounded,
                  text: 'What went well today?',
                ),
                const _ReflectionRow(
                  icon: Icons.battery_3_bar_rounded,
                  text: 'What took more energy than expected?',
                ),
                const _ReflectionRow(
                  icon: Icons.lightbulb_outline_rounded,
                  text: 'What is one small thing to try tomorrow?',
                ),
                const SizedBox(height: 12),
                Text(
                  'This summary uses your current tasks. Historical daily '
                  'snapshots and written reflections are not saved yet.',
                  style: TextStyle(color: muted, fontSize: 12, height: 1.5),
                ),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: loadTasks,
                  icon: const Icon(Icons.refresh_rounded),
                  label: const Text('Refresh summary'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ==========================================================
  // SETTINGS + LOGOUT
  // ==========================================================

  Widget _settings() {
    return ListView(
      padding: const EdgeInsets.all(22),
      children: [
        Text(
          'Settings',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 8),
        Text(
          'Make DaySpark feel right for you.',
          style: TextStyle(color: muted),
        ),
        const SizedBox(height: 22),
        Card(
          child: SwitchListTile(
            value: widget.darkMode,
            onChanged: widget.onThemeChanged,
            title: const Text('Dark mode'),
            subtitle: const Text('Switch between light and dark appearance.'),
            secondary: const Icon(Icons.dark_mode_outlined),
          ),
        ),
        const SizedBox(height: 12),
        Card(
          child: ListTile(
            leading: const Icon(Icons.cloud_sync_outlined, color: DS.teal),
            title: const Text('Server connection'),
            subtitle: Text(
              loading ? 'Loading tasks…' : errorMessage ?? 'Task API available',
            ),
            trailing: IconButton(
              tooltip: 'Refresh tasks',
              onPressed: loadTasks,
              icon: const Icon(Icons.refresh_rounded),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Card(
          child: const ListTile(
            leading: Icon(Icons.storage_outlined),
            title: Text('Task storage'),
            subtitle: Text(
              'Tasks are loaded and saved through your Serverpod API.',
            ),
          ),
        ),
        const SizedBox(height: 12),
        Card(
          child: const ListTile(
            leading: Icon(Icons.info_outline_rounded, color: DS.teal),
            title: Text('About DaySpark'),
            subtitle: Text(
              'A flexible personal progress planner. Progress, not pressure.',
            ),
          ),
        ),
        const SizedBox(height: 18),
        Card(
          child: ListTile(
            leading: const Icon(Icons.logout_rounded, color: DS.coral),
            title: const Text('Log out'),
            subtitle: const Text('Sign out of your DaySpark account.'),
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (dialogContext) => AlertDialog(
                  title: const Text('Log out?'),
                  content: const Text(
                    'You will need to sign in again to access DaySpark.',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () =>
                          Navigator.pop(dialogContext, false),
                      child: const Text('Cancel'),
                    ),
                    FilledButton(
                      onPressed: () =>
                          Navigator.pop(dialogContext, true),
                      child: const Text('Log out'),
                    ),
                  ],
                ),
              );

              if (confirm == true) {
                await widget.onLogout();
              }
            },
          ),
        ),
        const SizedBox(height: 18),
        Text(
          'Task privacy also depends on the Serverpod endpoint checking '
          'the authenticated user for every read, update, and delete.',
          style: TextStyle(color: muted, fontSize: 12, height: 1.5),
        ),
      ],
    );
  }

  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning.';
    if (hour < 17) return 'Good afternoon.';
    return 'Good evening.';
  }
}

// ============================================================
// SMALL REUSABLE WIDGETS
// ============================================================

class _StepRow extends StatelessWidget {
  const _StepRow({
    required this.number,
    required this.title,
    required this.subtitle,
  });

  final String number;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 15,
          backgroundColor: DS.teal.withValues(alpha: 0.13),
          child: Text(
            number,
            style: const TextStyle(
              color: DS.teal,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(width: 11),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 3),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ReflectionRow extends StatelessWidget {
  const _ReflectionRow({
    required this.icon,
    required this.text,
  });

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: DS.teal),
      title: Text(text),
    );
  }
}