import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/auth_provider.dart';
import '../providers/task_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/task_tile.dart';
import '../widgets/add_task_bottom_sheet.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isInit = true;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<TaskProvider>(context).fetchAndSetTasks().then((_) {
        setState(() {
          _isLoading = false;
        });
      }).catchError((error) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not fetch tasks from Firebase.'), backgroundColor: AppTheme.errorColor)
        );
      });
      _isInit = false;
    }
    super.didChangeDependencies();
  }

  void _showAddTaskSheet([existingTask]) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => AddTaskBottomSheet(existingTask: existingTask),
    );
  }

  Widget _buildTaskList(bool showCompleted) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    
    return Consumer<TaskProvider>(
      builder: (ctx, taskData, child) {
        final tasks = showCompleted ? taskData.completedTasks : taskData.pendingTasks;
        
        if (tasks.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  showCompleted ? Icons.check_circle_outline : Icons.task_outlined,
                  size: 64,
                  color: AppTheme.textSecondaryColor,
                ).animate().scale(duration: 400.ms),
                const SizedBox(height: 16),
                Text(
                  showCompleted ? 'No completed tasks yet.' : 'You are all caught up!',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppTheme.textSecondaryColor,
                  ),
                ).animate().fadeIn(delay: 200.ms),
              ],
            ),
          );
        }
        
        return ListView.builder(
          padding: const EdgeInsets.only(top: 8, bottom: 80),
          itemCount: tasks.length,
          itemBuilder: (ctx, i) => TaskTile(
             task: tasks[i], 
             onEdit: () => _showAddTaskSheet(tasks[i]),
          ).animate().fadeIn(duration: 400.ms, delay: (i * 100).ms).slideY(begin: 0.1),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TaskFlow', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded, color: AppTheme.errorColor),
            onPressed: () {
              Provider.of<AuthProvider>(context, listen: false).logout();
            },
          )
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppTheme.primaryColor,
          unselectedLabelColor: AppTheme.textSecondaryColor,
          indicatorColor: AppTheme.primaryColor,
          tabs: const [
            Tab(text: 'Pending'),
            Tab(text: 'Completed'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildTaskList(false),
          _buildTaskList(true),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddTaskSheet,
        backgroundColor: AppTheme.primaryColor,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Add Task', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ).animate().scale(delay: 800.ms, duration: 400.ms, curve: Curves.easeOutBack),
    );
  }
}
