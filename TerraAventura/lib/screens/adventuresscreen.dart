import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class AdventuresScreen extends StatelessWidget {
  const AdventuresScreen({super.key});

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
                initialCenter: LatLng(51.509364, -0.128928),
                initialZoom: 9.2,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.app',
                ),
                RichAttributionWidget(
                  attributions: [
                    TextSourceAttribution(
                      'OpenStreetMap contributors',
                      onTap: () => print('OpenStreetMap attribution tapped!'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Liste de monuments
          Expanded(
            child: ListView(
              children: [
                ListTile(
                  leading: Icon(Icons.place),
                  title: Text('Cathédrale Saint-Étienne'),
                  subtitle: Text('Cathédrale'),
                  trailing: Icon(Icons.keyboard_arrow_right),
                  onTap: () {
    }
                ),
                ListTile(
                  leading: Icon(Icons.place),
                  title: Text('Musée des Beaux-Arts'),
                  subtitle: Text('Musée'),
                  trailing: Icon(Icons.keyboard_arrow_right),
                  onTap: () {
    }
                ),
                ListTile(
                  leading: Icon(Icons.place),
                  title: Text('Musée de la Résistance'),
                  subtitle: Text('Musée'),
                  trailing: Icon(Icons.keyboard_arrow_right),
                  onTap: () {

                        }
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
