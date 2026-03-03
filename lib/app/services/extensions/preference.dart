import 'package:shared_preferences/shared_preferences.dart';

extension Preference on SharedPreferences {
  // Token
  Future<void> setToken(String token) async {
    await this.setString('token', token);
  }

  Future<String> getToken() async {
    return this.getString('token') ?? '';
  }

  // 

  // Remove All
  Future<void> removeAll() async {
    await clear();
  }
}
