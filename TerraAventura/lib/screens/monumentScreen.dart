import 'package:flutter/material.dart';
import 'package:terraaventura/functions/supabase_client.dart'; // Import SupabaseService

import '../widgets/AdventureCard.dart';

class BeforeAdventureScreen extends StatelessWidget {
  final dynamic monumentData;

  const BeforeAdventureScreen({Key? key, required this.monumentData})
      : super(key: key);

  Future<List<dynamic>> fetchAdventures() async {
    final response = SupabaseService.supabase
        .from('aventures')
        .select()
        .eq('monument_id', monumentData['id'])
        .asStream();

    if (response.length.toString() == "0") {
      return [];
    }

    return response.toList();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: fetchAdventures(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }

        if (snapshot.hasError) {
          return const Text('Une erreur est survenue');
        }

        final adventures = snapshot.data;

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
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(monumentData['image']), // Use NetworkImage to load image from URL
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
                          return (niv == "3")
                              ? "Difficile"
                              : (niv == "2")
                                  ? "Moyen"
                                  : "Facile";
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
                      // Display adventures
                      for (var adventure in adventures!)
                        AdventureCard(adventure: adventure), // Replace AdventureCard with your own widget
                      const SizedBox(height: 20)
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}