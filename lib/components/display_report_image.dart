import 'package:flutter/material.dart';
import 'package:gemini/components/constants.dart';

class display_report_image extends StatelessWidget  {
  final String fileUrl;
  final String? imageUrl = null;

  //constructor with required parameters
  //fileUrl must be the ENTIRE file path, including folders, file names and extension
  const display_report_image({
    required this.fileUrl});

  //gets PublicUrl string for a given user and a given fileUrl
  //fileUrl must be the ENTIRE file path, including folders, file names and extension
  String _getPublicUrl(String fileUrl) {
    // return '$userId/$fileUrl'; 
    try {
        final String publicUrl = supabase
        .storage
        .from('report_images')
        .getPublicUrl(fileUrl);
        print(publicUrl);
        return publicUrl;
    } catch (error) {
      SnackBar(
        content: const Text('Unexpected error occurred')
      );
      return 'No file image found.';
    }
  }
  
  @override
  Widget build(BuildContext context) {//<-- Error here
    return Row(
      children: [
        SizedBox(
          width: 150,
          height: 150,
          child: 
          Image.network(
                  _getPublicUrl(fileUrl),
                  fit: BoxFit.cover,
                )
        ),
        SizedBox(
          width: 150,
          height: 150,
          child: Text(fileUrl)
        )
      ], 
    );
  }
}