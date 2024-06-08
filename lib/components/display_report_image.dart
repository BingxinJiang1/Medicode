import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gemini/pages/feedback.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:typed_data';
import 'package:flutter/scheduler.dart';

// ignore: camel_case_types
class displayReportImage extends StatefulWidget {
  final String fileUrl;
  final String imageUrl;
  final String title;
  final DateTime createdAt;

  const displayReportImage({
    required this.fileUrl,
    required this.imageUrl,
    required this.title,
    required this.createdAt,
    super.key,
  });

  @override
  _displayReportImageState createState() => _displayReportImageState();
}

// ignore: camel_case_types
class _displayReportImageState extends State<displayReportImage> {
  final Color mint = const Color.fromARGB(255, 162, 228, 184);
  String? responseText;
  String? apiResults;

  Future<void> geminiImageToText() async {
    final apiKey = dotenv.env['APIKEY']!;
    final model = GenerativeModel(model: 'gemini-pro-vision', apiKey: apiKey);
    const prompt = 'You are an image-to-text converter. Please take this image and convert it to text, exactly as in the photo.';

    try {
      final data = await Supabase.instance.client
        .from('files_converted')
        .select('image_text')
        .eq('image_url', widget.fileUrl);

      bool notExists = data.isEmpty;
      if (notExists) {
        final Uint8List imageBytes = await Supabase.instance.client.storage
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

        await Supabase.instance.client.from('files_converted').insert({
                                      'user_id': Supabase.instance.client.auth.currentUser!.id,
                                      'image_url': widget.fileUrl,
                                      'image_text': responseText});
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Converted image into text'))
        );
      } else {
        setState(() {
            responseText = data.first['image_text'];
          });
      }
      
    } catch (error)  {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to either retrieve previously uploaded text, or failed to convert image into text: $error'))
      );
    }
  }
    
  Future<void> geminiAnalyze() async {
    if (responseText == null) {
      await geminiImageToText();
    }

    final apiKey = dotenv.env['APIKEY']!;
    final model = GenerativeModel(model: 'gemini-pro', apiKey: apiKey);

    try {
      final content = [Content.text('Please translate and explain any medical terminology or terms into short explanations: $responseText')];
      final response = await model.generateContent(content);
      var generatedText = response.text ?? "No result generated";

      // Store result in state
      setState(() {
        apiResults = generatedText;
      });

      // Navigate to FeedbackPage
      SchedulerBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => FeedbackPage(apiResults: apiResults!))
        );
      });

      // Inform the user of success
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Text successfully uploaded and analyzed')),
      );
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to upload text to gemini for analysis: $e')),
      );
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
        color: mint,
        highlightColor: mint,
        onPressed: () {
            geminiAnalyze();
          },
        child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: SizedBox(
              width: 100,
              height: 100,
              child: Image.network(
                      widget.imageUrl,
                      fit: BoxFit.cover,
                    ),
            ),
          ),
          SizedBox(
            width: 150,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 5),
                Text(
                  'Created: ${widget.createdAt.toLocal()}',
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
        ], 
      ),
    );
  }
}
