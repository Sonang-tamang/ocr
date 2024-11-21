// // ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

// import 'package:flutter/material.dart';
// import 'package:ocr/authentication/authentication.dart';
// import 'package:ocr/home/welcome.dart';

// class Signupform extends StatelessWidget {
//   const Signupform({super.key});

//   @override
//   Widget build(BuildContext context) {
//     double width = MediaQuery.of(context).size.width;
//     double height = MediaQuery.of(context).size.height;

//     return Scaffold(
//       body: SingleChildScrollView(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             SizedBox(
//               height: height * 0.07,
//             ),
//             Center(
//               child: Padding(
//                 padding: const EdgeInsets.all(19.0),
//                 child: Container(
//                   height: height * 1.1,
//                   width: width * .7,
//                   decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(20),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black.withOpacity(0.2), // Shadow color
//                           spreadRadius: 2, // How much the shadow spreads
//                           blurRadius: 10, // How blurry the shadow is
//                           offset: Offset(0, 5),
//                         ),

//                         // welcome text #######################
//                       ]),
//                   child: Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Column(
//                       children: [
//                         SizedBox(
//                           height: height * 0.02,
//                         ),
//                         Text(
//                           "Welcome to The OCR",
//                           style: TextStyle(
//                             fontWeight: FontWeight.w600,
//                             fontSize: height * 0.03,
//                           ),
//                           textAlign: TextAlign.center,
//                         ),

//                         SizedBox(
//                           height: height * 0.04,
//                         ),

//                         // profile pic slection ############################################

//                         Container(
//                           width: width,
//                           height: height * 0.09,
//                           decoration: BoxDecoration(
//                               shape: BoxShape.circle,
//                               color: Colors.transparent.withOpacity(0.5)),
//                           child: Icon(
//                             Icons.person,
//                             size: height * 0.07,
//                             color: Colors.white,
//                           ),
//                         ),
//                         SizedBox(
//                           height: height * 0.01,
//                         ),

//                         Text(
//                           "Upload you profile picture",
//                           style: TextStyle(
//                             fontWeight: FontWeight.w500,
//                             fontSize: height * 0.02,
//                           ),
//                         ),

//                         // user data ###########################################

//                         SizedBox(
//                           height: height * 0.04,
//                         ),

//                         // text box for username ###############################################
//                         Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: TextField(
//                             decoration: InputDecoration(
//                               enabledBorder: OutlineInputBorder(
//                                   borderSide: BorderSide(
//                                 color: const Color.fromARGB(255, 157, 165, 165),
//                               )),
//                               focusedBorder: OutlineInputBorder(
//                                 borderSide: BorderSide(
//                                     color:
//                                         const Color.fromARGB(255, 96, 93, 93)),
//                               ),
//                               hintText: "Username*",
//                               hintStyle: TextStyle(fontWeight: FontWeight.w300),
//                             ),
//                           ),
//                         ),

//                         // text box for Email ###############################################
//                         Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: TextField(
//                             decoration: InputDecoration(
//                               enabledBorder: OutlineInputBorder(
//                                   borderSide: BorderSide(
//                                 color: const Color.fromARGB(255, 157, 165, 165),
//                               )),
//                               focusedBorder: OutlineInputBorder(
//                                 borderSide: BorderSide(
//                                     color:
//                                         const Color.fromARGB(255, 96, 93, 93)),
//                               ),
//                               hintText: "Email*",
//                               hintStyle: TextStyle(fontWeight: FontWeight.w300),
//                             ),
//                           ),
//                         ),

//                         // text box for password ###############################################
//                         Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: TextField(
//                             decoration: InputDecoration(
//                               enabledBorder: OutlineInputBorder(
//                                   borderSide: BorderSide(
//                                 color: const Color.fromARGB(255, 157, 165, 165),
//                               )),
//                               focusedBorder: OutlineInputBorder(
//                                 borderSide: BorderSide(
//                                     color:
//                                         const Color.fromARGB(255, 96, 93, 93)),
//                               ),
//                               hintText: "Password*",
//                               hintStyle: TextStyle(fontWeight: FontWeight.w300),
//                             ),
//                           ),
//                         ),

