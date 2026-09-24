import 'package:flutter/material.dart';

import '../localization/app_strings.dart';
import '../services/api_exceptions.dart';
import '../services/auth_api_service.dart';
import '../services/auth_storage.dart';
import '../state/nyaya_tabs.dart';
import '../theme/app_colors.dart';

/// The NYAYA backend's `/categories` endpoint requires a signed-in user
/// (see openAPI_schema.yaml + the backend's `authenticate` middleware).
/// This screen is that real sign-in/sign-up flow — the user's own
/// credentials, nothing generated on their behalf. Pops with `true` once a
/// session has been established.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authApi = AuthApiService();
  final _authStorage = AuthStorage();

  bool _isRegistering = false;
  bool _isSubmitting = false;
  String? _errorMessage;

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _isSubmitting = true;
      _errorMessage = null;
    });
    try {
      final tokens = _isRegistering
          ? await _authApi.register(
              fullName: _fullNameController.text.trim(),
              email: _emailController.text.trim(),
              password: _passwordController.text,
            )
          : await _authApi.login(
              email: _emailController.text.trim(),
              password: _passwordController.text,
            );
      await _authStorage.saveTokens(tokens);
      if (mounted) Navigator.of(context).pop(true);
    } on ApiException catch (e) {
      setState(() => _errorMessage = e.message);
    } on NetworkException catch (e) {
      setState(() => _errorMessage = e.message);
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(_isRegistering ? tr('title_create_account') : tr('title_sign_in')),
      ),
      bottomNavigationBar: const GlobalBottomNav(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  _isRegistering ? tr('login_heading_register') : tr('login_heading_signin'),
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                ),
                const SizedBox(height: 5),
                Text(
                  tr('login_description'),
                  style: const TextStyle(fontSize: 12.5, color: AppColors.textSecondary, height: 1.4),
                ),
                const SizedBox(height: 24),
                if (_isRegistering) ...[
                  TextFormField(
                    controller: _fullNameController,
                    decoration: InputDecoration(labelText: tr('label_full_name')),
                    validator: (v) => (v == null || v.trim().isEmpty) ? tr('validation_required') : null,
                  ),
                  const SizedBox(height: 14),
                ],
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(labelText: tr('label_email')),
                  validator: (v) => (v == null || !v.contains('@')) ? tr('validation_email') : null,
                ),
                const SizedBox(height: 14),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(labelText: tr('label_password')),
                  validator: (v) => (v == null || v.length < 8) ? tr('validation_password') : null,
                ),
                if (_errorMessage != null) ...[
                  const SizedBox(height: 12),
                  Text(_errorMessage!, style: const TextStyle(color: AppColors.soonRed, fontSize: 12.5)),
                ],
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _isSubmitting ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 52),
                  ),
                  child: _isSubmitting
                      ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                      : Text(_isRegistering ? tr('button_create_account') : tr('button_sign_in')),
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: _isSubmitting ? null : () => setState(() => _isRegistering = !_isRegistering),
                  child: Text(
                    _isRegistering ? tr('link_have_account') : tr('link_no_account'),
                    style: const TextStyle(color: AppColors.gold, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
