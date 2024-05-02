import 'package:flutter/material.dart';

class display_report_image extends StatelessWidget  {
  final String fileUrl;
  final String imageUrl;

  //constructor with required parameters
  const display_report_image({
    required this.fileUrl,
    required this.imageUrl});
  @override
  Widget build(BuildContext context) {//<-- Error here
    return Row(
      children: [
        SizedBox(
          width: 150,
          height: 150,
          child: 
          Image.network(
                  imageUrl,
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