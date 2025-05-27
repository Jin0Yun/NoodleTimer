import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthRepository {
  Future<UserCredential> signUp(String email, String password);
  Future<UserCredential> signIn(String email, String password);
  Future<void> signOut();
  Future<void> deleteAccount();
  Future<void> reauthenticateWithPassword(String password);
  Future<void> deleteAccountWithReauth(String password);
}