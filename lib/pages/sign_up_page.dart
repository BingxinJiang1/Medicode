// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import 'package:gemini/supabase_manager.dart';
// import 'package:gemini/pages/disclaimer_screen.dart';

// class SignUpPage extends StatelessWidget {
//   const SignUpPage({super.key});


//   @override
//   Widget build(BuildContext context) {
//     const Color mint = Color.fromARGB(255, 162, 228, 184);

//     final TextEditingController emailController = TextEditingController();
//     final TextEditingController passwordController = TextEditingController();
//     final TextEditingController confirmPasswordController =
//     TextEditingController();

//     Future<void> signUp(BuildContext context) async {
//       final String email = emailController.text.trim();
//       final String password = passwordController.text;
//       final String confirmPassword = confirmPasswordController.text;

//       if (password != confirmPassword) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text("Passwords don't match")),
//         );
//         return;
//       }

//       try {
//         final response = await SupabaseManager.client.auth.signUp(email: email, password: password);
//         // if (response.error != null && response.error!.message != null) {
//         //   ScaffoldMessenger.of(context).showSnackBar(
//         //     SnackBar(content: Text(response.error!.message!)),
//         //   );
//         // } else if (response.data == null) {
//         //   ScaffoldMessenger.of(context).showSnackBar(
//         //     SnackBar(content: Text("An error occurred")),
//         //   );
//         // } else {
//           // SignUp successful, you can navigate to another screen or perform any other action here.
//           // Navigate to the disclaimer screen:
//           Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => DisclaimerPage()));
//         // }
//       } catch (error) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text("An error occurred")),
//         );
//       }
//     }

//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: mint,
//         title: Text('Sign Up', style: GoogleFonts.notoSerif()),
//         centerTitle: true,
//       ),
//       body: Padding(
//         padding: EdgeInsets.all(20),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             TextField(
//               controller: emailController,
//               decoration: InputDecoration(
//                 labelText: 'Email',
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             SizedBox(height: 20),
//             TextField(
//               controller: passwordController,
//               decoration: InputDecoration(
//                 labelText: 'Password',
//                 border: OutlineInputBorder(),
//               ),
//               obscureText: true,
//             ),
//             SizedBox(height: 20),
//             TextField(
//               controller: confirmPasswordController,
//               decoration: InputDecoration(
//                 labelText: 'Confirm Password',
//                 border: OutlineInputBorder(),
//               ),
//               obscureText: true,
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () => signUp(context),
//               child: Text('Sign Up'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
