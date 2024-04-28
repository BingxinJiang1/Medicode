import 'dart:async';

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:gemini/constants.dart';
import 'package:gemini/pages/signup.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gemini/pages/disclaimer_screen.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  bool _redirecting = false;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    supabase.auth.onAuthStateChange.listen((data) {
      if (_redirecting) return;
      final session = data.session;
      if (session != null) {
        _redirecting = true;
        Navigator.of(context).pushReplacementNamed('/home');
      }
    });
    super.initState();
  }

  Future<void> _signIn() async {
    try {
      await supabase.auth.signInWithPassword(email: _emailController.text, password: _passwordController.text);
      if (mounted) {
        _emailController.clear();
        _passwordController.clear();

        _redirecting = true;
        // Navigator.of(context).pushReplacementNamed('/home');
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const DisclaimerPage()));
      }
    } on AuthException catch (error) {
      context.showErrorSnackBar(message: error.message);
    } catch (error) {
      context.showErrorSnackBar(message: 'Unexpected error occurred');
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color mint = Color.fromARGB(255, 162, 228, 184);
    return Scaffold(
      appBar: AppBar(
            backgroundColor: mint,
            title: Text('Login', style: GoogleFonts.notoSerif()),
            centerTitle: true,
          ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              const SizedBox(
                height: 200,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(border: OutlineInputBorder(), labelText: 'Email', hintText: 'Enter a valid email'),
                  validator: (String? value) {
                    if (value!.isEmpty || !value.contains('@')) {
                      return 'Email is not valid';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 15, bottom: 0),
                //padding: EdgeInsets.symmetric(horizontal: 15),
                child: TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(border: OutlineInputBorder(), labelText: 'Password', hintText: 'Enter secure password'),
                  validator: (String? value) {
                    if (value!.isEmpty) {
                      return 'Invalid password';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Container(
                  height: 50,
                  width: 250,
                  decoration: BoxDecoration(color: mint, borderRadius: BorderRadius.circular(20)),
                  child: TextButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        _signIn();
                      }
                    },
                    child: const Text(
                      'Login',
                      style: TextStyle(color: Colors.black, fontSize: 25),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 130,
              ),
              TextButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const SignUpPage()));
                  },
                  child: const Text('New User? Create Account')),
              const SizedBox(
                height: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   const Color mint = Color.fromARGB(255, 162, 228, 184);
  //   final TextEditingController emailController = TextEditingController();
  //   final TextEditingController passwordController = TextEditingController();
  //
  //   return Scaffold(
  //     appBar: AppBar(
  //       backgroundColor: mint,
  //       title: Text('Login', style: GoogleFonts.notoSerif()),
  //       centerTitle: true,
  //     ),
  //     body: Padding(
  //       padding: EdgeInsets.all(20),
  //       child: Column(
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         children: <Widget>[
  //           TextField(
  //             controller: emailController,
  //             decoration: InputDecoration(
  //               labelText: 'Email',
  //               border: OutlineInputBorder(),
  //             ),
  //           ),
  //           SizedBox(height: 20),
  //           TextField(
  //             controller: passwordController,
  //             decoration: InputDecoration(
  //               labelText: 'Password',
  //               border: OutlineInputBorder(),
  //             ),
  //             obscureText: true,
  //           ),
  //           SizedBox(height: 20),
  //           ElevatedButton(
  //             // onPressed: () => login(context),
  //             onPressed: () async {
  //               if (_formKey.currentState!.validate()) {
  //                 _signIn();
  //               }
  //             },
  //             child: Text('Log In'),
  //           ),
  //           SizedBox(height: 20),
  //           Row(
  //             mainAxisAlignment: MainAxisAlignment.center,
  //             children: <Widget>[
  //               Text("Don't have an account? "),
  //               GestureDetector(
  //                 onTap: () {
  //                   Navigator.push(
  //                     context,
  //                     MaterialPageRoute(builder: (context) => const SignUpPage()),
  //                   );
  //                 },
  //                 child: Text(
  //                   'Sign Up',
  //                   style: TextStyle(
  //                     fontWeight: FontWeight.bold,
  //                     color: Colors.blue,
  //                   ),
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
}