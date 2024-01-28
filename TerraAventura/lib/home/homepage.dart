import 'package:flutter/material.dart';
import 'package:terraaventura/screens/homescreen.dart';
import 'package:terraaventura/screens/questsscreen.dart';
import 'package:terraaventura/screens/monumentsScreen.dart';
import 'package:terraaventura/screens/newsScreen.dart';
import 'package:terraaventura/screens/profilescreen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  String _currentTitle = 'Accueil'; // Variable pour le titre actuel

  final List<Widget> _pages = [
    const HomeScreen(),
    const QuestsScreen(),
    const AdventuresScreen(),
    NewsScreen(),
    const ProfileScreen(),
  ];

  // Met à jour le titre en fonction de la page actuelle
  void _updateTitle() {
    setState(() {
      switch (_currentIndex) {
        case 0:
          _currentTitle = 'Accueil';
          break;
        case 1:
          _currentTitle = 'Quêtes';
          break;
        case 2:
          _currentTitle = 'Aventures';
          break;
        case 3:
          _currentTitle = 'Actualités';
          break;
        case 4:
          _currentTitle = 'Profil';
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
            child: Text(
                _currentTitle)), // Utilisation de la variable pour le titre
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.blue.withOpacity(0.5),
        onTap: (index) {
          setState(() {
            _currentIndex = index;
            _updateTitle(); // Met à jour le titre lors du changement de page
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Accueil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            label: 'Quêtes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore),
            label: 'Aventures',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.new_releases),
            label: 'Actualités',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}
