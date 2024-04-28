import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gemini/pages/disclaimer_screen.dart';
import 'package:gemini/pages/login_page.dart';

class IntroScreen extends StatelessWidget {
  const IntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const Color mint = Color.fromARGB(255, 162, 228, 184);
    return Scaffold(
  backgroundColor: Colors.grey[50],
  appBar: AppBar(
    backgroundColor: mint,
    title: Row(
      children: [
        Image.asset('lib/images/medicode_logo.png', height: 40),
        const SizedBox(width: 10),
        Text('Medicode', style: TextStyle(color: Colors.black)),
      ],
      mainAxisAlignment: MainAxisAlignment.start, // Aligns title Row to the start of AppBar
    ),
    actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const DisclaimerPage()),
              );
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.black, backgroundColor: Colors.white, // Button background color
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18), // Rounded edges
              ),
            ),
            child: Text(
              'Log In',
              style: TextStyle(
                fontWeight: FontWeight.bold, // Make the text bold
              ),
            ),
          ),
          const SizedBox(width: 10), // Spacing after button
        ],
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          // Use SingleChildScrollView to avoid overflow and allow scrolling
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(100.0, 20.0, 100.0, 20),
                child: Image.asset('lib/images/heart.jpeg'),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(28.0, 0, 28.0, 20.0),
                child: Text(
                  'Understand your report',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.notoSerif(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 28.0), // Horizontal padding
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start, // Aligns text to the left
                  children: [
                    Text(
                      '✔ Upload PDFs of your radiologist\'s reports for instant rephrasing.',
                      style: TextStyle(fontSize: 20, color: Colors.grey[700]),
                    ),
                    Text(
                      '✔ Simplify medical reports into clear, understandable language.',
                      style: TextStyle(fontSize: 20, color: Colors.grey[700]),
                    ),
                    Text(
                      '✔ Get actionable insights and recommended questions for your doctor.',
                      style: TextStyle(fontSize: 20, color: Colors.grey[700]),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20), // Space before the button
              Center(
                // Center the button horizontally
                child: GestureDetector(
                  onTap: () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => DisclaimerPage()),
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12), // Adjust padding as needed
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: mint,
                    ),
                    child: const Text(
                      'Get Started',
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                  height:
                      30), // To ensure some space at the bottom of the screen
            ],
          ),
        ),
      ),
    );
  }
}
