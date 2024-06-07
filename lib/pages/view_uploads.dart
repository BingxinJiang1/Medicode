import 'package:flutter/material.dart';
import 'package:gemini/pages/upload_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:gemini/components/display_report_image.dart';
import 'package:gemini/pages/intro_screen.dart';

class ViewUploadsPage extends StatefulWidget {
  const ViewUploadsPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ViewUploadsPageState createState() => _ViewUploadsPageState();
}

class _ViewUploadsPageState extends State<ViewUploadsPage> {
  final userId = Supabase.instance.client.auth.currentUser?.id;
  final Color mint = const Color.fromARGB(255, 162, 228, 184);
  int len = 0;
  var _filesList = [];
  var _loading = true;
  String? _selectedFile;

  Future<void> _getStorageFiles() async {
    setState(() {
      _loading = true;
    });
    try {
      final userFiles = await Supabase.instance.client.storage
          .from('report_images')
          .list(path: userId);
      setState(() {
        len = userFiles.length;
        _filesList = userFiles;
      });
    } catch (error) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Unexpected error occurred')),
      );
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  String _getPublicUrl(String fileUrl) {
    try {
      final String publicUrl = Supabase.instance.client.storage
          .from('report_images')
          .getPublicUrl(fileUrl);
      return publicUrl;
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Unexpected error occurred')),
      );
      return 'No file image found.';
    }
  }

  @override
  void initState() {
    super.initState();
    _getStorageFiles();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mint,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.asset('lib/images/Medicode.png', height: 50),
            const SizedBox(width: 20),
            const Text(
              'Profile',
              style: TextStyle(color: Colors.black),
            ),
          ],
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const IntroScreen()),
              );
            },
            icon: const Icon(Icons.logout), // Use the logout icon
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
                const Divider(),
                Text('Number of uploaded images: ${len.toString()}'),
                const Text('Click on Image to select it for analysis'),
                const SizedBox(height: 18),
                ListView.builder(
                    physics: const ScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: len,
                    itemBuilder: (BuildContext context, int index) {
                      final file = _filesList[index];
                      return ListTile(
                        title: displayReportImage(
                            fileUrl: '$userId/${file.name}',
                            imageUrl: _getPublicUrl('$userId/${file.name}')),
                        selected: _selectedFile == file.name,
                        onTap: () {
                          setState(() {
                            _selectedFile = file.name;
                          });
                        },
                      );
                    }),
                const SizedBox(height: 50),
                navigationButtons(context),
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
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () {
                if (Navigator.canPop(context)) {
                  Navigator.pop(context);
                } else {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (_) => const ReportImage()));
                }
              },
              style: buttonStyle(),
              child: const Text("Back",
                  style: TextStyle(color: Colors.black, fontSize: 16)),
            ),
            ElevatedButton(
              onPressed: _selectedFile == null
                  ? null
                  : () {
                      // No need to navigate to FeedbackPage from here.
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content:
                                Text('Please wait for analysis to complete.')),
                      );
                    },
              style: buttonStyle(),
              child: const Text("Analyze",
                  style: TextStyle(color: Colors.black, fontSize: 16)),
            ),
          ],
        ),
      ],
    );
  }
}
