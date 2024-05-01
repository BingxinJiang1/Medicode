import 'package:flutter/material.dart';

class display_report_image extends StatelessWidget  {
  final String fileUrl;

  //constructor with required parameters
  const display_report_image({required this.fileUrl});
  @override
  Widget build(BuildContext context) {//<-- Error here
    return Row(
      children: [
        SizedBox(
          width: 150,
          height: 150,
          child: Text(fileUrl)
          // Image.network(
          //         imageUrl,
          //         fit: BoxFit.cover,
          //       )
        )
      ]
    );
  }
}