import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AdventuresScreen extends StatelessWidget {
  const AdventuresScreen({Key? key}) : super(key: key);
  static final SupabaseClient supabase = SupabaseClient(
    'https://kdiowwslccpwbzhccjaj.supabase.co',
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImtkaW93d3NsY2Nwd2J6aGNjamFqIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MDMyMzQ2MTMsImV4cCI6MjAxODgxMDYxM30.lHDaL3MYtfNsH5Oop32FfRlkSOhfGoDd34vl0b-4PWA',
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Barre de recherche
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Rechercher...',
              ),
            ),
          ),
          // Titre centré
          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Limoges',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          // Sous-titre centré
          Center(
            child: Text(
              'Monuments',
              style: TextStyle(
                fontSize: 18,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
          // Carte
          Expanded(
            //map
            child: FlutterMap(
              options: MapOptions(
                initialCenter: LatLng(45.82975453040051, 1.266962885714927),
                initialZoom: 10,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'flutter_map',
                ),
                RichAttributionWidget(
                  attributions: [
                    TextSourceAttribution(
                      'OpenStreetMap contributors',
                    ),
                  ],
                ),
                StreamBuilder(
                  stream: supabase.from('monuments').stream(primaryKey: ['id']),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    if (!snapshot.hasData || (snapshot.data as List).isEmpty) {
                      return Text('No data available');
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
                          child: FlutterLogo(),
                        ),
                      );
                    }

                    return MarkerLayer(markers: markers);
                  },
                ),
              ],
            ),
          ),

          Expanded(
            child: StreamBuilder(
              stream: supabase.from('monuments').stream(primaryKey: ['id']),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (!snapshot.hasData || (snapshot.data as List).isEmpty) {
                  return Text('No data available');
                }

                final data = snapshot.data as List;
                return ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    final monument = data[index];
                    return ListTile(
                      title: Text(monument['nom'].toString()),
                      subtitle: Row(
                        children: [
                          Text(monument['duree'].toString()),
                          Text(' - '),
                          Text(monument['distance'].toString()),
                          Text('km'),
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
