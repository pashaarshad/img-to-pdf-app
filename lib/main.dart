import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'constants/app_theme.dart';
import 'screens/home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Enforce white status bar and light navigation
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: AppTheme.backgroundWhite,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(const ImageToPdfApp());
}

class ImageToPdfApp extends StatelessWidget {
  const ImageToPdfApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Image to PDF Converter',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      themeMode: ThemeMode.light, // Strictly light white theme as specified
      home: const HomeScreen(),
    );
  }
}
