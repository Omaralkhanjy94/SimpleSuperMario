import 'package:flutter/material.dart';

class Box extends StatelessWidget {
  final size;

  Box(this.size);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      child: Image.asset("lib/images/box.png"),
    );
  }
}
