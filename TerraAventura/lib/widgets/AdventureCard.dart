import 'package:flutter/material.dart';
import 'package:terraaventura/screens/adventureScreen.dart';

import '../screens/place_page.dart';

class AdventureCard extends StatelessWidget {
  final dynamic adventure;
  final dynamic monumentData;

  const AdventureCard({Key? key, required this.adventure, this.monumentData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final adventureMap = adventure[0];
    final monumentDataMap = monumentData;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => PlacePage(
                  monumentData: monumentDataMap, adventure: adventureMap)),
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
