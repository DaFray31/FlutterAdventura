import 'package:flutter/material.dart';
import 'dart:math';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Training App',
      home: TrainingPage(),
    );
  }
}

class TrainingPage extends StatefulWidget {
  const TrainingPage({Key? key}) : super(key: key);

  @override
  TrainingPageState createState() => TrainingPageState();
}

class TrainingPageState extends State<TrainingPage> {


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

  void nextComment() {
    setState(() {
      currentCommentIndex = (currentCommentIndex + 1) % comments.length;
    });
  }

  void checkStep(int stepNumber, String secretCode) {
    if (secretCode == 'codeSecret123') {
      setState(() {
        points += 100;
      });
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Félicitations !'),
            content: Text('Vous avez validé l\'étape $stepNumber et gagné 100 points !'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Code incorrect'),
            content: Text('Le code secret que vous avez saisi est incorrect. Veuillez réessayer.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lieu m - Etape n'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              // Implement log-out logic here
            },
          ),
        ],
        backgroundColor: Colors.indigo, // Couleur de la barre d'applications
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.3,
              decoration: BoxDecoration(
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
                  Text(
                    'Étape de la Chasse',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  buildChaseStep('Étape 1', 'Trouvez l\'indice caché', 1, Icons.location_on, Colors.teal),
                  buildChaseStep('Étape 2', 'Résolvez la devinette', 2, Icons.question_answer, Colors.orange),
                  buildChaseStep('Étape 3', 'Prenez une photo', 3, Icons.camera_alt, Colors.purple),

                  const SizedBox(height: 16.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Points:',
                        style: TextStyle(color: Colors.white),
                      ),
                      Text(
                        '$points',
                        style: TextStyle(
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
                      icon: Icon(Icons.share),
                      onPressed: () {
                        // Code share
                      },
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Text(
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
                        color: Colors.grey[200], // Couleur de fond de la boîte de commentaires
                      ),
                      child: Text(
                        comments[currentCommentIndex],
                        style: TextStyle(fontSize: 16.0),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
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
                        onPressed: () {
                          // Implémentez le code à exécuter lorsqu'on appuie sur le bouton d'envoi
                        },
                        icon: Icon(Icons.send),
                        color: Colors.indigo, // Couleur de l'icône du bouton d'envoi
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

  Widget buildChaseStep(String label, String objective, int stepNumber, IconData icon, Color iconColor) {
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
                SizedBox(width: 8.0),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            IconButton(
              icon: Icon(
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
          style: TextStyle(color: Colors.white),
        ),
        const SizedBox(height: 16.0),
      ],
    );
  }

  void showCodeInputDialog(int stepNumber) {
    String secretCode = '';
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Vérification de l\'étape $stepNumber'),
          content: Column(
            children: [
              Text('Entrez le code secret trouvé sur l\'élément :'),
              TextField(
                onChanged: (value) {
                  secretCode = value;
                },
                decoration: InputDecoration(
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
              child: Text('Annuler'),
            ),
            TextButton(
              onPressed: () {
                checkStep(stepNumber, secretCode);
                Navigator.of(context).pop();
              },
              child: Text('Valider'),
            ),
          ],
        );
      },
    );
  }
}
