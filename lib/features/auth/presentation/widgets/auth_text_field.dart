import 'package:flutter/material.dart';
import '../../../../core/presentation/widgets/nyaya_widgets.dart';

/// Shared labeled input field style for the login and sign-up cards:
/// bold navy label above a rounded, icon-prefixed field.
class AuthTextField extends StatelessWidget {
  const AuthTextField({
    super.key,
    required this.label,
    required this.hint,
    required this.icon,
    this.controller,
    this.obscureText = false,
    this.suffixIcon,
    this.prefixText,
    this.keyboardType,
    this.textCapitalization = TextCapitalization.none,
    this.textInputAction = TextInputAction.next,
    this.validator,
    this.readOnly = false,
    this.onTap,
    this.autofillHints,
  });

  final String label;
  final String hint;
  final IconData icon;
  final TextEditingController? controller;
  final bool obscureText;
  final Widget? suffixIcon;

  /// A short leading label (e.g. a country code) shown before the field
  /// content, replacing the plain [icon] prefix.
  final String? prefixText;
  final TextInputType? keyboardType;
  final TextCapitalization textCapitalization;
  final TextInputAction textInputAction;
  final String? Function(String?)? validator;
  final bool readOnly;
  final VoidCallback? onTap;
  final Iterable<String>? autofillHints;

  @override
  Widget build(BuildContext context) {
    const borderColor = Color(0xFFE7DFD5);
    const fillColor = Color(0xFFFFFCF8);
    const hintColor = Color(0xFF8A94A6);
    const errorColor = Color(0xFFB64A4A);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: navy,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          readOnly: readOnly,
          onTap: onTap,
          keyboardType: keyboardType,
          textCapitalization: textCapitalization,
          textInputAction: textInputAction,
          validator: validator,
          autofillHints: autofillHints?.toList(),
          cursorColor: navy,
          enableSuggestions: !obscureText,
          autocorrect: !obscureText,
          decoration: InputDecoration(
            filled: true,
            fillColor: fillColor,
            hintText: hint,
            hintStyle: const TextStyle(color: hintColor, fontSize: 14),
            prefixIcon: prefixText == null
                ? Icon(icon, size: 20, color: bodyGrey.withValues(alpha: 0.74))
                : _PrefixWithText(icon: icon, text: prefixText!),
            prefixIconConstraints: prefixText == null
                ? null
                : const BoxConstraints(minWidth: 0, minHeight: 0),
            suffixIcon: suffixIcon,
            errorMaxLines: 2,
            errorStyle: const TextStyle(
              color: errorColor,
              fontSize: 12,
              height: 1.3,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: borderColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: borderColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(
                color: gold.withValues(alpha: 0.85),
                width: 1.5,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: errorColor, width: 1.2),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: errorColor, width: 1.4),
            ),
          ),
        ),
      ],
    );
  }
}

class _PrefixWithText extends StatelessWidget {
  const _PrefixWithText({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 12, right: 8),
      child: IntrinsicWidth(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18, color: bodyGrey.withValues(alpha: 0.74)),
            const SizedBox(width: 6),
            Text(
              text,
              style: const TextStyle(
                fontSize: 14,
                color: navy,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 2),
            Icon(
              Icons.keyboard_arrow_down_rounded,
              size: 16,
              color: bodyGrey.withValues(alpha: 0.7),
            ),
            const SizedBox(width: 8),
            Container(width: 1, height: 20, color: const Color(0xFFE7DFD5)),
          ],
        ),
      ),
    );
  }
}
