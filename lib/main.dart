import 'package:flutter/material.dart';
import 'pages/intro_screen.dart';
import 'package:gemini/supabase_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SupabaseManager.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.grey[50],
      ),
      home: IntroScreen(),
    );
  }
}
