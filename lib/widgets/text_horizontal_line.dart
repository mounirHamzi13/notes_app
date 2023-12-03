import 'package:flutter/material.dart';

// ignore: must_be_immutable
class TextHorizontalLine extends StatelessWidget {
  String text;
  TextHorizontalLine({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 15),
          child: Text(
            text,
            style: Theme.of(context)
                .textTheme
                .bodyMedium!
                .copyWith(color: Colors.black),
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        Container(
          margin: const EdgeInsets.only(left: 20, right: 20),
          height: 1,
          width: double.infinity,
          color: Colors.black,
        ),
      ],
    );
  }
}
