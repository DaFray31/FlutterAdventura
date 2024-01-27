import 'package:flutter/material.dart';
import 'package:terraaventura/screens/dialog_screen.dart';

class AdventureCard extends StatelessWidget {
  final dynamic adventure;

  const AdventureCard({Key? key, required this.adventure}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final adventureMap = adventure[0];

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AdventureLaunchScreen(
              adventureId: adventureMap['id'],
            ),
          ),
        );
      },
      child: Card(
        child: ListTile(
          leading: const Icon(Icons.place_outlined),
          title: Text(adventureMap['titre']),
          subtitle: Text(adventureMap['description']),
        ),
      ),
    );
  }
}