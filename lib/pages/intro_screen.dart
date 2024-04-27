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
        backgroundColor: mint,
        title: Row(
          children: [
            Image.asset('lib/images/medicode_logo.png', height: 40),
            const SizedBox(width: 10),
            Text('Medicode', style: TextStyle(color: Colors.black)),
          ],
        ),
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 100.0, vertical: 20),
              child: Image.asset('lib/images/heart.jpeg'),
            ),
            Expanded(
              // Wrap with Expanded for proper spacing
              child: Column(
                mainAxisAlignment:
                    MainAxisAlignment.center, // Centers vertically
                children: [
                  Text(
                    'Understand your report',
                    textAlign:
                        TextAlign.center, // Centers the text horizontally
                    style: GoogleFonts.notoSerif(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                      height: 20), // Add space between text and bullet points
                  Padding(
                    // Add Padding widget
                    padding: const EdgeInsets.symmetric(
                        horizontal: 28.0), // Horizontal padding
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start, // Aligns text to the left
                      children: [
                        Text(
                          '• Upload PDFs of your radiologist\'s reports for instant rephrasing.',
                          style:
                              TextStyle(fontSize: 20, color: Colors.grey[700]),
                        ),
                        Text(
                          '• Simplify medical reports into clear, understandable language.',
                          style:
                              TextStyle(fontSize: 20, color: Colors.grey[700]),
                        ),
                        Text(
                          '• Get actionable insights and recommended questions for your doctor.',
                          style:
                              TextStyle(fontSize: 20, color: Colors.grey[700]),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Center( // Center the button horizontally
              child: GestureDetector(
                onTap: () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => DisclaimerPage()),
                ),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12), // Adjust padding as needed
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
            const SizedBox(height: 30), // To ensure some space at the bottom of the screen
          ]
        ),
      ),
    );
  }
}
