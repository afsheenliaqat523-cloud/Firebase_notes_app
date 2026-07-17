import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_notes_app/notes_screen.dart';
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
      theme: ThemeData(
        colorScheme: ColorScheme .fromSeed(seedColor: Colors.deepPurple),
      ),
      home: StreamBuilder(stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context,snapshot){
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(body: Center(child: CircularProgressIndicator()));
            }

            // 🌟 The Magic Gatekeeper: If snapshot has data, the user is logged in!
            if (snapshot.hasData) {
              return const NotesScreen(); // Your actual app screen
            }

            // Otherwise, they are logged out. Send them to Login Screen
            return const LoginScreen();
          }
    )
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
