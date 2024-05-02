import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'pages/intro_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Supabase without dotenv for demonstration purposes
  await Supabase.initialize(
    url: 'https://taohrzssjrwvwqalesyj.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InRhb2hyenNzanJ3dndxYWxlc3lqIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTQyNTgzNDksImV4cCI6MjAyOTgzNDM0OX0.kHkSZlrvMKcKUSQDunsfPslHDBaJgEuKkaOrayGN7Y8',
  );

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

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
