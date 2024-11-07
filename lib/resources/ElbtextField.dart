import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ElbTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final Color? labelColor;
  final bool fill;
  final Color fillColor;
  final Color inputColor;
  final Color hintColor;
  final String labelText;
  final String? semanticsLabel;
  final int maxLines;
  final bool obscureText;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final String? Function(String?)? customValidator;
  final bool visible;
  final bool enabled;
  final bool enableInteractiveSelection;
  final TextInputType keyboardType;
  final FocusNode? focusNode;
  final List<TextInputFormatter> inputFormatters;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;

  const ElbTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.labelText,
    this.semanticsLabel,
    this.maxLines = 2,
    this.obscureText = false,
    this.suffixIcon,
    this.customValidator,
    this.visible = true,
    this.enabled = true,
    this.onChanged,
    this.keyboardType = TextInputType.text,
    this.focusNode,
    this.enableInteractiveSelection = true,
    this.inputFormatters = const [],
    this.prefixIcon,
    this.labelColor,
    this.hintColor = Colors.grey,
    this.fill = false,
    this.fillColor = Colors.white,
    this.inputColor = Colors.black,
    this.onSubmitted,
  });

  @override
  State<ElbTextField> createState() => _ElbTextFieldState();
}

class _ElbTextFieldState extends State<ElbTextField> {
  FocusNode focusNode = FocusNode();
  Color labelColor = Colors.grey;
  String? errorText;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();

    focusNode.addListener(() {
      if (!focusNode.hasFocus) {
        setState(() {
          errorText = widget.customValidator?.call(widget.controller.text);
        });
      }
    });
  }

  @override
  void dispose() {
    focusNode.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: widget.visible,
      child: Focus(
        onFocusChange: (hasFocus) {
          setState(() {
            labelColor = hasFocus ? Colors.blue : Colors.grey;
            if (!hasFocus) {
              _debounce?.cancel();
              errorText = widget.customValidator?.call(widget.controller.text);
            }
          });
        },
        child: TextFormField(
          focusNode: focusNode,
          enableInteractiveSelection: widget.enableInteractiveSelection,
          keyboardType: widget.keyboardType,
          onChanged: (text) {
            setState(() {
              errorText = null;
            });
            if (_debounce?.isActive ?? false) _debounce?.cancel();
            _debounce = Timer(const Duration(milliseconds: 2500), () {
              setState(() {
                errorText = widget.customValidator?.call(text);
              });
            });

            widget.onChanged?.call(text);
          },
          enabled: widget.enabled,
          controller: widget.controller,
          obscureText: widget.obscureText,
          onFieldSubmitted: widget.onSubmitted,
          autovalidateMode: AutovalidateMode.disabled,
          decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: TextStyle(
              color: widget.hintColor,
              fontWeight: FontWeight.normal,
              fontSize: 15,
            ),
            labelText: widget.labelText,
            labelStyle: TextStyle(
              color: widget.labelColor ?? labelColor,
              fontSize: 15,
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 15, vertical: 17),
            filled: widget.fill,
            fillColor: widget.fillColor,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: Color.fromARGB(255, 234, 242, 250),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: Color.fromARGB(255, 218, 234, 254),
                width: 1.5,
              ),
            ),
            suffixIcon: widget.suffixIcon,
            prefixIcon: widget.prefixIcon,
            semanticCounterText: widget.semanticsLabel,
            errorMaxLines: 5,
            errorText: errorText,
          ),
          inputFormatters: widget.inputFormatters,
          style: TextStyle(color: widget.inputColor),
          validator: widget.customValidator ??
              (val) {
                if (val == null || val.isEmpty) {
                  return 'Please ${widget.hintText}';
                }
                return null;
              },
        ),
      ),
    );
  }
}
