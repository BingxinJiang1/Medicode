import 'package:flutter/material.dart';
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
import 'package:gemini/components/display_report_image.dart';

import '../components/constants.dart';

class ReportImage extends StatefulWidget {
  const ReportImage({super.key});

  @override
  _ReportImageState createState() => _ReportImageState();
}

class _ReportImageState extends State<ReportImage> {
  final TextEditingController _textController = TextEditingController();
  final Color mint = Color.fromARGB(255, 162, 228, 184); // Use mint color for buttons
  final _userId = supabase.auth.currentSession == null ? null : supabase.auth.currentSession!.user.id;
  List<String> _ImagePaths = [];
  

  Future<void> uploadImages(BuildContext context) async {
    final ImagePicker picker = ImagePicker();
    final List<XFile>? images = await picker.pickMultiImage();
    _ImagePaths = [];
    
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
      _ImagePaths.add(imagePath);

      setState(() {
        _ImagePaths = _ImagePaths;
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

  void uploadText(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Text successfully uploaded')),
    );
    // Implement actual text upload logic as needed
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
              Text('Uploaded Images Below'),
              ListView.builder(
                physics: ScrollPhysics(),
                shrinkWrap: true,
                itemCount: _ImagePaths.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    height: 60,
                    child: Center(
                      child: display_report_image(fileUrl: _ImagePaths[index])
                    ),
                  );
                }
              ),
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
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const DisclaimerPage()));
            }
          },
          style: buttonStyle(),
          child: const Text("Back", style: TextStyle(color: Colors.black, fontSize: 16)),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => _userId != null ? 
                                                                                       const ViewUploadsPage() 
                                                                                     : const FeedbackPage()));
                                                                                    //display_report_image('reports/$imagePath') 
          },
          style: buttonStyle(),
          child: const Text("Next", style: TextStyle(color: Colors.black, fontSize: 16)),
        ),
      ],
    );
  }
}

class DividerWithText extends StatelessWidget {
  final String dividerText;
  const DividerWithText({Key? key, required this.dividerText}) : super(key: key);
  
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

