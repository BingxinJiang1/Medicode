import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:gemini/pages/login.dart';
import 'package:gemini/pages/view_uploads.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';

class ReportImage extends StatefulWidget {
  const ReportImage({super.key});

  @override
  _ReportImageState createState() => _ReportImageState();
}

class _ReportImageState extends State<ReportImage> {
  final Color mint = const Color.fromARGB(255, 162, 228, 184);
  final TextEditingController _textController = TextEditingController();
  int uploadedFileCount = 0;

  Future<void> _showTitleDialog(Function(String) onTitleEntered) async {
    final TextEditingController _titleController = TextEditingController();
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // User must enter a title
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Enter Title'),
          content: TextField(
            controller: _titleController,
            decoration: const InputDecoration(hintText: 'Title'),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Submit'),
              onPressed: () {
                final title = _titleController.text.trim();
                if (title.isNotEmpty) {
                  onTitleEntered(title);
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Title cannot be empty')),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> uploadImages(BuildContext context) async {
    final ImagePicker picker = ImagePicker();
    final List<XFile>? images = await picker.pickMultiImage();
    final userId = Supabase.instance.client.auth.currentUser?.id;

    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('You need to be logged in to upload files')));
      return;
    }

    if (images == null || images.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('No images selected')));
      return;
    }

    for (var image in images) {
      await _showTitleDialog((title) async {
        final imageBytes = await image.readAsBytes();
        final mimeType = lookupMimeType(image.path, headerBytes: imageBytes);
        final contentType = mimeType ?? 'application/octet-stream';
        final imageExtension =
            mimeType != null ? mimeType.split('/').last : 'bin';
        final imagePath =
            '$userId/report_${DateTime.now().toIso8601String()}.$imageExtension';

        try {
          await Supabase.instance.client.storage
              .from('report_images')
              .uploadBinary(
                imagePath,
                imageBytes,
                fileOptions: FileOptions(
                  upsert: true,
                  contentType: contentType,
                ),
              );

          await Supabase.instance.client
              .from('report_image_text_metadata')
              .insert({
            'user_id': userId,
            'path': imagePath,
            'type': contentType,
            'title': title,
          });

          setState(() {
            uploadedFileCount += 1;
          });

          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Image successfully uploaded')));
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Failed to upload image: $e')));
        }
      });
    }
  }

  Future<void> uploadText(BuildContext context) async {
    final userId = Supabase.instance.client.auth.currentUser?.id;

    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('You need to be logged in to upload files')));
      return;
    }

    if (_textController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter some text')));
      return;
    }

    await _showTitleDialog((title) async {
      final textContent = _textController.text;
      final textBytes = textContent.codeUnits;
      final textPath = '$userId/report_${DateTime.now().toIso8601String()}.txt';

      try {
        await Supabase.instance.client.storage
            .from('report_images')
            .uploadBinary(
              textPath,
              Uint8List.fromList(textBytes),
              fileOptions: FileOptions(
                upsert: true,
                contentType: 'text/plain',
              ),
            );

        await Supabase.instance.client
            .from('report_image_text_metadata')
            .insert({
          'user_id': userId,
          'path': textPath,
          'type': 'text/plain',
          'title': title,
        });

        setState(() {
          uploadedFileCount += 1;
        });

        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Text successfully uploaded')));
      } catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Failed to upload text: $e')));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          TextButton(
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
          ),
          const SizedBox(width: 10),
        ],
        elevation: 0,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(100.0, 10.0, 100.0, 10),
                child: Image.asset('lib/images/heart.png'),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  'Upload your report as an image or text for processing and analysis.',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: SizedBox(
                  height: 100,
                  child: TextField(
                    controller: _textController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Enter text to upload',
                      alignLabelWithHint: true,
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 20.0, horizontal: 20.0),
                    ),
                    style: const TextStyle(fontSize: 16),
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => uploadText(context),
                style: buttonStyle(),
                child: const Text('Upload Text',
                    style: TextStyle(color: Colors.black, fontSize: 16)),
              ),
              const SizedBox(height: 20),
              Divider(
                  thickness: 2,
                  color: Colors.grey[300]), // Adding a dividing line
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => uploadImages(context),
                style: buttonStyle(),
                child: const Text('Upload Screenshots',
                    style: TextStyle(color: Colors.black, fontSize: 16)),
              ),
              const SizedBox(height: 20),
              Text('Number of Uploaded Image Reports: $uploadedFileCount'),
              const SizedBox(height: 70),
              navigationButtons(context),
              const SizedBox(height: 20),
            ],
          ),
        ),
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
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => const ViewUploadsPage()));
          },
          style: buttonStyle(),
          child: const Text("Saved Image Reports",
              style: TextStyle(color: Colors.black, fontSize: 16)),
        ),
      ],
    );
  }
}
