import 'package:flutter/material.dart';

import 'package:terraaventura/screens/place_page.dart';

class BeforeAdventureScreen extends StatelessWidget {
  final dynamic monumentData;

  const BeforeAdventureScreen({Key? key, required this.monumentData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Fiche monument"),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 450,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('images/back1.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    monumentData['nom'].toString(),
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Difficulté : ${() {
                      String niv =
                          monumentData['niveau'].toString().split(" ")[0];
                      return (niv == "3") ? "Difficile" : (niv == "2") ? "Moyen" : "Facile";
                    }()}',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Description',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(monumentData['commentaires'].toString()),
                  const SizedBox(height: 10),
                  const Text(
                    'Conseils',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    monumentData['conseils'].toString(),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => PlacePage(monumentData: monumentData)),
                      );
                    },
                    child: const Text('Commencer la Chasse'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
