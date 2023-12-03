import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

mixin class Harmonise {

  Color generateRandomColor() {
  final Random random = Random();
  Color color;

  do {
    final int red = random.nextInt(256); // 0 to 255
    final int green = random.nextInt(256); // 0 to 255
    final int blue = random.nextInt(256); // 0 to 255
    color = Color.fromARGB(255, red, green, blue);
  } while (calculateBrightness(color) < 100);

  return color;
}

double calculateBrightness(Color color) {
  return (0.299 * color.red + 0.587 * color.green + 0.114 * color.blue);
}


// Color generateRandomColor() {
//   final Random random = Random();
//   final int red = random.nextInt(256); // 0 to 255
//   final int green = random.nextInt(256); // 0 to 255
//   final int blue = random.nextInt(256); // 0 to 255

//   return Color.fromARGB(255, red, green, blue);
// }


}



