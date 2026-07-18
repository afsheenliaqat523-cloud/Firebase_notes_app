import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_notes_app/notes_screen.dart';
import 'package:firebase_notes_app/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_notes_app/firebase_options.dart';

import 'login_screen.dart';

void main() async {
  // 🌟 Essential: Tells Flutter not to run the app until native bindings are ready
  WidgetsFlutterBinding.ensureInitialized();

  // 🌟 Initializes Firebase using your auto-generated credentials
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF769826),
          brightness: Brightness.light,
          primary: const Color(0xFF769826), // Olive Green
          primaryContainer: const Color(0xFFA1CB35), // Lime Green
          secondary: const Color(0xFFFFDE4E), // Warm Yellow
          tertiary: const Color(0xFFFF9D4D), // Soft Orange
          surface: Colors.white,
          background: const Color(0xFFFAFBF8),
        ),
        textTheme: const TextTheme(
          titleLarge: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 0.5, color: Color(0xFF2C3E02)),
          bodyLarge: TextStyle(color: Colors.black87, height: 1.4),
          bodyMedium: TextStyle(color: Colors.black54),
        ),

        // 🏷️ APP BAR STYLE: Flat, clean header with no harsh borders
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          iconTheme: IconThemeData(color: Color(0xFF769826)),
          titleTextStyle: TextStyle(
            color: Color(0xFF2C3E02),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        // 💳 CARD STYLE: Standardizes the rounded curves for your list items
        cardTheme: CardThemeData(
          color: Colors.white,
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),

        // 📥 INPUT FIELD STYLE: Modern, rounded outline text boxes for all forms
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFFFAFBF8),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey[200]!),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF769826), width: 1.5),
          ),
        ),

        // 🚀 BUTTON STYLE: Thick, rounded action elements using the new palette
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF769826),
            foregroundColor: Colors.white,
            minimumSize: const Size.fromHeight(48),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 1,
          ),
        ),

        ),

      home:SplashScreen()
    );
  }
}
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cloud Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => FirebaseAuth.instance.signOut(), // Logs out and instantly triggers the stream!
          )
        ],
      ),
      body: const Center(child: Text('You are logged into the Cloud!')),
    );
  }
}
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
 final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {


  @override
  Widget build(BuildContext context) {
     return Scaffold(
      appBar: AppBar(
         backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Text(
          'Firebase is initialized and ready!',
        ),
      ),
      );
  }
}
