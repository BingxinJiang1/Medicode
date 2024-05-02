import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gemini/pages/upload_page.dart';
import 'package:gemini/pages/feedback.dart';
import 'package:gemini/pages/intro_screen.dart';
import 'package:gemini/components/constants.dart';
import 'package:gemini/components/display_report_image.dart';



class ViewUploadsPage extends StatefulWidget {
  const ViewUploadsPage({super.key});

  @override
  _ViewUploadsPageState createState() => _ViewUploadsPageState();
}

class _ViewUploadsPageState extends State<ViewUploadsPage> {
  // final _usernameController = TextEditingController();
  // final _websiteController = TextEditingController();
  // String? _avatarUrl;
  final userId = supabase.auth.currentSession!.user.id;
  final Color mint = Color.fromARGB(255, 162, 228, 184);
  int len = 0;
  var _files_list = null;
  var _loading = true;

  /// get all files in storage bucket report_images 
  /// CURRENTLY ASSUMES user is authenticated. There will be errors if user is not auth.
  Future<void> _getStorageFiles() async {
    setState(() {
      _loading = true;
    });
      try {
        final userFiles = await supabase
          .storage
          .from('report_images')
          .list(path: userId);
        len = userFiles.length;
        _files_list = userFiles;
      } catch (error) {
      SnackBar(
        content: const Text('Unexpected error occurred'),
        backgroundColor: Theme.of(context).colorScheme.error,
      );
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
    }
  
  @override
  void initState() {
    super.initState();
    _getStorageFiles();
    
    setState(() { 
          _loading = false;
        });
  }

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mint,
        title: Row(
          children: [
            Image.asset('lib/images/medicode_logo.png', height: 40),
            const SizedBox(width: 10),
            Text(
              'Profile',
              style: TextStyle(color: Colors.black),
            ),
          ],
          mainAxisAlignment: MainAxisAlignment.start,
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const IntroScreen()),
              );
            },
            icon: Icon(Icons.logout), // Use the logout icon
            color: Colors.black,
          ),
          const SizedBox(width: 10),
        ],
        elevation: 0,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
        children: [
          
          const SizedBox(height: 18),
          Text('You are logged in as user_id: $userId'),
          // const Text('Not you? Sign out and log into a different account),
          // TextButton(onPressed: _signOut, child: const Text('Sign Out')),
          Text(len.toString()),
          const SizedBox(height: 18),
          ListView.builder(
              physics: ScrollPhysics(),
              shrinkWrap: true,
              itemCount: len,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  height: 60,
                  child: Center(
                    child: 
                    display_report_image(fileUrl: '$userId/${_files_list[index].name}')
                    // Text(
                    //   '${_files_list[index].name}',
                    //   style: const TextStyle(color: Colors.black, fontSize: 16),
                    // ),
                  ),
                );
              }),
          navigationButtons(context)
        ],
      ),
    );
  }

  ButtonStyle buttonStyle() {
    return ElevatedButton.styleFrom(
      backgroundColor: mint,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
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
}
