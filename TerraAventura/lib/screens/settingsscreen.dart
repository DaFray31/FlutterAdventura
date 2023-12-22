import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Paramètres')),
      ),
      body: const Center(
        child: Text('Contenu des paramètres ici.'),
      ),
    );
  }
}
