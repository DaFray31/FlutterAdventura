import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class DialoguesWidget extends StatelessWidget {
  final List<dynamic> dialogues;
  final int currentDialogueIndex;

  const DialoguesWidget({
    Key? key,
    required this.dialogues,
    required this.currentDialogueIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Map<int, Color> personnageColors = {
      1: Colors.red,
      2: Colors.blue,
      3: Colors.green,
      //FIXME - should be in database
    };

    return ListView.builder(
      itemCount: currentDialogueIndex + 1,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(dialogues[index]['personnages']['nom'],
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w300,
                      fontStyle: FontStyle.italic)),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.person,
                    color: personnageColors[dialogues[index]['personnage_id']],
                  ),
                  Expanded(
                    child: Card(
                      elevation: 5,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: MarkdownBody(data: dialogues[index]['texte']),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
