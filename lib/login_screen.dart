import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController=TextEditingController();
  final passController=TextEditingController();
  final _auth=FirebaseAuth.instance;
  bool isLoading=false;

  void login() async {
    setState(() {
      isLoading=true;
    });
    try{
      await _auth.signInWithEmailAndPassword(email: emailController.text.trim(), password: passController.text.trim(),);
        }
    catch(e){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
    finally{
      setState(() {
        isLoading=false;
      });
    }

  }
  @override
  void dispose() {
    emailController.dispose();
    passController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(padding: EdgeInsets.all(14),
      child: Column(
          children: [
        const Text(
        'Welcome Back',
        style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 40),
      TextField(
        controller: emailController,
        decoration: InputDecoration(labelText: 'Email', border: OutlineInputBorder()),
        keyboardType: TextInputType.emailAddress,
      ),
      const SizedBox(height: 16),
      TextField(
        controller: passController,
        decoration: const InputDecoration(labelText: 'Password', border: OutlineInputBorder()),
        //obscureText: true,
      ),
      const SizedBox(height: 24),
      isLoading
          ? const CircularProgressIndicator()
          : ElevatedButton(
        onPressed: login,
        style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(50)),
        child: const Text('Login'),
      ),
        ],
      ),),
    );
  }
}
