import 'package:flutter/material.dart';
import 'package:terraaventura/functions/supabase_client.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  TrainingPageState createState() => TrainingPageState();
}

class TrainingPageState extends State<ProfileScreen> {
  String _loginEmail = '';
  String _loginPassword = '';
  String _signupEmail = '';
  String _signupPassword = '';

  final _loginFormKey = GlobalKey<FormState>();
  final _signupFormKey = GlobalKey<FormState>();

  Widget _buildLoginForm() {
    return Form(
      key: _loginFormKey,
      child: Column(
        children: <Widget>[
          TextFormField(
            onChanged: (value) => _loginEmail = value,
            validator: (value) => value!.isEmpty ? 'Please enter your email' : null,
            decoration: const InputDecoration(labelText: 'Email'),
          ),
          const SizedBox(height: 10),
          TextFormField(
            onChanged: (value) => _loginPassword = value,
            validator: (value) => value!.isEmpty ? 'Please enter your password' : null,
            decoration: const InputDecoration(labelText: 'Password'),
            obscureText: true,
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white, backgroundColor: Colors.blue, // text color
            ),
            onPressed: () {
              if (_loginFormKey.currentState!.validate()) {
                SupabaseManager.signIn(_loginEmail, _loginPassword);
              }
            },
            child: const Text('Login'),
          ),
        ],
      ),
    );
  }

  Widget _buildSignupForm() {
    return Form(
      key: _signupFormKey,
      child: Column(
        children: <Widget>[
          TextFormField(
            onChanged: (value) => _signupEmail = value,
            validator: (value) => value!.isEmpty ? 'Please enter your email' : null,
            decoration: const InputDecoration(labelText: 'Email'),
          ),
          const SizedBox(height: 10),
          TextFormField(
            onChanged: (value) => _signupPassword = value,
            validator: (value) => value!.isEmpty ? 'Please enter your password' : null,
            decoration: const InputDecoration(labelText: 'Password'),
            obscureText: true,
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white, backgroundColor: Colors.blue, // text color
            ),
            onPressed: () {
              if (_signupFormKey.currentState!.validate()) {
                SupabaseManager.signUp(_signupEmail, _signupPassword);
              }
            },
            child: const Text('Sign Up'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mon Profil'),
      ),
      body: SupabaseManager.currentUser() != null
          ? SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  Text('Email: ${SupabaseManager.currentUser()!.email}'),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white, backgroundColor: Colors.blue, // text color
                    ),
                    onPressed: () {
                      SupabaseManager.signOut();
                    },
                    child: const Text('Sign Out'),
                  ),
                ],
              ),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _buildLoginForm(),
                    const SizedBox(height: 20),
                    _buildSignupForm(),
                  ],
                ),
              ),
            ),
    );
  }
}