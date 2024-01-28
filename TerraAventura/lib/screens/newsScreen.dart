import 'package:flutter/material.dart';


import '../functions/NewsItem.dart';
import '../functions/RssService.dart';
import 'newsDetailScreen.dart';


class NewsScreen extends StatelessWidget {
  final RssService rssService = RssService();

  NewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<NewsItem>>(
      future: rssService.fetchRss(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final item = snapshot.data![index];
              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NewsDetailScreen(newsItem: item),
                    ),
                  );
                },
                child: Card(
                  child: Column(
                    children: <Widget>[
                      item.imageUrl.isNotEmpty
                          ? Image.network(item.imageUrl)
                          : Container(),
                      ListTile(
                        title: Text(item.title, style: TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text(item.description),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
}
