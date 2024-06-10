import 'package:flutter/material.dart';
import 'package:gemini/pages/account_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gemini/pages/intro_screen.dart';
import 'package:gemini/pages/upload_page.dart';
import 'package:gemini/pages/login.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DisclaimerPage extends StatefulWidget {
  const DisclaimerPage({super.key});

  @override
  _DisclaimerPageState createState() => _DisclaimerPageState();
}

class _DisclaimerPageState extends State<DisclaimerPage> {
  final Color mint = const Color.fromARGB(255, 162, 228, 184);
  String? avatarUrl; // Variable to store avatar URL
  bool isAnonymousUser = false;

  @override
  void initState() {
    super.initState();
    _fetchUserProfile();
  }

  Future<void> _fetchUserProfile() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user != null) {
      print("test print: ");
      print(user.isAnonymous);
      isAnonymousUser = user.isAnonymous;
      final response = await Supabase.instance.client
          .from('profiles')
          .select()
          .eq('id', user.id)
          .single();
      setState(() {
        avatarUrl = response['avatar_url'];
      });
    }
  }

  Future<void> _showSignOutReminderDialog() async {
    showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Guest Mode'),
          content: const Text(
            'You are currently browsing as a guest. Would you like to sign out or keep browsing?',
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Keep Browsing'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Sign Out'),
              onPressed: () async {
                await Supabase.instance.client.auth.signOut();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const IntroScreen()),
                  (Route<dynamic> route) => false,
                );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  @override
@override
Widget build(BuildContext context) {
  final user = Supabase.instance.client.auth.currentUser;

  return WillPopScope(
    onWillPop: () async => false,
    child: Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: mint,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.asset('lib/images/Medicode.png', height: 50),
            const SizedBox(width: 20),
          ],
        ),
        actions: <Widget>[
          user == null
              ? TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginPage()),
                    );
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.black,
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  child: const Text(
                    'Log In',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              : GestureDetector(
                  onTap: () {
                    if (isAnonymousUser) {
                      _showSignOutReminderDialog();
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const AccountPage()),
                      );
                    }
                  },
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(
                      avatarUrl ?? 'https://via.placeholder.com/150',
                    ),
                  ),
                ),
          const SizedBox(width: 10),
        ],
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(100.0, 10.0, 100.0, 10),
                child: Image.asset('lib/images/heart.png'),
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
                child: Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildBulletPoint(
                          'Medicode is for informational purposes only – not a substitute for professional medical advice, diagnosis, or treatment.',
                        ),
                        _buildBulletPoint(
                          'Always consult your physician or a qualified health provider with any questions regarding a medical condition.',
                        ),
                        _buildBulletPoint(
                          'Do not disregard professional medical advice or delay seeking it based on information from this app.',
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ReportImage())); // Use push to add to stack
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: mint,
                  ),
                  child: const Text(
                    'Next',
                    style: TextStyle(color: Colors.black, fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    ),
  );
}

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '• ',
            style: TextStyle(
              fontSize: 20,
              color: Colors.black,
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
