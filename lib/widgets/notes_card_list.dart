// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';

// import 'notes_card.dart';

// class NotesHorizontalList extends StatelessWidget {
//   const NotesHorizontalList({
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       padding: const EdgeInsets.symmetric(
//           vertical: 20, horizontal: 20),
//       scrollDirection: Axis.horizontal,
//       child: ListView.builder(
//         // mainAxisAlignment: MainAxisAlignment.spaceAround,
//         itemBuilder: ( (context, index) {
//           return NoteCard(
//             title: 'title',
//             createdAt: Timestamp.now(),
//             content: 'content',
//             color: Colors.pink) ;
//         })
//           // NoteCard(
//           //   color: const Color.fromRGBO(207, 175, 248, 1),
//           // ),
//           // Transform.translate( 
//           //   offset: Offset(-10,0),
//           //   child: NoteCard(
//           //     color: const Color.fromRGBO(163, 254, 148, 1),
//           //   ),
//           // ),
//           // Transform.translate( 
//           //   offset: Offset(-20,0),
//           //   child: NoteCard(
//           //     color: const Color.fromRGBO(181, 222, 244, 1),
//           //   ),
//           // ),
        
//       ),
//     );
//   }
// }
