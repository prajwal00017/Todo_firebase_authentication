import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/task_model.dart';
import '../providers/task_provider.dart';
import '../theme/app_theme.dart';

class TaskTile extends StatelessWidget {
  final TaskModel task;
  final VoidCallback onEdit;

  const TaskTile({super.key, required this.task, required this.onEdit});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(task.id),
      background: Container(
        color: AppTheme.errorColor,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: const Icon(Icons.delete, color: Colors.white, size: 30),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        Provider.of<TaskProvider>(context, listen: false).deleteTask(task.id).catchError((_) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to delete task.')),
          );
        });
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        elevation: 0,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: Colors.grey.withOpacity(0.1)),
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          leading: GestureDetector(
            onTap: () {
              Provider.of<TaskProvider>(context, listen: false)
                  .toggleTaskStatus(task.id)
                  .catchError((_) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Failed to update status.')),
                );
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: task.isCompleted ? AppTheme.successColor : Colors.transparent,
                shape: BoxShape.circle,
                border: Border.all(
                  color: task.isCompleted ? AppTheme.successColor : Colors.grey,
                  width: 2,
                ),
              ),
              child: task.isCompleted 
                ? const Icon(Icons.check, color: Colors.white, size: 18)
                : null,
            ).animate(target: task.isCompleted ? 1 : 0).scale(),
          ),
          title: Text(
            task.title,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              decoration: task.isCompleted ? TextDecoration.lineThrough : null,
              color: task.isCompleted ? AppTheme.textSecondaryColor : AppTheme.textPrimaryColor,
              fontWeight: FontWeight.w600,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (task.description.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  task.description,
                  style: Theme.of(context).textTheme.bodyMedium,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              const SizedBox(height: 8),
              Text(
                DateFormat('MMM dd, yyyy').format(task.createdAt),
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
          trailing: IconButton(
            icon: const Icon(Icons.edit_outlined, color: AppTheme.primaryColor),
            onPressed: onEdit,
          ),
        ),
      ).animate().fadeIn(duration: 300.ms).slideX(begin: 0.1),
    );
  }
}
