import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:terraaventura/functions/supabase_client.dart'; // Add this line

import 'beforeAdventure.dart';

class AdventuresScreen extends StatelessWidget {
  const AdventuresScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Search bar
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Search',
              ),
            ),
          ),
          // Centered title
          const Center(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Limoges',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          // Centered subtitle
          const Center(
            child: Text(
              'Monuments',
              style: TextStyle(
                fontSize: 18,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
          // Map
          Expanded(
            //map
            child: FlutterMap(
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
                  stream: SupabaseService.supabase.from('monuments').stream(primaryKey: ['id']), // Modify this line
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

                      markers.add(
                          Marker(
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
                                        MaterialPageRoute(builder: (context) => BeforeAdventureScreen(monumentData: monumentData)),
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
            ),
          ),

          Expanded(
            child: StreamBuilder(
              stream: SupabaseService.supabase.from('monuments').stream(primaryKey: ['id']), // Modify this line
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
                    print(data);
                    return ListTile(
                      title: Text(monument['nom'].toString()),
                      subtitle: Row(
                        children: [
                          Text(monument['duree'].toString()),
                          const Text(' - '),
                          Text(monument['distance'].toString()),
                          const Text('km'),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}