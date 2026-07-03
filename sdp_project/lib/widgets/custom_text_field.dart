import 'package:flutter/material.dart';
import '../core/theme.dart';

class CustomTextField extends StatefulWidget {
  final String hintText;
  final IconData prefixIcon;
  final bool isPassword;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final String? errorText;
  final TextDirection? textDirection;
  final ValueChanged<String>? onChanged;
  final bool readOnly;
  final bool enabled;

  const CustomTextField({
    super.key,
    required this.hintText,
    required this.prefixIcon,
    this.isPassword = false,
    this.controller,
    this.keyboardType,
    this.validator,
    this.errorText,
    this.textDirection,
    this.onChanged,
    this.readOnly = false,
    this.enabled = true,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: widget.isPassword ? _obscureText : false,
      keyboardType: widget.keyboardType,
      validator: widget.validator,
      onChanged: widget.onChanged,
      textDirection: widget.textDirection,
      readOnly: widget.readOnly,
      enabled: widget.enabled,
      style: TextStyle(
        color: Theme.of(context).textTheme.bodyLarge?.color,
        fontSize: 16,
      ),
      decoration: InputDecoration(
        hintText: widget.hintText,
        errorText: widget.errorText,
        prefixIcon: Icon(widget.prefixIcon, color: Theme.of(context).iconTheme.color?.withOpacity(0.5)),
        suffixIcon: widget.isPassword
            ? IconButton(
                icon: Icon(
                  _obscureText ? Icons.visibility_off : Icons.visibility,
                  color: Theme.of(context).iconTheme.color?.withOpacity(0.5),
                ),
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
              )
            : null,
        errorStyle: const TextStyle(
          color: AppTheme.errorColor,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
