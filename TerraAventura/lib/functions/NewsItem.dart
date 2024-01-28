class NewsItem {
  final String title;
  final String link;
  final String creator;
  final DateTime pubDate;
  final String category;
  final String guid;
  final String description;
  final String imageUrl;

  NewsItem({
    required this.title,
    required this.link,
    required this.creator,
    required this.pubDate,
    required this.category,
    required this.guid,
    required this.description,
    required this.imageUrl,
  });
}