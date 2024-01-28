import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bienvenue à Terra Aventure'),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CarouselSlider(
              options: CarouselOptions(
                autoPlay: true,
                enlargeCenterPage: true,
                aspectRatio: 2.0,
                onPageChanged: (index, reason) {
                  // Gérer le changement de page ici
                },
              ),
              items: [
                'images/back1.jpg',
                'images/back1.jpg',
                'images/back1.jpg',
              ].map((item) {
                return Builder(
                  builder: (BuildContext context) {
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.symmetric(horizontal: 5.0),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(item),
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  },
                );
              }).toList(),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(
                        Icons.explore,
                        color: Colors.green,
                        size: 36.0,
                      ),
                      SizedBox(width: 10.0),
                      Text(
                        'Explorez le monde magique',
                        style: TextStyle(
                          fontSize: 22.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10.0),
                  Text(
                    'Parcourez des sentiers secrets, résolvez des énigmes et collectez des souvenirs inoubliables.',
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  const Row(
                    children: [
                      Icon(
                        Icons.face,
                        color: Colors.blue,
                        size: 36.0,
                      ),
                      SizedBox(width: 10.0),
                      Text(
                        'Rencontrez des personnages fascinants',
                        style: TextStyle(
                          fontSize: 22.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10.0),
                  Text(
                    'Faites la connaissance de créatures fantastiques et découvrez des histoires magiques tout au long de votre voyage.',
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  const Row(
                    children: [
                      Icon(
                        Icons.star,
                        color: Colors.orange,
                        size: 36.0,
                      ),
                      SizedBox(width: 10.0),
                      Text(
                        'Pourquoi Terra Aventure ?',
                        style: TextStyle(
                          fontSize: 22.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10.0),
                  Text(
                    'Terra Aventure offre une expérience unique mêlant découverte, mystère et interaction avec un monde fantastique. Que vous soyez seul, en famille ou entre amis, préparez-vous à vivre des moments extraordinaires !',
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
