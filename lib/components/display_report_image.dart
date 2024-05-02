import 'package:flutter/material.dart';

class display_report_image extends StatelessWidget  {
  final String fileUrl;
  final String imageUrl;
  static const Color mint = Color.fromARGB(255, 162, 228, 184);

  //constructor with required parameters
  const display_report_image({
    required this.fileUrl,
    required this.imageUrl});
  
  @override
  Widget build(BuildContext context) {

    return MaterialButton(
        hoverColor: mint,
        onPressed: () {print("Pressed!");},
        child: Row(
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
      )
    );
  }
}