import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/task_model.dart';
import '../providers/task_provider.dart';
import '../theme/app_theme.dart';

class AddTaskBottomSheet extends StatefulWidget {
  final TaskModel? existingTask;

  const AddTaskBottomSheet({super.key, this.existingTask});

  @override
  State<AddTaskBottomSheet> createState() => _AddTaskBottomSheetState();
}

class _AddTaskBottomSheetState extends State<AddTaskBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  late String _title;
  late String _description;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _title = widget.existingTask?.title ?? '';
    _description = widget.existingTask?.description ?? '';
  }

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();
    
    setState(() {
      _isLoading = true;
    });

    try {
      if (widget.existingTask == null) {
        await Provider.of<TaskProvider>(context, listen: false).addTask(_title, _description);
      } else {
        await Provider.of<TaskProvider>(context, listen: false).updateTask(widget.existingTask!.id, _title, _description);
      }
      if (mounted) Navigator.of(context).pop();
    } catch (error) {
       if (mounted) {
         ScaffoldMessenger.of(context).showSnackBar(
           const SnackBar(content: Text('Failed to save task.'), backgroundColor: AppTheme.errorColor),
         );
       }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 24,
        right: 24,
        top: 24,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              widget.existingTask == null ? 'New Task' : 'Edit Task',
              style: Theme.of(context).textTheme.displayMedium?.copyWith(fontSize: 24),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            TextFormField(
              initialValue: _title,
              decoration: const InputDecoration(labelText: 'Task Title'),
              validator: (value) {
                if (value == null || value.trim().isEmpty) return 'Please enter a title.';
                return null;
              },
              onSaved: (value) => _title = value!,
            ),
            const SizedBox(height: 16),
            TextFormField(
              initialValue: _description,
              decoration: const InputDecoration(labelText: 'Description (Optional)'),
              maxLines: 3,
              onSaved: (value) => _description = value ?? '',
            ),
            const SizedBox(height: 24),
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : ElevatedButton(
                    onPressed: _submit,
                    child: Text(widget.existingTask == null ? 'Add Task' : 'Save Changes'),
                  ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
