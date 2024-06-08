import 'package:flutter/material.dart';
import 'package:gemini/pages/account_page.dart';
import 'package:gemini/pages/login.dart';
import 'package:gemini/pages/upload_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:gemini/pages/intro_screen.dart';

class FeedbackPage extends StatefulWidget {
  final String apiResults;
  const FeedbackPage({super.key, this.apiResults = "No results available"});

  @override
  _FeedbackPageState createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  final Color mint = const Color.fromARGB(255, 162, 228, 184);
  String? avatarUrl;
  bool isAnonymousUser = false;

  @override
  void initState() {
    super.initState();
    _fetchUserProfile();
  }

  Future<void> _fetchUserProfile() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user != null) {
      isAnonymousUser = user.isAnonymous;
      final response = await Supabase.instance.client
          .from('profiles')
          .select('avatar_url')
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
  Widget build(BuildContext context) {
    final user = Supabase.instance.client.auth.currentUser;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: mint,
        title: Row(
          children: [
            Image.asset('lib/images/Medicode.png', height: 50),
            const SizedBox(width: 20),
            const Text('Feedbacks', style: TextStyle(color: Colors.black)),
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
                    style: TextStyle(fontWeight: FontWeight.bold),
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              navigationButtons(context),
              const Text(
                'Here are the results of your data:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Text(
                widget.apiResults,
                style: const TextStyle(fontSize: 16),
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 120),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget navigationButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            } else {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const ReportImage()));
            }
          },
          style: buttonStyle(),
          child: const Text("Back", style: TextStyle(color: Colors.black, fontSize: 16)),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const FeedbackPage()));
          },
          style: buttonStyle(),
          child: const Text("Next", style: TextStyle(color: Colors.black, fontSize: 16)),
        ),
      ],
    );
  }

  ButtonStyle buttonStyle() {
    return ElevatedButton.styleFrom(
      backgroundColor: const Color.fromARGB(255, 162, 228, 184),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
    );
  }
}
