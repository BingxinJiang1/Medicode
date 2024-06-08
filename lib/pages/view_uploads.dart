import 'package:flutter/material.dart';
import 'package:gemini/pages/upload_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:gemini/components/display_report_image.dart';
import 'package:gemini/pages/intro_screen.dart';

class ViewUploadsPage extends StatefulWidget {
  const ViewUploadsPage({super.key});

  @override
  _ViewUploadsPageState createState() => _ViewUploadsPageState();
}

class _ViewUploadsPageState extends State<ViewUploadsPage> {
  final String? userId = Supabase.instance.client.auth.currentUser?.id;
  final Color mint = const Color.fromARGB(255, 162, 228, 184);
  int len = 0;
  List<Map<String, dynamic>> _filesList = [];
  bool _loading = true;
  String? _selectedFile;

  Future<void> _getStorageFiles() async {
    setState(() {
      _loading = true;
    });
    try {
      final localUserId = userId; // Create a local copy of userId
      if (localUserId != null) {
        final response = await Supabase.instance.client
            .from('report_image_text_metadata')
            .select()
            .eq('user_id', localUserId);

        final files = List<Map<String, dynamic>>.from(response);

        // Filter files to only include images
        final imageFiles =
            files.where((file) => file['type'].startsWith('image/')).toList();

        setState(() {
          _filesList = imageFiles;
          len = _filesList.length;
        });
      }
    } catch (error) {
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
                Text('Number of uploaded files: ${len.toString()}'),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: Colors.amber.shade100,
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(color: Colors.amber, width: 2),
                  ),
                  child: const Text(
                    'Click on an item to select it for analysis',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 18),
                ListView.builder(
                    physics: const ScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: len,
                    itemBuilder: (BuildContext context, int index) {
                      final file = _filesList[index];
                      return ListTile(
                        title: DisplayReportImage(
                            fileUrl: file['path'],
                            imageUrl: _getPublicUrl(file['path']),
                            title: file['title'],
                            createdAt: DateTime.parse(file['created_at'])),
                        selected: _selectedFile == file['path'],
                        onTap: () {
                          setState(() {
                            _selectedFile = file['path'];
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
          ],
        ),
      ],
    );
  }
}
