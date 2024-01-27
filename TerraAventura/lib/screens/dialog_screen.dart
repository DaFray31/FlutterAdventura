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

  Future<String> getPersonnageName(int personnageId) async {
    var response = await SupabaseService.supabase
        .from('personnages')
        .select('nom')
        .eq('id', personnageId)
        .single();

    return response['nom'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lancement de l\'aventure'),
      ),
      body: StreamBuilder(
        stream: SupabaseService.supabase
            .from('dialogues')
            .select('id, etape_id, personnage_id, ordre, texte')
            .eq('etape_id', currentStep)
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
              Expanded(
                child: ListView.builder(
                  itemCount: currentDialogueIndex + 1,
                  itemBuilder: (context, index) {
                    return FutureBuilder(
                      future:
                          getPersonnageName(dialogues[index]['personnage_id']),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return ListTile(
                            leading: Icon(Icons.person),
                            title: Text('Loading...'),
                            subtitle: Text('${dialogues[index]['texte']}'),
                          );
                        }

                        if (snapshot.hasError) {
                          return ListTile(
                            leading: Icon(Icons.person),
                            title: Text('Error: ${snapshot.error}'),
                            subtitle: Text('${dialogues[index]['texte']}'),
                          );
                        }

                        return ListTile(
                          leading: Icon(Icons.person),
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
                child: Text('Suivant'),
              ),
              if (currentDialogueIndex >= dialogues.length - 1)
                Column(
                  children: [
                    TextField(
                      onChanged: (value) {
                        secretCode = value;
                      },
                      decoration: InputDecoration(
                        labelText: 'Entrez le code secret',
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        var response = await SupabaseService.supabase
                            .from('etapes')
                            .select('code_secret')
                            .eq('id', currentStep)
                            .single();

                        print(
                            'Response code_secret: ${response['code_secret']}'); // Debug print statement
                        print(
                            'Entered secretCode: $secretCode'); // Debug print statement

                        if (response['code_secret'] == secretCode) {
                          setState(() {
                            currentStep++;
                            currentDialogueIndex = 0;
                          });
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Code secret incorrect'),
                            ),
                          );
                        }
                      },
                      child: Text('Changer d\'étape'),
                    ),
                  ],
                ),
              Text('Etape $currentStep / ${dialogues.length}'),
            ],
          );
        },
      ),
    );
  }
}
