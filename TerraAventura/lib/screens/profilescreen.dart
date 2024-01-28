import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:terraaventura/functions/supabase_client.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _loginFormKey = GlobalKey<FormState>();
  final _signupFormKey = GlobalKey<FormState>();

  String _loginEmail = '';
  String _loginPassword = '';
  String _signupEmail = '';
  String _signupPassword = '';

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AuthState>(
      stream: SupabaseManager.client.auth.onAuthStateChange,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasData && SupabaseManager.currentUser() != null) {
          return _buildProfileContent();
        } else {
          return _buildLoginFormAndSignUp();
        }
      },
    );
  }

  Widget _buildProfileContent() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          Text('Email: ${SupabaseManager.currentUser()!.email}'),
          const SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.blue,
            ),
            onPressed: () {
              SupabaseManager.signOut();
            },
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginFormAndSignUp() {
    return SingleChildScrollView(
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
    );
  }

  Widget _buildLoginForm() {
    return Form(
      key: _loginFormKey,
      child: Column(
        children: <Widget>[
          _buildTextFormField(
            onChanged: (value) => _loginEmail = value,
            validator: (value) =>
                value!.isEmpty ? 'Please enter your email' : null,
            labelText: 'Email',
          ),
          const SizedBox(height: 10),
          _buildTextFormField(
            onChanged: (value) => _loginPassword = value,
            validator: (value) =>
                value!.isEmpty ? 'Please enter your password' : null,
            labelText: 'Password',
            obscureText: true,
          ),
          const SizedBox(height: 10),
          _buildElevatedButton(
            onPressed: () async {
              if (_loginFormKey.currentState!.validate()) {
                _handleLogin();
              }
            },
            label: 'Login',
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
          _buildTextFormField(
            onChanged: (value) => _signupEmail = value,
            validator: (value) =>
                value!.isEmpty ? 'Please enter your email' : null,
            labelText: 'Email',
          ),
          const SizedBox(height: 10),
          _buildTextFormField(
            onChanged: (value) => _signupPassword = value,
            validator: (value) =>
                value!.isEmpty ? 'Please enter your password' : null,
            labelText: 'Password',
            obscureText: true,
          ),
          const SizedBox(height: 10),
          _buildElevatedButton(
            onPressed: () {
              if (_signupFormKey.currentState!.validate()) {
                _handleSignUp();
              }
            },
            label: 'Sign Up',
          ),
        ],
      ),
    );
  }

  Widget _buildTextFormField({
    required Function(String) onChanged,
    required String? Function(String?) validator,
    required String labelText,
    bool obscureText = false,
  }) {
    return TextFormField(
      onChanged: onChanged,
      validator: validator,
      decoration: InputDecoration(labelText: labelText),
      obscureText: obscureText,
    );
  }

  Widget _buildElevatedButton(
      {required VoidCallback onPressed, required String label}) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: Colors.blue,
      ),
      onPressed: onPressed,
      child: Text(label),
    );
  }

  void _handleLogin() async {
    String? error =
        (await SupabaseManager.signIn(_loginEmail, _loginPassword)) as String?;
    if (error != null) {
      setState(() {});
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $error')),
      );
    }
  }

  void _handleSignUp() async {
    String? error =
        (await SupabaseManager.signUp(_signupEmail, _signupPassword))
            as String?;
    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Email as been sent to $_signupEmail')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $error')),
      );
    }
  }
}
