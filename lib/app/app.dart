import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../utils/constants.dart';
import 'routes.dart';
import 'theme.dart';

class DisasterAlertApp extends StatelessWidget {
  const DisasterAlertApp({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeMode themeMode = ThemeMode.light;
    try {
      final themeProvider = Provider.of<ThemeProvider>(context, listen: true);
      themeMode = themeProvider.themeMode;
    } catch (_) {}

    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      initialRoute: AppRoutes.splash,
      onGenerateRoute: AppRoutes.onGenerateRoute,
    );
  }
}
