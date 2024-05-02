import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gemini/components/constants.dart';
import 'package:gemini/pages/feedback.dart';
import 'package:gemini/pages/view_uploads.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:gemini/pages/disclaimer_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/widgets.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:gemini/pages/login.dart';
import 'dart:io';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ReportImage extends StatefulWidget {
  const ReportImage({super.key});

  @override
  _ReportImageState createState() => _ReportImageState();
}

class _ReportImageState extends State<ReportImage> {
  final TextEditingController _textController = TextEditingController();
  final Color mint = Color.fromARGB(255, 162, 228, 184);
  String? apiResults; // Variable to store API results
  int UploadedFileCount = 0;

  void uploadText(BuildContext context) async {
    if (_textController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Please enter the text and then upload!")));
      return;
    }

    final apiKey = 'AIzaSyDc8aYbZAgj1ZH5zKUUgD7y7JfZNYpNkpI';
    final model = GenerativeModel(model: 'gemini-pro', apiKey: apiKey!);

    try {
      final content = [
        Content.text(_textController.text +
            "Simplify the patient report so that people with no medical background can understand it, and then provide 5 potential questions that the patient wants to ask the doctor.")
      ];
      final response = await model.generateContent(content);
      var generatedText = response.text ?? "No result generated";

      // Store result in state
      setState(() {
        apiResults = generatedText;
      });
      print(apiResults);

      // Inform the user of success
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Text successfully uploaded and analyzed')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to upload text: $e')),
      );
    }
  }

  Future<void> uploadImages(BuildContext context) async {
    final ImagePicker picker = ImagePicker();
    final List<XFile>? images = await picker.pickMultiImage();
    final _userId = supabase.auth.currentSession == null ? null : supabase.auth.currentSession!.user.id;

    if (images == null || images.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('No images selected')));
      return;
    }
    for (var image in images) {
      final imageExtension = image.path.split('.').last.toLowerCase();
      final imageBytes = await image.readAsBytes();
      final imagePath = _userId != null ?
            '$_userId/report_${DateTime.now().toIso8601String()}.$imageExtension'
          : 'reports/report_${DateTime.now().toIso8601String()}.$imageExtension';
      setState(() {
        UploadedFileCount = images.length;
      });

      try {
        await supabase.storage.from('report_images').uploadBinary(
              imagePath,
              imageBytes,
              fileOptions: FileOptions(
                upsert: true,
                contentType: 'image/$imageExtension',
              ),
            );
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Image successfully uploaded')));
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to upload image: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(100.0, 10.0, 100.0, 10),
                child: Image.asset('lib/images/heart.jpeg'),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal:
                        20.0), // Reduced horizontal padding for wider TextField
                child: Container(
                  height: 100,
                  child: TextField(
                    controller: _textController,
                    decoration: InputDecoration(
                      border:
                          OutlineInputBorder(), // Rectangle appearance with a border
                      labelText:
                          'Enter text to upload', // Label inside the text field
                      alignLabelWithHint: true,
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 20.0, horizontal: 20.0), // Padding inside
                    ),
                    style: TextStyle(fontSize: 16),
                    keyboardType: TextInputType.multiline,
                    minLines: 10,
                    maxLines: null, // Allows unlimited lines
                  ),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => uploadText(context),
                style: buttonStyle(),
                child: const Text('Upload Text',
                    style: TextStyle(color: Colors.black, fontSize: 16)),
              ),
              SizedBox(height: 20),
              DividerWithText(dividerText: "OR"),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => uploadImages(context),
                style: buttonStyle(),
                child: const Text('Upload Screenshots',
                    style: TextStyle(color: Colors.black, fontSize: 16)),
              ),
              SizedBox(height: 20),
              Text('Number of Uploaded Images: $UploadedFileCount'),
              SizedBox(height: 120),
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
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            } else {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (_) => const DisclaimerPage()));
            }
          },
          style: buttonStyle(),
          child: const Text("Back",
              style: TextStyle(color: Colors.black, fontSize: 16)),
        ),
        ElevatedButton(
          onPressed: () {
            if (apiResults != null && apiResults!.isNotEmpty) {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          FeedbackPage(apiResults: apiResults!)));
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('No results')),
              );
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ViewUploadsPage()));
            }
          },
          style: buttonStyle(),
          child: const Text("Next",
              style: TextStyle(color: Colors.black, fontSize: 16)),
        ),
      ],
    );
  }
}

class DividerWithText extends StatelessWidget {
  final String dividerText;
  const DividerWithText({Key? key, required this.dividerText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(child: Divider()),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(dividerText),
        ),
        Expanded(child: Divider())
      ],
    );
  }
}

class GenerativeAIManager {
  GenerativeModel? model;

  Future<void> initializeModel() async {
    final apiKey = 'AIzaSyDc8aYbZAgj1ZH5zKUUgD7y7JfZNYpNkpI';
    if (apiKey == null) {
      print('No \$API_KEY environment variable found.');
      exit(1);
    } else {
      model = GenerativeModel(model: 'MODEL_NAME', apiKey: apiKey);
    }
  }
}

Future<void> simplifyMedicalText(String inputText) async {
  var url = Uri.parse(
      'https://api.geminiapi.com/v1/simplify'); // Replace with the actual URL
  var response = await http.post(
    url,
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'AIzaSyDc8aYbZAgj1ZH5zKUUgD7y7JfZNYpNkpI' // API key
    },
    body: jsonEncode({
      'text': inputText,
    }),
  );

  if (response.statusCode == 200) {
    var data = jsonDecode(response.body);
    return data[
        'simplifiedText']; // Assuming the response contains a field `simplifiedText`
  } else {
    throw Exception('Failed to simplify text: ${response.body}');
  }
}



// class ReportImage extends StatelessWidget {
//   const ReportImage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Upload Images"),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             ElevatedButton(
//               onPressed: () async {
//                 final ImagePicker picker = ImagePicker();
//                 final List<XFile>? images = await picker.pickMultiImage();
//                 if (images == null || images.isEmpty) {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(content: Text('No images selected')),
//                   );
//                   return;
//                 }
//                 for (var image in images) {
//                   final imageExtension =
//                       image.path.split('.').last.toLowerCase();
//                   final imageBytes = await image.readAsBytes();
//                   //final userId = supabase.auth.currentUser!.id;
//                   final imagePath =
//                       'reports/report_${DateTime.now().toIso8601String()}.$imageExtension';
//                   try {
//                     await supabase.storage.from('report_images').uploadBinary(
//                           imagePath,
//                           imageBytes,
//                           fileOptions: FileOptions(
//                             upsert: true,
//                             contentType: 'image/$imageExtension',
//                           ),
//                         );
//                     String imageUrl = supabase.storage
//                         .from('report_images')
//                         .getPublicUrl(imagePath);
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       SnackBar(content: Text('Image successfully uploaded')),
//                     );
//                   } catch (e) {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       SnackBar(content: Text('Failed to upload image: $e')),
//                     );
//                   }
//                 }
//               },
//               child: const Text('Upload Images'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

