import 'package:flutter/material.dart';

import 'package:terraaventura/screens/place_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Training App',
      home: BeforeAdventureScreen(),
    );
  }
}

class BeforeAdventureScreen extends StatefulWidget {
  const BeforeAdventureScreen({Key? key}) : super(key: key);

  @override
  BeforeAdventureScreenState createState() => BeforeAdventureScreenState();
}

class BeforeAdventureScreenState extends State<BeforeAdventureScreen> {



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fiche Cache'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 200,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/cache_image.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Nom de la Cache',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Difficulté : Facile',
                    style: TextStyle(
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
                  const Text(
                    'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec auctor magna non ipsum hendrerit, ut sagittis leo ultrices. Suspendisse fermentum iaculis fringilla. Mauris consectetur turpis et ipsum semper, eget lobortis mauris scelerisque. Nam ut faucibus lectus. Nunc iaculis lorem arcu, id euismod enim tincidunt non. Sed scelerisque quam vel libero consequat, a finibus erat finibus.',
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Conseils',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    '• Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae;\n'
                        '• Etiam sit amet pretium urna, vel placerat justo. Sed at justo est.',
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      // Action à effectuer lors du clic sur le bouton
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const TrainingPage()),
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
