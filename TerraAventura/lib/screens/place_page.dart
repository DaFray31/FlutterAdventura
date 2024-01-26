import 'package:flutter/material.dart';
import 'dart:math';
import 'package:latlong2/latlong.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PlacePage extends StatefulWidget {
  final dynamic monumentData;

  const PlacePage({Key? key, required this.monumentData}) : super(key: key);

  @override
  PlacePageState createState() => PlacePageState(monumentData);
}

class PlacePageState extends State<PlacePage> {
  static final SupabaseClient supabase = SupabaseClient(
    'https://kdiowwslccpwbzhccjaj.supabase.co',
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImtkaW93d3NsY2Nwd2J6aGNjamFqIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MDMyMzQ2MTMsImV4cCI6MjAxODgxMDYxM30.lHDaL3MYtfNsH5Oop32FfRlkSOhfGoDd34vl0b-4PWA',
  );
  bool isFavoritePressed = false;
  bool isFlagPressed = false;
  bool switchValue = false;
  int points = 120;
  List<String> comments = [
    'Super endroit !',
    'J\'adore ce lieu.',
    'Magnifique vue !',
    'C\'est vraiment cool ici.',
    'Expérience incroyable !',
  ];
  int currentCommentIndex = 0;
  TextEditingController commentController = TextEditingController();
  List<String> carouselComments = [];

  dynamic data;

  PlacePageState(dynamic monumentData) {
    data = monumentData;
  }

  void nextComment() {
    setState(() {
      currentCommentIndex = (currentCommentIndex + 1) % comments.length;
    });
  }

  void checkStep(int stepNumber, String secretCode) {
    // Implementation of checkStep
  }

  void addToCarousel() {
    String newComment = commentController.text.trim();
    if (newComment.isNotEmpty) {
      setState(() {
        comments.add(newComment);
        commentController.clear();
        //writeToSupabase(1, 3);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lieu m - Etape n'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              // Implement log-out logic here
            },
          ),
        ],
        backgroundColor: Colors.indigo,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.3,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('images/back1.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
              padding: const EdgeInsets.all(16.0),
              child: Align(
                alignment: Alignment.topRight,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.favorite,
                        color: isFavoritePressed ? Colors.red : Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          isFavoritePressed = !isFavoritePressed;
                        });
                      },
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.flag,
                        color: isFlagPressed ? Colors.red : Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          isFlagPressed = !isFlagPressed;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.45,
              decoration: BoxDecoration(
                color: Colors.indigo, // Couleur de fond de la partie 2
                borderRadius: BorderRadius.circular(16.0),
              ),
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // ... (votre code existant)

                  const SizedBox(height: 16.0),
                  const Text(
                    'Étape de la Chasse',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  buildChaseStep('Étape 1', 'Trouvez l\'indice caché', 1,
                      Icons.location_on, Colors.teal),
                  buildChaseStep('Étape 2', 'Résolvez la devinette', 2,
                      Icons.question_answer, Colors.orange),
                  buildChaseStep('Étape 3', 'Prenez une photo', 3,
                      Icons.camera_alt, Colors.purple),

                  const SizedBox(height: 16.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Points:',
                        style: TextStyle(color: Colors.white),
                      ),
                      Text(
                        '$points',
                        style: const TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.3,
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      icon: const Icon(Icons.share),
                      onPressed: () {
                        // Code share
                      },
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  const Text(
                    'Commentaires',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  GestureDetector(
                    onTap: nextComment,
                    child: Container(
                      height: 50.0,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(10.0),
                        color: Colors.grey[200],
                      ),
                      child: Text(
                        comments[currentCommentIndex],
                        style: const TextStyle(fontSize: 16.0),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: commentController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50.0),
                            ),
                            labelText: 'Ajouter un commentaire',
                          ),
                        ),
                      ),
                      const SizedBox(width: 10.0),
                      IconButton(
                        onPressed: addToCarousel,
                        icon: const Icon(Icons.send),
                        color: Colors.indigo,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildChaseStep(String label, String objective, int stepNumber,
      IconData icon, Color iconColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  color: iconColor,
                ),
                const SizedBox(width: 8.0),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            IconButton(
              icon: const Icon(
                Icons.check,
                color: Colors.white,
              ),
              onPressed: () {
                showCodeInputDialog(stepNumber);
              },
            ),
          ],
        ),
        const SizedBox(height: 8.0),
        Text(
          'Objectif: $objective',
          style: const TextStyle(color: Colors.white),
        ),
        const SizedBox(height: 16.0),
      ],
    );
  }

  /*void writeToSupabase(idUser, idMonument) async {
    // Créez un tableau de données que vous souhaitez écrire dans la base de données
    final List<Map<String, dynamic>> newData = [
      {'id_monument': idMonument},
      // Ajoutez d'autres données au besoin
    ];

    // Utilisez la méthode upsert pour écrire les données dans la table 'monuments'
    final response =
        await supabase.from('pers_commentaires').upsert(newData, onConflict: 'nom');

    // Vérifiez la réponse pour voir si l'opération a réussi
    if (response.error != null) {
      print('Erreur ${response.error!.message}');
    } else {
      print('Données écrites avec succès !');
    }
  }*/

  void showCodeInputDialog(int stepNumber) {
    String secretCode = '';
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Vérification de l\'étape $stepNumber'),
          content: Column(
            children: [
              const Text('Entrez le code secret trouvé sur l\'élément :'),
              TextField(
                onChanged: (value) {
                  secretCode = value;
                },
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Code Secret',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: () {
                checkStep(stepNumber, secretCode);
                Navigator.of(context).pop();
              },
              child: const Text('Valider'),
            ),
          ],
        );
      },
    );
  }
}
