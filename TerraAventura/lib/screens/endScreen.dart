import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../functions/supabase_client.dart';
import '../home/homepage.dart';

class EndScreen extends StatefulWidget {
  static final SupabaseClient supabase = SupabaseClient(
    'https://kdiowwslccpwbzhccjaj.supabase.co',
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImtkaW93d3NsY2Nwd2J6aGNjamFqIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MDMyMzQ2MTMsImV4cCI6MjAxODgxMDYxM30.lHDaL3MYtfNsH5Oop32FfRlkSOhfGoDd34vl0b-4PWA',
  );

  final int adventureId;
  final TextEditingController commentController = TextEditingController();

  EndScreen({Key? key, required this.adventureId}) : super(key: key);

  @override
  EndScreenState createState() => EndScreenState();
}

class EndScreenState extends State<EndScreen> {
  int selectedStarCount = 0;
  bool commentAdded = false; // Nouvel état pour suivre l'ajout du commentaire

  Future<void> completeAdventure(int adventureId) async {
    if (SupabaseManager.currentUser() == null) {
      return;
    }

    String userId = SupabaseManager.currentUser()!.id;

    Map<String, dynamic> completionData = {
      "adventure_id": adventureId,
      "completion_date": DateTime.now().toUtc().toIso8601String(),
    };

    await updateUserProfile(userId, {"adventure_completion": completionData});
  }

  Future<void> updateUserProfile(
      String userId, Map<String, dynamic> updates) async {
    final response = await SupabaseManager.client
        .from('profiles')
        .update(updates)
        .eq('id', userId);

    if (response != null) {
      print('Error updating user profile: ${response.error!.message}');
    }
  }

  Future<void> addToComment() async {
    try {
      final String newComment = widget.commentController.text.trim();

      if (newComment.isNotEmpty) {
        final response = await EndScreen.supabase.from('commentaires').insert({
          'aventure_id': widget.adventureId,
          'commentaires': newComment,
          'note': selectedStarCount
        });
        if (response.error != null) {
          print('Error adding comment: ${response.error!.message}');
        } else {
          print(
              'Comment added successfully with rating: $selectedStarCount stars');
        }

        if (response.error != null) {
          // La réponse contient une propriété 'error'
          print('Error adding comment: ${response.error!.message}');
        } else if (response.data != null) {
          // La réponse contient une propriété 'data', ce qui indique une insertion réussie
          print(
              'Comment added successfully with rating: $selectedStarCount stars');
          // Mettre à jour l'état pour indiquer que le commentaire a été ajouté avec succès

          widget.commentController.clear();
        } else {
          // Cas où ni 'error' ni 'data' ne sont présents dans la réponse
          print('Unexpected response from Supabase');
        }
      }
    } catch (error) {
      print('Error: $error');

      // Erreur que l'on a pas réuissi à résoudre, les données sont bien suavegardées mais on quand même une erreur, on rajoute donc la notification ici
      setState(() {
        commentAdded = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fin de l\'aventure'),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
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
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: widget.commentController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      labelText: 'Ajouter un commentaire',
                    ),
                  ),
                ),
                const SizedBox(width: 10.0),
                IconButton(
                  onPressed: addToComment,
                  icon: const Icon(Icons.send),
                  color: Colors.indigo,
                ),
              ],
            ),
            // Affichez le texte en vert si le commentaire a été ajouté avec succès
            if (commentAdded)
              const Text(
                'Commentaire ajouté avec succès!',
                style: TextStyle(color: Colors.green),
              ),
            const SizedBox(height: 16),
            const Text(
              'Notez cette aventure:',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                5,
                (index) => IconButton(
                  onPressed: () {
                    setState(() {
                      // Toggle the selected state of each star individually
                      if (selectedStarCount == index + 1) {
                        selectedStarCount =
                            0; // Deselect the star if it's already selected
                      } else {
                        selectedStarCount = index + 1; // Select the star
                      }
                    });
                  },
                  icon: Icon(
                    Icons.star,
                    color:
                        index < selectedStarCount ? Colors.amber : Colors.grey,
                    size: 30,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                await completeAdventure(widget.adventureId);
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const HomePage()),
                  (Route<dynamic> route) => false,
                );
              },
              child: const Text('Retour à la page d\'accueil'),
            )
          ],
        ),
      ),
    );
  }
}
