import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthRepository {
  Future<void> signUp(String email, String password);
  Future<UserCredential> signIn(String email, String password);
}
