import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../features/auth/presentation/sign_in_page.dart';
import 'app_services.dart';
import 'app_session.dart';

/// Revokes the backend session and signs out of Firebase (both
/// best-effort), clears the local session, then returns to sign-in with a
/// fresh navigation stack. Shows [message] there when given.
Future<void> endSession(BuildContext context, {String? message}) async {
  final navigator = Navigator.of(context, rootNavigator: true);
  final messenger = ScaffoldMessenger.maybeOf(context);
  await AppServices.authRepository.logout();
  try {
    await FirebaseAuth.instance.signOut();
  } catch (_) {
    // Signing out locally must never be blocked by Firebase.
  }
  await AppSession.clear();
  navigator.pushAndRemoveUntil(
    MaterialPageRoute<void>(builder: (_) => const SignInPage()),
    (route) => false,
  );
  if (message != null && messenger != null) {
    // Wait for the sign-in page's Scaffold to exist before showing it.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      messenger
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(message)));
    });
  }
}
