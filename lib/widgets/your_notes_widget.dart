// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:notes_app_ui/screens/write_notes_screen.dart';

class YourNotesWidget extends StatelessWidget {
  const YourNotesWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Your Notes',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            InkWell( 
              onTap: () => Navigator.of(context).pushNamed(WriteNoteScreen.routeName),
              child: Container(
                padding: const EdgeInsets.all(13),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 2),
                    borderRadius: BorderRadius.circular(12)),
                child: const Icon(
                  Icons.add,
                  size: 25,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
