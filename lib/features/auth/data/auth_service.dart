import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<UserCredential> login({
    required String email,
    required String password,
  }) async {
    return await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<String?> getToken() async {
    return await _auth.currentUser?.getIdToken();
  }

  Future<void> logout() async {
    await _auth.signOut();
  }
}