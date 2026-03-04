import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

@lazySingleton
class AuthService {
  final _client = Supabase.instance.client;

  // Current user
  User? get currentUser => _client.auth.currentUser;

  // Auth state stream
  Stream<AuthState> get authStateChanges => _client.auth.onAuthStateChange;

  // Sign up
  Future<User?> signUp(String email, String password) async {
    try {
      final res = await _client.auth.signUp(email: email, password: password);
      return res.user;
    } on AuthException catch (e) {
      print('SignUp error: ${e.message}');
      return null;
    } catch (e) {
      print('SignUp error: $e');
      return null;
    }
  }

  // Log in
  Future<User?> logIn(String email, String password) async {
    try {
      final res = await _client.auth.signInWithPassword(email: email, password: password);
      return res.user;
    } on AuthException catch (e) {
      print('Login error: ${e.message}');
      return null;
    } catch (e) {
      print('Login error: $e');
      return null;
    }
  }

  // Log out
  Future<void> logOut() async {
    await _client.auth.signOut();
  }

  // Get user profile
  Future<Map<String, dynamic>?> getProfile(String uid) async {
    try {
      final data = await _client.from('profiles').select().eq('id', uid).single();
      return data;
    } catch (e) {
      print('Get profile error: $e');
      return null;
    }
  }

  // Update display name
  Future<void> updateDisplayName(String name) async {
    final uid = currentUser?.id;
    if (uid == null) return;
    await _client.from('profiles').update({'display_name': name}).eq('id', uid);
  }
}
