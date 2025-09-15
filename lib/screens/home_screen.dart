import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import '../providers/theme_provider.dart';
import '../models/task.dart';
import '../models/app_theme.dart';
import '../widgets/task_card.dart';
import '../widgets/stats_card.dart';
import '../widgets/search_bar.dart';
import '../widgets/animated_fab.dart';
import '../widgets/filter_bottom_sheet.dart';
import 'add_task_screen.dart';
import 'task_details_screen.dart';
import 'analytics_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TaskProvider>().loadTasks();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              expandedHeight: 200,
              floating: false,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                title: const Text('TaskFlow Pro'),
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [AppTheme.primaryColor, AppTheme.secondaryColor],
                    ),
                  ),
                  child: const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.task_alt, size: 48, color: Colors.white),
                        SizedBox(height: 8),
                        Text(
                          'Stay Productive',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(20),
                        ),
                      ),
                      builder: (context) => const FilterBottomSheet(),
                    );
                  },
                  icon: const Icon(Icons.filter_list),
                  tooltip: 'Filter tasks',
                ),
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AnalyticsScreen(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.analytics_outlined),
                  tooltip: 'Analytics',
                ),
                Consumer<ThemeProvider>(
                  builder: (context, themeProvider, child) {
                    return IconButton(
                      onPressed: () => themeProvider.toggleTheme(),
                      icon: Icon(
                        themeProvider.isDarkMode
                            ? Icons.light_mode
                            : Icons.dark_mode,
                      ),
                      tooltip: 'Toggle theme',
                    );
                  },
                ),
              ],
            ),
            SliverToBoxAdapter(
              child: Column(
                children: [
                  Consumer<TaskProvider>(
                    builder: (context, taskProvider, child) {
                      return CustomSearchBar(
                        initialValue: taskProvider.searchQuery,
                        onChanged: taskProvider.setSearchQuery,
                      );
                    },
                  ),
                  _buildStatsSection(),
                ],
              ),
            ),
            SliverPersistentHeader(
              pinned: true,
              delegate: _SliverAppBarDelegate(
                TabBar(
                  controller: _tabController,
                  isScrollable: true,
                  tabs: const [
                    Tab(text: 'All Tasks'),
                    Tab(text: 'Pending'),
                    Tab(text: 'In Progress'),
                    Tab(text: 'Completed'),
                  ],
                ),
              ),
            ),
          ];
        },
        body: Consumer<TaskProvider>(
          builder: (context, taskProvider, child) {
            if (taskProvider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            return TabBarView(
              controller: _tabController,
              children: [
                _buildTaskList(taskProvider.filteredTasks),
                _buildTaskList(taskProvider.pendingTasks),
                _buildTaskList(taskProvider.inProgressTasks),
                _buildTaskList(taskProvider.completedTasks),
              ],
            );
          },
        ),
      ),
      floatingActionButton: AnimatedFAB(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddTaskScreen()),
          );
        },
        tooltip: 'Add new task',
      ),
    );
  }

  Widget _buildStatsSection() {
    return Consumer<TaskProvider>(
      builder: (context, taskProvider, child) {
        return Container(
          height: 110,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              SizedBox(
                width: 150,
                child: StatsCard(
                  title: 'Total Tasks',
                  value: '${taskProvider.tasks.length}',
                  icon: Icons.assignment,
                  color: AppTheme.primaryColor,
                ),
              ),
              const SizedBox(width: 16),
              SizedBox(
                width: 150,
                child: StatsCard(
                  title: 'Completed',
                  value: '${taskProvider.completedTasks.length}',
                  icon: Icons.check_circle,
                  color: AppTheme.successColor,
                ),
              ),
              const SizedBox(width: 16),
              SizedBox(
                width: 150,
                child: StatsCard(
                  title: 'In Progress',
                  value: '${taskProvider.inProgressTasks.length}',
                  icon: Icons.play_circle,
                  color: AppTheme.infoColor,
                ),
              ),
              const SizedBox(width: 16),
              SizedBox(
                width: 150,
                child: StatsCard(
                  title: 'Overdue',
                  value: '${taskProvider.overdueTasks.length}',
                  icon: Icons.warning,
                  color: AppTheme.errorColor,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTaskList(List<Task> tasks) {
    if (tasks.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.task_alt_outlined,
              size: 64,
              color: Theme.of(context).textTheme.bodyMedium?.color,
            ),
            const SizedBox(height: 16),
            Text(
              'No tasks found',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Add a new task to get started',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        return TaskCard(
          task: task,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TaskDetailsScreen(task: task),
              ),
            );
          },
          onToggle: () {
            context.read<TaskProvider>().toggleTaskStatus(task.id);
          },
          onDelete: () {
            _showDeleteDialog(context, task);
          },
        );
      },
    );
  }

  void _showDeleteDialog(BuildContext context, Task task) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Task'),
        content: Text('Are you sure you want to delete "${task.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              context.read<TaskProvider>().deleteTask(task.id);
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(foregroundColor: AppTheme.errorColor),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar _tabBar;

  _SliverAppBarDelegate(this._tabBar);

  @override
  double get minExtent => _tabBar.preferredSize.height;

  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
