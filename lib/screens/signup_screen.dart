import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/auth_provider.dart';
import '../theme/app_theme.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();
    
    try {
      await Provider.of<AuthProvider>(context, listen: false).signup(_email, _password);
      if(mounted) Navigator.of(context).pop();
    } catch (error) {
       if(!mounted) return;
       ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(
           content: Text(error.toString().replaceAll('Exception: ', '')),
           backgroundColor: AppTheme.errorColor,
         )
       );
    }
  }

  @override
  Widget build(BuildContext context) {
     final isLoading = Provider.of<AuthProvider>(context).isLoading;
     
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppTheme.textPrimaryColor),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              Text(
                'Create Account',
                style: Theme.of(context).textTheme.displayMedium,
              ).animate().fadeIn().slideY(begin: 0.2, duration: 400.ms),
              const SizedBox(height: 8),
              Text(
                'Join TaskFlow and supercharge your productivity.',
                style: Theme.of(context).textTheme.bodyMedium,
              ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.2, duration: 400.ms),
              const SizedBox(height: 48),
              
              TextFormField(
                decoration: const InputDecoration(labelText: 'Email Address', prefixIcon: Icon(Icons.email_outlined)),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty || !value.contains('@')) {
                    return 'Please enter a valid email.';
                  }
                  return null;
                },
                onSaved: (value) => _email = value!,
              ).animate().fadeIn(delay: 200.ms).slideX(begin: 0.1),
              
              const SizedBox(height: 16),
              
              TextFormField(
                decoration: const InputDecoration(labelText: 'Password', prefixIcon: Icon(Icons.lock_outline)),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.length < 6) {
                    return 'Password must be at least 6 characters.';
                  }
                  return null;
                },
                onSaved: (value) => _password = value!,
              ).animate().fadeIn(delay: 300.ms).slideX(begin: 0.1),
              
              const SizedBox(height: 32),
              
              isLoading
                ? const Center(child: CircularProgressIndicator(color: AppTheme.primaryColor))
                : ElevatedButton(
                    onPressed: _submit,
                    child: const Text('Sign Up'),
                  ).animate().fadeIn(delay: 400.ms).scale(),
            ],
          ),
        ),
      ),
    );
  }
}
