import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Current user stream
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Sign up
  Future<User?> signUp(String email, String password) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      return credential.user;
    } catch (e) {
      print(e);
    }
    return null;
  }

  // Login in
  Future<User?> logIn(String email, String password) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      return credential.user;
    } catch (e) {
      print(e);
    }
    return null;
  }

  // Log out
  Future<void> logOut() => _auth.signOut();
}
