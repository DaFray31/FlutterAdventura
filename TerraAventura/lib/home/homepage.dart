import 'package:flutter/material.dart';
import 'package:terraaventura/screens/homescreen.dart';
import 'package:terraaventura/screens/monumentsScreen.dart';
import 'package:terraaventura/screens/newsScreen.dart';
import 'package:terraaventura/screens/profileScreen.dart';

import '../screens/settingsscreen.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  String _currentTitle = 'Accueil';
  final PageController _pageController = PageController();

  final List<Widget> _pages = const [
    HomeScreen(),
    AdventuresScreen(),
    NewsScreen(),
    ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      final int currentPage = _pageController.page!.round();
      if (currentPage != _currentIndex) {
        setState(() {
          _currentIndex = currentPage;
          _updateTitle();
        });
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _updateTitle() {
    switch (_currentIndex) {
      case 0:
        _currentTitle = 'Accueil';
        break;
      case 1:
        _currentTitle = 'Aventures';
        break;
      case 2:
        _currentTitle = 'Actualités';
        break;
      case 3:
        _currentTitle = 'Profil';
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.settings),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SettingsScreen()),
            );
          },
        ),
        title: Center(child: Text(_currentTitle)),
      ),
      body: PageView(
        controller: _pageController,
        children: _pages,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
            _updateTitle();
          });
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.blue.withOpacity(0.5),
        onTap: (index) {
          _pageController.animateToPage(
            index,
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOut,
          );
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Accueil',
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