//                         // text box for confirm password ###############################################
//                         Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: TextField(
//                             decoration: InputDecoration(
//                               enabledBorder: OutlineInputBorder(
//                                   borderSide: BorderSide(
//                                 color: const Color.fromARGB(255, 157, 165, 165),
//                               )),
//                               focusedBorder: OutlineInputBorder(
//                                 borderSide: BorderSide(
//                                     color:
//                                         const Color.fromARGB(255, 96, 93, 93)),
//                               ),
//                               hintText: "Confirm Password*",
//                               hintStyle: TextStyle(fontWeight: FontWeight.w300),
//                             ),
//                           ),
//                         ),

//                         // text box for first name ###############################################
//                         Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: TextField(
//                             decoration: InputDecoration(
//                               enabledBorder: OutlineInputBorder(
//                                   borderSide: BorderSide(
//                                 color: const Color.fromARGB(255, 157, 165, 165),
//                               )),
//                               focusedBorder: OutlineInputBorder(
//                                 borderSide: BorderSide(
//                                     color:
//                                         const Color.fromARGB(255, 96, 93, 93)),
//                               ),
//                               hintText: "First Name*",
//                               hintStyle: TextStyle(fontWeight: FontWeight.w300),
//                             ),
//                           ),
//                         ),

//                         // text box for Last name ###############################################
//                         Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: TextField(
//                             decoration: InputDecoration(
//                               enabledBorder: OutlineInputBorder(
//                                   borderSide: BorderSide(
//                                 color: const Color.fromARGB(255, 157, 165, 165),
//                               )),
//                               focusedBorder: OutlineInputBorder(
//                                 borderSide: BorderSide(
//                                     color:
//                                         const Color.fromARGB(255, 96, 93, 93)),
//                               ),
//                               hintText: "Last Name*",
//                               hintStyle: TextStyle(fontWeight: FontWeight.w300),
//                             ),
//                           ),
//                         ),

//                         // text box for Contact ###############################################
//                         Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: TextField(
//                             decoration: InputDecoration(
//                               enabledBorder: OutlineInputBorder(
//                                   borderSide: BorderSide(
//                                 color: const Color.fromARGB(255, 157, 165, 165),
//                               )),
//                               focusedBorder: OutlineInputBorder(
//                                 borderSide: BorderSide(
//                                     color:
//                                         const Color.fromARGB(255, 96, 93, 93)),
//                               ),
//                               hintText: "Contact*",
//                               hintStyle: TextStyle(fontWeight: FontWeight.w300),
//                             ),
//                           ),
//                         ),

//                         SizedBox(
//                           height: height * 0.03,
//                         ),

//                         // login buttom ##################################

//                         SizedBox(
//                           height: height * 0.05,
//                           width: width * 0.6,
//                           child: Card(
//                             color: const Color.fromARGB(255, 55, 135, 200),
//                             child: Center(
//                               child: Text(
//                                 "Sign Up",
//                                 style: TextStyle(
//                                     fontSize: 15,
//                                     color: Colors.white,
//                                     fontWeight: FontWeight.bold),
//                               ),
//                             ),
//                           ),
//                         ),

//                         // signup text ########################################################

//                         TextButton(
//                             onPressed: () {
//                               goto_Login(context);
//                             },
//                             style: TextButton.styleFrom(
//                               foregroundColor: Colors.red,
//                             ),
//                             child: Text(
//                               "Already have an account? Login ",
//                               style: TextStyle(color: Colors.red),
//                             )),

//                         SizedBox(
//                           height: height * 0.05,
//                         ),

//                         // google login ###############################

//                         SizedBox(
//                           height: height * 0.06,
//                           width: width * 0.5,
//                           child: Card(
//                             color: Colors.red,
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 Text(
//                                   "Continue with Google ",
//                                   style: TextStyle(
//                                       color: Colors.white,
//                                       fontSize: height * 0.018,
//                                       fontWeight: FontWeight.bold),
//                                 ),
//                                 Icon(
//                                   Icons.g_mobiledata,
//                                   size: height * 0.04,
//                                   color: Colors.white,
//                                 )
//                               ],
//                             ),
//                           ),
//                         )
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }

// void goto_Login(BuildContext context) {
//   Navigator.push(
//     context,
//     MaterialPageRoute(builder: (context) => const Authentication()),
//   );
// }
