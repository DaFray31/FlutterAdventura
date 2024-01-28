import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static final SupabaseClient supabase = SupabaseClient(
    'https://kdiowwslccpwbzhccjaj.supabase.co',
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImtkaW93d3NsY2Nwd2J6aGNjamFqIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MDMyMzQ2MTMsImV4cCI6MjAxODgxMDYxM30.lHDaL3MYtfNsH5Oop32FfRlkSOhfGoDd34vl0b-4PWA',
  ); //FIXME - already initialized in main.dart
}

class SupabaseManager {
  static final SupabaseClient client = Supabase.instance.client;

  static Future<User?> signUp(String email, String password) async {
    try {
      final response =
          await client.auth.signUp(email: email, password: password);
      return response.user;
    } catch (e) {
      print('Error signing up: $e');
      return null;
    }
  }

  static Future<User?> signIn(String email, String password) async {
    try{
      final response =
          await client.auth.signInWithPassword(email: email, password: password);
      return response.user;
    } catch (e) {
      print('Error signing in: $e');
      return null;
    }

  }

  static Future<void> signOut() async {
    await client.auth.signOut();
  }

  static User? currentUser() {
    return client.auth.currentUser;
  }
}
