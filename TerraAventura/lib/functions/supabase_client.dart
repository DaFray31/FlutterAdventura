import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static final SupabaseClient supabase = SupabaseClient(
    'https://kdiowwslccpwbzhccjaj.supabase.co',
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImtkaW93d3NsY2Nwd2J6aGNjamFqIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MDMyMzQ2MTMsImV4cCI6MjAxODgxMDYxM30.lHDaL3MYtfNsH5Oop32FfRlkSOhfGoDd34vl0b-4PWA',
  );
}