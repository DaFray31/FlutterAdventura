import 'package:http/http.dart' as http;
import 'package:xml/xml.dart';
import 'NewsItem.dart';

class RssService {
  Future<List<NewsItem>> fetchRss() async {
    final response =
        await http.get(Uri.parse('https://chateaudeguise.fr/feed/'));
    return parseRss(response.body);
  }

  List<NewsItem> parseRss(String xmlString) {
    final document = XmlDocument.parse(xmlString);
    final items = document.findAllElements('item');

    return items.map((item) {
      return NewsItem(
        title: item.findElements('title').first.innerText,
        link: item.findElements('link').first.innerText,
        creator: item.findElements('dc:creator').first.innerText,
        pubDate: item.findElements('pubDate').first.innerText,
        category: item.findElements('category').isEmpty
            ? ''
            : item.findElements('category').first.innerText,
        guid: item.findElements('guid').isEmpty
            ? ''
            : item.findElements('guid').first.innerText,
        description: item.findElements('description').first.innerText,
        imageUrl: item.findElements('enclosure').isEmpty
            ? ''
            : item.findElements('enclosure').first.getAttribute('url') ?? '',
      );
    }).toList();
  }
}
