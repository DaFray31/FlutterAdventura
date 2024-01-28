import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'adventureScreen.dart';

class PlacePage extends StatefulWidget {
  final dynamic monumentData;
  final dynamic adventure;

  const PlacePage({Key? key, required this.monumentData, this.adventure})
      : super(key: key);

  @override
  PlacePageState createState() => PlacePageState(monumentData, adventure);
}

class PlacePageState extends State<PlacePage> {
  static final SupabaseClient supabase = SupabaseClient(
    'https://kdiowwslccpwbzhccjaj.supabase.co',
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImtkaW93d3NsY2Nwd2J6aGNjamFqIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MDMyMzQ2MTMsImV4cCI6MjAxODgxMDYxM30.lHDaL3MYtfNsH5Oop32FfRlkSOhfGoDd34vl0b-4PWA',
  );
  bool isFavoritePressed = false;
  bool isFlagPressed = false;
  List<Map<String, dynamic>> commentsData =
      []; // Updated to a list of map to store comments and ratings

  dynamic data;
  dynamic adventureData;
  dynamic adventureTitle;
  dynamic adventureDescription;

  PlacePageState(dynamic monumentData, adventure) {
    data = monumentData;
    adventureData = adventure;
    fetchComments();
    fetchAdventureData();
  }

  // Function to fetch comments from Supabase
  Future<void> fetchComments() async {
    try {
      final response = await supabase
          .from('commentaires')
          .select('commentaires, note')
          .eq('aventure_id', adventureData['id']);

      if (response.isEmpty) {
        print("Error when fetching data");
      } else {
        setState(() {
          // Update the comments list with fetched data
          commentsData = response;
        });
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  Future<void> fetchAdventureData() async {
    try {
      final response = await supabase
          .from('aventures')
          .select('titre, description')
          .eq('id', adventureData['id']);

      if (response.isEmpty) {
        print("Error when fetching data");
      } else {
        setState(() {
          adventureTitle = response[0]['titre'];
          adventureDescription = response[0]['description'];
        });
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  // Function to build star icons based on the given rating
  List<Icon> buildStarIcons(int rating) {
    List<Icon> stars = [];
    for (int i = 0; i < 5; i++) {
      IconData iconData = i < rating ? Icons.star : Icons.star_border;
      stars.add(Icon(iconData, color: Colors.amber));
    }
    return stars;
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(data['nom']),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.4,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(data['image']),
                  fit: BoxFit.cover,
                ),
              ),
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.favorite,
                              color:
                                  isFavoritePressed ? Colors.red : Colors.grey,
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
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text(
              '$adventureTitle',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              '$adventureDescription',
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AdventureLaunchScreen(
                            adventureId: adventureData['id']),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 20.0),
                  ),
                  child: const Text('Démarrer l\'aventure'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const Text(
                    'Commentaires',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(
                    height: 100.0,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: commentsData.map((commentData) {
                        String comment = commentData['commentaires'].toString();
                        int rating = commentData['note'] ?? 0;

                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.7,
                            padding: const EdgeInsets.all(16.0),
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: buildStarIcons(rating),
                                ),
                                //const SizedBox(height: 8),
                                Text(
                                  comment,
                                  style: const TextStyle(fontSize: 16.0),
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
