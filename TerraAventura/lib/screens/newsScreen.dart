import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../functions/NewsItem.dart';
import '../functions/RssService.dart';
import 'newsDetailScreen.dart';

class NewsScreen extends StatefulWidget {
  NewsScreen({super.key});

  @override
  _NewsScreenState createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  final RssService rssService = RssService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('News'),
      ),
      body: FutureBuilder<List<NewsItem>>(
        future: rssService.fetchRss(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return RefreshIndicator(
              onRefresh: () async {
                setState(() {});
              },
              child: ListView.separated(
                itemCount: snapshot.data!.length,
                separatorBuilder: (context, index) => Divider(),
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
                      child: ListTile(
                        leading: Container(
                          width: 50.0, // specify the width of the leading widget
                          child: item.imageUrl.isNotEmpty
                              ? Image.network(item.imageUrl)
                              : Container(),
                        ),
                        title: Text(item.title,
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text(
                            DateFormat('dd MMM yyyy').format(item.pubDate)),
                      ),
                    ),
                  );
                },
              ),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}