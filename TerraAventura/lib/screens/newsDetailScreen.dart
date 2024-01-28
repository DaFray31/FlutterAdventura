import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../functions/NewsItem.dart';

class NewsDetailScreen extends StatelessWidget {
  final NewsItem newsItem;

  const NewsDetailScreen({super.key, required this.newsItem});

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
            Text(newsItem.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
            Text(DateFormat('dd MMM yyyy').format(newsItem.pubDate)),
            Text(newsItem.description),
          ],
        ),
      ),
    );
  }
}