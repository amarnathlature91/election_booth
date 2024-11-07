import 'package:flutter/material.dart';

import 'app_colors.dart';

class ElbButton extends StatefulWidget {
  final String text;
  final Color backgroundColor;
  final bool isLoading;
  final Function onPressed;
  final double height;
  final double width;

  const ElbButton(
      {super.key,
      required this.text,
      this.backgroundColor = AppColors.globalButtonColor,
      required this.isLoading,
      required this.onPressed,
      this.height = 50,
      this.width = double.infinity});

  @override
  State<ElbButton> createState() => _ElbButtonState();
}

class _ElbButtonState extends State<ElbButton> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        widget.onPressed.call();
      },
      child: Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
              color: widget.backgroundColor,
              borderRadius: BorderRadius.circular(8)),
          child: Center(
              child: widget.isLoading
                  ? Transform.scale(
                      scale: 0.8,
                      child: const CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    )
                  : Text(
                      widget.text,
                      style: const TextStyle(color: Colors.white, fontSize: 17),
                    ))),
    );
  }
}
