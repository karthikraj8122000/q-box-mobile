// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
//
// import '../../Utils/network_error_state.dart';
//
// class NetworkErrorWidget extends StatelessWidget {
//   final Widget child;
//
//   const NetworkErrorWidget({
//     Key? key,
//     required this.child,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Consumer<NetworkErrorState>(
//       builder: (context, networkState, _) {
//         if (networkState.connectionState == ConnectionState.offline) {
//           return Center(
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 const Icon(
//                   Icons.cloud_off,
//                   size: 48,
//                   color: Colors.grey,
//                 ),
//                 const SizedBox(height: 16),
//                 Text(
//                   networkState.errorMessage,
//                   textAlign: TextAlign.center,
//                   style: const TextStyle(
//                     fontSize: 16,
//                     color: Colors.grey,
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//                 ElevatedButton(
//                   onPressed: () {
//                     // Implement your retry logic here
//                   },
//                   child: const Text('Retry'),
//                 ),
//               ],
//             ),
//           );
//         }
//         return child;
//       },
//     );
//   }
// }