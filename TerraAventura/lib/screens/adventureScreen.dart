import 'package:flutter/material.dart';
import 'package:terraaventura/functions/supabase_client.dart';
import 'package:terraaventura/widgets/DialoguesWidget.dart'; // Import DialoguesWidget

import 'endScreen.dart';

class AdventureLaunchScreen extends StatefulWidget {
  final int adventureId;

  const AdventureLaunchScreen({Key? key, required this.adventureId})
      : super(key: key);

  @override
  _AdventureLaunchScreenState createState() => _AdventureLaunchScreenState();
}

class _AdventureLaunchScreenState extends State<AdventureLaunchScreen> {
  List<int> steps = [];
  int currentStepIndex = 0;
  int currentDialogueIndex = 0;
  List<dynamic> dialogues = [];
  String secretCode = '';
  String adventureName = '';

  @override
  void initState() {
    super.initState();
    fetchAdventureName();
    fetchSteps();
  }

  Future<void> fetchAdventureName() async {
    try {
      var response = await SupabaseService.supabase
          .from('aventures')
          .select('titre')
          .eq('id', widget.adventureId)
          .single();

      if (response.isNotEmpty) {
        adventureName = response['titre'].toString();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching adventure name: $e')),
      );
    }
  }

  Future<void> fetchSteps() async {
    try {
      var response = await SupabaseService.supabase
          .from('etapes')
          .select('id')
          .eq('aventure_id', widget.adventureId)
          .order('ordre', ascending: true)
          .asStream()
          .toList();

      if (response.isEmpty || response[0].isEmpty) {
        steps = [];
      } else {
        steps =
            response[0].map<int>((e) => int.parse(e['id'].toString())).toList();
      }

      setState(() {});
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching steps: $e')),
      );
    }
  }

  StreamBuilder dialoguesStreamBuilder() {
    return StreamBuilder(
      stream: SupabaseService.supabase
          .from('dialogues')
          .select(
              'id, etape_id, personnage_id,ordre, texte, etapes!inner(id, code_secret),personnages!inner(nom)')
          .eq('etapes.aventure_id', widget.adventureId)
          .eq('etapes.id', steps[currentStepIndex])
          .order('ordre', ascending: true)
          .asStream(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (!snapshot.hasData || (snapshot.data as List).isEmpty) {
          return const Center(
            child: Text('Aucun dialogue disponible.'),
          );
        }

        dialogues = snapshot.data as List;
        return DialoguesWidget(
          // Correct widget returned
          dialogues: dialogues,
          currentDialogueIndex: currentDialogueIndex,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: adventureName.isEmpty
            ? const CircularProgressIndicator()
            : Text(adventureName),
      ),
      body: steps.isEmpty
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                Expanded(
                  child: dialoguesStreamBuilder(),
                ),
                if (currentDialogueIndex < dialogues.length - 1)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      if (currentDialogueIndex > 0)
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              currentDialogueIndex--;
                            });
                          },
                          child: const Text('Précédent'),
                        ),
                      ElevatedButton(
                        onPressed: currentDialogueIndex < dialogues.length - 1
                            ? () {
                                setState(() {
                                  currentDialogueIndex++;
                                });
                              }
                            : null,
                        child: const Text('Suivant'),
                      ),
                    ],
                  ),
                if (currentDialogueIndex >= dialogues.length - 1)
                  AlertDialog(
                    title: TextField(
                      onChanged: (value) {
                        secretCode = value;
                      },
                      decoration: const InputDecoration(
                        labelText: 'Entrez le code secret',
                      ),
                    ),
                    actions: [
                      ElevatedButton(
                        onPressed: () async {
                          var response = await SupabaseService.supabase
                              .from('etapes')
                              .select('code_secret')
                              .eq('id', steps[currentStepIndex])
                              .single();

                          if (response['code_secret'] == secretCode) {
                            if (currentStepIndex < steps.length - 1) {
                              setState(() {
                                currentStepIndex++;
                                currentDialogueIndex = 0;
                              });
                            } else {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EndScreen(
                                      adventureId: widget.adventureId),
                                ),
                              );
                            }
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Code secret incorrect'),
                              ),
                            );
                          }
                        },
                        child: const Text('Changer d\'étape'),
                      ),
                    ],
                  ),
                Text('Etape ${currentStepIndex + 1} / ${steps.length}'),
              ],
            ),
    );
  }
}
