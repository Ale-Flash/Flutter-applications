import 'package:flutter/material.dart';

class ColoredContainer extends StatefulWidget {
  final double size, padding;
  final Color color;
  const ColoredContainer(
      {super.key,
      required this.size,
      required this.padding,
      required this.color});

  @override
  State<ColoredContainer> createState() => _ColoredContainerState();
}

class _ColoredContainerState extends State<ColoredContainer> {
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
