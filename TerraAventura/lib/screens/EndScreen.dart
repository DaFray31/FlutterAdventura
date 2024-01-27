import 'package:flutter/material.dart';

import '../home/homepage.dart';

class EndScreen extends StatelessWidget {
  final int adventureId;

  const EndScreen({Key? key, required this.adventureId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopScope(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Fin de l\'aventure'),
          automaticallyImplyLeading: false, // Removes the back button in the AppBar
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'Félicitations!',
                style: TextStyle(fontSize: 24),
              ),
              const SizedBox(height: 16),
              const Text(
                'Vous avez terminé l\'aventure.',
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => HomePage()), // Replace HomePage() with your actual home page widget
                    (Route<dynamic> route) => false,
                  );
                },
                child: const Text('Retour à la page d\'accueil'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}