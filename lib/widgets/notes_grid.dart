// ignore_for_file: unused_import

import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:notes_app_ui/mixins/harmonized_colors.dart';

import 'notes_card.dart';

class NotesGrid extends StatelessWidget with Harmonise {
  final category;
  NotesGrid({
    super.key,
    required this.category,
  });
  @override
  Widget build(BuildContext context) {
    print("////////////////////////////////////////////////////////////////");
    // 844---> 1
    // 250---> x
    // x = 0.2962
    //
    print(MediaQuery.sizeOf(context).height);
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection('/notes')
            .where('category', isEqualTo: category)
            .where('userID',isEqualTo: FirebaseAuth.instance.currentUser!.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text('No notes in this category'),
            );
          }
          return GridView.builder(
              padding: const EdgeInsets.only(top: 30, bottom: 20),
              itemCount: /* snapshot.data!.docs.length */
                  snapshot.data!.docs.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                mainAxisExtent: 0.2962 * MediaQuery.sizeOf(context).height,
                crossAxisCount: 2, // Number of columns in the grid
                mainAxisSpacing: 10.0, // Spacing between items vertically
                crossAxisSpacing: 17.0, // Spacing between items horizontally
              ),
              itemBuilder: (BuildContext context, int index) {
                if (index.isEven) {
                  return Transform.translate(
                    offset: const Offset(15, -5),
                    child: Transform.rotate(
                        angle: -45 / 360,
                        child: NoteCard(
                            title: snapshot.data!.docs[index]['title'],
                            content: snapshot.data!.docs[index]['content'],
                            createdAt: snapshot.data!.docs[index]['createdAt'],
                            id: snapshot.data!.docs[index].id,
                            category: snapshot.data!.docs[index]['category'],
                            color: generateRandomColor())),
                  );
                } else {
                  return Transform.translate(
                    offset: const Offset(-15, 5),
                    child: Transform.rotate(
                        angle: -45 / 360,
                        child: NoteCard(
                          title: snapshot.data!.docs[index]['title'],
                          content: snapshot.data!.docs[index]['content'],
                          createdAt: snapshot.data!.docs[index]['createdAt'],
                          id: snapshot.data!.docs[index].id,
                          category: snapshot.data!.docs[index]['category'],
                          color: generateRandomColor(),
                        )
                        //  GridTile(
                        //   child: Container(
                        //     color: Colors.blueAccent,
                        //     child: Center(
                        //       child: Text(
                        //         'Item $index',
                        //         style: TextStyle(color: Colors.white),
                        //       ),
                        //     ),
                        //   ),
                        // ),
                        ),
                  );
                }
              });
        });
  }
}
