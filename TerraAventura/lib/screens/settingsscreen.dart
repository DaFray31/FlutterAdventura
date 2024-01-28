import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Paramètres')),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Code source de l\'application :'),
            TextButton(
              onPressed: _launchURL,
              child: Text(
                'https://github.com/DaFray31/FlutterAdventura',
                style: TextStyle(color: Colors.blue),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _launchURL() async =>
      await canLaunch('https://github.com/DaFray31/FlutterAdventura')
          ? await launch('https://github.com/DaFray31/FlutterAdventura')
          : throw 'Could not launch https://github.com/DaFray31/FlutterAdventura';
}