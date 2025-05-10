import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'home.dart';
import 'signin.dart';
import 'signup.dart';
import 'theme.dart';

// --- Supabase Configuration ---
const String supabaseUrl = 'https://amfomxmqoeyfuwkqlzyk.supabase.co';
const String supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImFtZm9teG1xb2V5ZnV3a3FsenlrIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDYwMDgyMDEsImV4cCI6MjA2MTU4NDIwMX0.erme360AeqVMShEVDXJadwZ0wJQP7Wb3-X_QRlsRsRk';

final supabase = Supabase.instance.client;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: supabaseUrl,
    anonKey: supabaseAnonKey,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final initialRoute =
        supabase.auth.currentSession == null ? '/signin' : '/home';

    return MaterialApp(
      title: 'EZMove',
      debugShowCheckedModeBanner: false,
      theme: buildThemeData(),
      initialRoute: initialRoute,
      routes: {
        '/signin': (context) => const SignInPage(),
        '/signup': (context) => const SignUpPage(),
        '/home': (context) => const MyHomePage(initialIndex: 0),
        '/housing': (context) => const MyHomePage(initialIndex: 1),
        '/community': (context) => const MyHomePage(initialIndex: 2),
        '/chatbot': (context) => const MyHomePage(initialIndex: 3),
        '/aboutus': (context) => const MyHomePage(initialIndex: 4),
      },
    );
  }
}
