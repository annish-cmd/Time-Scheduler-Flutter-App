import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/user_model.dart';
import 'models/task_model.dart';
import 'widgets/app_drawer.dart';
import 'widgets/task_list.dart';
import 'widgets/add_task_dialog.dart';
import 'widgets/edit_task_dialog.dart';
import 'utils/color_utils.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize user model
  final userModel = UserModel();
  await userModel.init();

  // Initialize task model
  final taskModel = TaskModel();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<UserModel>.value(value: userModel),
        ChangeNotifierProvider<TaskModel>.value(value: taskModel),
      ],
      child: const TaskSchedulerApp(),
    ),
  );
}

class TaskSchedulerApp extends StatelessWidget {
  const TaskSchedulerApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Access the user model to listen to dark mode changes
    final userModel = Provider.of<UserModel>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Task Scheduler',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF5E61F4),
          primary: const Color(0xFF5E61F4),
          brightness: userModel.isDarkMode ? Brightness.dark : Brightness.light,
        ),
        useMaterial3: true,
        // Using system default font instead of Poppins
        // fontFamily: 'Poppins',
        // Add some other theme properties
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFF5E61F4), width: 2),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          filled: true,
          fillColor:
              userModel.isDarkMode ? Colors.grey.shade800 : Colors.grey.shade50,
        ),
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF5E61F4),
          primary: const Color(0xFF5E61F4),
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xFF121212),
        useMaterial3: true,
        // Using system default font instead of Poppins
        // fontFamily: 'Poppins',
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.grey.shade700),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.grey.shade700),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFF5E61F4), width: 2),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          filled: true,
          fillColor: Colors.grey.shade800,
        ),
      ),
      themeMode: userModel.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    final taskModel = Provider.of<TaskModel>(context);

    return Scaffold(
      key: scaffoldKey,
      drawer: const AppDrawer(),
      body: Column(
        children: [
          // Professional App Bar
          Container(
            padding:
                const EdgeInsets.only(top: 35, left: 20, right: 20, bottom: 10),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF4568DC), // Blue
                  Color(0xFF7851DF), // Purple
                  Color(0xFFB06AB3), // Pink
                ],
                stops: [0.0, 0.5, 1.0],
              ),
              boxShadow: [
                BoxShadow(
                  color: Color(0x40000000),
                  offset: Offset(0, 4),
                  blurRadius: 8,
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Menu icon
                Container(
                  decoration: BoxDecoration(
                    color: ColorUtils.withAlpha15(Colors.white),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: ColorUtils.withAlpha10(Colors.black),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.menu, color: Colors.white, size: 24),
                    onPressed: () {
                      // Open drawer
                      scaffoldKey.currentState?.openDrawer();
                    },
                    padding: const EdgeInsets.all(8),
                    constraints: const BoxConstraints(),
                  ),
                ),
                const SizedBox(width: 20),

                // Title and subtitle stacked
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Task Scheduler',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 0.5,
                        shadows: [
                          Shadow(
                            color: Color(0x66000000),
                            blurRadius: 4,
                            offset: Offset(0, 1),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Organize your day efficiently',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.95),
                        letterSpacing: 0.3,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Task list or empty state
          Expanded(
            child: Consumer<TaskModel>(
              builder: (context, taskModel, child) {
                if (taskModel.isLoading) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(
                          color: Theme.of(context).primaryColor,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Loading tasks...',
                          style: TextStyle(
                            fontSize: 16,
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? Colors.white70
                                    : Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return TaskList(
                  tasks: taskModel.tasks,
                  onDeleteTask: (id) {
                    taskModel.removeTask(id);
                  },
                  onEditTask: (id) {
                    // Find the task with the given id
                    final task =
                        taskModel.tasks.firstWhere((task) => task.id == id);

                    // Show the edit task dialog
                    showDialog(
                      context: context,
                      builder: (context) => EditTaskDialog(
                        task: task,
                        onUpdateTask: (updatedTask) {
                          taskModel.updateTask(updatedTask);
                        },
                        onDeleteTask: (id) {
                          taskModel.removeTask(id);
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AddTaskDialog(
              onAddTask: (task) {
                taskModel.addTask(task);
              },
            ),
          );
        },
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
