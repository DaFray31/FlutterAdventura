import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:terraaventura/functions/supabase_client.dart'; // Add this line

import 'monumentScreen.dart';

class AdventuresScreen extends StatelessWidget {
  const AdventuresScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: _AdventuresBody(),
      ),
    );
  }
}

class _AdventuresBody extends StatelessWidget {
  const _AdventuresBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        _AdventuresTitle(),
        SizedBox(height: 10),
        _SearchBar(),
        SizedBox(height: 10),
        Expanded(child: _AdventuresMap()),
        SizedBox(height: 10),
        Expanded(child: _AdventuresList()),
      ],
    );
  }
}

class _AdventuresTitle extends StatelessWidget {
  const _AdventuresTitle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Liste des aventures',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class _SearchBar extends StatefulWidget {
  const _SearchBar({Key? key}) : super(key: key);

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<_SearchBar> {
  final TextEditingController _searchController = TextEditingController();
  List<dynamic> _searchResults = [];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: _searchController,
          onChanged: (value) {
            if (value.length > 2) {
              //Requete suppabase
              SupabaseService.supabase
                  .from('monuments')
                  .select()
                  .ilike('nom', '%$value%')
                  .then((response) {
                setState(() {
                  _searchResults = response;
                  print(response);
                });
              });
            } else {
              setState(() {
                _searchResults = [];
              });
            }
          },
          decoration: const InputDecoration(
            labelText: 'Search',
            border: OutlineInputBorder(),
          ),
        ),
        if (_searchResults.isNotEmpty)
          Container(
            height: 200,
            child: ListView.builder(
              itemCount: _searchResults.length,
              itemBuilder: (context, index) {
                final result = _searchResults[index];
                return ListTile(
                  title: Text(result['nom'].toString()),
                  onTap: () {
                    // Handle tap on search result, e.g., navigate to details screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            BeforeAdventureScreen(monumentData: result),
                      ),
                    );
                  },
                );
              },
            ),
          ),
      ],
    );
  }
}

class _AdventuresMap extends StatefulWidget {
  const _AdventuresMap({Key? key}) : super(key: key);

  @override
  _AdventuresMapState createState() => _AdventuresMapState();
}

class _AdventuresMapState extends State<_AdventuresMap> {
  late Future<List<dynamic>> _monumentsFuture;
  @override
  void initState() {
    super.initState();
    _monumentsFuture =
        SupabaseService.supabase.from('monuments').select().asStream().toList();
  }

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      options: const MapOptions(
        initialCenter: LatLng(45.82975453040051, 1.266962885714927),
        initialZoom: 10,
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'flutter_map',
        ),
        const RichAttributionWidget(
          attributions: [
            TextSourceAttribution(
              'OpenStreetMap contributors',
            ),
          ],
        ),
        StreamBuilder(
          stream: SupabaseService.supabase
              .from('monuments')
              .stream(primaryKey: ['id']),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (!snapshot.hasData || (snapshot.data as List).isEmpty) {
              return const Text('No data available');
            }

            final data = snapshot.data as List;
            List<Marker> markers = [];

            for (var monumentData in data) {
              // Extracting latitude and longitude from the string representation
              String pointString = monumentData['localisation'];
              List<String> pointValues = pointString
                  .replaceAll('(', '')
                  .replaceAll(')', '')
                  .split(',');

              double latitude = double.parse(pointValues[1]);
              double longitude = double.parse(pointValues[0]);

              markers.add(Marker(
                point: LatLng(latitude, longitude),
                width: 80,
                height: 80,
                child: Column(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.place,
                        // Replace with Icons.place for a "map pointer"
                        color: Colors.black,
                      ),
                      onPressed: () {
                        // Navigate to the TrainingPage
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => BeforeAdventureScreen(
                                  monumentData: monumentData)),
                        );
                      },
                    ),
                  ],
                ),
              ));
            }

            return MarkerLayer(markers: markers);
          },
        ),
      ],
    );
  }
}

class _AdventuresList extends StatefulWidget {
  const _AdventuresList({Key? key}) : super(key: key);

  @override
  _AdventuresListState createState() => _AdventuresListState();
}

class _AdventuresListState extends State<_AdventuresList> {
  late Future<List<dynamic>> _monumentsFuture;

  @override
  void initState() {
    super.initState();
    _monumentsFuture =
        SupabaseService.supabase.from('monuments').select().asStream().toList();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream:
      SupabaseService.supabase.from('monuments').stream(primaryKey: ['id']),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (!snapshot.hasData || (snapshot.data as List).isEmpty) {
          return const Text('No data available');
        }

        final data = snapshot.data as List;
        return ListView.builder(
          itemCount: data.length,
          itemBuilder: (context, index) {
            final monument = data[index];
            return InkWell(
              onTap: () {
                // Navigate to the BeforeAdventureScreen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          BeforeAdventureScreen(monumentData: monument)),
                );
              },
              child: ListTile(
                leading: const Icon(Icons.place), // Add leading icon
                title: Text(
                  monument['nom'].toString(),
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight
                          .bold), // Increase font size and make it bold
                ),
                subtitle: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: monument['duree'].toString(),
                        style: const TextStyle(
                            color: Colors.blue), // Change color to blue
                      ),
                      const TextSpan(
                        text: ' - ',
                        style: TextStyle(color: Colors.black),
                      ),
                      TextSpan(
                        text: monument['distance'].toString(),
                        style: const TextStyle(
                            color: Colors.red), // Change color to red
                      ),
                      const TextSpan(
                        text: 'km',
                        style: TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
                ),
                trailing: const Icon(Icons.arrow_forward), // Add trailing icon
              ),
            );
          },
        );
      },
    );
  }
}
