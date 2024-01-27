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
  List<int> steps = [];
  int currentStepIndex = 0;
  int currentDialogueIndex = 0;
  List<dynamic> dialogues = [];
  String secretCode = '';

  @override
  void initState() {
    super.initState();
    fetchSteps().then((result) {
      setState(() {
        steps = result;
      });
    });
  }

  Future<String> getPersonnageName(int personnageId) async {
    var response = await SupabaseService.supabase
        .from('personnages')
        .select('nom')
        .eq('id', personnageId)
        .single();

    return response['nom'];
  }

  Future<List<int>> fetchSteps() async {
    var response = await SupabaseService.supabase
        .from('etapes')
        .select('id')
        .eq('aventure_id', widget.adventureId)
        .order('ordre', ascending: true)
        .asStream()
        .toList();

    print('Response from fetchSteps: $response');

    if (response.isEmpty || response[0].isEmpty) {
      return [];
    }

    return response[0].map<int>((e) => int.parse(e['id'].toString())).toList();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lancement de l\'aventure'),
      ),
      body: FutureBuilder<List<int>>(
        future: fetchSteps(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('Aucun dialogue disponible.'),
            );
          }

          steps = snapshot.data!;
          return StreamBuilder(
            stream: SupabaseService.supabase
                .from('dialogues')
                .select(
                'id, etape_id, personnage_id,ordre, texte, etapes!inner(id, code_secret)')
                .eq('etapes.aventure_id', widget.adventureId)
                .eq('etapes.id', steps[currentStepIndex]) // Use the actual etape_id from the steps list
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

              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: currentDialogueIndex + 1,
                      itemBuilder: (context, index) {
                        return FutureBuilder(
                          future: getPersonnageName(
                              dialogues[index]['personnage_id']),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return ListTile(
                                leading: const Icon(Icons.person),
                                title: const Text('Loading...'),
                                subtitle: Text('${dialogues[index]['texte']}'),
                              );
                            }

                            if (snapshot.hasError) {
                              return ListTile(
                                leading: const Icon(Icons.person),
                                title: Text('Error: ${snapshot.error}'),
                                subtitle: Text('${dialogues[index]['texte']}'),
                              );
                            }

                            return ListTile(
                              leading: const Icon(Icons.person),
                              title: Text('${snapshot.data}'),
                              subtitle: Text('${dialogues[index]['texte']}'),
                            );
                          },
                        );
                      },
                    ),
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
                  if (currentDialogueIndex >= dialogues.length - 1)
                    Column(
                      children: [
                        TextField(
                          onChanged: (value) {
                            secretCode = value;
                          },
                          decoration: const InputDecoration(
                            labelText: 'Entrez le code secret',
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            var response = await SupabaseService.supabase
                                .from('etapes')
                                .select('code_secret')
                                .eq('id', steps[currentStepIndex])
                                .single();

                            if (response['code_secret'] == secretCode) {
                              setState(() {
                                currentStepIndex++;
                                currentDialogueIndex =
                                    0; // Reset currentDialogueIndex
                              });
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
              );
            },
          );
        },
      ),
    );
  }
}
