import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gemini/pages/disclaimer_screen.dart';

class IntroScreen extends StatelessWidget {
  const IntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const Color mint = Color.fromARGB(255, 162, 228, 184);
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: mint, // Adjust this color as needed.
        title: Row(
          children: [
            // Image.asset('lib/images/logo.png',
            //     height: 40), // Place your logo image here.
            // const SizedBox(width: 10),
            Text(
              'MediDecode', // Replace with your app or company name.
              style: TextStyle(
                  color: Colors.black), // Adjust text color as needed.
            ),
          ],
        ),
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 100.0,
                vertical: 20,
              ),
              child: Image.asset('lib/images/heart.jpeg'),
            ),
            Padding(
              padding: const EdgeInsets.all(28.0),
              child: Text(
                'Introduction',
                textAlign: TextAlign.center,
                style: GoogleFonts.notoSerif(
                    fontSize: 36, fontWeight: FontWeight.bold),
              ),
            ),
            Text(
              'Welcome to Our App',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 24),
            const Spacer(),
            GestureDetector(
              onTap: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return DisclaimerPage();
                  },
                ),
              ),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: mint,
                ),
                child: const Text(
                  "Get Started",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
