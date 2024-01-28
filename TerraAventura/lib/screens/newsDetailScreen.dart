import 'package:flutter/material.dart';
import '../functions/NewsItem.dart';

class NewsDetailScreen extends StatelessWidget {
  final NewsItem newsItem;

  NewsDetailScreen({required this.newsItem});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(newsItem.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            newsItem.imageUrl.isNotEmpty
                ? Image.network(newsItem.imageUrl)
                : Container(),
            Text(newsItem.title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
            Text(newsItem.description),
          ],
        ),
      ),
    );
  }
}