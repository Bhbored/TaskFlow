import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taskflow_pro/screens/add_task/add_task_screen.dart';
import '../../providers/task_provider.dart';
import 'widgets/animated_fab.dart';
import 'widgets/home_sliver_app_bar.dart';
import 'widgets/sliver_app_bar_delegate.dart';
import 'widgets/stats_section.dart';
import 'widgets/task_list.dart';
import 'widgets/search_bar.dart';

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
            const HomeSliverAppBar(),
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
                  const StatsSection(),
                ],
              ),
            ),
            SliverPersistentHeader(
              pinned: true,
              delegate: SliverAppBarDelegate(
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
                TaskList(tasks: taskProvider.filteredTasks),
                TaskList(tasks: taskProvider.pendingTasks),
                TaskList(tasks: taskProvider.inProgressTasks),
                TaskList(tasks: taskProvider.completedTasks),
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
}
