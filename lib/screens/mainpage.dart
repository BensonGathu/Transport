// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/src/widgets/container.dart';
// import 'package:flutter/src/widgets/framework.dart';
// import 'package:transportapp/utils/colors.dart';

// class MainPage extends StatelessWidget {
//   const MainPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//         decoration: BoxDecoration(
//             image: DecorationImage(
//                 // image: AssetImage('assets/transport.avif'),
//                 image: NetworkImage("https://www.shutterstock.com/image-illustration/addicted-people-using-gadgets-while-600w-1784319470.jpg"),
//                 fit: BoxFit.cover,
//                 colorFilter: ColorFilter.mode(
//                     Colors.black.withOpacity(0.2), BlendMode.darken))),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             Padding(
//               padding: const EdgeInsets.all(5.0),
//               child: SizedBox(
//                 height: 60,
//                 width: 200,
//                 child: ElevatedButton.icon(
//                   onPressed: () {},
//                   style: ButtonStyle(
//                       shape: MaterialStateProperty.all<RoundedRectangleBorder>(
//                           RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(18.0),
//                               side: const BorderSide(color: Colors.grey))),backgroundColor: MaterialStateProperty.all(Color.fromARGB(255, 19, 158, 89))),
//                   icon: Icon(Icons.directions_bus_outlined, size: 28),
//                   label: Text("Travel"),
//                 ),
//               ),
//             ),
//             // Padding(
//             //   padding: const EdgeInsets.all(5.0),
//             //   child: SizedBox(
//             //     height: 60,
//             //     width: 200,
//             //     child: ElevatedButton.icon(
                  
//             //       onPressed: () {},
//             //       style: ButtonStyle(
//             //           shape: MaterialStateProperty.all<RoundedRectangleBorder>(
//             //               RoundedRectangleBorder(
//             //                   borderRadius: BorderRadius.circular(18.0),
//             //                   side: const BorderSide(color: Colors.grey))),backgroundColor: MaterialStateProperty.all(Color.fromARGB(255, 255, 78, 65))
//             //                   ),
//             //       icon: Icon(Icons.local_shipping_outlined, size: 28),
//             //       label: Text("Courier"),
                  
//             //     ),
//             //   ),
//             // ),
//           ],
//         ));
//   }
// }
