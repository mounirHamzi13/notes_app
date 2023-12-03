// ignore_for_file: unused_import

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:notes_app_ui/mixins/harmonized_colors.dart';
import 'package:notes_app_ui/widgets/notes_card.dart';
import 'package:notes_app_ui/widgets/notes_card_list.dart';
import 'package:notes_app_ui/widgets/text_horizontal_line.dart';

class CategorieNotesList extends StatelessWidget with Harmonise {
  final category;
  const CategorieNotesList({
    super.key,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextHorizontalLine(text: category),
        const SizedBox(
          height: 20,
        ),
        Container(
          margin: const EdgeInsets.only(bottom: 10),
          height: 270,
          child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: FirebaseFirestore.instance
                  .collection('notes')
                  .where('userID',
                      isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                  .where('category', isEqualTo: category)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                print(FirebaseAuth.instance.currentUser!.uid);
                return ListView.builder(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    return Transform.translate(
                      offset: Offset(-index * 8, 0),
                      child: Transform.rotate(
                          angle: -45 / 360,
                          child: NoteCard(
                              title: snapshot.data!.docs[index]['title'],
                              content: snapshot.data!.docs[index]['content'],
                              createdAt: snapshot.data!.docs[index]
                                  ['createdAt'],
                              id: snapshot.data!.docs[index].id,
                              category: snapshot.data!.docs[index]['category'],
                              color: generateRandomColor())),
                    );
                  },
                );
              }),
        )
      ],
    );
  }
}
