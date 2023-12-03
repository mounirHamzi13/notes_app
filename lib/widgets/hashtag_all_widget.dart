import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notes_app_ui/widgets/text_horizontal_line.dart';

import 'categorie_notes_list.dart';
import 'notes_card_list.dart';

class HashtagAllWidget extends StatelessWidget {
  const HashtagAllWidget({Key? key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
          .collection('categories')
          .where('userID', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance
              .collection('notes')
              .where('userID',
                  isEqualTo: FirebaseAuth.instance.currentUser!.uid)
              .snapshots(),
          builder: (context, notesSnapshot) {
            print(notesSnapshot.data!.docs); 
            if (!notesSnapshot.hasData ||
                notesSnapshot.data == null ||
                notesSnapshot.data!.docs.isEmpty) {
              return const Center(
                child: Text("No notes"),
              );
            }

            return ListView.builder(
              itemCount: snapshot.data?.docs.length,
              itemBuilder: (context, index) {
                final categoryData = snapshot.data;
                if (categoryData != null &&
                    categoryData.docs.isNotEmpty &&
                    categoryData.docs.length > index) {
                  final category = categoryData.docs[index]['name'];
                  return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    stream: FirebaseFirestore.instance
                        .collection('notes')
                        .where('category', isEqualTo: category)
                        .where('userID',
                            isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                        .snapshots(),
                    builder: (context, categorynoteSnapshot) {
                      if (categorynoteSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      if (categorynoteSnapshot.hasData &&
                          categorynoteSnapshot.data != null &&
                          categorynoteSnapshot.data!.docs.isNotEmpty) {
                        return CategorieNotesList(category: category);
                      } else {
                        // Return an empty container or another widget for categories with no notes.
                        return Container();
                      }
                    },
                  );
                } else {
                  return Container();
                }
              },
            );
          },
        );
      },
    );
  }
}
