import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_time_chat/app/controllers/auth_controller.dart';
import 'package:real_time_chat/app/services/auth_service.dart';
import 'package:real_time_chat/app/utils/helpers/getItHook/getit_hook.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends GetItHookState<AuthController, LoginScreen> {
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _auth = AuthService();
  bool _isLoading = false;

  @override
  initState() {
    super.initState();
    _emailCtrl.text = '';
    _passCtrl.text = '';

    // if debug mode
    if (kDebugMode) {
      _emailCtrl.text = 'test@example.com';
      _passCtrl.text = 'Text@123';
    }
  }

  Future<void> _handleLogin() async {
    setState(() => _isLoading = true);

    var user = await _auth.logIn(_emailCtrl.text, _passCtrl.text);
    user ??= await _auth.signUp(_emailCtrl.text, _passCtrl.text);

    setState(() => _isLoading = false);

    if (user != null) {
      Get.toNamed('/home');
    } else {
      ShadToaster(
        child: ShadToast.destructive(title: Text('Login Failed'), description: Text('Invalid credentials. Please try again.')),
      );
      // ShadToaster.of(context).show(const ShadToast.destructive(title: Text('Login Failed'), description: Text('Invalid credentials. Please try again.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ShadCard(
          width: MediaQuery.of(context).size.width * .8,
          title: const Text('Welcome Back'),
          description: const Text('Enter your credentials to login or sign up.'),
          child: Padding(
            padding: const .only(top: 16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Email Field
                ShadInputFormField(controller: _emailCtrl, label: const Text('Email'), placeholder: const Text('you@example.com'), keyboardType: TextInputType.emailAddress),

                const SizedBox(height: 12),

                // Password Field
                ShadInputFormField(controller: _passCtrl, label: const Text('Password'), placeholder: const Text('••••••••'), obscureText: true),

                const SizedBox(height: 24),

                // Login Button
                ShadButton(
                  onPressed: _isLoading ? null : _handleLogin,
                  child: _isLoading ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)) : const Text('Login / Sign Up'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  bool get autoDispose => true;
}
