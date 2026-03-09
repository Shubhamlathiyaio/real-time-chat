import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

import '../../../data/services/auth_service.dart';
import '../../../routes/app_routes.dart';
import '../../../utils/helpers/injectable/injectable.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _auth = getIt<AuthService>();
  bool _isLoading = false;
  String? _error;

  Future<void> _handleSubmit() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    // Try login first, then signup
    var user = await _auth.logIn(_emailCtrl.text.trim(), _passCtrl.text);
    user ??= await _auth.signUp(_emailCtrl.text.trim(), _passCtrl.text);

    setState(() => _isLoading = false);

    if (user != null) {
      Get.offAllNamed(AppRoutes.chat);
    } else {
      setState(() => _error = 'Invalid credentials. Please try again.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0F),
      body: Center(
        child: ShadCard(
          width: 380,
          title: const Text('Welcome'),
          description: const Text('Login or create a new account'),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ShadInputFormField(controller: _emailCtrl, label: const Text('Email'), placeholder: const Text('you@example.com'), keyboardType: TextInputType.emailAddress),
              const SizedBox(height: 12),
              ShadInputFormField(controller: _passCtrl, label: const Text('Password'), placeholder: const Text('••••••••'), obscureText: true),
              if (_error != null) ...[const SizedBox(height: 12), Text(_error!, style: const TextStyle(color: Color(0xFFEF4444), fontSize: 13))],
              const SizedBox(height: 20),
              ShadButton(
                onPressed: _isLoading ? null : _handleSubmit,
                width: double.infinity,
                child: _isLoading ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : const Text('Continue'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
