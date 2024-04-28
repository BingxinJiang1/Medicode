import 'package:flutter/material.dart';
import 'package:gemini/pages/disclaimer_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gemini/pages/sign_up_page.dart';
import 'package:gemini/supabase_manager.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key});


  @override
  Widget build(BuildContext context) {
    const Color mint = Color.fromARGB(255, 162, 228, 184);
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    Future<void> login(BuildContext context) async {
      final String email = emailController.text.trim();
      final String password = passwordController.text;

      try {
        final response = await SupabaseManager.client.auth.signIn(email: email, password: password);
        if (response.error != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(response.error!.message)),
          );
        } else if (response.data == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("An error occurred")),
          );
        } else {
          // Login successful, you can navigate to another screen or perform any other action here.
          // For example, you can navigate to the home screen:
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => DisclaimerPage()));
        }
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("An error occurred")),
        );
      }
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: mint,
        title: Text('Login', style: GoogleFonts.notoSerif()),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => login(context),
              child: Text('Log In'),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("Don't have an account? "),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const SignUpPage()),
                    );
                  },
                  child: Text(
                    'Sign Up',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
