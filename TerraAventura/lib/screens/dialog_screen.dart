import 'package:flutter/material.dart';
import 'package:terraaventura/functions/supabase_client.dart';

class AdventureLaunchScreen extends StatefulWidget {
  final int adventureId;

  const AdventureLaunchScreen({Key? key, required this.adventureId})
      : super(key: key);

  @override
  _AdventureLaunchScreenState createState() => _AdventureLaunchScreenState();
}

class _AdventureLaunchScreenState extends State<AdventureLaunchScreen> {
  int currentStep = 1;
  int currentDialogueIndex = 0;
  List<dynamic> dialogues = [];
  String secretCode = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lancement de l\'aventure'),
      ),
      body: StreamBuilder(
        stream: SupabaseService.supabase
            .from('dialogues:etape_id=etapes.id,personnage_id=personnages.id')
            .select('dialogues.texte, personnages.nom, etapes.titre')
            .eq('etapes.aventure_id', widget.adventureId)
            .eq('etape_id', currentStep)
            .order('dialogues.ordre', ascending: true)
            .asStream(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (!snapshot.hasData || (snapshot.data as List).isEmpty) {
            return Center(
              child: Text('Aucun dialogue disponible.'),
            );
          }

          dialogues = snapshot.data as List;

          return Column(
            children: [
              Text(
                  '${dialogues[currentDialogueIndex]['personnages.nom']}: ${dialogues[currentDialogueIndex]['dialogues.texte']}'),
              if (currentDialogueIndex < dialogues.length - 1)
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      currentDialogueIndex++;
                    });
                  },
                  child: Text('Suivant'),
                )
              else
                TextField(
                  onChanged: (value) {
                    secretCode = value;
                  },
                  decoration: InputDecoration(
                    labelText: 'Entrez le code secret',
                  ),
                ),
              if (currentDialogueIndex == dialogues.length - 1)
                ElevatedButton(
                  onPressed: () async {
                    var response = await SupabaseService.supabase
                        .from('etapes_aventure')
                        .select()
                        .eq('id', currentStep)
                        .single();

                    if (response['code_secret'] == secretCode) {
                      setState(() {
                        currentStep++;
                        currentDialogueIndex = 0;
                      });
                    } else {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Erreur'),
                            content: Text('Le code secret est incorrect.'),
                            actions: [
                              TextButton(
                                child: Text('OK'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    }
                  },
                  child: Text('Valider'),
                ),
            ],
          );
        },
      ),
    );
  }
}
