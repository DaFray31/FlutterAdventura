import 'package:flutter/material.dart';
import 'package:terraaventura/


class NewsScreen extends StatelessWidget {
  final RssService rssService = RssService();

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
              return ListTile(
                title: Text(item.title),
                subtitle: Text(item.description),
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