import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gemini/pages/intro_screen.dart';
import 'package:gemini/pages/upload_page.dart';
import 'package:gemini/pages/login.dart';

class FeedbackPage extends StatelessWidget {
  const FeedbackPage({super.key});

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
          mainAxisAlignment: MainAxisAlignment
              .start, // Aligns title Row to the start of AppBar
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
              );
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.black,
              backgroundColor: Colors.white, // Button background color
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
                padding: const EdgeInsets.fromLTRB(100.0, 10.0, 100.0, 10),
                child: Image.asset('lib/images/heart.jpeg'),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(28.0, 0, 28.0, 20.0),
                child: Text(
                  'Before using Medicode, please read the Terms of Service and remember:',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.notoSerif(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '• Medicode is for informational purposes only – not a substitute for professional medical advice, diagnosis, or treatment.',
                      style: TextStyle(fontSize: 20, color: Colors.grey[700]),
                    ),
                    Text(
                      '• Always consult your physician or a qualified health provider with any questions regarding a medical condition.',
                      style: TextStyle(fontSize: 20, color: Colors.grey[700]),
                    ),
                    Text(
                      '• Do not disregard professional medical advice or delay seeking it based on information from this app.',
                      style: TextStyle(fontSize: 20, color: Colors.grey[700]),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                  height: 20), // Adjust the space before the buttons as needed
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      if (Navigator.canPop(context)) {
                        Navigator.pop(context);
                      } else {
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (_) => IntroScreen()));
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: mint,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 16),
                    ),
                    child: const Text("Back",
                        style: TextStyle(color: Colors.black, fontSize: 16)),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ReportImage()));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: mint,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 16),
                    ),
                    child: const Text("Next",
                        style: TextStyle(color: Colors.black, fontSize: 16)),
                  ),
                ],
              ),
              const SizedBox(
                  height:
                      20), // Adjust the space at the bottom of the screen as needed
            ],
          ),
        ),
      ),
    );
  }
}
