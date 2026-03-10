import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/auth_provider.dart';
import '../theme/app_theme.dart';
import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';

  void _submit() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();
    
    try {
      await Provider.of<AuthProvider>(context, listen: false).login(_email, _password);
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
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Icon(
                  Icons.task_alt_rounded,
                  size: 80,
                  color: AppTheme.primaryColor,
                ).animate().scale(duration: 500.ms, curve: Curves.easeOutBack),
                
                const SizedBox(height: 24),
                
                Text(
                  'Welcome Back',
                  style: Theme.of(context).textTheme.displayLarge,
                  textAlign: TextAlign.center,
                ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.2),
                
                const SizedBox(height: 8),
                
                Text(
                  'Sign in to manage your tasks.',
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2),
                
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
                ).animate().fadeIn(delay: 300.ms).slideX(begin: 0.1),
                
                const SizedBox(height: 16),
                
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Password', prefixIcon: Icon(Icons.lock_outline)),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password.';
                    }
                    return null;
                  },
                  onSaved: (value) => _password = value!,
                ).animate().fadeIn(delay: 400.ms).slideX(begin: 0.1),
                
                const SizedBox(height: 32),
                
                isLoading
                  ? const Center(child: CircularProgressIndicator(color: AppTheme.primaryColor))
                  : ElevatedButton(
                      onPressed: _submit,
                      child: const Text('Log In'),
                    ).animate().fadeIn(delay: 500.ms).scale(),
                
                const SizedBox(height: 16),
                
                TextButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (ctx) => const SignupScreen()),
                    );
                  },
                  child: const Text('Don\'t have an account? Sign Up'),
                ).animate().fadeIn(delay: 600.ms),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
