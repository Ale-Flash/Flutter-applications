import 'package:flutter/material.dart';

class ColorContainer extends StatefulWidget {
  final double size, padding;
  final Color color;
  const ColorContainer(
      {super.key,
      required this.size,
      required this.padding,
      required this.color});

  @override
  State<ColorContainer> createState() => _ColorContainerState();
}

class _ColorContainerState extends State<ColorContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(widget.padding),
        width: widget.size,
        height: widget.size,
        child: Container(
          decoration:
              BoxDecoration(color: widget.color, shape: BoxShape.circle),
        ));
  }
}
