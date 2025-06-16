import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FormInputField extends ConsumerWidget {
  final TextEditingController textController;
  final String hintText;
  final bool obscureText;
  final Icon? prefixIcon;
  final Icon? suffixIcon;
  final Function()? onSuffixIconTap;

  const FormInputField({
    super.key,
    required this.textController,
    required this.obscureText,
    required this.hintText,
    this.onSuffixIconTap,
    this.prefixIcon,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: TextField(
        controller: textController,
        obscureText: obscureText,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: const BorderSide(color: Colors.green),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              width: 2.0,
              color: Colors.green,
            ),
            borderRadius: BorderRadius.circular(8.0),
          ),
          fillColor: Colors.white,
          filled: true,
          hintText: hintText,
          hintStyle: const TextStyle(
            color: Color.fromARGB(255, 26, 25, 25),
          ),
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon != null
              ? InkWell(
                  onTap: onSuffixIconTap,
                  child: suffixIcon,
                )
              : null,
        ),
        cursorColor: Colors.green,
        style: const TextStyle(
          color: Colors.black,
        ),
      ),
    );
  }
}
