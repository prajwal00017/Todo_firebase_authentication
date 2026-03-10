import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme/app_theme.dart';
import 'providers/auth_provider.dart';
import 'providers/task_provider.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProxyProvider<AuthProvider, TaskProvider>(
          create: (_) => TaskProvider(null, null, []),
          update: (ctx, auth, previousTasks) => TaskProvider(
            auth.token,
            auth.userId,
            previousTasks == null ? [] : previousTasks.tasks,
          ),
        ),
      ],
      child: Consumer<AuthProvider>(
        builder: (ctx, auth, _) => MaterialApp(
          title: 'TaskFlow',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          home: auth.isAuth ? const HomeScreen() : const LoginScreen(),
        ),
      ),
    );
  }
}
