import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient _sb = Supabase.instance.client;

  Future<void> signIn(String email, String password) async {
    await _sb.auth.signInWithPassword(email: email, password: password);
  }

  Future<void> signUp(String email, String password) async {
    await _sb.auth.signUp(email: email, password: password);
  }

  Future<void> signOut() async {
    await _sb.auth.signOut();
  }

  Future<void> resetPassword(String email) async {
    await _sb.auth.resetPasswordForEmail(email);
  }

  User? get currentUser => _sb.auth.currentUser;
  Session? get currentSession => _sb.auth.currentSession;
}
