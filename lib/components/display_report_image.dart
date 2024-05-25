import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gemini/components/constants.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:gemini/pages/feedback.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/scheduler.dart';

class displayReportImage extends StatefulWidget  {
  //fileUrl MUST CONTAIN: the file name and extension, AND ALL folders that should be in the path
  final String fileUrl;
  final String imageUrl;

  //constructor with required parameters
  const displayReportImage({
    required this.fileUrl,
    required this.imageUrl});

  @override
  displayReportImageState createState() => displayReportImageState();
}

class displayReportImageState extends State<displayReportImage> {
  final Color mint = Color.fromARGB(255, 162, 228, 184);
  String? responseText;
  String? apiResults;

  Future<void> geminiImageToText() async {
    // const apiKey = 'AIzaSyDc8aYbZAgj1ZH5zKUUgD7y7JfZNYpNkpI';
    final apiKey = dotenv.env['APIKEY']!;
    final model = GenerativeModel(model: 'gemini-pro-vision', apiKey: apiKey);
    const prompt = 'You are an image-to-text converter. Please take this image and convert it to text, exactly as in the photo.';

    try {
      print(widget.fileUrl);
      final Uint8List imageBytes = await supabase
        .storage
        .from('report_images')
        .download(widget.fileUrl);
      
      final convertedText = [
         Content.multi([
          TextPart(prompt),
          DataPart('image/png', imageBytes),
      ])];

      final response = await model.generateContent(convertedText);

      setState(() {
          responseText = response.text;
        });
      print(responseText);

      await supabase.from('files_converted').insert({
                                    'user_id': supabase.auth.currentSession!.user.id,
                                    'image_url': widget.fileUrl,
                                    'image_text': responseText});
      ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Converted image into text'))
      );
      
    } catch (error)  {
      print(error);
      ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to convert image into text: $error'))
      );
    }
  }
    
  void geminiAnalyze() async {
    if (responseText == null) {
      await geminiImageToText();
    }

    // const apiKey = 'AIzaSyDc8aYbZAgj1ZH5zKUUgD7y7JfZNYpNkpI';
    final apiKey = dotenv.env['APIKEY']!;
    final model = GenerativeModel(model: 'gemini-pro', apiKey: apiKey);

    try {
      final content = [Content.text('Please translate and explain any medical terminology or terms into short explainations: $responseText')];
      final response = await model.generateContent(content);
      var generatedText = response.text ?? "No result generated";

      // Inform the user of success
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Text successfully uploaded and analyzed')),
      );
      // Store result in state
      setState(() {
        apiResults = generatedText;
      });
      print(apiResults);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to upload text to gemini for analysis: $e')),
      );
    }
  }
  
    @override
    Widget build(BuildContext context) {
      if (apiResults != null && apiResults!.isNotEmpty) {
        SchedulerBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => FeedbackPage(apiResults: apiResults!))
        );
      });

      }
      //else
      return MaterialButton(
          hoverColor: mint,
          onPressed: () {
              geminiAnalyze();
            },
          child: Row(
          children: [
            SizedBox(
              width: 150,
              height: 150,
              child: 
              Image.network(
                      widget.imageUrl,
                      fit: BoxFit.cover,
                    )
            ),
            SizedBox(
              width: 150,
              height: 150,
              child: Text(widget.fileUrl)
            )
          ], 
        )
      );
    }
}