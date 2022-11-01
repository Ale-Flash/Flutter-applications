import 'package:flutter/material.dart';

class TryButton extends StatefulWidget {
  final void Function() function;
  final double size, padding;
  final Color color;
  const TryButton(
      {super.key,
      required this.function,
      required this.size,
      required this.padding,
      required this.color});

  @override
  State<TryButton> createState() => _TryButtonState();
}

class _TryButtonState extends State<TryButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(widget.padding),
        width: widget.size,
        height: widget.size,
        child: ElevatedButton(
          onPressed: () => widget.function(),
          style: ButtonStyle(
              backgroundColor: MaterialStatePropertyAll<Color>(widget.color),
              shape: MaterialStateProperty.all(const CircleBorder())),
          child: const SizedBox(),
        ));
  }
}
