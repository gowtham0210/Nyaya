import 'package:flutter/material.dart';

/// Shows [message] in a snackbar, replacing any current one.
void showMessage(BuildContext context, String message) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(message)));
}
