import 'package:pocketbase/pocketbase.dart';

class AuthService {
  final PocketBase pb = PocketBase('http://127.0.0.1:8090/');

  Future<void> register(String email, String password) async {
    await pb.collection('users').create(body: {
      'email': email,
      'password': password,
      'passwordConfirm': password,
    });
  }

  Future<void> login(String email, String password) async {
    await pb.collection('users').authWithPassword(email, password);
  }

  Future<void> logout() async {
    pb.authStore.clear();
  }

  bool isAdmin() {
    final user = pb.authStore.model;
    return user != null && user.getStringValue('role') == 'admin';
  }
}