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
  final _formKey = GlobalKey<FormState>();

  String _loginEmail = '';
  String _loginPassword = '';
  String _signupEmail = '';
  String _signupPassword = '';
  String _newEmail = '';
  String _newPassword = '';

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
    return FutureBuilder(
      future: _getUserProfile(),
      builder: (context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          final profile = snapshot.data!;
          final avatarUrl = profile['avatar'] as String?;
          final completedAdventures = (profile['adventure_completion'] as List<dynamic>?) ?? [];

          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              CircleAvatar(
                backgroundImage: avatarUrl == null || avatarUrl.isEmpty
                    ? null
                    : NetworkImage(avatarUrl),
                radius: 50,
                child: avatarUrl == null || avatarUrl.isEmpty
                    ? const FlutterLogo(size: 50)
                    : null,
              ),
              const SizedBox(height: 20),
              Text('Email: ${SupabaseManager.currentUser()!.email}'),
              const SizedBox(height: 20),
              ...completedAdventures.map((adventure) {
                final adventureId = adventure['adventure_id'];
                final completionDate =
                    DateTime.parse(adventure['completion_date']).toLocal();
                return ListTile(
                  title: Text('Adventure ID: $adventureId'),
                  subtitle: Text('Completion Date: $completionDate'),
                );
              }).toList(),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.blue,
                ),
                onPressed: SupabaseManager.signOut,
                child: const Text('Se déconnecter'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.blue,
                ),
                onPressed: () => _showEditProfileBottomSheet(context),
                child: const Text('Modifier les informations'),
              ),
            ],
          );
        }
      },
    );
  }

  Future<Map<String, dynamic>> _getUserProfile() async {
    final response = await SupabaseManager.client
        .from('profiles')
        .select('avatar_url, adventure_completion')
        .eq('id', SupabaseManager.currentUser()!.id)
        .single();

    if (response.isEmpty) {
      throw Error();
    }

    return Map<String, dynamic>.fromEntries(response.entries);
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
                value!.isEmpty ? 'Veuillez entrer votre email' : null,
            labelText: 'Email',
          ),
          const SizedBox(height: 10),
          _buildTextFormField(
            onChanged: (value) => _loginPassword = value,
            validator: (value) =>
                value!.isEmpty ? 'Veuillez entrer votre mot de passe' : null,
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
            label: 'Se connecter',
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
                value!.isEmpty ? 'Veuillez entrer votre email' : null,
            labelText: 'Email',
          ),
          const SizedBox(height: 10),
          _buildTextFormField(
            onChanged: (value) => _signupPassword = value,
            validator: (value) =>
                value!.isEmpty ? 'Veuillez entrer un mot de passe' : null,
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
            label: 'S\'inscrire',
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
        SnackBar(content: Text('Email envoyé à $_signupEmail')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $error')),
      );
    }
  }

  void _showEditProfileBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextFormField(
                    initialValue: SupabaseManager.currentUser()!.email,
                    decoration: const InputDecoration(labelText: 'Email'),
                    onChanged: (value) => _newEmail = value,
                    validator: (value) =>
                        value!.isEmpty ? 'Please enter your email' : null,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Password'),
                    onChanged: (value) => _newPassword = value,
                    validator: (value) =>
                        value!.isEmpty ? 'Please enter your password' : null,
                    obscureText: true,
                  ),
                  ElevatedButton(
                    onPressed: _updateProfile,
                    child: const Text('Update Profile'),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  //TODO - don't really work
  void _updateProfile() {
    if (_formKey.currentState!.validate()) {
      SupabaseManager.client.auth.updateUser(
        UserAttributes(
          email: _newEmail,
          password: _newPassword,
        ),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profil mis à jour...')),
      );

      setState(() {});

      Navigator.pop(context);
    }
  }
}
